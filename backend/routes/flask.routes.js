const express = require("express")
const router = express.Router()
const axios = require("axios")

const flaskAPILink = "http://localhost:5000"

router.post("/recommend/seeker", async (req, res, next) => {
    try
    {
        console.log("received /recommend/seeker request")
        const { seeker_id } = req.body
        const recs_response = await axios.post(`${flaskAPILink}/recommend/seeker`, { seeker_id })
        const recs = recs_response.data
        console.log("sent to Flask")
        console.log(recs)
        res.json(recs)
    }
    catch (err)
    {
        console.log("error", err)
        res.json(err)
    }
})


router.post("/recommend/owner", async (req, res, next) => {
    try
    {
        const { target_user } = req.body
        const recs_response = await axios.post(`${flaskAPILink}/recommend/owner`, { target_user })
        const recs = recs_response.data
        console.log("sent to Flask")
        console.log(recs)
        res.json(recs)
    }
    catch (err)
    {
        console.log("error", err)
        res.json(err)
    }
})

module.exports = router




