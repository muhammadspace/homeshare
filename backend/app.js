// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const UserRoute = require('./routes/user.routes');
const FlaskRoute = require("./routes/flask.routes.js")
const InviteRoute = require("./routes/invite.routes.js")
const app = express();

app.use(bodyParser.json());
app.use(cors());

app.use('/', UserRoute);
app.use("/flask/", FlaskRoute);
app.use("/invite/", InviteRoute)

module.exports = app;
