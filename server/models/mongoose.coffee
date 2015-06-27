mongoose = require 'mongoose'

mongoUri = 'mongodb://localhost:27017/tldr'
mongoose.connect mongoUri

module.exports = mongoose
