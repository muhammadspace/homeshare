const mongoose = require("mongoose")
const bcrypt = require("bcrypt")

const schema = mongoose.Schema(
    {
        type: {
            type: String,
            required: true
        },
        username: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true
        },
        password: {
            type: String,
            required: true,
        },
    }
)

module.exports = mongoose.model("admins", schema, "users2")