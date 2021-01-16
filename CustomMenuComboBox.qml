import QtQuick.Layouts 1.12
import QtQuick 2.6
import QtQuick.Controls 2.0

Rectangle {
    id:item;
    property string text;

    property string colorSelected : "goldenrod"
    property string colorDefault: "gold"

    property bool isPC: combobox.currentIndex === 1;

    property string player: "Player"
    property string pc: "PC"


    property var selectedItem : combobox.currentText;

    Layout.alignment: Qt.AlignCenter
    Layout.preferredWidth: 85
    Layout.preferredHeight: 30


    ComboBox {
        id:combobox
        anchors.fill: parent;
        model: [ player, pc ]
        currentIndex: selectedItem === player ? 0 : 1
        background: Rectangle {
                anchors.fill: parent;
                radius: 45;
                color: colorDefault
                border.width: 2

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (combobox.popup.visible) {
                            combobox.popup.close()
                        } else {
                            combobox.popup.open()
                        }
                    }
                }
            }
        delegate: MenuItem {
                width: combobox.popup.width
                background: Rectangle {
                    anchors.fill: parent;
                    color: combobox.highlightedIndex === index ? colorSelected : colorDefault
                    border.width: 1
                }
                text: modelData
                highlighted: combobox.highlightedIndex === index
                hoverEnabled: combobox.hoverEnabled
            }

        popup: Popup {
                id: checkbox_popup
                y: combobox.height+1
                width: combobox.width
                implicitHeight: contentItem.implicitHeight
                padding: 1
                contentItem: ListView {
                    implicitHeight: contentHeight+2
                    model: combobox.popup.visible ? combobox.delegateModel : null
                    currentIndex: combobox.highlightedIndex
                }

                onClosed: if (combobox.forceOpen) open()
        }
    }

}
