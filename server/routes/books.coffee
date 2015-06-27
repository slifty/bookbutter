BooksModel = require '../models/book'
Summaries = require '../models/summary_node'
Step = require 'step'
_ = require 'lodash'
uuid = require 'node-uuid'

class Books
  @init: (app) ->
    app.get '/books', @find
    app.get '/books/:id', @get
    app.post '/books/:id/start', @start

  @find: (req, res, next) ->
    BooksModel.find({}, (err, books) ->
      return next err if err
      res.json books
    )

  @get: (req, res, next) ->
    BooksModel.findById req.params.id, (err, book) ->
      return next err if err
      res.json book

  @start: (req, res, next) ->
    Step(
      ->
        BooksModel.findById req.params.id, @
        return
      (err, book) ->
        throw err if err
        filter = {}
        if req.query.chapters?
          filter[chapter] = true for chapter in req.query.chapters.split ','
        else
          filter[chapter] = true for chapter in [1...book.chapters]
        applicableLeaves = _.filter(book.leaves, (leaf) -> filter[leaf.chapter]? )
        group = @group()
        @id = uuid.v1()
        for applicableLeaf in applicableLeaves
          leaf = new Summaries
            text: applicableLeaf.text
            compression: 0
            summaryId: @id
          leaf.save group()
        return
      (err, summaries) ->
        if err then return next err
        response =
          summaryId: @id
        res.json response
    )

module.exports = Books