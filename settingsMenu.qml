import QtQuick 2.0
import QtQuick.Layouts 1.12

Item{
    id:settingsMenu;
    visible: en;
    enabled: en;
    ColumnLayout
    {
        anchors.fill: parent;
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
                text: "Back"
                font.bold: true;
                anchors.centerIn: parent
            }

            MouseArea{
                anchors.fill: parent;
                onClicked:
                {
                    settingsMenu.visible = false;
                    menu.visible = true;
                }
            }
        }

    }
}
