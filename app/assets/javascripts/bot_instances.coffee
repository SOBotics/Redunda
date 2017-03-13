# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  clipboard = new Clipboard("#copy-key")
  copyButton = $("#copy-key")

  showTooltip = (message) ->
    copyButton.attr "data-title", message
    copyButton.tooltip('show')
    setTimeout ->
      $("#copy-key").tooltip 'hide'
    , 1000

  clipboard.on 'success', (e) -> showTooltip "Copied!"
  clipboard.on 'error', (e) -> showTooltip "Press Ctrl+C to copy."



  $('.owner-instance-key').on 'click', (e) ->
    $('#key-label').text e.target.getAttribute('data-key')
    $('#revoke-form').attr "action", "/bots/#{e.target.getAttribute 'data-bot'}/bot_instances/#{e.target.getAttribute 'data-instance'}/revoke_key"
    $('#authenticity_token').attr "value", $('meta[name="csrf-token"]').attr("content")
