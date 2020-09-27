import Prism from "prismjs";

// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.scss";

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html";
import { Socket } from "phoenix";
import LiveSocket from "phoenix_live_view";

// Import local files
//
// Local files can be imported directly using relative paths, for example:
// import socket from "./socket"

// const toggleSwitch = document.querySelector(
//   '.theme-switch input[type="checkbox"]'
// );
// function switchTheme(e) {
//   if (e.target.checked) {
//     document.documentElement.setAttribute("data-theme", "dark");
//     localStorage.setItem("theme", "dark");
//   } else {
//     document.documentElement.setAttribute("data-theme", "light");
//     localStorage.setItem("theme", "light");
//   }
// }

// toggleSwitch.addEventListener("change", switchTheme, false);
// const currentTheme = localStorage.getItem("theme")
//   ? localStorage.getItem("theme")
//   : null;

// if (currentTheme) {
//   document.documentElement.setAttribute("data-theme", currentTheme);

//   if (currentTheme === "dark") {
//     toggleSwitch.checked = true;
//   }
// }

let Hooks = {};
Hooks.ScrollToTop = {
  mounted() {
    this.el.addEventListener("click", e => {
      window.scrollTo(0, 0);
    });
  }
};

document.body.addEventListener("keydown", function(event) {
  const key = event.key;
  if (key === "ArrowLeft" || key === "ArrowRight") {
    window.scrollTo(0, 0);
  }
});

let csrfToken = document
  .querySelector("meta[name='csrf-token']")
  .getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {
  hooks: Hooks,
  params: { _csrf_token: csrfToken }
});

liveSocket.connect();
