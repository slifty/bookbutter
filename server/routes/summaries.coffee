SummariesModel = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'

class Summaries
  @init: (app) ->
    app.get '/summaries/:id', @get
    app.get '/summaries/:id/jobs', @getJobs

  @getJobs: (req, res, next) ->
    Step(
      ->
        SummariesModel.find { summaryId: req.params.id }, @
        return
      (err, summaryNodes) ->
        if err then return next err
        graph = Summaries._buildGraph(summaryNodes)
        jobs = Summaries._getJobs(graph)
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

  @_getJobs: (graph) ->
    # use iterative deepening to find the first level with two nodes that do not have parents
    level = 0
    paragraphs = graph
    jobs = []
    while jobs.length < 2
      # if next level is empty, no more jobs
      if _.isEmpty(paragraphs) then return []

      children = []
      for paragraph in paragraphs
        if not paragraph.parentId?
          jobs.push paragraph
        else
          children.push paragraph.parent
      paragraphs = paragraphs.concat(children)

    return [ jobs[0], jobs[1] ]


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
        node.parent = summaryNodeIndex[leafNode.parentId]
        node = node.parent

    return leafNodes

module.exports = Summaries

