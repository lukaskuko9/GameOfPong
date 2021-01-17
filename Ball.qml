import QtQuick 2

Rectangle{
    id:ball;
    property bool isMovingUp: false;
    property bool isMovingLeft: false;

    property alias ballTimer: ballTimer;

    property int initialSpeed: 50

    property real speed: initialSpeed
    property real horMove: initialSpeed
    property real vertMove: initialSpeed


    readonly property int animSpeed: 100

    property Player player1;
    property Player player2;

    focus: true;
    color: "green";
    radius: 360
    visible: ballTimer.running;

    signal gameEnd(Player player)

    Behavior on x { NumberAnimation { easing { type: Easing.Linear } } }
    Behavior on y { NumberAnimation { easing { type: Easing.Linear } } }
    Timer {
        id: ballTimer
        interval: animSpeed
        repeat: true
        running: false

        onTriggered: {

           ball.x += (ball.isMovingLeft) ? -ball.horMove : ball.horMove;
           ball.y += (ball.isMovingUp)   ? -ball.vertMove : ball.vertMove;
        }
    }

    onXChanged: {
        if(ballTimer.running)
        {
            // ball goes right
            var player = ball.player2

            var dist = Math.abs(ball.x + ball.width - player.x)


            if(ball.isMovingLeft)
            {
                player = ball.player1
                dist = Math.abs(ball.x - player.width - player.x)
            }
            var detOffset = ball.width / 4

            var horizontalDetection = dist <= detOffset

            if(dist <= detOffset)
                console.log("player dist: " + dist)

            if(horizontalDetection)
            {
                var vertMove = (isMovingUp) ? - ball.vertMove : ball.vertMove;

                if(ball.y + vertMove + ball.height/2>= player.y &&                  //bottom player point
                                   ball.y + vertMove + ball.height/2<= player.y + player.height //top player point
                ) //vertical detection
                {
                    var pHalf = player.y + player.height/2; //player vertical middle point
                    var diff = ball.y - pHalf; //the further the ball is from middle of the player, the faster vertical speed
                    var seed = diff/100

                    if(seed > 3/4)
                        seed = 3/4

                    if(speed <= 60)
                        speed++

                    ball.vertMove = 1.5*Math.abs(seed*ball.speed); //calc percentage
                    ball.horMove = 1.5*ball.speed - ball.vertMove;

                    console.log(ball.horMove + " " + ball.vertMove)

                    ball.isMovingLeft = !ball.isMovingLeft;
                    ball.isMovingUp = ball.y <= pHalf;
                }
            }

            else if(ball.x <= gameWindow.x - ball.width ) //left end game bar
                gameEnd(player2);
            else if(ball.x >= gameWindow.x + gameWindow.width - 2*ball.width) // right end game  bar
                gameEnd(player1);
        }
    }

    onYChanged: {
        if(ballTimer.running)
        {
            var topbarYpos =  gameWindow.y - gameWindow.anchors.margins;
            var topbardist = topbarYpos - ball.y

            var bottombarYpos =  topbarYpos + gameWindow.height - gameWindow.anchors.margins;
            var bottombardist = bottombarYpos - ball.y

            if(topbardist <= 0 && topbardist >= -ball.height/2) //top bar detection
            {
                console.log("top bar: " + topbardist)
                isMovingUp = false;
            }
            else if(bottombardist <= 0 && bottombardist >= -ball.height/2) //bottom bar detection
            {
                console.log("bottom bar: " + bottombardist)
                isMovingUp = true;
            }
        }
    }

    function reset()
    {
        ball.ballTimer.running = false;
        ball.isMovingUp = Math.random() <= 0.5;
        ball.isMovingLeft = Math.random() <= 0.5;
        ball.speed = ball.initialSpeed
        ball.horMove = ball.initialSpeed
        ball.vertMove = ball.initialSpeed
        var seed = Math.random()
        if(seed > 2/3)
            seed = 2/3

        //ball.vertMove = Math.abs(seed*ball.speedMultiplier); //calc percentage
        //ball.horMove = Math.abs(ball.speedMultiplier - ball.vertMove);

        //ball.horMove = speedMultiplier;
        //ball.vertMove = horMove;
    }
}
