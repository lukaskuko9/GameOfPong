import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.12
import Qt.labs.settings 1.0

Window {
    id:mainWindow

   // flags: gameWindow.isGameRunning() ?  WindowMinimizeButtonHint : Qt.Window

    minimumHeight : 480;
    minimumWidth : 640;

    visible: true
    title: qsTr("Game of Pong")

    Settings {
        id: settings
        property alias width: mainWindow.width
        property alias height: mainWindow.height
        property alias player1_isPC: player1_combobox.isPC
        property alias player2_isPC: player2_combobox.isPC
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

            ball.x = gameWindow.width / 2 - ball.width/2;
            ball.y = gameWindow.height /2 - ball.height/2;

            player1.y = gameWindow.height /2 - player1.height/2;
            player2.y = gameWindow.height /2 - player2.height/2;

            mainWindow.maximumHeight = 3000;
            mainWindow.maximumWidth = 3000;
            mainWindow.minimumHeight = 480;
            mainWindow.minimumWidth = 640;

            if(player !== undefined)
                player.score++;
        }

        function startGame(){
            ball.ballTimer.running = true;
            mainWindow.maximumWidth = mainWindow.width;
            mainWindow.minimumHeight = mainWindow.height;
            mainWindow.minimumWidth = mainWindow.width;
            mainWindow.maximumHeight = mainWindow.height;

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
                isPC: player1_combobox.isPC;
            }

            Player{
                id:player2;
                x: gameWindow.width - 2*player2.width;
                color: "red";
                moveUpKey: Qt.Key_Up;
                moveDownKey: Qt.Key_Down;
                isPC: player2_combobox.isPC;
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
            x: gameWindow.width/2 - menuLayout.width/2
            y: gameWindow.height/2 - menuLayout.height/2
            visible: !gameWindow.isGameRunning();

            property var settingsMenu : null;

            ColumnLayout{
                id: menuLayout
                spacing: 6;

                CustomMenuItem {
                    text: "Start Game"
                    mouseArea.onClicked:{
                        gameWindow.endGame();
                        gameWindow.startGame();
                    }

                }

                RowLayout{
                    spacing: 4
                    CustomMenuComboBox {
                        id: player1_combobox
                        //selectedItem: "PC"
                    }
                    CustomMenuComboBox {
                        id: player2_combobox
                    }
                }

                Item{ height: 4}

                /*CustomMenuItem {
                    text: "Settings"
                    mouseArea.onClicked: {

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
                }*/

                CustomMenuItem {
                    text: "Quit"
                    mouseArea.onClicked: Qt.quit();
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
