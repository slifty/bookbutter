mongoose = require('./mongoose')
Schema = mongoose.Schema

Leaf = new Schema
  text:
    type: String
    required: true
  chapter:
    type: Number
    required: true

Book = new Schema
  title:
    type: String
    required: true
  description:
    type: String
    required: true
  sampleText:
    type: String
    required: true
  leaves:
    type: [Leaf]
    required: true
  chapters:
    type: Number
    required: true
  paragraphs:
    type: Number
    required: true

module.exports =
   Book: mongoose.model 'Book', Book
   Leaf: mongoose.model 'Leaf', Leaf

