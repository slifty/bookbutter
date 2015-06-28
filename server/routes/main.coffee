BooksModel = require '../models/book'
Summaries = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'
uuid = require 'node-uuid'

class Main
  @init: (app) ->
    app.get '/', @home
    app.get '/read', @read
    app.get '/write', @write
    app.get '/browse', @browse

  @home: (req, res, next) ->
    res.render 'index', { title: 'Instant Classic' }

  @write: (req, res, next) ->
    res.render 'write', { title: 'Instant Classic' }

  @read: (req, res, next) ->
    res.render 'read', { title: 'Instant Classic' }

  @browse: (req, res, next) ->
    res.render 'browse', { title: 'Instant Classic' }

module.exports = Main
