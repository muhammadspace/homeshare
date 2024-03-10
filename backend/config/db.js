// db.js
const mongoose = require('mongoose');

mongoose.connect('mongodb+srv://swdproject:swdproject@cluster0.56yizii.mongodb.net/gp?retryWrites=true&w=majority' /* , {
  useNewUrlParser: true,
  useUnifiedTopology: true,
} */ );

const db = mongoose.connection;

db.on('error', (err) => {
  console.error('MongoDB Connection error:', err);
});

db.once('open', () => {
  console.log('MongoDB Connected');
});

module.exports = db;
