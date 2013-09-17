cli = require("cli").enable "help", "version", "glob"
path = require "path"
glob = require "glob"
Detector = require('./../detector').Detector
Strategy = require('./../strategy').Strategy
Report = require('./../report').Report

cli.setUsage "jscpd [OPTIONS]"
cli.setApp path.resolve "#{__dirname}/../../package.json"
cli.parse {
  "min-lines": ['l', "min size of duplication in code lines", "number", 5]
  "min-tokens": ['t', "mim size of duplication in code tokens", "number", 70]
  "path": ['p', "path to code", "path", process.cwd()]
  "coffee": ['c', "is CoffeeScript code", "boolean", false]
  "ignore": ['i', "directory to ignore", "path"],
  "output": ['o', "path to report xml file", "path"],
  "verbose": [false, "show full info about copies"]
}

cli.main (args, options) ->
  console.log "\njscpd - copy/paste detector
 for JavaScript and CoffeeScript, developed by Andrey Kucherenko\n"
  files = []
  pattern = "#{options.path}/**/*.#{ if options.coffee then 'coffee' else 'js'}"
  exclude = process.cwd() + '/' + options.ignore if options.ignore

  files = glob.sync(pattern, {})
  files = (file for file in files when file.indexOf(exclude) is -1) if exclude
  console.log 'Scaning...' if files.length

  strategy = new Strategy options.coffee
  detector = new Detector strategy

  report = new Report
    verbose: options.verbose
    output: options.output

  codeMap = detector.start files, options['min-lines'], options['min-tokens']
  console.log 'Scaning... done!\n'
  report.generate codeMap


