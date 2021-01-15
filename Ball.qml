import QtQuick 2.0


Rectangle{
    id:ball;
    property bool isMovingUp: false;
    property bool isMovingLeft: false;

    property alias ballTimer: ballTimer;

    property int hitCount: 0;
    property int speedMultiplier: 20
    property int horMove: speedMultiplier;
    property int vertMove: horMove;

    property int initialSpeed: 120
    property int stopSpeed: 50
    property int animSpeed: (initialSpeed-hitCount <= stopSpeed) ? stopSpeed : initialSpeed-hitCount;


    property Player player1;
    property Player player2;

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
                var vertMove = (isMovingUp) ? - ball.vertMove : ball.vertMove;

                if(ball.y + vertMove + ball.height/2>= players[i].y &&                  //bottom player point
                   ball.y + vertMove - ball.height/2<= players[i].y + players[i].height //top player point
                ) //vertical detection
                {
                    var horMove = (isMovingLeft) ? - ball.horMove : ball.horMove;
                    var ballWidthHalf = (isMovingLeft) ? -ball.width/2 : ball.width/2; //ball horizontal middle point

                    var pHalf = players[i].y + players[i].height/2; //player vertical middle point

                    if(ball.x + horMove -ball.width/4<= players[i].x &&
                       ball.x + horMove +ball.width/4>= players[i].x) //horizontal detection
                    {
                        var speed = ball.y - pHalf; //the further the ball is from middle of the player, the faster vertical speed
                        ball.vertMove = Math.abs((speed/100)*ball.speedMultiplier); //calc percentage
                        ball.horMove = 2*ball.speedMultiplier - ball.vertMove;

                        ball.isMovingLeft = !ball.isMovingLeft;
                        ball.isMovingUp = ball.y <= pHalf;
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
            var vertMove = (isMovingUp) ? - ball.vertMove : ball.vertMove;

            if(ball.y + vertMove <= barYpos - ball.height/4) //top bar detection
            {
                ball.y = barYpos - ball.height/2;
                isMovingUp = false;
            }
            else if(ball.y + vertMove >= barYpos - ball.height/4 + gameWindow.height) //bottom bar detection
            {
                ball.y = barYpos - ball.height/2 + gameWindow.height
                isMovingUp = true;
            }
        }
    }

    Behavior on x{
        NumberAnimation {
            duration: animSpeed
            easing.type: Easing.Linear
        }
    }
    Behavior on y{
        NumberAnimation {
            duration: animSpeed
            easing.type: Easing.Linear
        }
    }

    Timer {
        id: ballTimer
        interval: animSpeed/4
        repeat: true
        running: false
        onTriggered: {
            ball.x += (ball.isMovingLeft) ? -ball.horMove : ball.horMove;
            ball.y += (ball.isMovingUp)   ? -ball.vertMove : ball.vertMove;
        }
    }

    function reset()
    {
        ball.ballTimer.running = false;
        ball.isMovingUp = Math.random() <= 0.5;
        ball.isMovingLeft = Math.random() <= 0.5;
        ball.hitCount = 0;

        ball.vertMove = Math.abs((Math.random())*ball.speedMultiplier); //calc percentage
        ball.horMove = 2*ball.speedMultiplier - ball.vertMove;

        //ball.horMove = speedMultiplier;
        //ball.vertMove = horMove;
    }
}
