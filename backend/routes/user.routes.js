const mongoose = require("mongoose")

const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const User = require("../models/user.model");
const { userExtractor } = require('../utils/middleware');

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

    // const { username, picture, dob, job, gender, move_in_date, type, interests, traits, owned_apts, resident_apt } = user
    // const publicUserData = { username, picture, dob, job, gender, move_in_date, type, interests, traits, owned_apts, resident_apt }

    // console.log("All data of this user, before sending only the user's public data:", user)
    await user.save()
    console.log(user)
    // res.status(200).json(publicUserData);
    res.status(200).json(user);
})
router.get('/profile', userExtractor, async (req, res) => {
    /* Get the information of the logged-in user */

    const user = await User.findById(req.user.id)
    user.password = "cannot display this information"

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

    // for (key of Object.keys(newInfo))
    //     console.log("old:", Object.entries(oldInfo).filter( ([k, v]) => k === key ))
    // console.log("new:", newInfo)

    console.log("Successfully updated user information:", newInfo)
    res.status(200).json(user);
})

module.exports = router;