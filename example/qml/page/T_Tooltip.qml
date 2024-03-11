import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0
import "../component"

FluScrollablePage{

    title: qsTr("Tooltip")

    FluText{
        Layout.topMargin: 20
        text: qsTr("Hover over Tultip and it pops up")
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 68
        paddings: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Text properties of FluIconButton support the Tooltip pop-up window by default")
            }
            FluIconButton{
                iconSource:FluentIcons.ChromeCloseContrast
                iconSize: 15
                text: qsTr("Delete")
                onClicked:{
                    showSuccess(qsTr("Click IconButton"))
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluIconButton{
    iconSource:FluentIcons.ChromeCloseContrast
    iconSize: 15
    text: qsTr("Delete")
    onClicked:{
        showSuccess(qsTr("Click IconButton"))
    }
}
'
    }

    FluArea{
        Layout.fillWidth: true
        Layout.topMargin: 20
        height: 68
        paddings: 10

        Column{
            spacing: 5
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
            }
            FluText{
                text: qsTr("Add a Tooltip pop-up to a Button")
            }
            FluButton{
                id:button_1
                text: qsTr("Delete")
                onClicked:{
                    showSuccess(qsTr("Click Button"))
                }
                FluTooltip{
                    visible: button_1.hovered
                    text:button_1.text
                    delay: 1000
                }
            }
        }
    }
    CodeExpander{
        Layout.fillWidth: true
        Layout.topMargin: -1
        code:'FluButton{
    id: button_1
    text: qsTr("Delete")
    FluTooltip{
        visible: button_1.hovered
        text:button_1.text
        delay: 1000
    }
    onClicked:{
        showSuccess(qsTr("Click Button"))
    }
}'
    }


}
