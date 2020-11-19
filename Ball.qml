import QtQuick 2.0


Rectangle{
    id:ball;
    property bool moveUp: false;
    property bool moveLeft: false;

    property alias ballTimer: ballTimer;

    property int hitCount: 0;
    property int maxSpeed: 20
    property int horMove: maxSpeed;
    property int vertMove: horMove;

    property Player player1;
    property Player player2;

    property int maxAnimTime: 150;
    property int minAnimTime: 20;
    property int acceleration: 3;

    focus: true;
    color: "green";
    radius: 360
    visible: ballTimer.running;
    anchors.centerIn: ball;

    signal gameEnd(Player player)

    onXChanged: {
        if(ballTimer.running)
        {
            var players = [ball.player1, ball.player2];
            var i;
            for(i = 0; i<players.length; i++)
            {
                var vertMove = (moveUp) ? - ball.vertMove : ball.vertMove;

                if(ball.y + vertMove + ball.height/2>= players[i].y &&                  //bottom player point
                   ball.y + vertMove - ball.height/2<= players[i].y + players[i].height //top player point
                ) //vertical detection
                {
                    var horMove = (moveLeft) ? - ball.horMove : ball.horMove;
                    var ballWidthHalf = (moveLeft) ? -ball.width/2 : ball.width/2; //ball horizontal middle point

                    var pHalf = players[i].y + players[i].height/2; //player vertical middle point

                    if(ball.x + horMove -ball.width/4<= players[i].x &&
                       ball.x + horMove +ball.width/4>= players[i].x) //horizontal detection
                    {
                        var speed = ball.y - pHalf; //the further the ball is from middle of the player, the faster vertical speed
                        ball.vertMove = Math.abs((speed/100)*ball.maxSpeed); //calc percentage
                        ball.horMove = 1.5*ball.maxSpeed - ball.vertMove;

                        ball.moveLeft = !ball.moveLeft;
                        ball.moveUp = ball.y <= pHalf;
                        ball.hitCount++;
                        break;
                    }

                }
            }


            if(ball.x <= gameWindow.x - ball.width ) //left end game bar
                gameEnd(player2);
            if(ball.x >= gameWindow.x + gameWindow.width - 2*ball.width) // right end game  bar
                gameEnd(player1);
        }
    }

    onYChanged: {
        if(ballTimer.running)
        {
            var barYpos =  gameWindow.y - gameWindow.anchors.margins;
            var vertMove = (moveUp) ? - ball.vertMove : ball.vertMove;

            if(ball.y + vertMove <= barYpos - ball.height/4) //top bar detection
            {
                ball.y = barYpos - ball.height/2;
                moveUp = false;
            }
            else if(ball.y + vertMove >= barYpos - ball.height/4 + gameWindow.height) //bottom bar detection
            {
                ball.y = barYpos - ball.height/2 + gameWindow.height
                moveUp = true;
            }
        }
    }

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

    Timer {
        id: ballTimer
        interval: 100
        repeat: true
        running: false
        onTriggered: {
            ball.x += (ball.moveLeft) ? -ball.horMove : ball.horMove;
            ball.y += (ball.moveUp)   ? -ball.vertMove : ball.vertMove;
        }
    }

    function reset()
    {
        ball.ballTimer.running = false;
        ball.moveUp = Math.random() <= 0.5;
        ball.moveLeft = Math.random() <= 0.5;
        ball.hitCount = 0;

        ball.horMove = maxSpeed;
        ball.vertMove = horMove;
    }
}
