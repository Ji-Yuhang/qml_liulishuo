import VPlayApps 1.0


App {
  id: app

  // You get free licenseKeys from https://v-play.net/licenseKey
  // With a licenseKey you can:
  //  * Publish your games & apps for the app stores
  //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
  //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
  //licenseKey: "<generate one from https://v-play.net/licenseKey>"

  onInitTheme: {
    // Set styles
    Theme.colors.tintColor = "#57adee"
    Theme.colors.backgroundColor = "#eee"

    Theme.navigationBar.backgroundColor = Theme.tintColor
    Theme.navigationBar.titleColor = "white"
    Theme.navigationBar.itemColor = "white"
    Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite
  }

  TwitterMainItem { }
}
