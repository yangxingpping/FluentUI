import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Shapes 1.5

Rectangle{
    id: mainBottomBasePane
    property var btnClickedBackgroundColor: "#6d829d" //Qt.rgba(0.215,0.322,0.471,0.7) // "#6d829d" //Qt.rgba(1,1,1,0.2)
    property var btnDefaultBackgroundColor: Qt.rgba(1,1,1,0.0)
    anchors{
        right: parent.left
        bottom: parent.bottom
        left: parent.left
        bottomMargin: 2
        rightMargin: 2
        leftMargin: 98
    }
    height: 62
    z: 998
    color: "transparent"
    Shape {
        ShapePath {
            id: mainBottomRealPanel
            fillColor: "#5d7492"
            //opacity: 0.8
            strokeWidth: 2
            strokeColor: "#5d7492"
            startX: 30; startY: 0
            PathSvg { 
                id: mainBottomRealPanelPath
                path: "M38.3513 0C34.6227 0 31.2038 2.0744 29.4817 5.38152L0 62H765.497H922C923.105 62 %1 61.1046 %1 60V0H38.3513Z".arg(mainBottomBasePane.width)
                //path: "L 400 0 L 400 62 L 0 62 z" 
            }
        }

    }

    Rectangle{
        id: rectBottomMenuMain
        
        anchors.fill: parent
        
        color: "transparent"
        MainBottomMenu{
            id: bottomMenu
            color: "transparent"
        }
    }
    Connections{
        target: bottomMenu
        function onSClickBottomMainMenu(index){
            console.log("click bottom main menu")
        }
        function onSClickBottomDetailMenu(index){
            console.log("click bottom detail menu")
        }
    }
}