const router = require("express").Router()
const Invite = require("../models/invite.model")
const User = require("../models/user.model")
const Apt = require("../models/apt.model")

router.post("/", async (req, res) => {
    // owner invites a seeker to join his apartment
    try
    {
        const { to, from, apt } = req.body
        const tmpInvite = new Invite({ to, from, apt, rejected: false, accepted: false })

        const invite = await tmpInvite.save()

        const recepient = await User.findById(invite.to)
        if (!recepient.invites)
            recepient.invites = [invite._id]
        else 
            recepient.invites.push(invite._id)

        const sender = await User.findById(invite.from)
        if (!sender.invites)
            sender.invites = [invite._id]
        else 
            sender.invites.push(invite._id)

        recepient.save()
        sender.save()

        console.log(`
            ✔ Invite created. 
                ID: ${invite._id}
                Apartment: ${invite.apt}
                To user ID: ${invite.to}
                From user ID: ${invite.from}
            `)

        res.json({ id: invite._id, to: invite.to, from: invite.from, apt: invite.apt }).status(200)
    } catch (err) {
        console.log("Whoops! An error occured when trying to POST this invite:")
        console.err(err)
    }
})

router.get("/:inviteid", async (req, res) => {
    // get invitation information
    try
    {
        const invite = await Invite.findById(req.params.inviteid)

        // if (invite.to === auth.user_id)
            res.json({ invite_id: invite._id, from: invite.from, apt: invite.apt }).status(200)
        // else
        //  res.json({ error: "unauthorized access to invite" }).status(401)
    } catch (err) {
        console.log("Whoops! An error occured when trying to GET this invite:")
        console.err(err)
    }
})

module.exports = router