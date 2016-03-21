class WS
  constructor: ->
    protocol = window.location.url
    host = window.localtion.host
    @url = "#{url}//:#{host}/ws"

    @setConnection()


  setConnection: ->
    @ws = WebSocket.new(@url)
    @ws.onmessage = @onMessage
    @ws.onerror = @onError

  @onMessage: (data) ->
    console.log(data)

  @onError: (data) ->
    console.log(data)

  @send: (data) ->
    json = JSON.stringify(data)
    @ws.send(json)
