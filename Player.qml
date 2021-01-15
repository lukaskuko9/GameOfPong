import QtQuick 2.0
import QtQuick.VirtualKeyboard 2.15

Rectangle{
    id:player
    width: gameWindow.objectsWidth; height: 150;
    x: gameWindow.x; y: gameWindow.height /2 - height/2
    focus: true;
    radius: 180

    property bool isPC: false
    property int score : 0;
    property int moveUpKey;
    property int moveDownKey;

    property int movement :40;
    Behavior on y{
        NumberAnimation {
            duration: 100
            easing.type: Easing.Linear
        }
    }

    Timer{
        repeat: true;
        running : isPC && gameWindow.isGameRunning();
        interval: 80
        onTriggered: {

            if(ball.y < player.y  || ball.y + ball.height + player.movement> player.y + player.height - player.movement)
            {
                var half = player.y + player.height/2; //player vertical middle point
                     if(half - player.movement < ball.y + ball.height/2)
                    player.moveDown();
                else if(half + player.movement > ball.y + ball.height/2)
                    player.moveUp();
            }
        }
    }

    function moveUp()
    {
        if(y - movement >= gameWindow.y )
            y-= movement;
        else
            y = gameWindow.y - gameWindow.anchors.margins + gameWindow.border.width;
    }

    function moveDown()
    {
        if(y + movement <= gameWindow.height - height - gameWindow.border.width)
            y += movement;
        else
            y = gameWindow.height - height - gameWindow.border.width;
    }

    Keys.onPressed: {
        if(!gameWindow.isGameRunning())
            return;

        event.accepted = false;
        if(!isPC)
        {
            switch(event.key)
            {
                case moveUpKey:
                    moveUp();
                    event.accepted = true;
                    break;
                case moveDownKey:
                    moveDown();
                    event.accepted = true;
                    break;
            }
        }
    }
}
