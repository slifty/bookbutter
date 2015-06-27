mongoose = require 'mongoose'
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

summaryNode = new Schema
  ancestors:
    type: [ObjectId]
    required: true
  text:
    type: String
    required: true
  compression:
    type: Number
    required: true
