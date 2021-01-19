import QtQuick 2

Rectangle{
    id:ball;
    property bool isMovingUp: false;
    property bool isMovingLeft: false;

    property alias ballTimer: ballTimer;

    property int initialSpeed: 100
    readonly property int maxSpeed: 160

    property real speed: initialSpeed
    property real horMove: initialSpeed
    property real vertMove: initialSpeed


    readonly property int animSpeed: 50

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

                if(ballBottomPoint + detOffset   >= player.y &&                  //top player point
                   ballTopPoint    - detOffset   <= player.y + player.height     //bottom player point
                ) //vertical detection
                {
                    var pHalf = player.y + player.height/2; //player vertical middle point
                    var diff = Math.abs(ball.y - pHalf); //the further the ball is from middle of the player, the faster vertical speed
                    var seed = diff/100

                    if(seed > 2/3) //make sure there is some horizontal speed as well
                    {
                        console.log("seed: "+ seed)
                        seed = 2/3
                    }

                    if(speed <= maxSpeed)
                    {
                        console.log("speed: "+ speed)
                        speed++  
                    }

                    ball.vertMove = seed*ball.speed; //calc vertical speed
                    ball.horMove = Math.abs(1-seed)*ball.speed; //distribute the rest of total speed to horizontal speed

                    console.log("horizontal speed: " + ball.horMove + "\nvertical speed: " + ball.vertMove)

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

            if((topbardist <= 0 && topbardist >= -ball.height/2) //top bar detection
                || (topbardist>ball.height && topbardist >= 0) //possible bug prevention
            )
            {
                isMovingUp = false;
            }

            else if((bottombardist <= 0 && bottombardist >= -ball.height/2) //bottom bar detection
                || (bottombardist < ball.height && bottombardist <= 0))
            {
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
        ball.horMove = ball.initialSpeed/2
        ball.vertMove = ball.initialSpeed/2
    }
}
