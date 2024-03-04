import QtQuick
import QtQuick.Controls
import Qt.labs.qmlmodels

Rectangle{
    id: mainBottomBasePane
    property var bottomPaneSelectedButtonColor: Qt.rgba(1,1,1,1)
    property var bottomPaneNoSelectButtonColor: Qt.rgba(1,1,1,0.6)
    property var btnClickedBackgroundColor: "#6d829d" //Qt.rgba(0.215,0.322,0.471,0.7) // "#6d829d" //Qt.rgba(1,1,1,0.2)
    property var btnDefaultBackgroundColor: Qt.rgba(1,1,1,0.0)
    anchors.fill: parent
    color: "transparent"
    signal sClickBottomMainMenu(int index);
    signal sClickBottomDetailMenu(int index);
    Rectangle{
        id: rectBottomMenuMain
        x: 0
        y: 0
        color: "transparent"
        width: parent.width
        height: parent.height
        ButtonGroup{
            id: btnsBotton
            exclusive: true
            onClicked: function(btn) {
                console.log('click')
                console.log(btn)
                console.log(checkedButton)
                if(checkedButton){
                    checkedButton.contentItem.color =  mainBottomBasePane.bottomPaneNoSelectButtonColor
                    console.log("clicked type %1".arg(checkedButton))
                    checkedButton.background.color = "transparent"
                }

                btn.contentItem.color = mainBottomBasePane.bottomPaneSelectedButtonColor 
                btn.background.color = mainBottomBasePane.btnClickedBackgroundColor
                checkedButton = btn
                //pagemain.switchPageFromQML(btn.index)
            }
        }
        ListModel {
            id: contactModel
            ListElement {
                name: qsTr("Prod")
                iconsource: "Prod.svg"
            }
            ListElement {
                name: qsTr("Prog")
                iconsource: "Prog.svg"
            }
            ListElement {
                name: qsTr("Tool")
                iconsource: "Tool.svg"
            }
            ListElement {
                name: qsTr("Work")
                iconsource: "Work.svg"
            }
            ListElement {
                name: qsTr("Variable")
                iconsource: "Variable.svg"
            }
            ListElement {
                name: qsTr("Diag")
                iconsource: "Diag.svg"
            }
            ListElement {
                name: qsTr("Service")
                iconsource: "Service.svg"
            }
            ListElement {
                name: qsTr("Extend")
                iconsource: "Extend.svg"
            }
        }
        ListView {
            id: rowBottomBtns
            topMargin: 0
            bottomMargin: 0
            leftMargin: 68
            rightMargin: mainBottomBasePane.width > 700 ? 68 : 10
            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            orientation: ListView.Horizontal
            model: contactModel
            delegate: RoundButton {
                height: parent.height
                ButtonGroup.group: btnsBotton
                width : (rowBottomBtns.width - rowBottomBtns.leftMargin - rowBottomBtns.rightMargin) / contactModel.count
                radius: 2
                text: name
                font.pixelSize: 10
                icon.source: "qrc:/example/res/svg/" + iconsource //imgPath + "Button/" + iconsource
                icon.color: "transparent"
                icon.width: 48
                icon.height: 40
                spacing: 0
                display: AbstractButton.TextUnderIcon
                onClicked: {
                    sClickBottomMainMenu(index)
                }
                background: Rectangle{
                    color: "transparent"
                }
                Component.onCompleted: {
                    contentItem.color =  mainBottomBasePane.bottomPaneNoSelectButtonColor
                }
            }
            Component.onCompleted: {
                console.debug("main menu count %1".arg(count))
                btnsBotton.checkedButton = btnsBotton.buttons[0]
                btnsBotton.buttons[0].contentItem.color = mainBottomBasePane.bottomPaneSelectedButtonColor 
                btnsBotton.buttons[0].background.color = mainBottomBasePane.btnClickedBackgroundColor
            }
        }
    }
    Rectangle{
        id: rectBottomMenuDetail
        color: "transparent"
        x: parent.x
        y: parent.y + rectBottomMenuMain.height
        width: parent.width
        height: 0
        ButtonGroup{
            id: groupBtnDetails
            exclusive: true
            onClicked: function(btn) {
                console.log('click')
                console.log(btn)
                console.log(checkedButton)
                if(checkedButton){
                    checkedButton.contentItem.color =  mainBottomBasePane.bottomPaneNoSelectButtonColor
                }

                btn.contentItem.color = mainBottomBasePane.bottomPaneSelectedButtonColor
                checkedButton = btn
                pagemain.switchPageFromQML(btn.index)
            }
            Component.onCompleted: {
                console.log("button group count=%1".arg(btnsBotton.buttons))
            }
        }
        ListModel {
            id: detailModel
            ListElement {
                name: qsTr("Prod")
                iconsource: "Prod.svg"
            }
            ListElement {
                name: qsTr("Prog")
                iconsource: "Prog.svg"
            }
        }
        ListView {
            id: rowBottomDetails
            topMargin: 0
            bottomMargin: 0
            leftMargin: 68/2
            rightMargin: 10 //mainBottomBasePane.width > 700 ? 68 : 10
            orientation: ListView.Horizontal
            anchors.fill: parent
            model: detailModel
            delegate: RoundButton {
                height: rowBottomDetails.height
                ButtonGroup.group: groupBtnDetails
                width : (rowBottomDetails.width - rowBottomDetails.leftMargin - rowBottomDetails.rightMargin) / detailModel.count
                radius: 2
                text: name
                font.pixelSize: mainBottomBasePane.width > 700 ? 10 : 8 //10
                //Material.background: Qt.rgba(1,1,1,0.0)
                icon.source: "qrc:/example/res/svg/" + iconsource // imgPath + "Button/" + iconsource
                icon.color: "transparent"
                icon.width: 30
                icon.height: 30
                spacing: 0
                display: AbstractButton.TextUnderIcon
                onClicked: {
                    sClickBottomDetailMenu(index)
                }
                Component.onCompleted: {
                    contentItem.color =  mainBottomBasePane.bottomPaneNoSelectButtonColor
                    //Material.background = mainBottomBasePane.btnDefaultBackgroundColor
                }
            }
            
            Component.onCompleted: {
                console.debug("list view detail count %1".arg(count))
                console.debug("main menu count %1".arg(count))
                groupBtnDetails.checkedButton = groupBtnDetails.buttons[0]
                groupBtnDetails.buttons[0].contentItem.color = mainBottomBasePane.bottomPaneSelectedButtonColor 
                groupBtnDetails.buttons[0].background.color = mainBottomBasePane.btnClickedBackgroundColor
            }
            
        }
    }


    AnimationController {
        id: controllerBottom
        property bool toEnd: true
        animation: ParallelAnimation {
            id: animBottomMenu
            NumberAnimation { target: rectBottomMenuMain; property: "height"; duration: 600; from: mainBottomBasePane.height; to: 0; easing.type: Easing.InOutQuad }
            NumberAnimation { target: rectBottomMenuDetail; property: "y"; duration: 600; from: mainBottomBasePane.height; to: 0; easing.type: Easing.InOutQuad }
            NumberAnimation { target: rectBottomMenuDetail; property: "height"; duration: 600; from: 0; to: mainBottomBasePane.height; easing.type: Easing.InOutQuad }
            onFinished: {
                console.log("animation completed...")
            }
        }
    }

    function switchBottomMenu(){
        if(controllerBottom.toEnd){
            controllerBottom.completeToEnd();
        }
        else{
            controllerBottom.completeToBeginning()
        }
        controllerBottom.toEnd = !controllerBottom.toEnd
    }

    Component.onCompleted: {
        console.log("mainBottomBasePane hegith %1".arg(mainBottomBasePane.height))
    }

    function initProdDetailMenu(){
        detailModel.clear()
        detailModel.append({"name": qsTr("Auto"),"iconsource": "ProdAuto.svg"});
        detailModel.append({"name": qsTr("Single"),"iconsource": "ProdSingle.svg"});
        detailModel.append({"name": qsTr("MDI"),"iconsource": "ProdMDI.svg"});
        detailModel.append({"name": qsTr("Rapid"),"iconsource": "ProdRapid.svg"});
        detailModel.append({"name": qsTr("Search"),"iconsource": "ProdSearch.svg"});
        detailModel.append({"name": qsTr("Test"),"iconsource": "ProdTest.svg"});
        detailModel.append({"name": qsTr("Manual"),"iconsource": "ProdManual.svg"});
        detailModel.append({"name": qsTr("Home"),"iconsource": "ProdHome.svg"});
        detailModel.append({"name": qsTr("Jog"),"iconsource": "ProdJog.svg"});
        detailModel.append({"name": qsTr("NCFunc"),"iconsource": "ProdNCFunc.svg"});
    }

    function switchToPage(index){
        console.log("switch to main page %1".arg(index))
        switch(index){
            case 0: //home(load) page
            {
                mainBottomBasePane.visible = false
            }break;
            case 1: //prod page
            {
                initProdDetailMenu()
            }break;
            default:
            {

            }break;
        }
    }
}
