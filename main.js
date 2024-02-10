import "./css/app.css";
import { Elm } from "./elm/Main.elm";

Elm.Main.init({
  flags: {
    environment: process.env.NODE_ENV,
  },
});
