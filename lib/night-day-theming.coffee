{CompositeDisposable} = require 'atom'


getThemeNamesEndingIn = (str) ->
  atom.themes.getLoadedThemeNames().filter (e)->e.match(///.*#{str}///)


module.exports = NightDayTheming =
  uiThemeNames: getThemeNamesEndingIn("ui")
  syntaxThemeNames: getThemeNamesEndingIn("syntax")
  config:
    darkUITheme:
      type: 'string'
      default: 'atom-dark-ui'
      enum: getThemeNamesEndingIn("ui")
    lightUITheme:
      type: 'string'
      default: 'atom-light-ui'
      enum: getThemeNamesEndingIn("ui")
    darkSyntaxTheme:
      type: 'string'
      default:  'atom-dark-syntax'
      enum: getThemeNamesEndingIn("syntax")
    lightSyntaxTheme:
      type: 'string'
      default:  'atom-light-syntax'
      enum: getThemeNamesEndingIn("syntax")


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
