const db = require('../config/db');
const bcrypt = require('bcrypt');
const mongoose = require('mongoose');
const Apt = require('./apt.model');
const { Schema } = mongoose;

const userSchema = new Schema({
  username: {
    type: String,
    required: [true, "Username can't be empty"],
    unique: true
  },
  email: {
    type: String,
    lowercase: true,
    required: [true, "Email can't be empty"],
    match: [
      /^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})?$/,
      'Email format is not correct',
    ],
    unique: true,
  },
  password: {
    type: String,
    required: [true, 'Password is required'],
  },
  picture: {
    type: String,
    // required: true
  },
  dob: {
    type: Date,
    required: true
  },
  job: {
    type: String,
    required: true
  },
  gender: {
    type: String,
    required: true
  },
//   move_in_date: {
//     type: Date,
//     required: true
//   },
  type: {
    type: String,
    required: true
  },
  invites: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: "invite",
  }],
//   interests: [String],
  hobbies_pastimes: {
    type: String,
    required: true
  },
  sports_activities: {
    type: String,
    required: true
  },
  cultural_artistic: {
    type: String,
    required: true
  },
  intellectual_academic: {
    type: String,
    required: true
  },
  personality_trait: {
    type: String,
    // required: true
  },
  value_belief: {
    type: String,
    // required: true
  },
  interpersonal_skill: {
    type: String,
    // required: true
  },
  work_ethic: {
    type: String,
    // required: true
  },
  owned_apt: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "apt",
  },
  resident_apt: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "apt",
  },
  notification: String,
  picture: {
    type: mongoose.Schema.Types.ObjectId,
    ref: "image"
  }
}, { timestamps: true });

userSchema.pre('save', async function () {
  var user = this;
  if (!user.isModified('password')) {
    return;
  }
  try {
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(user.password, salt);

    user.owned_apts = Apt.find({ owner: this._id })
    user.resident_apt = Apt.find({ residents: this._id })

    user.password = hash;
  } catch (err) {
    throw err;
  }
});

userSchema.methods.comparePassword = async function (candidatePassword) {
  try {
    const isMatch = await bcrypt.compare(candidatePassword, this.password);
    return isMatch;
  } catch (error) {
    throw error;
  }
};

userSchema.set("toJSON", {
    transform: (document, returnedDocument) => {
        delete returnedDocument.password
        delete returnedDocument._v
    }
})

const UserModel = db.model('users2', userSchema);
module.exports = UserModel;