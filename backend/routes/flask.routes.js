const express = require("express")
const router = express.Router()
const axios = require("axios")

// const flaskAPILink = "http://localhost:5000"
const flaskAPILink = "https://homeshare-flask.onrender.com"

router.post("/recommend/seekers", async (req, res, next) => {
    try
    {
        console.log("received /recommend/seeker request")
        const { owner_id } = req.body
        const recs_response = await axios.post(`${flaskAPILink}/recommend/seekers`, { owner_id })
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


router.post("/recommend/owners", async (req, res, next) => {
    try
    {
        const { seeker_id } = req.body
        const recs_response = await axios.post(`${flaskAPILink}/recommend/owners`, { seeker_id })
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




