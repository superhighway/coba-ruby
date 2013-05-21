challengePath = ''
challengeAnswerable = false

updateChallenge = ->
  challengePath = ''
  challengeAnswerable = false
  $jsChallenge = $('#js-challenge')
  if $jsChallenge?
    challengePath = $jsChallenge.data('path')
    challengeAnswerable = $jsChallenge.data('answerable')

updateChallenge()

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

popstateIsBoundToWindow = false
navigateToChallengeURL = (challengeURL) ->
  if hasHistorySupport()
    unless popstateIsBoundToWindow
      popstateIsBoundToWindow = true
      $(window).on 'popstate', (e) ->
        navigateToChallengeURL window.location.href

    $.get challengeURL, {}, (data, textStatus, xhr) ->
      questionId = "#js-question"
      $question = $(questionId)
      updateChallengeContent = ->
        $data = $(data)
        $question.html $data.find(questionId).html()
        updateChallenge()
        history.pushState {}, $data.find('title').text(), challengeURL

      if $.support.transition
        $question.transition opacity: 0, scale: 0.9, 350, 'out', ->
          updateChallengeContent()
          $question.transition opacity: 1, scale: 1, 400, 'out'
      else
        updateChallengeContent()
  else
    window.location.href = challengeURL

navigateToChallengePath = (challengePath) ->
  navigateToChallengeURL [challengeRoot, challengePath].join('/') + ".html"

$body = $("body")
$loadingIndicator = $ '#loading-indicator'
snippetRequestError = $("#snippet-request-error-template").text()
$runner = $("#snippet-runner")
$("#snippet-request-error-template").remove()

if hasHistorySupport()
  $(".js-challenge-link").click ->
    navigateToChallengeURL $(this).attr('href')
    return false

$(".btn-run").click ->
  $outputTarget = $("#run-output")
  snippet = getEditorValue()
  $loadingIndicator.text "Memproses jawaban..."
  if challengeAnswerable
    $.post(rubyEvalRoot + "/coba-ruby.json", snippet: snippet, challenge_path: challengePath, (data, textStatus, xhr) ->
      if data.is_correct
        navigateToChallengePath data.next_challenge_path
      $loadingIndicator.text ""
      $outputTarget.text data.output
    ).fail ->
      $loadingIndicator.text ""
      $outputTarget.text snippetRequestError
  else
    $.post(rubyEvalRoot, snippet: snippet, (data, textStatus, xhr) ->
      $loadingIndicator.text ""
      $outputTarget.text data
    ).fail ->
      $loadingIndicator.text ""
      $outputTarget.text snippetRequestError
