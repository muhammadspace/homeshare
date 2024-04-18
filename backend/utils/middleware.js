const express = require("express")
const jwt = require("jsonwebtoken")

const tokenExtractor = (req, res, next) => {
    const authorization = req.get("Authorization")
    console.log(authorization)
    if (authorization && authorization.startsWith("Bearer"))
    {
        const token = authorization.replace("Bearer ", "")
        req.token = token
    }

    next()
}

const userExtractor = (req, res, next) => {
    const decodedToken = jwt.decode(req.token, process.env.JWTSecret_Key)
    if (!decodedToken)
        return res.status(401).json({ success: false, message: "Invalid or missing token" })

    req.user = decodedToken
    console.log(req.user)

    next()
}

module.exports = {
    tokenExtractor,
    userExtractor,
}