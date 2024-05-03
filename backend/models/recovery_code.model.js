const mongoose = require("mongoose")

const schema = new mongoose.Schema({
    code: {
        type: [Number],
        required: true
    },
    email: {
        type: String,
        required: true
    }
})

module.exports = new mongoose.model("recovery_codes", schema)