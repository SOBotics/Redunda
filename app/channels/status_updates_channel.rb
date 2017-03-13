class StatusUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "status_updates"
  end

  def unsubscribed
  end
end
