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
        order = 0
        maxHeight = Math.ceil(Math.log(applicableLeaves.length))

        console.log applicableLeaves.length % 2
        if applicableLeaves.length % 2 isnt 0
          # we need to create a parent for the last item
          parent = new Summaries
            text: applicableLeaves[applicableLeaves.length - 1].text
            compression: 1 / (maxHeight)
            summaryId: @id
            bookId: req.params.id
            order: 0
            height: 1
            maxHeight: maxHeight
          parent.save group()
          child = new Summaries
            text: applicableLeaves[applicableLeaves.length - 1].text
            compression: 0
            summaryId: @id
            bookId: req.params.id
            order: order++
            height: 0
            maxHeight: maxHeight
          child.save group()

          applicableLeaves = applicableLeaves.slice(0, -1)

        for applicableLeaf in applicableLeaves
          leaf = new Summaries
            text: applicableLeaf.text
            compression: 0
            summaryId: @id
            bookId: req.params.id
            order: order++
            height: 0
            maxHeight: maxHeight
          leaf.save group()
        return
      (err, summaries) ->
        if err then return next err
        response =
          summaryId: @id
        res.json response
    )

module.exports = Books
