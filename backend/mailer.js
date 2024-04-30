const postmark = require("postmark")

const client = new postmark.ServerClient("a5309d45-a787-4a26-bf03-5f395d48732d")

const send = (To, Subject, HtmlBody) => {
    client.sendEmail({
        "From": "mohamed10.sw2021@fci.helwan.edu.eg",
        To,
        Subject,
        HtmlBody,
        "MessageStream": "outbound"
    });
}

module.exports = {
    send
}