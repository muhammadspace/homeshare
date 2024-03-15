// user.service.js
const UserModel = require('../models/user.model');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
require("dotenv").config()

const registerUser = async (userData) => {
    try {
        const createUser = new UserModel({ ...userData });
        return await createUser.save();
    } catch (err) {
        console.error("Error in registerUser service:", err);
        throw err;
    }
}

const loginUser = async (email, password) => {
    try {
        const user = await UserModel.findOne({ email });
        if (!user) throw new Error('User not found');

        const isMatch = await bcrypt.compare(password, user.password);
        if (!isMatch) throw new Error('Invalid password');

        return await generateAccessToken({ id: user._id, email: user.email, username: user.username }, process.env.JWT_SECRET_KEY, process.env.JWT_EXPIRE);
    } catch (err) {
        console.error("Error in loginUser service:", err);
        throw err;
    }
}

const generateAccessToken = async (tokenData, JWTSecret_Key, JWT_EXPIRE) => {
    // const JWTSecret_Key = 'your_secret_key';  // Replace with your actual secret key
    // const JWT_EXPIRE = '1h';  // Replace with your desired expiration time

    console.log(JWTSecret_Key, JWT_EXPIRE)
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
}

module.exports = {
    registerUser,
    loginUser,
    generateAccessToken,
};
