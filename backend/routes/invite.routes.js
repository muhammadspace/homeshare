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
        console.log(err)
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
        console.log(err)
    }
})

// reject invite request
router.post(("/:inviteid/reject"), async (req, res) => {
    try
    {
        const invite = await Invite.findById(req.params.inviteid)

        if (invite.accepted)
        {
            console.log(`Invite ${req.params.inviteid} was already accepted.`)
            res.json({ success: false, message: `Invite ${req.params.inviteid} was already accepted.` })
        }
        else if (invite.rejected)
        {
            console.log(`Invite ${req.params.invite} was already rejected.`)
            res.json({ success: false, message: `Invite ${req.params.inviteid} was already rejected.` })
        }
        else
        {
            invite.rejected = true
            await invite.save()
            console.log(`Rejected invite ${req.params.inviteid}`)
            res.json({ success: true, message: `Successfully rejected invite ${req.params.inviteid}` }).status(200)
        }
    } catch (err) {
        console.log("🔴 Whoops! An error occured when trying to POST reject this invite:")
        console.log(err)
        res.status(500)
    }
})

// accept invite request
router.post(("/:inviteid/accept"), async (req, res) => {
    try
    {
        const invite = await Invite.findById(req.params.inviteid)

        if (invite.accepted)
        {
            console.log(`Invite ${req.params.inviteid} was already accepted.`)
            res.json({ success: false, message: `Invite ${req.params.invite} was already accepted.` })
        }
        else if (invite.rejected)
        {
            console.log(`Invite ${req.params.inviteid} was already rejected.`)
            res.json({ success: false, message: `Invite ${req.params.inviteid} was already rejected.` })
        }
        else
        {
            invite.accepted = true
            await invite.save()
            console.log(`Accepted invite ${req.params.inviteid}`)
            res.json({ success: true, message: `Successfully accepted invite ${req.params.inviteid}` }).status(200)
        }
    } catch (err) {
        console.log("🔴 Whoops! An error occured when trying to POST accept this invite:")
        console.log(err)
        res.status(500)
    }
})

module.exports = router