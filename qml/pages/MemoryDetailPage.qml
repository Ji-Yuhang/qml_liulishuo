import QtQuick 2.4
import QtQuick.Layouts 1.1
import VPlayApps 1.0
import QtWebView 1.1
Page {
  id: memoryDetailPage

  title: qsTr("Memory")
  backgroundColor: "white"

  property var memory

  Component.onCompleted: {
      answerWebView.loadHtml(memory.answer)
  }

  GridLayout {
    id: innerGrid

    // Auto-break after 2 columns, so we do not have to set row & column manually
    columns: 2
    rowSpacing: dp(8)
    columnSpacing: dp(8)

    x: dp(10)
    y: dp(10)
    width: parent.width - 2 * x

    RoundedImage {
      id: avatarImage

      source: memory.user.avatar.url

      Layout.preferredWidth: dp(50)
      Layout.preferredHeight: dp(50)
      Layout.rowSpan: 2
      Layout.alignment: Qt.AlignTop

      MouseArea {
        anchors.fill: parent

        onClicked: {
          navigationStack.push(profilePageComponent, { profile: memory.user })
        }
      }
    }

    Column {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignTop | Qt.AlignLeft
      Layout.preferredWidth: parent.width

      spacing: dp(4)

      Text {
        id: nameText
        elide: Text.ElideRight
        maximumLineCount: 1
        color: Theme.textColor
        font.family: Theme.normalFont.name
        font.bold: true
        font.pixelSize: dp(14)
        lineHeight: dp(16)
        lineHeightMode: Text.FixedHeight
        text: memory.user.nickname
      }

      Text {
        id: handleText
        elide: Text.ElideRight
        maximumLineCount: 1
        color: Theme.secondaryTextColor
        font.family: Theme.normalFont.name
        font.pixelSize: dp(12)
        lineHeight: dp(16)
        lineHeightMode: Text.FixedHeight
        text: memory.id
      }
    }


    Text {
      id: contentText
      color: Theme.textColor
      linkColor: Theme.tintColor
      font.family: Theme.normalFont.name
      font.pixelSize: dp(18)
      lineHeight: 1.15
      text: memory.question
      wrapMode: Text.WordWrap
      Layout.columnSpan: 2
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignTop


      onLinkActivated: {
        Qt.openUrlExternally(link)
      }
    }
    // Divider
    Rectangle {
      width: parent.width
      color: Theme.dividerColor
      height: 1 // Use absolute value for now

      Layout.columnSpan: 2
      Layout.fillWidth: true
    }
    WebView {
        id: answerWebView
        width: parent.width
        Layout.columnSpan: 2
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.alignment: Qt.AlignTop
        //url: pathToFile
    }
    Text {
      id: answerText
      color: Theme.textColor
      linkColor: Theme.tintColor
      font.family: Theme.normalFont.name
      font.pixelSize: dp(18)
      lineHeight: 1.15
      text: "<table><tr><td>" + memory.answer+"</td></tr></table>"
      wrapMode: Text.WordWrap
      Layout.columnSpan: 2
      Layout.fillWidth: true
      Layout.fillHeight: true
      Layout.alignment: Qt.AlignTop


      onLinkActivated: {
        Qt.openUrlExternally(link)
      }
    }
//    RoundedImage {
//      id: contentImage

//      fillMode: Image.PreserveAspectCrop
//      visible: memory.user.avatar.url && memory.user.avatar.url.length > 0

//      source: memory.user.avatar.url || ""

//      Layout.columnSpan: 2
//      Layout.fillWidth: true
//      Layout.preferredWidth: contentText.width
//      Layout.preferredHeight: dp(240)
//      Layout.maximumWidth: contentText.width
//      Layout.maximumHeight: dp(240)

//      MouseArea {
//        anchors.fill: parent

//        onClicked: {
//          PictureViewer.show(app, contentImage.source)
//        }
//      }
//    }

    Text {
      id: timeText
      elide: Text.ElideRight
      maximumLineCount: 1
      color: Theme.secondaryTextColor
      font.family: Theme.normalFont.name
      font.pixelSize: dp(12)
      lineHeight: dp(16)
      lineHeightMode: Text.FixedHeight
      verticalAlignment: Text.AlignBottom
      text: memory.time || "timeText"

      Layout.columnSpan: 2
      Layout.fillWidth: true
    }

    // Divider
    Rectangle {
      width: parent.width
      color: Theme.dividerColor
      height: 1 // Use absolute value for now

      Layout.columnSpan: 2
      Layout.fillWidth: true
    }

    Flow {
      spacing: dp(6)

      Layout.columnSpan: 2
      Layout.fillWidth: true

      Text {
        text: memory.retweet_count || 'retweet_count'
        font.family: Theme.normalFont.name
        font.bold: true
        font.pixelSize: sp(14)
        color: Theme.textColor
      }

      Text {
        text: qsTr("Retweets")
        font.family: Theme.normalFont.name
        font.pixelSize: sp(14)
        font.capitalization: Font.AllUppercase
        color: Theme.secondaryTextColor
      }

      Text {
        text: memory.favorite_count || 'favorite_count'
        font.family: Theme.normalFont.name
        font.bold: true
        font.pixelSize: sp(14)
        color: Theme.textColor
      }

      Text {
        text: qsTr("Favorites")
        font.family: Theme.normalFont.name
        font.pixelSize: sp(14)
        font.capitalization: Font.AllUppercase
        color: Theme.secondaryTextColor
      }
    }

    // Divider
    Rectangle {
      width: parent.width
      color: Theme.dividerColor
      height: 1 // Use absolute value for now

      Layout.columnSpan: 2
      Layout.fillWidth: true
    }
  }
}
