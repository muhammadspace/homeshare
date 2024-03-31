// user.routes.js
const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const User = require("../models/user.model")

router.use(express.json());

router.post('/registration', UserController.register);
router.post('/login', UserController.login);
router.get('/:id', async (req, res) => {
    const user = await User.findById(req.params.id)
    console.log(user)
})

module.exports = router;
