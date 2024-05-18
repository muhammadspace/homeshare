const router = require("express").Router()
const axios = require("axios")

// const flaskAPILink = "http://localhost:5000"
const flaskAPILink = "https://homeshare-flask.onrender.com"

router.post("/", async (req, res) => {
    const message = req.body.message
    const chatResponse = await axios.post(`${flaskAPILink}/chat`, { message })

    res.status(200).json(chatResponse.data)
})

module.exports = router