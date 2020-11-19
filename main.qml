import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

Window {
    id:mainWindow
    width: 1024; height: 680

    minimumWidth: (gameWindow.isGameRunning()? width : 640);
    minimumHeight: (gameWindow.isGameRunning()? height : 480);
    maximumWidth: (gameWindow.isGameRunning()? width : 1920);
    maximumHeight: (gameWindow.isGameRunning()? height : 1080);
    visible: true
    title: qsTr("Game of Pong")

    Settings {
        property alias width: mainWindow.width
        property alias height: mainWindow.height
    }

    Rectangle{
        id: gameWindow;
        anchors.fill: parent;
        anchors.margins: 30;
        border.color: "black";
        border.width: 2

        property int objectsWidth: 25;
        radius: 0

        Keys.onPressed: {
            if(!gameWindow.isGameRunning())
                return;

            if(event.key === Qt.Key_Escape)
                endGame();
        }

        Item{
            anchors.top: gameWindow.top;
            anchors.topMargin: 10;
            z: 1000;
            Text {
                x: gameWindow.width / 4 - width/2;
                text: qsTr("Score: %1").arg(player1.score);
                font.bold: true;
                font.pointSize: 15;
            }
            Text {
                x: (3*gameWindow.width / 4) - width/2;
                text: qsTr("Score: %1").arg(player2.score);
                font.bold: true;
                font.pointSize: 15;
            }

        }

        function endGame(player) {
            ball.reset();

            ball.x = gameWindow.width / 2;
            ball.y = gameWindow.height /2 ;

            player1.x = gameWindow.x;
            player2.x = gameWindow.width - 2*player2.width;

            if(player !== undefined)
                player.score++;
        }

        function startGame(){
            ball.ballTimer.running = true;
        }

        function isGameRunning() {
            return ball.ballTimer.running;
        }


        Item {
            Player{
                id:player1;
                color: "blue";
                moveUpKey: Qt.Key_W;
                moveDownKey: Qt.Key_S;
                isAi: false;
            }

            Player{
                id:player2;
                x: gameWindow.width - 2*player2.width;
                color: "red";
                moveUpKey: Qt.Key_Up;
                moveDownKey: Qt.Key_Down;
                isAi: true;
            }

            Keys.forwardTo: [player1, player2]
            focus: true
        }

        Ball{
            id: ball;
            player1: player1;
            player2: player2;
            width: gameWindow.objectsWidth; height: gameWindow.objectsWidth;
            x: gameWindow.width / 2;
            y: gameWindow.height /2 ;

            onGameEnd: {
                gameWindow.endGame(player);
            }
        }

        //menu
        Item{
            id:menu;
            x: gameWindow.width/2 - gameWindow.x*2
            y: gameWindow.height/2 - gameWindow.y*2
            visible: !gameWindow.isGameRunning();

            property var settingsMenu : null;

            Component.onCompleted: {
               /* var component = Qt.createComponent("qrc:/settingsMenu.qml");
                if (component.status === Component.Ready) {
                    var settingsMenu = component.createObject(gameWindow);
                    settingsMenu.x = gameWindow.width/2 - gameWindow.x*2;
                    settingsMenu.y = gameWindow.height/2 - gameWindow.y*2;
                   // settingsMenu.en = true;
                    menu.settingsMenu = component;

                }*/
            }

            ColumnLayout{
                spacing: 10;
                Rectangle {
                    Layout.alignment: Qt.AlignCenter
                    color: "steelblue"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 50
                    opacity: 0.9

                    Text{
                        text: "Start Game"
                        font.bold: true;
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent;
                        onClicked:
                        {
                            gameWindow.endGame();
                            gameWindow.startGame();
                        }
                    }
                }

                Rectangle {
                    Layout.alignment: Qt.AlignCenter
                    color: "steelblue"
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 50
                    opacity: 0.9

                    Text{
                        text: "Settings"
                        font.bold: true;
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent;
                        hoverEnabled: true
                        onClicked: {
                            var component = Qt.createComponent("qrc:/settingsMenu.qml");
                            if (component.status === Component.Ready) {
                                var settingsMenu = component.createObject(gameWindow);
                                settingsMenu.x = gameWindow.width/2 - gameWindow.x*2;
                                settingsMenu.y = gameWindow.height/2 - gameWindow.y*2;
                                settingsMenu.visible = true;
                                menu.visible = false;
                               // menu.settingsMenu = component;

                            }
                        }
                    }


                }

                Rectangle {
                    Layout.alignment: Qt.AlignCenter
                    color: "steelblue"
                    Layout.fillHeight: true; Layout.fillWidth: true;
                    Layout.preferredWidth: 100
                    Layout.preferredHeight: 50
                    opacity: 0.9

                    Text{
                        text: "Quit"
                        font.bold: true;
                        anchors.centerIn: parent
                    }

                    MouseArea{
                        anchors.fill: parent;
                        onClicked: Qt.quit();
                    }
                }
            }

        }
    }
}

/*##^##
Designer {
    D{i:6;annotation:"1 //;;// menu //;;//  //;;// <!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\" \"http://www.w3.org/TR/REC-html40/strict.dtd\">\n<html><head><meta name=\"qrichtext\" content=\"1\" /><style type=\"text/css\">\np, li { white-space: pre-wrap; }\n</style></head><body style=\" font-family:'MS Shell Dlg 2'; font-size:8.25pt; font-weight:400; font-style:normal;\">\n<p style=\"-qt-paragraph-type:empty; margin-top:0px; margin-bottom:0px; margin-left:0px; margin-right:0px; -qt-block-indent:0; text-indent:0px;\"><br /></p></body></html> //;;// 1605361860";customId:""}
}
##^##*/
