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
        Thread.new do
          con = Connection.connected.find{|c| c.ws == ws}
          puts "Finded connection user - #{con.user.name}"
          delay = 15.second.from_now
          loop {break if Time.now > delay}
          con.user.leave_lobby unless Connection.find_by_user_id(con.user.id)
        end
      end

      ws.rack_response
    end
  end
end
