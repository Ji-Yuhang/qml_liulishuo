import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0
import "../widgets"
import "../model"

ListPage {
  id: page

  title: qsTr("LiuLiReading")

  listView.emptyText.text: qsTr("No LiuLiReading")

  model: liuLiReadingModel.liuLiReadings

  delegate: LiuLiReadingRow {
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
  pullToRefreshHandler.pullToRefreshEnabled: true
//  pullToRefreshHandler.onRefreshingChanged: {
//       console.log("PullToRefreshHandler onRefreshingChanged")
//  }
    pullToRefreshHandler.onRefresh: {
      console.log("PullToRefreshHandler onRefresh")
      logic.fetchLiuLiReadings()
  }
//  pullToRefreshHandler: PullToRefreshHandler {
//      onRefresh: {
//            console.log("PullToRefreshHandler onRefresh")
//            logic.fetchLiuLiReadings()
//        }
//  }


}
//晚上9点半之前，把冀佳琪灰色厚羽绒服送到高二二班楼下阿姨那里。
