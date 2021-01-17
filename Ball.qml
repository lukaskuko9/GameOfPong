import QtQuick 2

Rectangle{
    id:ball;
    property bool isMovingUp: false;
    property bool isMovingLeft: false;

    property alias ballTimer: ballTimer;

    property int initialSpeed: 60

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
            // assume ball is moving right
            var player = ball.player2
            var dist = Math.abs(ball.x + ball.width - player.x)

            if(ball.isMovingLeft) //ball is moving left
            {
                player = ball.player1
                dist = Math.abs(ball.x - player.width - player.x)
            }
            var detOffset = ball.width / 4

            if(dist <= detOffset)
            {
                detOffset = ball.height / 3
                console.log("player horizontal dist: " + dist)

                var ballTopPoint    = ball.y
                var ballBottomPoint = ball.y + ball.height

                if(ballBottomPoint + detOffset   >= player.y                     //top player point
                && ballTopPoint    - detOffset   <= player.y + player.height     //bottom player point
                ) //vertical detection
                {
                    var pHalf = player.y + player.height/2; //player vertical middle point
                    var diff = Math.abs(ball.y - pHalf); //the further the ball is from middle of the player, the faster vertical speed
                    var seed = diff/100

                    if(seed > 2/3)
                    {
                        console.log("seed"+ seed)
                        seed = 2/3
                    }

                    if(speed <= 150)
                        speed++

                    console.log("speed"+ speed)

                    ball.vertMove = seed*ball.speed; //calc percentage
                    ball.horMove = Math.abs(1-seed)*ball.speed;

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

            if(topbardist <= 0 && topbardist >= -ball.height/4) //top bar detection
            {
                //console.log("top bar: " + topbardist)
                isMovingUp = false;
            }
            else if(topbardist>ball.height)
            {
                console.log("bug fix (top)")
                isMovingUp = false;
            }

            else if(bottombardist <= 0 && bottombardist >= -ball.height/4) //bottom bar detection
            {
                //console.log("bottom bar: " + bottombardist)
                isMovingUp = true;
            }
            else if(bottombardist < ball.height)
            {
                console.log("bug fix (bottom)")
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
