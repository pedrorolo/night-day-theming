NightDayThemingView = require './night-day-theming-view'
{CompositeDisposable} = require 'atom'

module.exports = NightDayTheming =
  config:
    darkUITheme:
      type: 'string'
      default: 'one-dark-ui'
    lightUITheme:
      type: 'string'
      default: 'one-light-ui'
    darkSyntaxTheme:
      type: 'string'
      default:  'solarized-dark-syntax'
    lightSyntaxTheme:
      type: 'string'
      default:  'solarized-light-syntax'


  nightDayThemingView: null
  modalPanel: null
  subscriptions: null
  activate: (state) ->
    # @nightDayThemingView = new NightDayThemingView(state.nightDayThemingViewState)
    # @modalPanel = atom.workspace.addModalPanel(item: @nightDayThemingView.getElement(), visible: false)
    #
    # # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'night-day-theming:toggle': => @toggle()


  getDarkUITheme: -> atom.config.get('night-day-theming.darkUITheme')
  getLightUITheme: -> atom.config.get('night-day-theming.lightUITheme')
  getDarkSyntaxTheme: -> atom.config.get('night-day-theming.darkSyntaxTheme')
  getLightSyntaxTheme: -> atom.config.get('night-day-theming.lightSyntaxTheme')




  deactivate: ->
    # @modalPanel.destroy()
    # @subscriptions.dispose()
    # @nightDayThemingView.destroy()

  serialize: ->
    #nightDayThemingViewState: @nightDayThemingView.serialize()



  toggle: ->
    enabledThemeNames = atom.themes.getEnabledThemeNames()

    if "solarized-dark-syntax" in enabledThemeNames
      @enableLightTheme()
    else
      @enableDarkTheme()

  enableDarkTheme: ->
    enabled = atom.themes.getEnabledThemeNames()
    emptyPromise =  new Promise (resolve)-> resolve()

    reducer = (acc, t)=>
      acc.then =>
        @disableTheme(t)

    disabled = enabled.reduce reducer,emptyPromise

    disabled.then =>
      @enableTheme(@getDarkSyntaxTheme())
    .then =>
      @enableTheme(@getDarkUITheme())

  enableLightTheme: ->
    enabled = atom.themes.getEnabledThemeNames()
    emptyPromise =  new Promise (resolve)-> resolve()
    reducer = (acc, t)=>
      acc.then =>
        @disableTheme(t)
    disabled = enabled.reduce reducer,emptyPromise
    disabled.then =>
      @enableTheme(@getLightSyntaxTheme())
    .then =>
      @enableTheme(@getLightUITheme())


  enableTheme: (themeName) ->
    themes = atom.themes.getLoadedThemes().filter (t) ->
      t.name == themeName
    t = themes[0]
    t.enable()

  disableTheme: (themeName) ->
    themes = atom.themes.getLoadedThemes().filter (t) ->
      t.name == themeName
    t = themes[0]
    t.disable()
