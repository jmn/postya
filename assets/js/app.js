import Prism from "prismjs"

// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"
import { Socket } from "phoenix"
import LiveSocket from "phoenix_live_view"

let liveSocket = new LiveSocket("/live", Socket)
liveSocket.connect()

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

// Dark mode js: https://codepen.io/kleinfreund/pen/bJwqpB
document.addEventListener("DOMContentLoaded", function() {
    const checkbox = document.querySelector(".dark-mode-checkbox")

    checkbox.checked = localStorage.getItem("darkMode") === "true"

    checkbox.addEventListener("change", function(event) {
        localStorage.setItem("darkMode", event.currentTarget.checked)
    })
})
