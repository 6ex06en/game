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
  
  
  class EventController
  
    constructor: ->
      @eventList = []
      
    addEvent: (event, elem) ->
      
    getEventList: ->
      @eventList
  
  $(document).on "update_status", ->
    $(".lobbies__list a").each (e) ->
      if $(@).data("full")
        $(@).addClass("js_lobby_full")
        $(@).click (e) ->
          return false
      else
        $(@).removeClass("js_lobby_full")
        $(@).off("click")
        
  $(document).ready ->
    $(@).trigger("update_status")
    
  class Game
  
    constructor: (player1_id, player2_id) ->
      @state = "stop"
      @player1 = player1_id
      @player2 = player2_id
      
    getPlyer1ID: ->
      @player1
      
    getPlyer2ID: ->
      @player2
      
    getState: ->
      @state
      
    changeState: =>
      new StartState(@)
      
  class GameState
  
      constructor: (game) ->
        @game = game
        
  class StopState extends GameState
    
        
      
    
