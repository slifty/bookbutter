mongoose = require('./mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

summaryNode = new Schema
  ancestors:
    type: [ObjectId]
    default: []
  parentId:
    type: ObjectId
  text:
    type: String
    required: true
  compression:
    type: Number
    required: true
  summaryId:
    type: String
    required: true
  bookId:
    type: ObjectId
    required: true
  order:
    type: Number
    required: true
  height:
    type: Number
    required: true
  maxHeight:
    type: Number
    required: true
  jobExecutionTimestamp:
    type: Date
    required: false

module.exports = mongoose.model 'SummaryNode', summaryNode
