mongoose = require 'mongoose'

mongoUri = process.env.MONGOHQ_URL || 'mongodb://localhost:27017/tldr'
mongoose.connect mongoUri

module.exports = mongoose
