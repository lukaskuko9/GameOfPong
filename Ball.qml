import QtQuick 2.6

Rectangle{
    id:ball;
    property bool isMovingUp: false;
    property bool isMovingLeft: false;

    property alias ballTimer: ballTimer;

    property int speedMultiplier: 40
    property int horMove: speedMultiplier;
    property int vertMove: speedMultiplier;


    property int animSpeed: 240

    property Player player1;
    property Player player2;

    focus: true;
    color: "green";
    radius: 360
    visible: ballTimer.running;

    signal gameEnd(Player player)

    Behavior on x{
        NumberAnimation {
            duration: animSpeed
            easing.type: Easing.Linear
        }
    }
    Behavior on y{
        NumberAnimation {
            duration: animSpeed*2
            easing.type: Easing.Linear
        }
    }

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
            var player = ball.player1

            if(!ball.isMovingLeft)
                player = ball.player2

            var horMove = (isMovingLeft) ? - ball.horMove : ball.horMove;

            if(ball.x + horMove -ball.width/2<= player.x &&
               ball.x + horMove +ball.width/2>= player.x) //horizontal detection
            {
                var vertMove = (isMovingUp) ? - ball.vertMove : ball.vertMove;

                if(ball.y + vertMove >= player.y &&                  //bottom player point
                   ball.y + vertMove <= player.y + player.height //top player point
                ) //vertical detection
                {
                    var pHalf = player.y + player.height/2; //player vertical middle point
                    var speed = ball.y - pHalf; //the further the ball is from middle of the player, the faster vertical speed
                    ball.vertMove = Math.abs((speed/100)*ball.speedMultiplier); //calc vertical speed
                    ball.horMove = 1.1*ball.speedMultiplier - ball.vertMove;

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
            var barYpos =  gameWindow.y - gameWindow.anchors.margins;
            var vertMove = (isMovingUp) ? - ball.vertMove : ball.vertMove;

            if(ball.y + vertMove <= barYpos - ball.height/2) //top bar detection
            {
                ball.y = barYpos - ball.height/2;
                isMovingUp = false;
            }
            else if(ball.y + vertMove >= barYpos - ball.height/2 + gameWindow.height) //bottom bar detection
            {
                ball.y = barYpos - ball.height/2 + gameWindow.height
                isMovingUp = true;
            }
        }
    }

    function reset()
    {
        ball.ballTimer.running = false;
        ball.isMovingUp = Math.random() <= 0.5;
        ball.isMovingLeft = Math.random() <= 0.5;


        do{
            var seed = Math.random()
            ball.vertMove = Math.abs(seed*ball.speedMultiplier); //calc percentage
            ball.horMove = Math.abs(ball.speedMultiplier - ball.vertMove);
        }
        while(ball.horMove < ball.speedMultiplier/2) //ensures at least half of total speed goes to horizontal speed
        console.log(ball.horMove + " " + ball.vertMove)
        //ball.horMove = speedMultiplier;
        //ball.vertMove = horMove;
    }
}
