const mongoose = require("mongoose")
const express = require('express');
const router = express.Router();
const UserController = require('../controller/user.controller');
const User = require("../models/user.model");
const Apt = require("../models/apt.model.js")
const RecoveryCode = require("../models/recovery_code.model.js")
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

    if (oldInfo.owned_apt)
    {
        const old_apt = await Apt.findById(oldInfo.owned_apt)
        old_apt.owner = null
        await old_apt.save()
        console.log("removed owner from the old apartment")
    }

    for (key of Object.keys(newInfo))
        user[key] = newInfo[key]

    await user.save()

    console.log("Successfully updated user information:", newInfo)
    res.status(200).json(user);
})

router.post('/reset_password', async (req, res) => {
    const email = req.body.email
    console.log(req.body)

    if (!email)
    {
        res.status(404).json({success: false, message: "No email address was provided in the request body."})
        return
    }

    const code = [0, 0, 0, 0, 0, 0]
    code.forEach( (_, idx) => {
        const digit = Math.round(Math.random() * 9)
        code[idx] = digit
    })

    let recoveryCode = await RecoveryCode.findOne({ email });
    if (recoveryCode)
    {
        console.log("recovery code found")
        recoveryCode.code = code
        await recoveryCode.save()
    }
    else
    {
        console.log("no recovery code found")
        recoveryCode = new RecoveryCode({code, email})
        await recoveryCode.save()
    }

    console.log(recoveryCode)

    if (email)
    {
        mailer.send(email, "HomeHarmony - reset your passowrd", 
        `
        <h2>Hello!</h2>
        <p>We received a request from you to <b>reset your HomeHarmony acount password</b>. Please enter the following 6-digit code in the HomeHarmony application to reset your password:
        
        <p><b>${recoveryCode.code[0]} - ${recoveryCode.code[1]} - ${recoveryCode.code[2]} - ${recoveryCode.code[3]} - ${recoveryCode.code[4]} - ${recoveryCode.code[5]}</b></p>
        
        Make sure to not share this code with anyone! If you did not request to reset your password, please make sure to secure your account and email address.</p>
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

router.post("/reset_password_confirm", async (req, res) => {
    const {email, code} = req.body
    const recoveryCode = await RecoveryCode.findOne({email: email})
    console.log(req.body)

    if (recoveryCode)
    {
        let codeMatches = true
        console.log("recovery code found", recoveryCode.code)
        recoveryCode.code.forEach( (digit, idx) => {
            if (digit != code[idx])
                codeMatches = false;
        })

        if (codeMatches)
        {
            console.log("User-provided code matches the recovery code.")
            res.status(200).json({success: true, message: "User-provided code matches the recovery code."})
        }
        else
        {
            console.log("User-provided code does not match the recovery code.")
            res.status(401).json({success: false, message: "User-provided code does not match the recovery code."})
        }
    }
    else
    {
        console.log("Could not find any recovery codes matching this email address.")
        res.status(404).json({success: false, message: "Could not find any recovery codes matching this email address."})
    }
})

router.post("/set_new_password", async (req, res) => {
    const { newPassword, email } = req.body
    const user = await User.findOne({email})
    user.password = newPassword;
    await user.save();
    console.log('yeah baby, new password set!');
    res.status(200).json({success: true, message: "Successfully reset password."})
})

module.exports = router;