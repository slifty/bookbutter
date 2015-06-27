mongoose = require 'mongoose'
Schema = mongoose.Schema

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
    type: [String]
    required: true
  chapters:
    type: Number
    required: true
  paragraphs:
    type: Number
    required: true

module.exports = mongoose.model 'Book', Book
