express = require 'express'
http = require 'http'

app = express()

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

server = http.createServer app

server.listen 3000