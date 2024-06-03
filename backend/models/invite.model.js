const mongoose = require("mongoose")

const inviteSchema = new mongoose.Schema({
    to: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user"
    },
    from: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user"
    },
    apt: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "apt"
    },
    markAsRead: Boolean,
    rejected: Boolean,
    accepted: Boolean
})

const Invite = mongoose.model("invite", inviteSchema)

module.exports = Invite