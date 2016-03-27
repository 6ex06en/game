require "json"

module FayeWebsocket
  class Eventer

    def self.handle(ws, user)

      ws.on :open do |event|
        p "#{event.type} - #{object_id}"
        Connection.new(ws, user)
        p "count_connections: #{Connection.connected.length}"
      end

      ws.on :message do |event|
        p "#{event.type} - #{object_id}"
        hash = JSON.parse(event.data)
        p hash
        p Connection.connected.count
        Connection.notify(hash.to_json)
      end

      ws.on :close do |event|
      end

      ws.rack_response
    end
  end
end
