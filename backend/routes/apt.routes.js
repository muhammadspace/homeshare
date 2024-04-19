const router = require("express").Router()
const Apt = require("../models/apt.model")
const User = require("../models/user.model")
const { userExtractor } = require("../utils/middleware")

// create a new apt
router.post("/", async (req, res) => {
    try
    {
        const properties = { location, residents, owner, price, rooms, bathrooms, furnished, invites } = req.body
        const tmpApt = new Apt({ ...properties, available: true })
        const apt = await tmpApt.save()

        const ownerUser = await User.findById(apt.owner)
        ownerUser.owned_apts.push(apt._id)
        await ownerUser.save()

        const residentsUsers = []
        await new Promise( (resolve, reject) => {
            residents.forEach( async resident => {
                const user = await User.findById(resident)
                residentsUsers.push(user) 

                if (residentsUsers.length == residents.length)
                    resolve()
            })
        })
        residentsUsers.forEach( async user => {
            user.resident_apt = apt._id
            await user.save()
        })

        console.log(`
    ✅ Successfully created a new apartment!
         ├ location: ${location}
         ├ owner: ${owner}
         └ id: ${apt._id}
         *rest of the information is saved to the database.
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

router.post("/join/:aptid", userExtractor, async (req, res) => {
    try
    {
        const apt = await Apt.findById(req.params.aptid)

        if (apt.residents.length < apt.max)
        {
            const user = await User.findById(req.user.id)
            apt.residents.push(user._id)
            user.resident_apt = apt._id
            apt.save()
            user.save()

            console.log(`
    🏡 Successfully joined this apartment
            `)
            res.status(200).json({ success: true, message: `Successfully added user ${user._id} - ${user.username} to this apartment.` })
        }
        else
            res.status(403).json({ success: false, error: "This apartment already has the maximum number of users" })
    } catch (err) {
        console.log(`
    🔴 An error occured while trying to join this apartment:
        `)
        console.log(err)
        res.json({ error: err, success: false }).status(500)
    }
})

router.post("/kick/", userExtractor, async (req, res) => {
    const user = await User.findById(req.user.id)
    const apt = await Apt.findById(req.body.apt)

    if (!apt.owner.equals(user._id))
    {
        console.log(`
    🔴 Could not remove ${resident.username} - ${resident._id} from this apartment. You are not the owner of this apartment.
        `)
        res.status(401).json({ success: false, message: "You are not the owner of this apartment." })
        return
    }

    const resident = await User.findById(req.body.resident)

    resident.resident_apt = null
    apt.residents = apt.residents.filter( id => !id.equals(resident._id) )
    apt.save()
    resident.save()

    console.log(`
    🗑 Successfully removed ${resident.username} - ${resident._id} from this apartment.
    `)
    res.status(200).json({ success: true, message: `Successfully removed ${resident.username} - ${resident._id} from this apartment.` })
})

router.get("/:id", async (req, res) => {
    const apt = await Apt.findById(req.params.id)
    res.status(200).json(apt)
})

module.exports = router 