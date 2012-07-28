apitree = require 'apitree'
Path    = require 'path'


exports.usage = [
  "JSON RPC mode for the GUI."

  '  server', [
    "Run in RPC mode, speaking JSON on stdin and stdout."
  ]
  '  console', [
    "Run in debugging-friendly RPC REPL mode, speaking JSON on stdin and stdout via readline."
  ]
  '  print-apis', [
    "Print the list of available RPC APIs."
    "This command is invoked by 'rake routing' to build the client-side proxy code."
  ]
]


flattenHash = (object, sep='.', prefix='', result={}) ->
  for own key, value of object
    newKey = if prefix then "#{prefix}#{sep}#{key}" else key

    if (typeof value is 'object') && value.constructor is Object
      flattenHash value, sep, newKey, result
    else
      result[newKey] = value

  return result


setupRpcEnvironment = (options, context) ->
  global.LR = require('../../config/env').createEnvironment(options, context)

runServer = (options, context) ->
  process.title = "LiveReloadHelper"
  LR.rpc.init(process, process.exit)

runConsoleServer = (options, context) ->
  LR.rpc.init(process, process.exit, { callbackTimeout: 60000, consoleDebuggingMode: true })

  LR.app.api.init {
    resourcesDir: [ context.paths.bundledPlugins ],
    appDataDir: context.paths.bundledPlugins,
    logDir: process.env['TMPDIR']
  }, (err) ->
    if err
      throw err

printApis = (options, context) ->
  tree = apitree.createApiTree context.paths.rpc,
    loadItem: (path) -> require(path).api || {}

  tree = flattenHash(tree)

  for k in Object.keys(tree)
    process.stdout.write "#{k}\n"


exports.run = (options, context) ->
  switch options.subcommand
    when 'print-apis'
      printApis(options, context)
    when 'server'
      setupRpcEnvironment(options, context)
      runServer(options, context)
    when 'console'
      setupRpcEnvironment(options, context)
      runConsoleServer(options, context)

