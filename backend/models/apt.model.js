const mongoose = require("mongoose")

const aptSchema = new mongoose.Schema({
    location: {
        type: String,
        required: true,
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
        required: true
    },
    max: {
        type: Number,
        required: true
    },
    residents: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
    }],
    price: {
        type: Number,
        required: true,
    },
    rooms: {
        type: Number,
        required: true,
    },
    bathrooms: {
        type: Number,
        required: true,
    },
    furnished: {
        type: Boolean,
        required: true,
    },
    available: {
        type: Boolean,
        required: true,
    },
    invites: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "invite"
    }]
})

const Apt = mongoose.model("apt", aptSchema)

module.exports = Apt