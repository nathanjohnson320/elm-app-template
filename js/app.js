import { Elm } from "../elm/Main.elm";

let env = document.querySelector("meta[name='env']")?.getAttribute("content");

const elm = Elm.Main.init({
  flags: {
    environment: env || "dev",
    user: null,
  },
});
