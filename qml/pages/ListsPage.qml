import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0
import "../widgets"

ListPage {
  title: qsTr("Lists")

  listView.emptyText.text: qsTr("No lists")

  onItemSelected: {
    console.debug("Selected list at position", index)

    navigationStack.push(mainPageComponent, { title: item.text, rightBarItem: null })
  }

  model: [
    { "text": "V-Play Developers", "detailText": "49.213 members" },
    { "text": "App Developers", "detailText": "10.968 members" },
    { "text": "Random things", "detailText": "4.323 members" }
  ]
}
