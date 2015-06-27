SummariesModel = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'

class Summaries
  @init: (app) ->
    app.get '/summaries/:id', @get

  @get: (req, res, next) ->
    Step(
      ->
        SummariesModel.find { summaryId: req.params.id }, @
        return
      (err, summaryNodes) ->
        throw err if err
        res.json Summaries._buildGraph(summaryNodes)
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
        node.parent = summaryNodeIndex[leafNode.parentId]
        node = node.parent

    return leafNodes

module.exports = Summaries

