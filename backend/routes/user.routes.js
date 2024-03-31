// user.routes.js
const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const User = require("../models/user.model");
const { userExtractor } = require('../utils/middleware');

router.use(express.json());

router.post('/registration', UserController.register);
router.post('/login', UserController.login);
router.get('/user/:id', userExtractor, async (req, res) => {
    const user = await User.findById(req.params.id)
    console.log(user)

    res.status(200).json(user);
})

module.exports = router;
