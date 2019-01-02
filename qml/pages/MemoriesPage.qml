import QtQuick 2.4
import QtQuick.Controls 1.2

import VPlayApps 1.0
import "../widgets"
import "../model"

ListPage {
    property var last_pos


  id: page

  title: qsTr("Memoreis")

  listView.emptyText.text: qsTr("No Memory")

  model: liuLiReadingModel.memories

  delegate: MemoriesRow {
    id: row

    onSelected: {
      console.debug("Selected item at index:", index)
      navigationStack.push(memoryDetailPage, { memory: row.item })
    }

    onProfileSelected: {
      console.debug("Selected profile at index:", index)
      navigationStack.push(profilePageComponent, { profile: row.item.user })
    }
  }
//  pullToRefreshHandler.pullToRefreshEnabled: true
//  pullToRefreshHandler.onRefreshingChanged: {
//       console.log("PullToRefreshHandler onRefreshingChanged")
//  }
//    pullToRefreshHandler.onRefresh: {
//      console.log("PullToRefreshHandler onRefresh")
//      logic.fetchMemories()
//  }
//  pullToRefreshHandler: PullToRefreshHandler {
//      onRefresh: {
//            console.log("PullToRefreshHandler onRefresh")
//            logic.fetchLiuLiReadings()
//        }
//  }

    //load older tweets with visibility handler
    listView.footer: VisibilityRefreshHandler {
      canRefresh: liuLiReadingModel.messages ? liuLiReadingModel.memories_count > liuLiReadingModel.messages.length : false
      onRefresh: {
          console.log("VisibilityRefreshHandler onRefresh")
          last_pos = listView.getScrollPosition()

          logic.fetchMoreMemories()

      }
    }
    Connections {
        target: liuLiReadingModel
        onFetchPageSuccess:{
            if (last_pos){
                listView.restoreScrollPosition(last_pos)
            }


        }
    }



    //load new tweets with pull handler
    pullToRefreshHandler {
      pullToRefreshEnabled: true
      onRefresh: {
          console.log("PullToRefreshHandler onRefresh")
          logic.fetchMemories()
      }
//      refreshing: loadNewTimer.running
    }

}
//晚上9点半之前，把冀佳琪灰色厚羽绒服送到高二二班楼下阿姨那里。
