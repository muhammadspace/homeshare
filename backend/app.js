// app.js
const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const middleware = require("./utils/middleware.js")
const UserRoute = require('./routes/user.routes');
const AdminRoute = require('./routes/admin.routes');
const FlaskRoute = require("./routes/flask.routes.js")
const InviteRoute = require("./routes/invite.routes.js")
const AptRoute = require("./routes/apt.routes.js")
const ChatRoute = require("./routes/chat.routes.js")
const app = express();

app.use(bodyParser.json());
app.use(cors());
app.use(middleware.tokenExtractor)
// app.use(middleware.userExtractor)

app.use('/', UserRoute);
app.use("/flask/", FlaskRoute);
app.use("/invite/", middleware.userExtractor, InviteRoute)
app.use("/apt", AptRoute)
app.use("/admin", middleware.userExtractor, AdminRoute);
app.use("/chat", ChatRoute)

module.exports = app;