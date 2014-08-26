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
	]
	.forEach grunt.loadNpmTasks

	# task sets
	build = ['html2js', 'ngmin', 'jshint', 'concat', 'sass', 'clean']
	test = ['html2js', 'coffee', 'jasmine:unit']
	testAndBuild = ['html2js', 'coffee', 'jasmine:unit', 'ngmin', 'jshint', 'concat', 'sass', 'clean']
	run = ['default', 'express:dev', 'watch']

	# task defs
	grunt.initConfig

		pkg: grunt.file.readJSON 'package.json'

		clean:
			main: [
				'./dist/template.js'
			]

		coffee:
			compile:
				files:
					'test/unit.js': 'test/unit.coffee'

		concat:
			main:
				src: ['./dist/*.js']
				dest: './dist/turn-orbicular.js'

		coveralls:
			options:
				force: true
			main:
				src: 'reports/lcov/lcov.info'

		html2js:
			main:
				src: './src/html/*.html'
				dest: './dist/template.js'
			options:
				base: './src/html'
				module: 'turnOrbicularTemplate'

		jasmine:
			coverage:
				src: [
					'./src/turn-orbicular.js'
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
						'./dist/template.js'
					]
			unit:
				src: './src/turn-orbicular.js'
				options:
					specs: './test/unit.js'
					vendor: [
						'./bower_components/angular/angular.js'
						'./bower_components/angular-mocks/angular-mocks.js'
						'./dist/template.js'
					]
					keepRunner: true

		ngmin:
			main:
				src: ['./src/turn-orbicular.js']
				dest: './dist/turn-orbicular.js'

		sass:
			main:
				files:
					'dist/turn-orbicular.css': 'src/turn-orbicular.scss'

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

		watch:
			main:
				files: [
					'./src/**/*'
					'./bower_components/*'
					'./node_modules/*'
				]
				tasks: testAndBuild
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
	grunt.registerTask 'test', test
	grunt.registerTask 'run', run
