import QtQuick 2.4
import "pages"
import "model"

Item {
  anchors.fill: parent

//  Component.onCompleted: logic.fetchTwitterData()
//  Component.onCompleted:
  Component.onCompleted: function(){
      logic.fetchLiuLiReadings()
      logic.fetchTwitterData()
  }

  DataModel {
    id: dataModel
    dispatcher: logic
  }
  LiuLiReadingModel {
      id: liuLiReadingModel
      dispatcher: logic
  }

  Logic {
    id: logic
  }


  TwitterMainPage { }
}
