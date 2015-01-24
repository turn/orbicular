module.exports = (grunt) ->

	[
		'grunt-contrib-clean'
		'grunt-contrib-coffee'
		'grunt-contrib-concat'
		'grunt-contrib-jasmine'
		'grunt-contrib-jshint'
		'grunt-contrib-sass'
		'grunt-contrib-watch'
		'grunt-express-server'
		'grunt-coveralls'
		'grunt-html2js'
		'grunt-ngmin'
		'grunt-browserify'
		'grunt-contrib-uglify'
		'grunt-contrib-cssmin'
	]
	.forEach grunt.loadNpmTasks

	# task sets
	build = ['clean:pre', 'test', 'sass:dev', 'clean:post']
	test = ['html2js', 'browserify', 'coffee:unit', 'jasmine:unit']
	run = ['build', 'express:dev', 'watch']
	release = ['build', 'uglify', 'cssmin']

	# task defs
	grunt.initConfig

		pkg: grunt.file.readJSON 'package.json'

		clean:
			pre: [
				'build'
			]
			post: []

		coffee:
			unit:
				files:
					'test/unit.js': 'test/unit.coffee'

		coveralls:
			options:
				force: true
			main:
				src: 'reports/lcov/lcov.info'

		html2js:
			main:
				src: './src/html/*.html'
				dest: './src/template-build.js'
			options:
				base: './src/html'
				module: 'turnOrbicularTemplate'

		jasmine:
			coverage:
				src: [
					'./build/turn-orbicular.js'
				]
				options:
					specs: ['./test/unit.js']
					template: require 'grunt-template-jasmine-istanbul'
					templateOptions:
						coverage: 'reports/lcov/lcov.json'
						report: [
							{
								type: 'html'
								options:
									dir: 'reports/html'
							}
							{
								type: 'lcov'
								options:
									dir: 'reports/lcov'
							}
						]
					type: 'lcovonly'
					vendor: [
						'./bower_components/angular/angular.js'
						'./bower_components/angular-mocks/angular-mocks.js'
					]
			unit:
				src: './build/turn-orbicular.js'
				options:
					specs: './test/unit.js'
					vendor: [
						'./bower_components/angular/angular.js'
						'./bower_components/angular-mocks/angular-mocks.js'
					]
					keepRunner: true

		ngmin:
			main:
				src: ['./src/turn-orbicular.js']
				dest: './dist/turn-orbicular.js'

		sass:
			options:
				loadPath: ['node_modules', 'bower_components']
			dev:
				files:
					'build/turn-orbicular.css': 'src/turn-orbicular.scss'

		# autoprefixer:
		# 	options:
		# 		browsers: [
		# 			'Explorer >= 9',
		# 			'last 5 Chrome versions'
		# 			'last 5 Firefox versions'
		# 		]
		# 		cascade: true
		# 	main:
		# 		src: 'build/turn-orbicular.css'
		# 		dest: 'build/turn-orbicular.css'

		jshint:
			main:
				option:
					multistr: true
					laxcomma: true
					laxbreak: true
					smarttabs: true
					force: true
				files:
					src: ['src/*.js']

		browserify:
			dev:
				options:
					transform: ['browserify-ngannotate']
				files:
					'build/turn-orbicular.js': 'src/turn-orbicular.js'

		uglify:
			release:
				files:
					'dist/turn-orbicular.js': 'build/turn-orbicular.js'


		watch:
			main:
				files: [
					'src/**/*'
					'./bower_components/*'
					'./node_modules/*'
					'!src/template-build.js'
				]
				tasks: build
				options:
					interrupt: true
					spawn: false
			test:
				files: './test/*.coffee'
				tasks: test
				options:
					interrupt: true
					spawn: false
			express:
				files: './server.js'
				tasks: ['express:dev']
				options:
					interrupt: true
					spawn: false

		express:
			dev:
				options:
					script: 'server.js'

	grunt.registerTask 'default', build
	grunt.registerTask 'build', build
	grunt.registerTask 'test', test
	grunt.registerTask 'run', run
	grunt.registerTask 'release', release
