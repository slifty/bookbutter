express = require 'express'
http = require 'http'
books = require './routes/books'
summaries = require './routes/summaries'

app = express()

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

server = http.createServer app

books.init app
summaries.init app

server.listen 3000
