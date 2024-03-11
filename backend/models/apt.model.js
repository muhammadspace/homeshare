const mongoose = require("mongoose")

const aptSchema = new mongoose.Schema({
    location: String,
    // add more attributes here 
})

const Apt = mongoose.model("apt", aptSchema)

module.exports = Apt