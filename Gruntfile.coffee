module.exports = (grunt) ->
  require('matchdep').filter('grunt-*').forEach grunt.loadNpmTasks

  grunt.initConfig
    regarde:
      coffee:
        files: [
          'server/**/*.coffee',
          'client/**/*.coffee'
        ]
        tasks: ['default']

    coffee:
      options:
        bare: true
        sourceMap: false
        sourceRoot: "."
      server:
        files: [
          {
            expand: true
            flatten: false
            cwd: 'server'
            src: '**/*.coffee'
            dest: 'dist/server'
            ext: '.js'
          }
        ]
      client:
        files: [
          {
            expand: true
            flatten: false
            cwd: 'client'
            src: '**/*.coffee'
            dest: 'dist/client'
            ext: '.js'
          }
        ]

    copy:
      main: {
        files: [
          {
            expand: true
            src: ['server/views/**']
            dest: 'dist/'
          }
          {
            expand: true
            src: ['client/**']
            dest: 'dist/'
          }
        ]
      }

    coffeelint:
      dist: ['Gruntfile.coffee']
      server:
        files:
          src: ['server/**/*.coffee']
        options:
          max_line_length:
            level: 'warn'
      client:
        files:
          src: ['client/**/*.coffee']
        options:
          max_line_length:
            level: 'warn'

    grunt.registerTask 'supervise', 'Restarts server when changes occur', ->
      require('child_process').spawn(
        'supervisor',
        ['-w', 'dist/server', '--', '--debug=3001', 'dist/server/index.js'],
        { stdio: 'inherit'}
      )

    grunt.registerTask 'watch', [
      'default',
      'copy:main',
      'supervise',
      'regarde'
    ]

    grunt.registerTask 'default', [
      'coffeelint',
      'coffee',
    ]
