const mongoose = require("mongoose")
const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const User = require("../models/user.model");
const { userExtractor } = require('../utils/middleware');
const mailer = require("../mailer.js")

router.use(express.json());

router.post('/registration', UserController.register);
router.post('/login', UserController.login);
router.get('/user/:identifier', async (req, res) => {
    /* Get the public information of any user */

    // determine if identifier is an id or a username
    let user;
    if (req.params.identifier.length === 24)
    {
        const identifierToObjectId = new mongoose.Types.ObjectId(req.params.identifier)
        if (identifierToObjectId.toString() === req.params.identifier)
            // is id
            user = await User.findById(req.params.identifier)
        else
            // is username
            user = await User.findOne({ username: req.params.identifier })
    }
    else
        // is username
        user = await User.findOne({ username: req.params.identifier })

    await user.save()
    console.log(user)
    res.status(200).json(user);
})

router.post('/profile', userExtractor, async (req, res) => {
    /* Update the information of the logged-in user */

    const user = await User.findById(req.user.id)
    const oldInfo = user.toObject()
    const newInfo = { ...req.body }

    for (key of Object.keys(newInfo))
        user[key] = newInfo[key]

    await user.save()

    console.log("Successfully updated user information:", newInfo)
    res.status(200).json(user);
})

router.post('/reset_password', async (req, res) => {
    const userEmailAddress = req.body.userEmailAddress
    const resetLink = "https://google.com/"
    if (userEmailAddress)
    {
        mailer.send(userEmailAddress, "HomeHarmony - reset your passowrd", 
        `
        <h2>Hello!</h2>
        <p>We received a request from you to <a href="${resetLink}"><b>reset your HomeHarmony acount password</b></a>. If this wasn't you, please make sure to secure your account and email address.</p>
        <br>
        <br>
        <p>The HomeHarmony team</p>`)

        res.status(200).json({success: true, message: "An email was sent with the reset password instructions."})
    }
    else
    {
        res.status(404).json({success: false, message: "No email address was provided in the request body."})
    }
})
module.exports = router;