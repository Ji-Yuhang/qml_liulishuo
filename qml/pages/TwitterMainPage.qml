import VPlay 2.0
import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0
import "."
import "../widgets"


Page {
  id: twitterMainPage
  signal logoutClicked

  // These can be used from anywhere in the app - this way the QML files are parsed only once
  Component { id: mainPageComponent; MainPage { } }
  Component { id: detailPageComponent; DetailPage { } }
  Component { id: profilePageComponent; ProfilePage { } }
  Component { id: listsPageComponent; ListsPage { } }

  // make page navigation public, so app-demo launcher can track navigation changes and log screens with Google Analytics
  property alias navigation: navigation
  property bool userLoggedIn: false

  useSafeArea: false // fill full screen
  // login page is always visible if user is not logged in
   LoginPage {
     z: 1 // show login above actual app pages
     visible: opacity > 0
     enabled: visible
     opacity: userLoggedIn ? 0 : 1 // hide if user is logged in
     onLoginSucceeded: userLoggedIn = true

     Behavior on opacity { NumberAnimation { duration: 250 } } // page fade in/out
   }
   onLogoutClicked: {
        userLoggedIn = false
   }
  Navigation {
    id: navigation
    enabled: userLoggedIn

    drawer.drawerPosition: drawer.drawerPositionLeft
    headerView: NavHeader {}
    footerView: NavFooter {}

    //this overrides the default mode of drawer on android and tabs elsewhere
    //navigationMode: navigationModeTabsAndDrawer


    NavigationItem {
      title: "Home"
      icon: IconType.home

      NavigationStack {
        MainPage {
//            onLogoutClicked: userLoggedIn = false
        }
      }
    }

    NavigationItem {
      title: "Lists"
      icon: IconType.bars

      NavigationStack {
        ListsPage {
//         onLogoutClicked: userLoggedIn = false
        }
      }
    }

    NavigationItem {
      title: "Messages"
      icon: IconType.envelope

      NavigationStack {
        MessagesPage {
//            onLogoutClicked: userLoggedIn = false
        }
      }
    }
    NavigationItem {
      title: "LiuLiReadings"
      icon: IconType.envelope

      NavigationStack {
        LiuLiReadingPage {
//            onLogoutClicked: userLoggedIn = false
        }
      }
    }
    NavigationItem {
      title: "Memories"
      icon: IconType.envelope

      NavigationStack {
        MemoriesPage {
        }
      }
    }

    NavigationItem {
      title: "Me"
      icon: IconType.user

      NavigationStack {

        // manually push profilePage to fix initial scroll position of profile page
        // (due to bug when using ListView::headerItem)

        Component.onCompleted: {
          push(profilePageComponent, { profile: dataModel.currentProfile })
        }
      }
    }
    NavigationItem {
      title: "Logout"
      icon: IconType.user

      Page {
        title: "Logout"

        Storage{
            id: storage
        }
        AppButton {
          anchors.centerIn: parent
          text: "Logout"
          onClicked: {
              storage.clearValue('user')
              twitterMainPage.logoutClicked()
          }
        }
      }
    }
  }
}
