mongoose = require('./mongoose')
Schema = mongoose.Schema
ObjectId = Schema.ObjectId

summaryNode = new Schema
  ancestors:
    type: [ObjectId]
    default: []
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

module.exports = mongoose.model 'SummaryNode', summaryNode
