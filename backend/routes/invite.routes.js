const router = require("express").Router()
const Invite = require("../models/invite.model")
const User = require("../models/user.model")
const Apt = require("../models/apt.model")

// create a new invite
router.post("/", async (req, res) => {
    try
    {
        const { to, from, apt } = req.body

        // if (req.headers.authorization)
        const invite = new Invite({ to, from, apt, rejected: false, accepted: false })

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

        const aptObj = await Apt.findById(invite.apt)
        if (!aptObj.invites)
            aptObj.invites = [invite._id]
        else 
            aptObj.invites.push(invite._id)

        await invite.save();
        await recepient.save()
        await sender.save()
        await aptObj.save()

        console.log(`
        ✔ Invite created. 
            ├ ID: ${invite._id}
            ├ Apartment: ${invite.apt}
            ├ To user ID: ${invite.to}
            └ From user ID: ${invite.from}
            `)

        res.json({ id: invite._id, to: invite.to, from: invite.from, apt: invite.apt }).status(201)
    } catch (err) {
        console.log(`
    🔴 An error occured when trying to POST this invite:`)
        console.log(err)
        res.json({ error: err, success: false }).status(500)
    }
})

router.get("/:inviteid", async (req, res) => {
    // get invitation information
    try
    {
        const invite = await Invite.findById(req.params.inviteid)
        
        // update seeker
        const seeker = await User.findById(invite.to)

        if (seeker.resident_apt)
        {
            const oldApt = await Apt.findById(seeker.resident_apt)
            oldApt.residents = oldApt.residents.filter( userid => userid != seeker._id.toString() )
            oldApt.save()
        }

        seeker.resident_apt = invite.apt
        await seeker.save()


        // if (invite.to === auth.user_id)
            res.json({ invite_id: invite._id, from: invite.from, to: invite.to, apt: invite.apt, accepted: invite.accepted, rejected: invite.rejected }).status(200)
            
        // else
        //  res.json({ error: "unauthorized access to invite" }).status(401)
    } catch (err) {
        console.log("An error occured when trying to GET this invite:")
        console.log(err)
        res.json({ error: err, success: false }).status(500)
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
        console.log("🔴 Whoops! An error occured when trying to reject this invite:")
        console.log(err)
        res.json({ error: err, success: false }).status(500)
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
        console.log("🔴 Whoops! An error occured when trying to accept this invite:")
        console.log(err)
        res.json({ error: err, success: false }).status(500)
    }
})

module.exports = router