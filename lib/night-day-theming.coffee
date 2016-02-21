{CompositeDisposable} = require 'atom'

getThemeNamesEndingIn = (str) ->
  atom.themes.getLoadedThemeNames().filter (e)->e.match(/.*#{str}/)

uiThemeNames = getThemeNamesEndingIn("ui")
syntaxThemeNames = getThemeNamesEndingIn("syntax")

module.exports = NightDayTheming =
  config:
    darkUITheme:
      type: 'string'
      default: 'atom-dark-ui'
      enum: uiThemeNames
    lightUITheme:
      type: 'string'
      default: 'atom-light-ui'
      enum: uiThemeNames
    darkSyntaxTheme:
      type: 'string'
      default:  'atom-dark-syntax'
      enum: syntaxThemeNames
    lightSyntaxTheme:
      type: 'string'
      default:  'atom-light-syntax'
      enum: syntaxThemeNames


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

    if @getDarkSyntaxTheme() in enabledThemeNames
      atom.config.set('core.themes', [@getDarkUITheme(),@getDarkSyntaxTheme()])
      @enableLightTheme()
    else
      @enableDarkTheme()

  enableDarkTheme: ->
    changeTheme =
      => atom.config.set('core.themes',
                         [@getDarkUITheme(),@getDarkSyntaxTheme()])
    setTimeout(changeTheme,0)
  enableLightTheme: ->
    changeTheme =
      => atom.config.set('core.themes',
                         [@getLightUITheme(),@getLightSyntaxTheme()])
    setTimeout(changeTheme,0)
