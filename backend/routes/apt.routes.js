const router = require("express").Router()
const Apt = require("../models/apt.model")

// create a new apt
router.post("/", async (req, res) => {
    try
    {
        const properties = { location, residents, owner, price, rooms, bathrooms, furnished, invites } = req.body
        const tmpApt = new Apt({ ...properties, available: true })
        const apt = await tmpApt.save()

        console.log(`
    ✅ Successfully created a new apartment!
         ├ location: ${location}
         └ id: ${apt._id}
        `)
        res.json({ ...properties, id: apt._id, available: apt.available }).status(201)
    } catch (err) {
        console.log(`
        🔴 Whoops! An error occured while trying to create a new apartment:
        `)
        console.log(err)
        res.json({ error: err, success: false }).status(500).end()
    }
})

router.post("/join/:aptid", async (req, res) => {
    try
    {

    } catch (err) {
        console.log(`
        🔴 Whoops! An error occured while trying to join this apartment:
        `)
        console.log(err)
        res.json({ error: err, success: false }).status(500)
    }
})

module.exports = router 