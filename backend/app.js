// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const middleware = require("./utils/middleware.js")
const UserRoute = require('./routes/user.routes');
const FlaskRoute = require("./routes/flask.routes.js")
const InviteRoute = require("./routes/invite.routes.js")
const AptRoute = require("./routes/apt.routes")
const app = express();

const Invite = require("./models/invite.model.js")
const User = require("./models/user.model.js")
const Apt = require('./models/apt.model.js');

app.use(bodyParser.json());
app.use(cors());
app.use(middleware.tokenExtractor)

app.use('/', UserRoute);
app.use("/flask/", FlaskRoute);
app.use("/invite/", middleware.userExtractor, InviteRoute)
app.use("/apt", AptRoute)

// temporary
app.get('/all', async (req, res) => {
    const users = await User.find({})
    const invites = await Invite.find({})
    const apts = await Apt.find({})

    res.json({
        users,
        invites,
        apts
    })
})

module.exports = app;
