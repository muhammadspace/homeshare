// user.routes.js
const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');

router.use(express.json());

router.post('/registration', UserController.register);
router.post('/login', UserController.login);

module.exports = router;
