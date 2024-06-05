const router = require("express").Router()
const Apt = require("../models/apt.model")
const User = require("../models/user.model")
const { userExtractor } = require("../utils/middleware")

// create a new apt
router.post("/", async (req, res) => {
    try
    {
        const properties = { location, owner, max, residents, pictures, price, bedrooms, bathrooms, property_type, start_date, end_date, invites, contract } = req.body
        const apt = new Apt({ ...properties, admin_approval: "pending" })

        const ownerUser = await User.findById(apt.owner)

        if (ownerUser.owned_apt)
        {
            const oldApt = await Apt.findById(ownerUser.owned_apt)
            oldApt.owner = null
            oldApt.save()
            console.log("removed owner from the old apartment")
        }

        ownerUser.owned_apt = apt._id

        await apt.save()
        await ownerUser.save()

        console.log(apt)
        const residentsUsers = []
        if (residents)
        {
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
        }

        console.log(`
    ✅ Successfully created a new apartment!
         ├ admin approval: ${apt.approved_by_admin}
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
        res.json({ message: err.message, success: false }).status(500).end()
    }
})

router.post("/join/:aptid", userExtractor, async (req, res) => {
    try
    {
        const apt = await Apt.findById(req.params.aptid)

        if (Object.prototype.toString.call(apt?.residents) !== "array" || apt?.residents === "empty")
        {
            apt.residents = []
        }

        if (apt?.residents?.length < apt.max)
        {
            const user = await User.findById(req.user.id)

            if (user.resident_apt)
            {
                const oldApt = await Apt.findById(user.resident_apt)
                console.log(oldApt)
                oldApt.residents = oldApt.residents.filter(residentId => residentId.toString() !== user._id.toString())
                await oldApt.save()
            }

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

    if (!apt.owner?.equals(user._id))
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

router.get("/:identifier", async (req, res) => {
    // Get apt by :identifier or get the apt owned by user with :identifier
    let apt = await Apt.findById(req.params.identifier)
    if (apt)
        res.status(200).json(apt)
    else
    {
        const user = await User.findById(req.params.identifier)
        console.log(user)
        apt = await Apt.findById(user.owned_apt)
        res.status(200).json(apt)
    }
})

module.exports = router 