import QtQuick 2.0
import QtQuick.Layouts 1.12

Rectangle {
    id:item;
    property string text;
    property alias mouseArea: ma;

    property string colorEntered : "goldenrod"
    property string colorExited: "gold"

    Layout.alignment: Qt.AlignCenter
    Layout.preferredWidth: 100
    Layout.preferredHeight: 50

    color: colorExited
    radius: 45;
    opacity: 0.9
    border.color: "black"
    border.width: 2

    Text{
        id: label
        text: parent.text
        font.bold: true;
        anchors.centerIn: parent
    }

    MouseArea{
        id: ma;
        anchors.fill: parent;
        hoverEnabled: true;
        onEntered: {
            animateColor.start()
        }
        onExited:  {
            item.color = colorExited;
            animateColor.stop()
        }
    }

    PropertyAnimation {id: animateColor; target: item; properties: "color"; to: colorEntered; duration: 250}
}
