App.status_updates = App.cable.subscriptions.create "StatusUpdatesChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    handler = App.handler
    return unless handler.controller == 'BotsController' && handler.action == 'index'

    bot_panel = $("#bot-" + data.bot_id)
    instance_li = $("#instance-" + data.instance_id)
    bot_panel.removeClass("panel-default panel-success panel-warning panel-danger").addClass(data.classes.panel)

    instance_status = instance_li.children(".instance_status").first()
    instance_status.removeClass("bot-status-okay bot-status-warn bot-status-dead bot-status-nil").addClass(data.classes['status'])
    instance_status.attr("title", data.ping.exact)
    instance_status.text(data.ping.ago)
