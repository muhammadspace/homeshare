const mongoose = require("mongoose")

const aptSchema = new mongoose.Schema({
    location: {
        type: String,
        required: true,
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
        // required: true
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
    bedrooms: {
        type: Number,
        required: true,
    },
    bathrooms: {
        type: Number,
        required: true,
    },
    property_type:
    {
        type: String,
        required: true
    },
    start_date: {
        type: Date,
        required: true,
    },
    end_date: {
        type: Date,
        required: true,
    },
    invites: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: "invite"
    }],
    contract: String,
    approved_by_admin: String, 
})

const Apt = mongoose.model("apt", aptSchema)

module.exports = Apt