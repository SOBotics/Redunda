# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $("input.permissions-checkbox").change ->
    console.log("oy")
    $(this).disabled = true

    checkbox = $(this)

    $.ajax
      type: 'PUT'
      data: {'permitted': $(this).is(":checked"), 'user_id': $(this).data("user-id"), 'role': $(this).data("role")}
      dataType: 'json'
      url: "/admin/permissions"
      success: (data) ->
        checkbox.disabled = false
