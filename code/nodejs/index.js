const express = require("express");
const nodeinfo = require('nodejs-info');
const app = express();

app.listen(80, function () {
  console.log("listening on 80");
});

app.get("/", (req, res) => {
  res.send(nodeinfo(req));
});
