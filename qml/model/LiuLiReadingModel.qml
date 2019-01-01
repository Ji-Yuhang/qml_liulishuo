import VPlay 2.0
import QtQuick 2.0
import VPlayApps 1.0

Item {
  id: liuLiReadingModel

  // property to configure target dispatcher / logic
  property alias dispatcher: logicConnection.target

  readonly property alias currentProfile: _.currentProfile
  readonly property alias timeline: _.timeline
  readonly property alias messages: _.messages
  readonly property alias firstTweetData: _.firstTweetData

  readonly property alias liuLiReadings: _.liuLiReadings
  readonly property alias memories: _.memories
  property int current_memories_page: 1
  property int per_memories_page: 10

  Storage{
      id: storage
  }
  Connections {
    id: logicConnection

    onFetchLiuLiReadings: {
        console.debug("Loading liuLiReadingModel...")
        let user = storage.getValue('user')
        let token = user.authentication_token
        HttpRequest.get(Qt.resolvedUrl("https://memorysheep.com/api/v1/liu_li_readings"))
        .set('Authentication-Token', token)
//        HttpRequest.get(Qt.resolvedUrl("http://localhost:3000/api/v1/liu_li_readings"))

        .then(function(res) {
//          console.log("http return: ",res, JSON.stringify(res.body))
//          _.liuLiReadings = JSON.parse(res.body)
          _.liuLiReadings = res.body.readings
//          console.log("Loading liuLiReadingModel result:", _.liuLiReadings)
        })
        .catch(function(err) {
            console.error(err);
        })
//        logicConnection.onFetchTwitterData()
    }


    onFetchMemories: {
        current_memories_page = 1
//        liuLiReadingModel.current_memories_page = 1
        _.loadPageMemories(current_memories_page,per_memories_page)
    }
    onFetchMoreMemories:{
         current_memories_page = current_memories_page + 1
         _.loadPageMemories(current_memories_page,per_memories_page)
    }



    onFetchTwitterData:  {
      console.debug("Loading datamodel...")

      // Profile
      HttpRequest.get(Qt.resolvedUrl("../data/user.json"))
      .then(function(res) {
        _.currentProfile = JSON.parse(res.body)
      })

      // Feed
      HttpRequest.get(Qt.resolvedUrl("../data/feed.json"))
      .then(function(res) {
        var json = JSON.parse(res.body)
        var model = []

        _.firstTweetData = json[0]
        for (var i = 0; i < json.length; i++) {
          model.push(_.tweetModel(json[i]))
        }
        _.timeline = model
      })

      // Messages
      HttpRequest.get(Qt.resolvedUrl("../data/messages.json"))
      .then(function(res) {
        var raw = JSON.parse(res.body)
        var model = []

        for (var i = 0; i < raw.length; i++) {
          var names = model.map(function(val) { return val.handle } )
          var message = JSON.parse(JSON.stringify(raw[i]))
          message.user = message.sender
          message = _.tweetModel(message)

          if (names.indexOf("@" + message.user.screen_name) === -1) {
            message.actionsHidden = true
            delete message.sender
            delete message.image
            delete message.retweeted
            delete message.favorited
            delete message.retweet_count
            delete message.favorite_count
            model.push(message)
          }
        }
        _.messages = model
      })
    }

//    // action 2 - addTweet
//    onAddTweet: {
//      //create fake tweet as copy of first tweet with new text
//      var newTweet = JSON.parse(JSON.stringify(_.firstTweetData))
//      newTweet.user = _.currentProfile
//      newTweet.text = text
//      _.timeline.splice(0, 0, _.tweetModel(newTweet)) //insert at position 0
//      _.timelineChanged()
//    }
  }

  // private
  Item {
    id: _

    property var currentProfile
    property var timeline
    property var messages

    property var firstTweetData
    property var liuLiReadings
    property var memories

    function loadPageMemories(page, per_page){
        page = page || '1'
        per_page = per_page || per_memories_page
        console.debug("Loading loadPageMemories...",page,per_page)
        let user = storage.getValue('user')
        let token = user.authentication_token
        HttpRequest.get(Qt.resolvedUrl("https://memorysheep.com/api/v1/memories?page="+page+"&per_page="+per_page))
        .set('Authentication-Token', token)
        .then(function(res) {
//          console.log("http return: ",res, JSON.stringify(res.body))
          _.memories = res.body.memories
//          console.log("Loading loadPageMemories result:", _.memories)
        })
        .catch(function(err) {
            console.error(err);
        })
    }

    function tweetModel(data) {
      console.log("TWEET MODEL: "+JSON.stringify(data))
      // Twitter uses custom format not recognized by new Date(string)
      var date = new Date(data.created_at.replace("+0000 ", "") + " UTC")

      // Check for URLs
      var text = data.text
      if (!!data.entities && !!data.entities.urls) {
        for (var j = 0; j < data.entities.urls.length; j++) {
          var url = data.entities.urls[j]
          text = text.replace(url.url, "<a href=\"" + url.url + "\">" + url.display_url + "</a>")
        }
      }

      // Check for image media
      var image = null
      if (!!data.entities && !!data.entities.media) {
        for (var j = 0; j < data.entities.media.length; j++) {
          var med = data.entities.media[j]
          if (med.type === "photo") {
            // Save image reference
            image = med.media_url

            // Remove possible url from text
            text = text.replace(med.url, "")

            // We just use the first found photo for now
            break
          }
        }
      }

      return {
        "name": data.user.name,
        "handle": "@" + data.user.screen_name,
        "icon": data.user.profile_image_url.replace("_normal", "_bigger"),
        "text": text,
        "image": image,
        "time": DateFormatter.prettyDateTime(date),
        "retweet_count": data.retweet_count,
        "favorite_count": data.favorite_count,
        "retweeted": data.retweeted,
        "favorited": data.favorited,
        "user": data.user,
        "actionsHidden": undefined // workaround because dynamic add/remove of properties has troubles on iOS with Qt. 5.6.0
      }
    }
  }
}
