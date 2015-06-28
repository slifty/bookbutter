mongoose = require 'mongoose'

mongoUri = process.env.MONGOLAB_URI || 'mongodb://localhost:27017/tldr'
mongoose.connect mongoUri

module.exports = mongoose
