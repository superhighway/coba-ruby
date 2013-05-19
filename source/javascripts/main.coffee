unless window.console and console.log
  (->
    noop = ->

    methods = ["assert", "clear", "count", "debug", "dir", "dirxml", "error", "exception", "group", "groupCollapsed", "groupEnd", "info", "log", "markTimeline", "profile", "profileEnd", "markTimeline", "table", "time", "timeEnd", "timeStamp", "trace", "warn"]
    length = methods.length
    console = window.console = {}
    console[methods[length]] = noop  while length--
  )()

hasHistorySupport = -> !!(window.history && history.pushState)

setEditorValue = (snippet) ->
  if window.ace and editor?
    editor.getSession().setValue snippet
  else
    $("#snippet-runner-code-content").html "<pre>" + snippet + "</pre>"
getEditorValue = ->
  if window.ace and editor?
    editor.getSession().getValue()
  else
    $("#snippet-runner-code-content").text()
editor = null
if window.ace
  editor = ace.edit("code-editor")
  editor.setTheme "ace/theme/solarized_light"
  editor.getSession().setMode "ace/mode/ruby"


$body = $("body")
$loadingIndicator = $ '#loading-indicator'
# evalURL = "http://mengenal-ruby-eval.herokuapp.com"
evalURL = 'http://localhost:4000'
snippetRequestError = $("#snippet-request-error-template").text()
$runner = $("#snippet-runner")
$("#snippet-request-error-template").remove()
$(".btn-run").click ->
  $outputTarget = $("#run-output")
  snippet = getEditorValue()
  $loadingIndicator.text "Memproses jawaban..."
  if challengeCanBeAnswered
    $.post(evalURL + "/coba-ruby.json", snippet: snippet, challenge_path: challengePath
    , (data, textStatus, xhr) ->
      $loadingIndicator.text ""
      $outputTarget.text data.output
    ).fail ->
      $loadingIndicator.text ""
      $outputTarget.text snippetRequestError
  else
    $.post(evalURL, snippet: snippet, (data, textStatus, xhr) ->
      $loadingIndicator.text ""
      $outputTarget.text data
    ).fail ->
      $loadingIndicator.text ""
      $outputTarget.text snippetRequestError
