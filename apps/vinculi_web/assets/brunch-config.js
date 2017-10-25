exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
    javascripts: {
      joinTo: "js/app.js",

      // To use a separate vendor.js bundle, specify two files path
      // http://brunch.io/docs/config#-files-
      // joinTo: {
      //   "js/app.js": /^js/,
      //   "js/vendor.js": /^(?!js)/
      // }
      //
      // To change the order of concatenation of files, explicitly mention here
      // order: {
      //   before: [
      //     "vendor/js/jquery-2.1.1.js",
      //     "vendor/js/bootstrap.min.js"
      //   ]
      // }
    },
    stylesheets: {
      joinTo: "css/app.css",
      order: {
        after: ["css/app.scss", "node_modules/colors.css/css/colors.css"] // concat app.css last
      }
    },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/assets/static". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(static)/
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: ["static", "css", "js", "vendor", "elm"],
    // Where to compile files to
    public: "../priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/vendor/]
    },
    copycat: {
      "fonts": ["node_modules/font-awesome/fonts"], // copy node_modules/font-awesome/fonts/* to priv/static/fonts/
      verbose: true,
      onlyChanged: true
    },
    elmBrunch: {
      elmFolder: "elm",

      executablePath: "../node_modules/elm/binwrappers",
      mainModules: ["src/VinculiExplorer.elm"],
      makeParameters: ["--debug"],
      outputFolder: "../js/vinculi-explorer",
      outputFile: "elm-vinculi-explorer.js"
    },
    sass: {
      options: {
        includePaths: ["node_modules/bootstrap/scss", "node_modules/font-awesome/scss"], // tell sass-brunch where to look for files to @import
        precision: 8 // minimum precision required by bootstrap
      }
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["js/app"]
    }
  },

  npm: {
    enabled: true,
    globals: { // Bootstrap JavaScript requires both '$', 'jQuery', and Popper in global scope
      $: 'jquery',
      jQuery: 'jquery',
      Popper: 'popper.js',
      bootstrap: 'bootstrap' // require Bootstrap JavaScript globally too
    },
    styles: {
      "colors.css": ["css/colors.css"]
    }
  }
};
