// https://hexdocs.pm/phoenix/asset_management.html#esbuild-plugins
const esbuild = require("esbuild");
const ElmPlugin = require("esbuild-plugin-elm");

const args = process.argv.slice(2);
const watch = args.includes("--watch");
const deploy = args.includes("--deploy");
const serve = args.includes("--serve");

const loader = {
  // Add loaders for images/fonts/etc, e.g. { '.svg': 'file' }
};

let elmPluginOptions = {
  debug: !deploy,
  optimize: deploy,
};

const plugins = [
  // Add and configure plugins here
  ElmPlugin(elmPluginOptions),
];

// Define esbuild options
let opts = {
  entryPoints: ["js/app.js"],
  bundle: true,
  logLevel: "info",
  target: "es2017",
  outdir: "./assets",
  external: ["*.css", "fonts/*", "images/*"],
  loader: loader,
  plugins: plugins,
};

if (deploy) {
  opts = {
    ...opts,
    minify: true,
  };
}

if (watch) {
  opts = {
    ...opts,
    sourcemap: "inline",
  };
  return esbuild
    .context(opts)
    .then((ctx) => {
      ctx.watch();
    })
    .catch((_error) => {
      process.exit(1);
    });
}

if (serve) {
  opts = {
    ...opts,
    sourcemap: "inline",
  };
  return esbuild
    .context(opts)
    .then((ctx) => {
      ctx.watch();
      ctx.serve({ servedir: "assets" });
    })
    .then((ctx) => {
      //   return ctx.serve({ servedir: "assets" });
    })
    .catch((error) => {
      console.log(error);
      process.exit(1);
    });
}

return esbuild.build(opts);
