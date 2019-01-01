import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0
import "../widgets"
import "../model"

ListPage {
  id: page

  title: qsTr("Messages")

  listView.emptyText.text: qsTr("No messages")

  model: dataModel.messages
  listView.scrollIndicatorVisible: true
//  listView.scrollsToTop:
  listView.onAtYEndChanged: {
      console.log("listView.onAtYEndChanged",listView.atYEnd)
      if (listView.atYEnd) {
        // Loading tail messages...
          login.fetchMoreMemories()
      }
    }
  listView.footer:  VisibilityRefreshHandler {

      // disable the default view
      defaultAppActivityIndicatorVisible: false

      Rectangle {
        anchors.fill: parent
        color: "grey"
        Text {
          text: "Refreshing ..."
          anchors.centerIn: parent
        }
      }

      onRefresh: login.fetchMoreMemories()

    }
  delegate: TweetRow {
    id: row

    onSelected: {
      console.debug("Selected item at index:", index)
      navigationStack.push(detailPageComponent, { tweet: row.item })
    }

    onProfileSelected: {
      console.debug("Selected profile at index:", index)
      navigationStack.push(profilePageComponent, { profile: row.item.user })
    }
  }
}
