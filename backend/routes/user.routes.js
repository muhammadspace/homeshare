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

    console.log(user)
    res.status(200).json(user);
})

module.exports = router;
