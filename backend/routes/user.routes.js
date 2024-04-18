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
    if (req.params.identifier.length === 12)
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

    const { username, picture, dob, job, gender, move_in_date, type, interests, traits } = user
    const publicUserData = { username, picture, dob, job, gender, move_in_date, type, interests, traits }

    console.log("All user data, before only sending public data:", user)
    res.status(200).json(publicUserData);
})
router.get('/profile', userExtractor, async (req, res) => {
    /* Get the information of the logged-in user */

    const user = await User.findById(req.user.id)
    user.password = "cannot display this information"

    res.status(200).json(user);
})

module.exports = router;