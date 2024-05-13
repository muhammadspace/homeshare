const User = require("../models/user.model.js")
const Admin = require("../models/admin.model.js")
const Apt = require("../models/apt.model.js")
const router = require("express").Router()

router.post("/apt/approve", async (req, res) => {
    const loggedInUser = await Admin.findById(req.user.id)
    if (loggedInUser.type.toLowerCase() !== "admin")
        res.json({ success: false, message: "You are not an admin and do not have permissions to approve apartments."}).status(401)

    const aptid = req.body.aptid
    try
    {
        const apt = await Apt.findById(aptid)

        apt.admin_approval = "approved"
        await apt.save()
        res.json({success: true, message: `Approved apartment ${apt._id} by admin`}).status(200)
    }
    catch (err)
    {
        console.log(`
        🔴 An error occured: ${err}
        `)
        res.json({ success: false, message: err.message }).status(500)
    }
})

router.post("/apt/reject", async (req, res) => {
    const loggedInUser = await Admin.findById(req.user.id)
    if (loggedInUser.type.toLowerCase() !== "admin")
        res.json({ success: false, message: "You are not an admin and do not have permissions to reject apartments."}).status(401)

    const aptid = req.body.aptid
    try
    {
        const apt = await Apt.findById(aptid)
        apt.admin_approval = "rejected"
        await apt.save()

        const owner = await User.findById(apt.owner)
        owner.owned_apt = null
        await owner.save()

        res.json({success: true, message: `Rejected apartment ${apt._id} by admin. The owner's 'owned_apt' field has been reset to null.`}).status(200)
    }
    catch (err)
    {
        console.log(`
        🔴 An error occured: ${err}
        `)
        res.json({ success: false, message: err.message }).status(500)
    }
})

module.exports = router