const mongoose = require("mongoose")
const bcrypt = require("bcrypt")

const schema = mongoose.Schema(
    {
        type: {
            type: String,
            required: true
        },
        username: {
            type: String,
            required: true
        },
        email: {
            type: String,
            required: true
        },
        password: {
            type: String,
            required: true,
        },
    }
)

schema.pre('save', async function () {
  var user = this;
  if (!user.isModified('password')) {
    return;
  }
  try {
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(user.password, salt);

    // user.owned_apts = Apt.find({ owner: this._id })
    // user.resident_apt = Apt.find({ residents: this._id })

    user.password = hash;
  } catch (err) {
    throw err;
  }
});

schema.methods.comparePassword = async function (candidatePassword) {
  try {
    const isMatch = await bcrypt.compare(candidatePassword, this.password);
    return isMatch;
  } catch (error) {
    throw error;
  }
};

module.exports = mongoose.model("admins", schema, "users2")