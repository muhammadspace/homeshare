// user.service.js
const UserModel = require('../models/user.model');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');

class UserServices {
  static async registerUser(userData) {
    try {
      const createUser = new UserModel({ ...userData });
      return await createUser.save();
    } catch (err) {
      console.error("Error in registerUser service:", err);
      throw err;
    }
  }

  static async loginUser(email, password) {
    try {
      const user = await UserModel.findOne({ email });
      if (!user) throw new Error('User not found');

      const isMatch = await bcrypt.compare(password, user.password);
      if (!isMatch) throw new Error('Invalid password');

      return await this.generateAccessToken({ email: user.email }, process.env.JWT_SECRET_KEY, process.env.JWT_EXPIRE);
    } catch (err) {
      console.error("Error in loginUser service:", err);
      throw err;
    }
  }

  static async generateAccessToken(tokenData) {
    const JWTSecret_Key = 'your_secret_key';  // Replace with your actual secret key
    const JWT_EXPIRE = '1h';  // Replace with your desired expiration time
  
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
  }
}

module.exports = UserServices;
