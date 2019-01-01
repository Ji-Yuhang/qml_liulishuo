import QtQuick 2.0
import VPlayApps 1.0

AppText {
  width: parent.width
  height: dp(48)
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter

  text: "https://memorysheep.com"

  color: Theme.tintColor
  font.pixelSize: sp(16)

  MouseArea {
    id: mouse
    anchors.fill: parent
    onClicked: Qt.openUrlExternally("https://memorysheep.com")
    cursorShape: Qt.PointingHandCursor
  }
}
