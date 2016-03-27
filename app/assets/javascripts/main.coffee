class WS
  constructor: ->
    protocol = if window.location.protocol.slice(-2) == "s" then "wss" else "ws"
    host = window.location.host
    @url = "#{protocol}://#{host}/ws"
    @eventController = new EventController()

    @setConnection()


  setConnection: ->
    @ws = new WebSocket(@url)
    @ws.onmessage = @onMessage
    @ws.onerror = @onError

  onMessage: (data) ->
    # console.log(data.data)
    # console.log(typeof data.data)
    event_data = JSON.parse(data.data)
    console.log(event_data)
    @submitEvent(event_data)

  onError: (data) ->
    console.log(data)

  send: (data) ->
    json = JSON.stringify(data)
    @ws.send(json)

  submitEvent: (data)->
    @eventController.reciveEvent(data)


class EventController

  constructor: ->
    @handlers = {notify: new Page(), game: new Game()}

  getPage: ->
    @handlers.notify

  getGame: ->
    @handlers.game

  setGameParams: (player1, player2, timer, maxScore)->
    options =
      player1: player1,
      player2: player2,
      timer: timer,
      maxScore: maxScore
    @getGame().setParams(options)

  reciveEvent: (event_data)->
    event_type = event_data.type
    @handlers[event_type].reciveEvent(event_data)

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

class Page
  constructor: ->
  recieveEvent: ->

class Game

  constructor: (player1_id, player2_id, timer, maxScore) ->
    @options =
      player1: player1_id,
      player2: player2_id,
      timer: timer || 5,
      maxScore: maxScore || 3
    @state = "stop"

  getPlyer1: ->
    @options.player1
  getPlyer2: ->
    @options.player2
  getState: ->
    @state
  getTimer: ->
    @options.timer
  setState: (state) ->
    @state = state
  setParams: (options)->
    $.extend(true, @options, options)
  recieveEvent: (event)->

  changeState: =>
    @setState(new StartState(@)).handle() if @state = "stop"

class GameState
    constructor: (game, event) ->
      @game = game
      @event = event
    getGame: ->
      @game

class StopState extends GameState

    constructor: ->
      super

    handle: ->
      console.log("Current_state - Stop")

class StartState extends GameState

    constructor: ->
      super

    handle: ->
      # WS.send
      #   creator: @getGame().getPlyer1(),
      #   invited: @getGame().player2(),
      #   state: "start",
      #   timer: @getGame().getTimer()

      console.log("Current_state - Start")
      @getGame().setState(new RunState(@getGame())).handle()

class RunState extends GameState

    constructor: ->
      super

    handle: ->
      console.log("Current_state - Run")
      console.log @getGame()
      @setTimer()
      @getGame().setState(new StopState(@getGame())).handle()

    setTimer: ->
      @time = @getGame().getTimer()
      if @time
        @waitRoll()
        timer = setInterval =>
          $(".lobby__timer").html(@time)
          @time--
          if @time < 0
            clearInterval(timer)
            @stopWaitingRoll()
        , 1000

    waitRoll: ->
      figures_list = $(".lobby__figures")
      _this = @
      figures_list.on "click", "li", (e)->
        clickedFigure = $(@).data("figure")
        _this.hideElem(".lobby__figures li")
        $("<li/>", {class: "selected", text: clickedFigure}).appendTo(figures_list)

    stopWaitingRoll: ->
      $(".lobby__figures li").off("click")
      selected = $(".lobby__figures li.selected")
      selected.remove() if selected
      # @showElem(".lobby__figures li")


    hideElem: (elem)->
      $(elem).hide()

    showElem: (elem)->
      $(elem).show()

window.WS = new WS()
window.Game = Game
window.Page = Page
window.StopState = StopState
window.StartState = StartState
