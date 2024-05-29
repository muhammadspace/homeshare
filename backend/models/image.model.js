const mongoose = require("mongoose")

const schema = new mongoose.Schema({
  path: String,
  originalName: String
});

module.exports = mongoose.model('image', schema);