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

            var movement = 35;
            switch(event.key)
            {
                case Qt.Key_Up:
                    if(player2.y - movement >= gameWindow.y )
                        player2.y-= movement;
                    else
                        player2.y = gameWindow.y - gameWindow.anchors.margins + gameWindow.border.width;

                    break;
                case Qt.Key_Down:
                    if(player2.y + movement <= gameWindow.height - player2.height - gameWindow.border.width)
                        player2.y += movement;
                    else
                        player2.y = gameWindow.height - player2.height - gameWindow.border.width;
                    break;

                case Qt.Key_W:
                    if(player1.y -  movement >= gameWindow.y )
                        player1.y -= movement;
                    else
                        player1.y = gameWindow.y - gameWindow.anchors.margins + gameWindow.border.width;

                    break;
                case Qt.Key_S:
                    if(player1.y + movement <= gameWindow.height - player1.height - gameWindow.border.width)
                        player1.y+= movement;
                    else
                        player1.y = gameWindow.height - player1.height - gameWindow.border.width;
                    break;

                case Qt.Key_Escape:
                    endGame();
                    break;
            }
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

        Timer {
            id: noDetectionTimer;
            running: true;
            repeat: false;
            interval: 100;
        }

        function endGame() {
            ballTimer.running = false;
            ball.moveUp = Math.random() <= 0.5;
            ball.moveLeft = Math.random() <= 0.5;
            ball.hitCount = 0;

            ball.horMove = 20;
            ball.vertMove = 20;

            player1.x = gameWindow.x;
            player2.x = gameWindow.width - 2*player2.width;
            ball.x = gameWindow.width / 2;
            ball.y = gameWindow.height /2 ;
        }

        function startGame(){
            ballTimer.running = true;
            noDetectionTimer.running = true;
        }

        function isGameRunning() {
            return ballTimer.running;
        }

        Rectangle{
            id:player1;
            width: gameWindow.objectsWidth; height: 150;
            x: gameWindow.x; y: gameWindow.height /2 - height/2
            focus: true;
            color: "blue";
            radius: 180
            property int score : 0;

            Behavior on y{
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
        }

        Rectangle{
            id:player2;
            width: gameWindow.objectsWidth; height: 150;
            x: gameWindow.width - 2*player2.width; y: gameWindow.height /2 - height/2
            focus: true;
            color: "red";
            radius: 180;
            property int score : 0;

            Behavior on y{
                NumberAnimation {
                    duration: 100
                    easing.type: Easing.Linear
                }
            }
        }

        Timer {
            id: ballTimer
            interval: 10
            repeat: true
            running: false
            onTriggered: {
                ball.x += (ball.moveLeft) ? -ball.horMove : ball.horMove;
                ball.y += (ball.moveUp)   ? -ball.vertMove : ball.vertMove;
            }
        }

        Rectangle{
            id:ball;
            width: gameWindow.objectsWidth; height: gameWindow.objectsWidth;
            focus: true;
            color: "green";
            radius: 360
            visible: gameWindow.isGameRunning();
            x:gameWindow.width / 2; y: gameWindow.height / 2

            property int hitCount: 0;
            property int horMove: 20;
            property bool moveUp: false;
            property bool moveLeft: false;

            property int vertMove: horMove;

            onXChanged: {
                if(!noDetectionTimer.running && ballTimer.running)
                {
                    var vertMove = (moveUp) ? - ball.vertMove : ball.vertMove;

                        if(ball.x - ball.horMove <= player1.x && //check xpos
                         //check ypos
                           ball.y + vertMove + ball.height/2>= player1.y && //bottom interval
                           ball.y + vertMove - ball.height/2<= player1.y + player1.height //top interval
                    ) //player1 hit detection
                    {
                        var tmp1 = -(player1.height - (ball.y + ball.width/2));
                        var p1Half = player1.y + player1.height/2;
                        var speed1 = ball.y - p1Half;

                        ball.vertMove = Math.abs((speed1/100)*ball.horMove);
                        ball.moveLeft = false;
                        ball.moveUp = ball.y <= p1Half;
                        ball.hitCount++;
                    }
                    else  if(ball.x + ball.horMove >= player2.x && //check xpos
                         //check ypos
                           ball.y + vertMove + ball.height/2>= player2.y && //bottom interval
                           ball.y + vertMove - ball.height/2<= player2.y + player2.height //top interval
                    ) //player2 hit detection
                    {
                        var tmp2 = -(player2.height - (ball.y + ball.width/2));
                        var p2Half = player2.y + player2.height/2;
                        var speed2 = ball.y - p2Half;

                        ball.vertMove = Math.abs((speed2/100)*ball.horMove);
                        ball.moveUp = ball.y <= p2Half;
                        ball.moveLeft = true;
                        ball.hitCount++;
                    }

                    if(ball.x <= gameWindow.x - ball.width ) //left end game bar
                    {
                        player2.score++;
                        gameWindow.endGame();
                    }
                    if(ball.x >= gameWindow.x + gameWindow.width - 2*ball.width) // right end game  bar
                    {
                        player1.score++;
                        gameWindow.endGame();
                    }
                }
            }

            onYChanged: {
                if(!noDetectionTimer.running && ballTimer.running)
                {
                    var barYpos =  gameWindow.y - gameWindow.anchors.margins;
                    var vertMove = (moveUp) ? - ball.vertMove : ball.vertMove;

                    if(ball.y + vertMove <= barYpos - ball.height/2) //top bar detection
                    {
                        ball.y = barYpos - ball.height/2;
                        moveUp = false;
                    }
                    else if(ball.y + vertMove >= barYpos - ball.height/2 + gameWindow.height) //bottom bar detection
                    {
                        ball.y = barYpos - ball.height/2 + gameWindow.height
                        moveUp = true;
                    }
                }
            }

            property int maxAnimTime: 150;
            property int minAnimTime: 20;
            property int acceleration: 3;

            Behavior on x{
                NumberAnimation {
                    duration: (ball.maxAnimTime-(ball.hitCount*ball.acceleration) >= ball.minAnimTime) ? ball.maxAnimTime-(ball.hitCount*ball.acceleration) : ball.minAnimTime;
                    easing.type: Easing.Linear
                }
            }
            Behavior on y{
                NumberAnimation {
                    duration: (ball.maxAnimTime-(ball.hitCount*ball.acceleration) >= ball.minAnimTime) ? ball.maxAnimTime-(ball.hitCount*ball.acceleration) : ball.minAnimTime;
                    easing.type: Easing.Linear
                }
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
