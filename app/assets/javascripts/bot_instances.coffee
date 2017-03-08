# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$('.owner-instance-key').click (e) ->
  e.preventDefault();
  prompt("Your instance key:", $(this).data("key"));
