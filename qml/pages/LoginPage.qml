import VPlay 2.0
import VPlayApps 1.0
import QtQuick 2.0
import QtQuick.Layouts 1.1

Page {
  id: loginPage
  title: "Login"
  signal loginSucceeded

  Component.onCompleted: function(){
      let user = storage.getValue('user');
      console.log("Storage.user", user)
      if (user){
          txtUsername.text = user.email
          loginSucceeded()
      }
  }
  backgroundColor: Qt.rgba(0,0,0, 0.75) // page background is translucent, we can see other items beneath the page
  Storage{
      id: storage
  }

  // login form background
  Rectangle {
    id: loginForm
    anchors.centerIn: parent
    color: "white"
    width: content.width + dp(48)
    height: content.height + dp(16)
    radius: dp(4)
  }

  // login form content
  GridLayout {
    id: content
    anchors.centerIn: loginForm
    columnSpacing: dp(20)
    rowSpacing: dp(10)
    columns: 2

    // headline
    AppText {
      Layout.topMargin: dp(8)
      Layout.bottomMargin: dp(12)
      Layout.columnSpan: 2
      Layout.alignment: Qt.AlignHCenter
      text: "Login"
    }

    // email text and field
    AppText {
      text: qsTr("E-mail")
      font.pixelSize: sp(12)
    }

    AppTextField {
      id: txtUsername
      Layout.preferredWidth: dp(200)
      showClearButton: true
      font.pixelSize: sp(14)
      borderColor: Theme.tintColor
      borderWidth: !Theme.isAndroid ? dp(2) : 0
    }

    // password text and field
    AppText {
      text: qsTr("Password")
      font.pixelSize: sp(12)
    }

    AppTextField {
      id: txtPassword
      Layout.preferredWidth: dp(200)
      showClearButton: true
      font.pixelSize: sp(14)
      borderColor: Theme.tintColor
      borderWidth: !Theme.isAndroid ? dp(2) : 0
      echoMode: TextInput.Password
    }

    // column for buttons, we use column here to avoid additional spacing between buttons
    Column {
      Layout.fillWidth: true
      Layout.columnSpan: 2
      Layout.topMargin: dp(12)

      // buttons
      AppButton {
        text: qsTr("Login")
        flat: false
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
          loginPage.forceActiveFocus() // move focus away from text fields

          let params = "email=yuhang.silence%40gmail.com&password=jiyuhang8757871"
            HttpRequest.post(Qt.resolvedUrl("https://memorysheep.com/api/v1/users/sign_in"))
            .send({ email: txtUsername.text, password: txtPassword.text })
    //        HttpRequest.get(Qt.resolvedUrl("http://localhost:3000/api/v1/liu_li_readings"))
            .then(function(res) {
              console.log("http Login return: ",res, JSON.stringify(res.body))
    //          _.liuLiReadings = JSON.parse(res.body)
              //_.liuLiReadings = res.body.readings
              let user = res.body.user
              console.log("Login  result:", JSON.stringify(user))
              storage.setValue('user', user)
              loginSucceeded()

            })
            .catch(function(err) {
                nativeUtils.displayAlertDialog("Error!", "Email or Password Error", "", "")
                console.error(err);
            })

          // simulate successful login
          console.debug("logging in ...")

        }
      }

      AppButton {
        text: qsTr("No account yet? Register now")
        flat: true
        anchors.horizontalCenter: parent.horizontalCenter
        onClicked: {
          loginPage.forceActiveFocus() // move focus away from text fields

          // call your server code to register here
          console.debug("registering...")
        }
      }
    }
  }
}
