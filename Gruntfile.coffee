module.exports = ( grunt ) ->

    grunt.initConfig

        pkg : grunt.file.readJSON "package.json"

        meta :

            banner : '/*! <%= pkg.title || pkg.name %> - v<%= pkg.version %> - ' +
            '<%= grunt.template.today("yyyy-mm-dd") %>\n ' +
            '<%= pkg.homepage ? "* " + pkg.homepage + "\\n *\\n " : "" %>' +
            '* Copyright (c) <%= grunt.template.today("yyyy") %> <%= pkg.author.name %> <<%= pkg.author.email %>>;\n' +
            ' * Licensed under the <%= _.pluck(pkg.licenses, "type").join(", ") %> license */\n\n'

        #  Remove old build.
        #
        clean :

            dist :

                src : [ "dist" ]

        #  Copy the images and the index to the dist location.
        #
        copy :

            dist :

                files : [
                    { expand: true, cwd: "src", src: "images/**/*", dest: "dist/src" }
                ,   { expand: true, cwd: "src", src: "css/**/*",  dest: "dist/src" }
                ,   { expand: true, cwd: "src", src: "js/**/*",  dest: "dist/src" }
                ,   { expand: true, cwd: "src", src: "index.html",  dest: "dist/src" }
                ]

        #  Validate javascript files with jsHint.
        #
        jshint :

            options :

                jshintrc : ".jshintrc"

            all : [
                #"src/lib/*.js"
                "src/core/**/*.js"
            ]

        #  Minify the javascript.
        #
        uglify :

            dist :

                options :

                    banner   : "<%= meta.banner %>"
                    beautify : false

                files :

                        "dist/src/js/jquery.<%= pkg.name %>.min.js" : ["dist/src/js/jquery.<%= pkg.name %>.js"]


        #  Replace image file paths in css and correct css path in the index.
        #
        replace :

            dist :
                src : [
                    "dist/src/index.html"
                ]
                overwrite     : true
                replacements  : [
                    {
                        from : /@@bnr@@/ig
                    ,   to   : "<%= pkg.version %>"
                    }
                ]

        # Make a zipfile.
        #
        compress :

            dist :

                options :

                    archive: "dist/<%= pkg.name %>-<%= pkg.version %>.zip"

                expand  : true
                cwd     : "dist/src"
                src     : ["**/*"]
                dest    : "."


    #  Load all the task modules we need.
    #
    grunt.loadNpmTasks "grunt-contrib-copy"
    grunt.loadNpmTasks "grunt-contrib-clean"
    grunt.loadNpmTasks "grunt-contrib-uglify"
    grunt.loadNpmTasks "grunt-text-replace"
    grunt.loadNpmTasks "grunt-contrib-compress"

    #  Distribution build
    #
    grunt.registerTask(

        "default"
    ,   [
            "clean:dist"
            "copy:dist"
            "uglify:dist"
            "compress:dist"
        ]
    )
