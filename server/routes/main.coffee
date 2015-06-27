BooksModel = require '../models/book'
Summaries = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'
uuid = require 'node-uuid'

class Main
  @init: (app) ->
    app.get '/', @home

  @home: (req, res, next) ->
    res.render 'index', { title: 'Instant Classic' }

module.exports = Main
