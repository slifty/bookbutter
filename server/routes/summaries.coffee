SummariesModel = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'

class Summaries
  @init: (app) ->
    app.get '/summaries/:id', @get
    app.get '/summaries', @find
    app.get '/summaries/:id/jobs', @getJobs
    app.post '/summaries/:id/jobs/summarize', @summarize

  @find: (req, res, next) ->
    SummariesModel.find { }, (err, summaries) ->
      if err then return next err
      result = _.map(summaries, (summary) ->
        return {
          bookId: summary.bookId
        })
      res.json result

  @getJobs: (req, res, next) ->
    Step(
      ->
        SummariesModel.find { summaryId: req.params.id }, @
        return
      (err, summaryNodes) ->
        if err then return next err
        graph = Summaries._buildGraph(summaryNodes)
        Summaries._getJobs(graph, @)
        return
      (err, jobs) ->
        if err then return next err
        res.json jobs
    )

  @get: (req, res, next) ->
    Step(
      ->
        SummariesModel.find { summaryId: req.params.id }, @
        return
      (err, summaryNodes) ->
        if err then return next err
        res.json Summaries._buildGraph(summaryNodes)
    )

  @summarize: (req, res, next) ->
    Step(
      ->
        paragraphIds = req.query.ids.split ','
        SummariesModel.find {
          summaryId: req.params.id,
          _id: { $in: paragraphIds },
          parentId: { $exists: false } }, @
        return
      (err, @summaryNodes) ->
        throw err if err
        if _.isEmpty(@summaryNodes)
          return res.json 'lulz'

        newSummary = new SummariesModel(
          text: req.body.text
          compression: (@summaryNodes[0].height + 1) / (@summaryNodes[0].maxHeight)
          summaryId: @summaryNodes[0].summaryId
          bookId: @summaryNodes[0].bookId
          order: 0
          height: @summaryNodes[0].height + 1
          maxHeight: @summaryNodes[0].maxHeight
        )
        newSummary.save @
        return
      (err, summaryNode) ->
        throw err if err
        group = @group()
        for summaryNodeItem in @summaryNodes
          SummariesModel.findByIdAndUpdate summaryNodeItem._id, {
            $set: {
              parentId: summaryNode._id
            }
          }, group()
        return
      (err) ->
        if err then return next err
        res.json 'yay'
    )


  @_getJobs: (graph, callback) ->
    # use iterative deepening to find the first level with two nodes that do not have parents
    level = 0
    paragraphs = graph
    jobs = []
    jobIds = {}
    while jobs.length < 2
      # if next level is empty, no more jobs
      if _.isEmpty(paragraphs) then return callback(null, [])

      children = []
      for paragraph in paragraphs
        if not paragraph.parentId? and not jobIds[paragraph._id.toString()]
          # if this was already given as a job within the past 30 mins we should choose a different job
          if not paragraph.jobExecutionTimestamp? or Date.now() - paragraph.jobExecutionTimestamp > 1000 * 60 * 30
            jobs.push paragraph
          jobIds[paragraph._id.toString()] = true
        else if paragraph?.parent
          children.push paragraph.parent
        else
          # do nothing

      # if current level complete and can't find two jobs, must be root
      if jobs.length is 1 then return callback(null, [])

      paragraphs = paragraphs.concat(children)
    
    jobsToUpdate = [ jobs[0], jobs[1] ]
    Step(
      ->
        group = @group()
        for summaryNodeItem in jobsToUpdate
          SummariesModel.findByIdAndUpdate summaryNodeItem._id, {
            $set: {
              jobExecutionTimestamp: Date.now()
            }
          }, group()
        return
      (err, summaryNodes) ->
        if err then callback(err)
        return callback(null, summaryNodes)
    )


  @_buildGraph: (summaryNodes) ->
    # leaf nodes have a compression of 0
    leafNodes = _.filter summaryNodes, (leafNode) -> return leafNode.compression is 0

    # sort leaf nodes by order
    leafNodes = _.sortBy leafNodes, (leafNode) -> return leafNode.order

    # index all summary nodes by id for convenience
    summaryNodeIndex = _.indexBy summaryNodes, '_id'

    # we should connect each leaf node to the larger graph
    for leafNode in leafNodes
      # connecting a leaf node to the graph involves adding ancestors until there are no more parents left
      node = leafNode
      while node.parentId?
        node.parent = summaryNodeIndex[node.parentId]
        node = node.parent

    return leafNodes

module.exports = Summaries

