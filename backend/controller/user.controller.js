// user.controller.js
const UserService = require('../services/user.service');

exports.register = async (req, res, next) => {
  try {
    const userData = { username, email, password, picture, dob, job, gender, move_in_date, type, interests, traits } = req.body;
    const successRes = await UserService.registerUser(userData);
    res.json({ success: true, message: 'User Registered Successfully' });
    console.log("User registered successfully")
  } catch (error) {
    console.error("Error in registration:", error);
    res.status(500).json({ success: false, message: 'Internal Server Error' });
  }
};

exports.login = async (req, res, next) => {
  try {
    const { email, password } = req.body;
    console.log('Received login request:', { email, password, headers: req.headers });

    const token = await UserService.loginUser(email, password);
    
    console.log('Login successful. Generated token:', token);

    res.json({ success: true, message: 'Login successful', token });
  } catch (error) {
    console.error("Error in login:", error);
    res.status(401).json({ success: false, message: 'Invalid email or password' });
  }
};