import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import FluentUI 1.0

Window {
    default property alias content: layout_content.data
    property string windowIcon: FluApp.windowIcon
    property bool closeDestory: true
    property int launchMode: FluWindowType.Standard
    property var argument:({})
    property var background : com_background
    property bool fixSize: false
    property Component loadingItem: com_loading
    property bool fitsAppBarWindows: false
    property Item appBar: FluAppBar {
        title: window.title
        height: 30
        showDark: window.showDark
        showClose: window.showClose
        showMinimize: window.showMinimize
        showMaximize: window.showMaximize
        showStayTop: window.showStayTop
        icon: window.windowIcon
    }
    property color backgroundColor: {
        if(active){
            return FluTheme.windowActiveBackgroundColor
        }
        return FluTheme.windowBackgroundColor
    }
    property bool stayTop: false
    property bool showDark: false
    property bool showClose: true
    property bool showMinimize: true
    property bool showMaximize: true
    property bool showStayTop: true
    property bool autoMaximize: false
    property bool autoVisible: true
    property bool autoCenter: true
    property bool useSystemAppBar
    property color resizeBorderColor: {
        if(window.active){
            return FluTheme.dark ? "#333333" : "#6E6E6E"
        }
        return FluTheme.dark ? "#3D3D3E" : "#A7A7A7"
    }
    property int resizeBorderWidth: 1
    property var closeListener: function(event){
        if(closeDestory){
            destoryOnClose()
        }else{
            visible = false
            event.accepted = false
        }
    }
    signal showSystemMenu
    signal initArgument(var argument)
    signal firstVisible()
    property point _offsetXY : Qt.point(0,0)
    property var _originalPos
    property int _realHeight
    property int _realWidth
    property int _appBarHeight: appBar.height
    property var _windowRegister
    property string _route
    id:window
    color:"transparent"
    Component.onCompleted: {
        _realHeight = height
        _realWidth = width
        useSystemAppBar = FluApp.useSystemAppBar
        if(useSystemAppBar && autoCenter){
            moveWindowToDesktopCenter()
        }
        fixWindowSize()
        lifecycle.onCompleted(window)
        initArgument(argument)
        if(!useSystemAppBar){
            loader_frameless_helper.sourceComponent = com_frameless_helper
        }
        if(window.autoVisible){
            if(window.autoMaximize){
                window.showMaximized()
            }else{
                window.show()
            }
        }
    }
    Component.onDestruction: {
        lifecycle.onDestruction()
    }
    on_OriginalPosChanged: {
        if(_originalPos){
            var dx = (_originalPos.x - screen.virtualX)/screen.devicePixelRatio
            var dy = (_originalPos.y - screen.virtualY)/screen.devicePixelRatio
            if(dx<0 && dy<0){
                _offsetXY = Qt.point(Math.abs(dx)-1,Math.abs(dy)-1)
            }else{
                _offsetXY = Qt.point(0,0)
            }
        }else{
            _offsetXY = Qt.point(0,0)
        }
    }
    onShowSystemMenu: {
        if(loader_frameless_helper.item){
            loader_frameless_helper.item.showSystemMenu()
        }
    }
    onVisibleChanged: {
        if(visible && d.isFirstVisible){
            window.firstVisible()
            d.isFirstVisible = false
        }
        lifecycle.onVisible(visible)
    }
    QtObject{
        id:d
        property bool isFirstVisible: true
    }
    Connections{
        target: window
        function onClosing(event){closeListener(event)}
    }
    Component{
        id:com_frameless_helper
        FluFramelessHelper{
            onLoadCompleted:{
                if(autoCenter){
                    window.moveWindowToDesktopCenter()
                }
            }
        }
    }
    Component{
        id:com_background
        Rectangle{
            color: window.backgroundColor
        }
    }
    Component{
        id:com_app_bar
        Item{
            data: window.appBar
        }
    }
    Component{
        id:com_loading
        Popup{
            id:popup_loading
            focus: true
            width: window.width
            height: window.height
            anchors.centerIn: Overlay.overlay
            closePolicy: {
                if(cancel){
                    return Popup.CloseOnEscape | Popup.CloseOnPressOutside
                }
                return Popup.NoAutoClose
            }
            Overlay.modal: Item {}
            onVisibleChanged: {
                if(!visible){
                    loader_loading.sourceComponent = undefined
                }
            }
            padding: 0
            opacity: 0
            visible:true
            Behavior on opacity {
                SequentialAnimation {
                    PauseAnimation {
                        duration: 88
                    }
                    NumberAnimation{
                        duration:  167
                    }
                }
            }
            Component.onCompleted: {
                opacity = 1
            }
            background: Rectangle{
                color:"#44000000"
            }
            contentItem: Item{
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        if (cancel){
                            popup_loading.visible = false
                        }
                    }
                }
                ColumnLayout{
                    spacing: 8
                    anchors.centerIn: parent
                    FluProgressRing{
                        Layout.alignment: Qt.AlignHCenter
                    }
                    FluText{
                        text:loadingText
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }
    Component{
        id:com_border
        Rectangle{
            color:"transparent"
            border.width: window.resizeBorderWidth
            border.color: window.resizeBorderColor
        }
    }
    FluLoader{
        id:loader_frameless_helper
    }
    Item{
        id:layout_container
        anchors{
            fill:parent
            topMargin: _offsetXY.y
        }
        onWidthChanged: {
            window.appBar.width = width
        }
        FluLoader{
            anchors.fill: parent
            sourceComponent: background
        }
        FluLoader{
            id:loader_app_bar
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            height: {
                if(window.useSystemAppBar){
                    return 0
                }
                return window.fitsAppBarWindows ? 0 : window.appBar.height
            }
            sourceComponent: window.useSystemAppBar ? undefined : com_app_bar
        }
        Item{
            id:layout_content
            anchors{
                top: loader_app_bar.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            clip: true
        }
        FluLoader{
            property string loadingText: "加载中..."
            property bool cancel: false
            id:loader_loading
            anchors.fill: layout_content
        }
        FluInfoBar{
            id:infoBar
            root: window
        }
        FluWindowLifecycle{
            id:lifecycle
        }
        FluLoader{
            id:loader_border
            anchors.fill: parent
            sourceComponent: {
                if(window.useSystemAppBar){
                    return undefined
                }
                if(FluTools.isWindows10OrGreater()){
                    return undefined
                }
                if(window.visibility === Window.Maximized || window.visibility === Window.FullScreen){
                    return undefined
                }
                return com_border
            }
        }
    }
    function destoryOnClose(){
        lifecycle.onDestoryOnClose()
    }
    function showLoading(text = "加载中...",cancel = true){
        loader_loading.loadingText = text
        loader_loading.cancel = cancel
        loader_loading.sourceComponent = com_loading
    }
    function hideLoading(){
        loader_loading.sourceComponent = undefined
    }
    function showSuccess(text,duration,moremsg){
        infoBar.showSuccess(text,duration,moremsg)
    }
    function showInfo(text,duration,moremsg){
        infoBar.showInfo(text,duration,moremsg)
    }
    function showWarning(text,duration,moremsg){
        infoBar.showWarning(text,duration,moremsg)
    }
    function showError(text,duration,moremsg){
        infoBar.showError(text,duration,moremsg)
    }
    function moveWindowToDesktopCenter(){
        screen = Qt.application.screens[FluTools.cursorScreenIndex()]
        var taskBarHeight = FluTools.getTaskBarHeight(window)
        window.setGeometry((Screen.width-window.width)/2+Screen.virtualX,(Screen.height-window.height-taskBarHeight)/2+Screen.virtualY,window.width,window.height)
    }
    function fixWindowSize(){
        if(fixSize){
            window.maximumWidth =  window.width
            window.maximumHeight =  window.height
            window.minimumWidth = window.width
            window.minimumHeight = window.height
        }
    }
    function registerForWindowResult(path){
        return FluApp.createWindowRegister(window,path)
    }
    function onResult(data){
        if(_windowRegister){
            _windowRegister.onResult(data)
        }
    }
    function layoutContainer(){
        return layout_container
    }
    function layoutContent(){
        return layout_content
    }
}
