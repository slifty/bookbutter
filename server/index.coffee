express = require 'express'
http = require 'http'
books = require './routes/books'
summaries = require './routes/summaries'
main = require './routes/main'

app = express()

app.configure ->
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router

app.set 'view engine', 'jade'
app.set 'views', __dirname + '/views'

app.use '/static', express.static 'dist/client'
app.use '/static/lib', express.static 'bower_components'

server = http.createServer app

books.init app
summaries.init app
main.init app

server.listen(process.env.PORT || 3000)
