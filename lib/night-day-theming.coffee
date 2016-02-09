NightDayThemingView = require './night-day-theming-view'
{CompositeDisposable} = require 'atom'

module.exports = NightDayTheming =
  nightDayThemingView: null
  modalPanel: null
  subscriptions: null
  activate: (state) ->
    @nightDayThemingView = new NightDayThemingView(state.nightDayThemingViewState)
    @modalPanel = atom.workspace.addModalPanel(item: @nightDayThemingView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'night-day-theming:toggle': => @toggle()

  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @nightDayThemingView.destroy()

  serialize: ->
    nightDayThemingViewState: @nightDayThemingView.serialize()

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
      @enableTheme('solarized-dark-syntax')
    .then =>
      @enableTheme('one-dark-ui')

  enableLightTheme: ->
    enabled = atom.themes.getEnabledThemeNames()
    emptyPromise =  new Promise (resolve)-> resolve()
    reducer = (acc, t)=>
      acc.then =>
        @disableTheme(t)
    disabled = enabled.reduce reducer,emptyPromise
    disabled.then =>
      @enableTheme('solarized-light-syntax')
    .then =>
      @enableTheme('one-light-ui')


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
