import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls
//import QtGraphicalEffects 1.15
import Qt5Compat.GraphicalEffects
//import QtMultimedia 5.15
import QtQuick.Layouts 1.15

Window {

    width: 1000
    height: 650

    maximumWidth: 1000
    maximumHeight: 650

    visible: true
    title: qsTr("BLAST-NG")

    //Main Controller Connections
    Connections {
        target: mainController

        onSelectedFileDataToQml:{
            blastOutputText.text = _fileContents
            //scrollView.ScrollBar.vertical.position = 1.0 - scrollView.ScrollBar.vertical.size
        }
        onDirectionsTextToQml:{
            blastOutputText.text = directionsText
        }
        onDbDirectionsTxtToQml:{
            buildDbOutputText.text = dbdirectionsTxt
        }
        onBuildDbOutputToQml:{
            buildDbOutputText.text += buildDbText
        }
        onDbNameTxtToQml:{
            model.append({text: dbName})
        }
        onBlastPData2Qml:{
            blastOutputText.text += blastPText
        }
        onBlastTimeLogData2Qml:{
            blastOutputText.text += timeLogText
        }
        onSeqFileNameToQml:{
            selectedFileText.text = _seqFileName
        }
        onDbFileNameToQml:{
            filePathLabel.text = _dbFileName
        }
        onDirPathToQml:{
            dirPathLabel.text = _dirPath
        }
        onDataFileName2QML:{
            console.log("Trying to add file names to combo box...")
            modelLogView.append({text: dataFileName})
        }
        onFileViewerData2Qml:{
            dataViewerTxtArea.text += fileData + "/n"
        }
    }

    Rectangle {
        id: dataViewerWin
        x: 0
        y: 0
        width: 1000
        height: 650
        opacity: 1
        visible: false
        color: "#000000"

        Image {
            id: dataViewerWinBg
            x: 0
            y: 0
            width: 1000
            height: 650
            source: "images/bg_1000X650.png"
            fillMode: Image.PreserveAspectFit

            ComboBox {
                       id: controlLogView
                       x: 96
                       y: 26
                       width: 200
                       height: 21
                       //model: ["Available Logs", "Application", "System", "Security", "Custom"]
                       model: ListModel{
                           id: modelLogView
                           ListElement {text: "Select Data File"}
                       }
                       onAccepted: {
                           if (find(editText) === -1)
                               modelLogView.append({text: editText})
                       }

                       delegate: ItemDelegate {
                           width: controlLogView.width
                           contentItem: Text {
                               text: controlLogView.textRole
                                     ? (Array.isArray(controlLogView.model) ? modelData[controlLogView.textRole] : model[controlLogView.textRole])
                                     : modelData
                               color: "#000000" //Change the text color of the model data in the drop down box.
                               font: controlLogView.font
                               elide: Text.ElideRight
                               verticalAlignment: Text.AlignVCenter
                           }
                           highlighted: controlLogView.highlightedIndex === index
                       }

                       indicator: Canvas {
                           id: canvasDWV
                           x: controlLogView.width - width - controlLogView.rightPadding
                           y: controlLogView.topPadding + (controlLogView.availableHeight - height) / 2
                           width: 12
                           height: 8
                           contextType: "2d"

                           Connections {
                               target: controlLogView
                               function onPressedChanged() { canvasDWV.requestPaint(); }
                           }

                           //This will change the color of the triangle indicator.
                           onPaint: {
                               context.reset();
                               context.moveTo(0, 0);
                               context.lineTo(width, 0);
                               context.lineTo(width / 2, height);
                               context.closePath();
                               context.fillStyle = controlLogView.pressed ? "#ffffff" : "#ffffff";
                               context.fill();
                           }
                       }
                       //The second color is the main color. The first item is what color the changes to once clicked.
                       //This will change the text color of main text in the box.
                       contentItem: Text {
                           leftPadding: 0
                           rightPadding: controlLogView.indicator.width + controlLogView.spacing

                           text: controlLogView.displayText
                           font: controlLogView.font
                           color: controlLogView.pressed ? "#000000" : "#ffffff"
                           verticalAlignment: Text.AlignVCenter
                           elide: Text.ElideRight
                       }

                       //This will change the main box background color, border color,  and the border color when pressed.
                       //The second color is the main color. The first item is what color the changes to once clicked.
                       background: Rectangle {
                           implicitWidth: 120
                           implicitHeight: 40
                           color: "#000000"
                           border.color: controlLogView.pressed ? "#ffffff" : "#ffffff"
                           border.width: controlLogView.visualFocus ? 2 : 1
                           radius: 2
                       }

                       popup: Popup {
                           y: controlLogView.height - 1
                           width: controlLogView.width
                           implicitHeight: contentItem.implicitHeight
                           padding: 1

                           contentItem: ListView {
                               clip: true
                               implicitHeight: contentHeight
                               model: controlLogView.popup.visible ? controlLogView.delegateModel : null
                               currentIndex: controlLogView.highlightedIndex

                               ScrollIndicator.vertical: ScrollIndicator { }
                           }

                           //This will change the color of the drop down Rectangle
                           background: Rectangle {
                               border.color: "#ffffff"
                               color: "#ffffff"
                               radius: 5
                           }
                       }
                       Component.onCompleted: {
                           //populate saved logs
                           mainController.populateDataFiles()
                       }
                       onSelectTextByMouseChanged: {

                       }
                   }

            Image {
                id: image5
                x: 416
                y: 8
                width: 172
                height: 32
                source: "images/dataviewertext.png"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: dvw_OpenBtn
                x: 96
                y: 495
                width: 77
                height: 24
                source: "images/open_file_btn.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                x: 96
                y: 495
                width: 77
                height: 24
                hoverEnabled: true
                onExited: {
                    dvw_OpenBtn.width = 77
                    dvw_OpenBtn.height = 24
                }
                onClicked: {
                  mainController.loadDataFile(controlLogView.currentText)

                }
                onEntered: {
                    dvw_OpenBtn.width = 79
                    dvw_OpenBtn.height = 26
                }
            }

            Image {
                id: dvw_CloseBtn
                x: 463
                y: 495
                width: 77
                height: 24
                source: "images/close_file_btn.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                x: 463
                y: 495
                width: 77
                height: 24
                hoverEnabled: true
                onExited: {
                                    dvw_OpenBtn.width = 77
                                    dvw_OpenBtn.height = 24
                }
                onClicked: {
                    dataViewerTxtArea.text = ""
                }
                onEntered: {
                    dvw_OpenBtn.width = 79
                    dvw_OpenBtn.height = 26
                }
            }

            Image {
                id: dvw_HelpBtn
                x: 861
                y: 495
                width: 77
                height: 24
                source: "images/elpBtn.png"
                fillMode: Image.PreserveAspectFit
            }

            MouseArea {
                x: 861
                y: 495
                width: 77
                height: 24
                hoverEnabled: true
                onExited: {
                                    dvw_OpenBtn.width = 77
                                    dvw_OpenBtn.height = 24
                                }
                onClicked: {
                                    if(buildDbOutputText.getText(0,1) === ""){
                                        mainController.getDbInstructions()
                                    }
                                }
                onEntered: {
                                    dvw_OpenBtn.width = 79
                                    dvw_OpenBtn.height = 26
                                }
            }
        }

        Rectangle {
            id: rectangle2
            x: 96
            y: 50
            width: 839
            height: 425
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: dataViewerScrollView
                x: 4
                y: 4
                width: 831
                height: 416
                //visible: false
                clip: true



                TextArea {
                    id: dataViewerTxtArea
                    x: -7
                    y: -3
                    color: "#ffffff"
                    placeholderText: qsTr("")
                    background: Rectangle {color: "black"}
                }
            }
        }



    }

    Rectangle {
        id: buildDatabaseWin
        width: 1000
        height: 650
        color: "#000000"
        visible: false

        MouseArea {
            id: buildDbWinMouseArea
            width: 1000
            height: 650
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if (mouse.button === Qt.RightButton){
                    //contextMenuDbWin.popup()
                }
                else if(mouse.button === Qt.LeftButton){
                    dbNameTxtEdit.deselect()
                    buildDbOutputText.deselect()
                }
            }
        }

        Image {
            id: image3
            width: 1000
            height: 650
            source: "images/bg_1000X650.png"
            fillMode: Image.PreserveAspectFit

            Label {
                id: label
                x: 291
                y: 409
                width: 217
                height: 13
                color: "#ffffff"
                text: qsTr("Optional: Select directory to store database")
                font.pointSize: 7
            }
        }

        Rectangle {
            id: rectangle
            x: 198
            y: 62
            width: 605
            height: 292
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: scrollView1
                x: 4
                y: 4
                width: 596
                height: 282
                opacity: 1
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff


                TextArea {
                    id: buildDbOutputText
                    x: -7
                    y: -3
                    width: 572
                    height: 287
                    color: "#ffffff"
                    text: ""
                    wrapMode: Text.Wrap
                    placeholderTextColor: "#ffffff"
                    clip: true
                    placeholderText: qsTr("")
                    visible: true
                    selectByMouse: true
                    selectionColor: "#ffffff"
                    background: Rectangle {color: "black"}
                    //persistentSelection: true
                }
                clip: false
                ScrollBar.vertical.position: 0
            }
        }
        /*
        Button {
            id: backBtn
            x: 14
            y: 15
            width: 91
            height: 36
            text: qsTr("Back")
            palette.buttonText: "#ffffff"
            layer.enabled: true
            visible: false
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                verticalOffset: 2
                samples: 17
                horizontalOffset: 2
                transparentBorder: true
                spread: 0
            }
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            onClicked: {
                buildDatabaseWin.visible = false
                mainWindow.visible = true
            }
        }
*/
        ComboBox {
            id: controlDb
            x: 471
            y: 379
            width: 152
            height: 21
            visible: true
            model: ["         ", " Nucleic Acid Sequence", " Protein Sequence"]

            delegate: ItemDelegate {
                width: controlDb.width
                contentItem: Text {
                    text: controlDb.textRole
                          ? (Array.isArray(controlDb.model) ? modelData[controlDb.textRole] : model[controlDb.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: controlDb.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: controlDb.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvasDb
                x: controlDb.width - width - controlDb.rightPadding
                y: controlDb.topPadding + (controlDb.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: controlDb
                    function onPressedChanged() { canvasDb.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = controlDb.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: controlDb.indicator.width + controlDb.spacing

                text: controlDb.displayText
                font: controlDb.font
                color: controlDb.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: controlDb.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: controlDb.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: controlDb.height - 1
                width: controlDb.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: controlDb.popup.visible ? controlDb.delegateModel : null
                    currentIndex: controlDb.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }

        Button {
            id: ad_selectFileBtn
            x: 240
            y: 393
            width: 125
            height: 40
            text: qsTr("Select File")
            palette.buttonText: "#ffffff"
            layer.enabled: true
            visible: false
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                verticalOffset: 2
                samples: 17
                horizontalOffset: 2
                transparentBorder: true
                spread: 0
            }
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            onClicked: {
                mainController.selectAFile()
            }
        }

        Rectangle {
            id: dbNameRect
            x: 635
            y: 379
            width: 168
            height: 21
            color: "#000000"

            TextEdit {
                id: dbNameTxtEdit
                x: 2
                y: 2
                width: 164
                height: 17
                color: "#ffffff"
                text: qsTr("")
                selectedTextColor: "#000000"
                selectionColor: "#ffffff"
                cursorVisible: false
                clip: true
                font.pixelSize: 13
                selectByMouse:  true
                //persistentSelection: true
            }
            border.color: "#ffffff"
        }

        Label {
            id: label6
            x: 665
            y: 360
            width: 109
            height: 22
            color: "#ffffff"
            text: qsTr("Database Name")
            font.pointSize: 11
        }

        Label {
            id: label7
            x: 476
            y: 360
            width: 144
            height: 22
            color: "#ffffff"
            text: qsTr("Select Database Type")
            font.pointSize: 11
        }

        Button {
            id: buildDbBtn
            x: 465
            y: 508
            width: 125
            height: 40
            text: qsTr("Build Database")
            palette.buttonText: "#ffffff"
            layer.enabled: true
            visible: false
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                verticalOffset: 2
                samples: 17
                horizontalOffset: 2
                transparentBorder: true
                spread: 0
            }
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            onClicked: {
                var curText = dbNameTxtEdit.getText(0,dbNameTxtEdit.length)
                if(controlDb.currentText.trim() === ""){
                    buildDbOutputText.text = "Select a database type before proceeding"

                }else{
                    if(controlDb.currentText.trim() === "Protein Sequence"){
                        mainController.buildDatabase("prot", curText)

                    }else{
                        mainController.buildDatabase("nucl", curText)
                    }
                }
            }
        }

        Image {
            id: addDbTxtImg
            x: 409
            y: 14
            width: 183
            height: 33
            source: "images/adddbtext.png"
            fillMode: Image.PreserveAspectFit
        }

        Button {
            id: dbHelpBtn
            x: 690
            y: 508
            width: 125
            height: 40
            text: qsTr("Help")
            palette.buttonText: "#ffffff"
            layer.enabled: true
            visible: false
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                verticalOffset: 2
                samples: 17
                horizontalOffset: 2
                transparentBorder: true
                spread: 0
            }
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            onClicked: {
                if(buildDbOutputText.getText(0,1) === ""){
                    mainController.getDbInstructions()
                }
            }
        }

        Rectangle {
            id: filePathRect
            x: 290
            y: 379
            width: 168
            height: 21
            color: "#000000"

            Label {
                id: filePathLabel
                x: 3
                y: 3
                width: 163
                height: 17
                color: "#ffffff"
                text: qsTr("")
                clip: true
                font.pointSize: 8
            }
            border.color: "#ffffff"
        }
        Image {
            id: db_selectFileBtn
            x: 207
            y: 378
            width: 77
            height: 24
            source: "images/sfBtn-adb.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: addDbSelectFileMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                hoverEnabled: true
                onClicked: {
                    mainController.selectAFile()
                }
                onEntered: {
                    db_selectFileBtn.width = 79
                    db_selectFileBtn.height = 26
                }
                onExited: {
                    db_selectFileBtn.width = 77
                    db_selectFileBtn.height = 24
                }
            }
        }
        Image {
            id: db_buildDbBtn
            x: 288
            y: 453
            width: 77
            height: 24
            source: "images/buildDBBtn.png"
            MouseArea {
                id: buildDbMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                hoverEnabled: true
                onClicked: {
                    var curText = dbNameTxtEdit.getText(0,dbNameTxtEdit.length)
                    if(controlDb.currentText.trim() === ""){
                        buildDbOutputText.text = "Select a database type before proceeding"

                    }else{
                        if(controlDb.currentText.trim() === "Protein Sequence"){
                            mainController.buildDatabase("prot", curText)

                        }else{
                            mainController.buildDatabase("nucl", curText)
                        }
                    }
                }
                onEntered: {
                    db_buildDbBtn.width = 79
                    db_buildDbBtn.height = 26
                }
                onExited: {
                    db_buildDbBtn.width = 77
                    db_buildDbBtn.height = 24
                }
            }
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: db_helpBtn
            x: 730
            y: 453
            width: 77
            height: 24
            source: "images/elpBtn.png"
            MouseArea {
                id: helpMouseArea
                width: 77
                height: 24
                hoverEnabled: true
                onEntered: {
                    db_helpBtn.width = 79
                    db_helpBtn.height = 26
                }
                onExited: {
                    db_helpBtn.width = 77
                    db_helpBtn.height = 24
                }
                onClicked: {
                    if(buildDbOutputText.getText(0,1) === ""){
                        mainController.getDbInstructions()
                    }
                }
            }
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: dirPathRect
            x: 290
            y: 421
            width: 513
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            Label {
                id: dirPathLabel
                x: 3
                y: 3
                width: 508
                height: 17
                color: "#ffffff"
                text: qsTr("")
                clip: true
                font.pointSize: 8
            }
        }

        Image {
            id: dbSelectDirVtn
            x: 207
            y: 420
            width: 77
            height: 24
            fillMode: Image.PreserveAspectFit
            source: "images/selectDirBtn.png"
            MouseArea {
                id: selectDirMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                hoverEnabled: true
                onEntered: {
                    dbSelectDirVtn.width = 79
                    dbSelectDirVtn.height = 26
                }
                onExited: {
                    dbSelectDirVtn.width = 77
                    dbSelectDirVtn.height = 24
                }
                onClicked: {
                    mainController.selectDirectory()
                }
            }
        }
    }



    Rectangle {
        id: mainWindow
        x: 0
        y: 0
        width: 1000
        height: 650
        visible: true
        color: "#000000"
        border.color: "#e7d8d8"

        MouseArea {
            id: mainWinMouseArea
            x: 0
            y: 1
            width: 1000
            height: 650
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            onClicked: {
                if (mouse.button === Qt.RightButton){
                    //contextMenuM.popup()
                }
                else if(mouse.button === Qt.LeftButton){
                    //threadsTxtInput.deselect()
                    //eValueTxtInput.deselect()
                    resultFmtTxtInput.deselect()
                    //otherCmdTxtInput.deselect()
                    seqInputText.deselect()
                    blastOutputText.deselect()
                    dbNameTxtEdit.deselect()
                    buildDbOutputText.deselect()
                }
            }
        }

        Image {
            id: image2
            x: 0
            y: 0
            width: 1000
            height: 650
            visible: true
            source: "images/bg_1000X650.png"
            fillMode: Image.PreserveAspectFit

            ScrollView {
                id: scrollView2
                x: 777
                y: 406
                width: 200
                height: 200
            }
        }

        Image {
            id: image
            x: 463
            y: 8
            width: 75
            height: 33
            visible: true
            source: "images/hometext.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: rectangle1
            x: 126
            y: 45
            width: 739
            height: 224
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            ScrollView {
                id: scrollView
                x: 4
                y: 4
                width: 731
                height: 216
                opacity: 1
                clip: false
                //color: "#000000"

                //contentItem: Rectangle {color: "#000000"}
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ScrollBar.vertical.position: 0
                TextArea {
                    id: blastOutputText
                    x: -7
                    y: -3
                    width: 730
                    height: 214
                    visible: true
                    wrapMode: Text.Wrap
                    placeholderTextColor: "#ffffff"
                    clip: true
                    color: "#ffffff"
                    text: ""
                    font.pointSize: 10
                    placeholderText: qsTr("")
                    selectByMouse: true
                    selectionColor: "#ffffff"
                    //persistentSelection: true
                    background: Rectangle {color: "black"}

                }
                //ScrollBar.vertical.position: ScrollBar.setPosition(100)
            }
        }

        Button {
            id: selectFileBtn
            x: 62
            y: 365
            width: 67
            height: 21
            visible: false
            text: qsTr("Select File")
            background: Rectangle {
                width: 73
                height: 18
                color: "#000000"
                radius: 0
            }
            layer.effect: DropShadow {
                width: 69
                color: "#FFFFFF"
                radius: 8
                verticalOffset: 2
                transparentBorder: true
                horizontalOffset: 2
                spread: 0
                samples: 17
            }
            palette.buttonText: "#FFFFFF"
            layer.enabled: true

            onClicked: {
                //Select a file
                //var num = 3;
                mainController.selectAFile2()
            }
        }

        Button {
            id: helpBtn
            x: 888
            y: 186
            width: 100
            height: 35
            visible: false
            text: qsTr("Help")
            palette.buttonText: "#ffffff"
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                horizontalOffset: 2
                transparentBorder: true
                spread: 0
                verticalOffset: 2
                samples: 17
            }
            layer.enabled: true

            onClicked: {
                if(blastOutputText.getText(0,1) === ""){
                    mainController.getMainInstructions()
                }
            }
        }

        ComboBox {
            id: dbSelectDropDown
            x: 210
            y: 419
            width: 485
            height: 21
            visible: true
            editable: false
            //model: ["         ", " DB One", " DB Two", " DB Three"]
            model: ListModel{
                id: model
                ListElement {text: ""}
            }
            onAccepted: {
                if (find(editText) === -1)
                    model.append({text: editText})
            }

            delegate: ItemDelegate {
                width: dbSelectDropDown.width
                contentItem: Text {
                    text: dbSelectDropDown.textRole
                          ? (Array.isArray(dbSelectDropDown.model) ? modelData[dbSelectDropDown.textRole] : model[dbSelectDropDown.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: dbSelectDropDown.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: dbSelectDropDown.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas
                x: dbSelectDropDown.width - width - dbSelectDropDown.rightPadding
                y: dbSelectDropDown.topPadding + (dbSelectDropDown.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: dbSelectDropDown
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = dbSelectDropDown.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: dbSelectDropDown.indicator.width + dbSelectDropDown.spacing

                text: dbSelectDropDown.displayText
                font: dbSelectDropDown.font
                color: dbSelectDropDown.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: dbSelectDropDown.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: dbSelectDropDown.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: dbSelectDropDown.height - 1
                width: dbSelectDropDown.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: dbSelectDropDown.popup.visible ? dbSelectDropDown.delegateModel : null
                    currentIndex: dbSelectDropDown.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }

        ComboBox {
            id: selectMethodDropDown
            x: 126
            y: 18
            width: 150
            height: 21
            editable: false
            visible: true
            model: [" Select Method", " BLASTn", " BLASTp", " BLASTx", " tBLASTn", " tBLASTx"]

            delegate: ItemDelegate {
                width: selectMethodDropDown.width
                contentItem: Text {
                    text: selectMethodDropDown.textRole
                          ? (Array.isArray(selectMethodDropDown.model) ? modelData[selectMethodDropDown.textRole] : model[selectMethodDropDown.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: selectMethodDropDown.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: selectMethodDropDown.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas2
                x: selectMethodDropDown.width - width - selectMethodDropDown.rightPadding
                y: selectMethodDropDown.topPadding + (selectMethodDropDown.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: selectMethodDropDown
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = selectMethodDropDown.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: selectMethodDropDown.indicator.width + selectMethodDropDown.spacing

                text: selectMethodDropDown.displayText
                font: selectMethodDropDown.font
                color: selectMethodDropDown.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: selectMethodDropDown.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: selectMethodDropDown.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: selectMethodDropDown.height - 1
                width: selectMethodDropDown.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: selectMethodDropDown.popup.visible ? selectMethodDropDown.delegateModel : null
                    currentIndex: selectMethodDropDown.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }

        Label {
            id: label2
            x: 906
            y: 372
            width: 60
            height: 14
            visible: false
            color: "#ffffff"
            text: qsTr("Threads")
        }

        Label {
            id: label3
            x: 907
            y: 438
            width: 60
            height: 16
            visible: false
            color: "#ffffff"
            text: qsTr("E-Value")
        }

        Label {
            id: label4
            x: 906
            y: 502
            width: 96
            height: 14
            visible: false
            color: "#ffffff"
            text: qsTr("Output Format")
        }

        Rectangle {
            id: rectangle5
            x: 896
            y: 522
            width: 96
            height: 21
            color: "#000000"
            visible: false
            border.color: "#ffffff"

            TextEdit {
                id: resultFmtTxtInput
                x: 3
                y: 1
                width: 91
                height: 18
                color: "#ffffff"
                text: qsTr("")
                visible: false
                selectedTextColor: "#000000"
                selectionColor: "#ffffff"
                font.pixelSize: 15
                clip: true
                cursorVisible: false
                selectByMouse: true
                //persistentSelection: true
            }

        }

        Label {
            id: label5
            x: 898
            y: 566
            width: 77
            height: 14
            visible: false
            color: "#ffffff"
            text: qsTr("Other cmd")
        }

        Label {
            id: label1
            x: 128
            y: 1
            width: 106
            height: 19
            visible: false
            color: "#ffffff"
            text: qsTr("Select  Method")
        }

        Label {
            id: threadStateLabel
            x: 782
            y: 22
            width: 155
            height: 19
            color: "#ffffff"
            text: qsTr("")
            visible: true
            font.pointSize: 11
        }

        Label {
            id: label8
            x: 126
            y: 275
            width: 358
            height: 17
            color: "#ffffff"
            text: qsTr("Enter accession numbers(s), gi(s), FASTA sequences(s) or select a file")
            visible: true
        }

        Button {
            id: addDbBtn
            x: 886
            y: 234
            width: 100
            height: 35
            visible: false
            text: qsTr("Add Database")
            palette.buttonText: "#ffffff"
            background: Rectangle {
                color: "#000000"
                radius: 50
            }
            layer.effect: DropShadow {
                width: 69
                color: "#ffffff"
                radius: 8
                horizontalOffset: 2
                transparentBorder: true
                verticalOffset: 2
                spread: 0
                samples: 17
            }
            layer.enabled: true

            onClicked: {
                mainWindow.visible = false
                buildDatabaseWin.visible = true
            }
        }

        Label {
            id: label9
            x: 747
            y: 275
            width: 81
            height: 17
            color: "#ffffff"
            text: qsTr("Query Subrange")
            visible: true
        }

        Rectangle {
            id: rectangle8
            x: 735
            y: 292
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: fSubrangeTxt
                x: 3
                y: 1
                width: 127
                height: 18
                color: "#ffffff"
                text: qsTr("")
                clip: true
                selectByMouse: true
                selectionColor: "#ffffff"
                selectedTextColor: "#000000"
                font.pixelSize: 12
                cursorVisible: false
            }
            visible: true
        }

        Rectangle {
            id: rectangle9
            x: 735
            y: 338
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: tSubrangeTxt
                x: 3
                y: 1
                width: 127
                height: 18
                color: "#ffffff"
                text: qsTr("")
                clip: true
                selectByMouse: true
                selectionColor: "#ffffff"
                selectedTextColor: "#000000"
                font.pixelSize: 14
                cursorVisible: false
            }
            visible: true
        }

        Label {
            id: label10
            x: 701
            y: 300
            width: 28
            height: 19
            color: "#ffffff"
            text: qsTr("From")
            visible: true
        }

        Label {
            id: label11
            x: 714
            y: 340
            width: 15
            height: 19
            color: "#ffffff"
            text: qsTr("To")
            visible: true
        }

        Rectangle {
            id: selectedFileRect
            x: 210
            y: 365
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: selectedFileText
                x: 2
                y: 2
                width: 481
                height: 17
                color: "#ffffff"
                text: qsTr("")
                clip: true
                selectByMouse: true
                selectionColor: "#ffffff"
                selectedTextColor: "#000000"
                font.pixelSize: 11
            }
            visible: true
        }

        Rectangle {
            id: jobTitleRect
            x: 210
            y: 392
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: jobTitleText
                x: 2
                y: 2
                width: 481
                height: 17
                color: "#ffffff"
                text: qsTr("")
                selectByMouse: true
                clip: true
                selectionColor: "#ffffff"
                selectedTextColor: "#000000"
                cursorVisible: false
                font.pixelSize: 11
            }
            visible: true
        }

        Label {
            id: label12
            x: 161
            y: 394
            width: 43
            height: 17
            color: "#ffffff"
            text: qsTr("Job Title")
            visible: true
        }

        Rectangle {
            id: seqInputRect
            x: 126
            y: 292
            width: 569
            height: 67
            color: "#000000"
            border.color: "#ffffff"
            ScrollView {
                id: seqInputScrollView
                x: 2
                y: 2
                width: 565
                height: 63
                opacity: 0
                clip: false
                ScrollBar.vertical.position: 0
                TextArea {
                    id: seqInputText
                    x: -9
                    y: -6
                    width: 562
                    height: 63
                    color: "#ffffff"
                    text: ""
                    font.pointSize: 10
                    clip: true
                    selectByMouse: true
                    placeholderText: qsTr("")
                    selectionColor: "#ffffff"
                    wrapMode: Text.Wrap
                    visible: true
                }
            }
            visible: true
        }

        Rectangle {
            id: jobTitleRect1
            x: 210
            y: 460
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: jobTitleText1
                x: 2
                y: 2
                width: 481
                height: 17
                color: "#ffffff"
                text: qsTr("")
                selectionColor: "#ffffff"
                cursorVisible: false
                clip: true
                font.pixelSize: 11
                selectedTextColor: "#000000"
                selectByMouse: true
            }
            visible: true
        }

        Label {
            id: label13
            x: 159
            y: 457
            width: 47
            height: 15
            color: "#ffffff"
            text: qsTr("Organism")
            visible: true
        }

        Label {
            id: label14
            x: 158
            y: 421
            width: 47
            height: 17
            color: "#ffffff"
            text: qsTr("Database")
            visible: true
        }

        CheckBox {
            id: checkBox
            x: 204
            y: 487
            width: 114
            height: 23
            text: qsTr("Models (XM/XP)")
            checkState: Qt.Unchecked
            checked: false

            indicator: Rectangle {
                implicitWidth: 18
                implicitHeight: 18
                x: checkBox.leftPadding
                y: parent.height / 2 - height / 2
                width: 18
                height: 18
                radius: 3
                border.color: "#000000"

                Rectangle {
                    width: 12
                    height: 12
                    color: "#000000"
                    x: 3
                    y: 3
                    radius: 2
                    border.color: "#ffffff"
                    visible: checkBox.checked
                }
            }

            contentItem: Text {
                color: "#ffffff"
                text: checkBox.text
                font: checkBox.font
                opacity: enabled ? 1.0 : 0.3
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkBox.indicator.width + checkBox.spacing
            }
        }

        CheckBox {
            id: checkBox1
            x: 335
            y: 487
            width: 217
            height: 23
            text: qsTr("Non-redundant RefSeq proteins (WP)")
            contentItem: Text {
                color: "#ffffff"
                text: checkBox1.text
                font: checkBox1.font
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkBox1.indicator.width + checkBox1.spacing
                opacity: enabled ? 1.0 : 0.3
            }
            indicator: Rectangle {
                x: checkBox1.leftPadding
                y: parent.height / 2 - height / 2
                width: 18
                height: 18
                radius: 3
                implicitWidth: 18
                border.color: "#000000"
                Rectangle {
                    x: 3
                    y: 3
                    width: 12
                    height: 12
                    color: "#000000"
                    radius: 2
                    border.color: "#ffffff"
                    visible: checkBox1.checked
                }
                implicitHeight: 18
            }
            checked: false
            checkState: Qt.Unchecked
        }

        CheckBox {
            id: checkBox2
            x: 568
            y: 487
            width: 260
            height: 23
            text: qsTr("Uncultured/environmental sample sequences")
            contentItem: Text {
                color: "#ffffff"
                text: checkBox2.text
                font: checkBox2.font
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkBox2.indicator.width + checkBox2.spacing
                opacity: enabled ? 1.0 : 0.3
            }
            indicator: Rectangle {
                x: checkBox2.leftPadding
                y: parent.height / 2 - height / 2
                width: 18
                height: 18
                radius: 3
                border.color: "#000000"
                implicitWidth: 18
                Rectangle {
                    x: 3
                    y: 3
                    width: 12
                    height: 12
                    color: "#000000"
                    radius: 2
                    border.color: "#ffffff"
                    visible: checkBox2.checked
                }
                implicitHeight: 18
            }
            checked: false
            checkState: Qt.Unchecked
        }

        Label {
            id: excludeLabel
            x: 168
            y: 487
            width: 38
            height: 14
            color: "#ffffff"
            text: qsTr("Exclude")
            visible: true
        }

        CheckBox {
            id: checkBox3
            x: 701
            y: 459
            width: 79
            height: 23
            text: qsTr("Exclude")
            contentItem: Text {
                color: "#ffffff"
                text: checkBox3.text
                font: checkBox3.font
                verticalAlignment: Text.AlignVCenter
                leftPadding: checkBox3.indicator.width + checkBox3.spacing
                opacity: enabled ? 1.0 : 0.3
            }
            indicator: Rectangle {
                x: checkBox3.leftPadding
                y: parent.height / 2 - height / 2
                width: 18
                height: 18
                radius: 3
                implicitWidth: 18
                border.color: "#000000"
                Rectangle {
                    x: 3
                    y: 3
                    width: 12
                    height: 12
                    color: "#000000"
                    radius: 2
                    border.color: "#ffffff"
                    visible: checkBox3.checked
                }
                implicitHeight: 18
            }
            checked: false
            checkState: Qt.Unchecked
        }

        Label {
            id: label16
            x: 210
            y: 446
            width: 449
            height: 14
            color: "#ffffff"
            text: qsTr("Enter organism common name, binomial, or tax id. Only 20 top taxa will be shown")
            font.bold: false
            font.pointSize: 8
            visible: true
        }
        ComboBox {
            id: selectAlgorithm
            x: 210
            y: 516
            width: 485
            height: 21
            editable: false
            visible: true
            model: [" Select Algorithm", " Quick BLASTP (Accelerated protein-protein BLAST)", " blastp (protein-protein BLAST)", " PSI-BLAST (Position-Specific Iterated BLAST)", " PHI-BLAST (Pattern Hit Initiated BLAST)", " DELTA-BLAST (Domain Enhanced Lookup Time Accelerated BLAST)"]

            delegate: ItemDelegate {
                width: selectAlgorithm.width
                contentItem: Text {
                    text: selectAlgorithm.textRole
                          ? (Array.isArray(selectAlgorithm.model) ? modelData[selectAlgorithm.textRole] : model[selectAlgorithm.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: selectAlgorithm.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: selectAlgorithm.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvasselectAlgorithm
                x: selectAlgorithm.width - width - selectAlgorithm.rightPadding
                y: selectAlgorithm.topPadding + (selectAlgorithm.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: selectAlgorithm
                    function onPressedChanged() { canvasselectAlgorithm.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = selectAlgorithm.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: selectAlgorithm.indicator.width + selectAlgorithm.spacing

                text: selectAlgorithm.displayText
                font: selectAlgorithm.font
                color: selectAlgorithm.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: selectAlgorithm.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: selectAlgorithm.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: selectAlgorithm.height - 1
                width: selectAlgorithm.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: selectAlgorithm.popup.visible ? selectAlgorithm.delegateModel : null
                    currentIndex: selectAlgorithm.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }

        ComboBox {
            id: selectOutputFormat
            x: 210
            y: 545
            width: 485
            height: 21
            editable: false
            visible: true
            model: [" Select Output Format", " pairwise", " query-anchored showing identities",
                " query-anchored no identities", " flat query-anchored, show identities",
                " flat query-anchored, no identities", " XML Blast output", " tabular",
                " tabular with comment lines", " Text ASN.1", " Binary ASN.1",
                " Comma-separated values", " BLAST archive format (ASN.1) "]

            delegate: ItemDelegate {
                width: selectOutputFormat.width
                contentItem: Text {
                    text: selectOutputFormat.textRole
                          ? (Array.isArray(selectOutputFormat.model) ? modelData[selectOutputFormat.textRole] : model[selectOutputFormat.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: selectOutputFormat.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: selectOutputFormat.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvasselectOutputFormat
                x: selectOutputFormat.width - width - selectOutputFormat.rightPadding
                y: selectOutputFormat.topPadding + (selectOutputFormat.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: selectOutputFormat
                    function onPressedChanged() { canvasselectAlgorithm.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = selectOutputFormat.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: selectOutputFormat.indicator.width + selectOutputFormat.spacing

                text: selectOutputFormat.displayText
                font: selectOutputFormat.font
                color: selectOutputFormat.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: selectOutputFormat.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: selectOutputFormat.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: selectOutputFormat.height - 1
                width: selectOutputFormat.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: selectOutputFormat.popup.visible ? selectOutputFormat.delegateModel : null
                    currentIndex: selectOutputFormat.highlightedIndex

                    ScrollIndicator.vertical: ScrollIndicator { }
                }

                //This will change the color of the drop down Rectangle
                background: Rectangle {
                    border.color: "#FFFFFF"
                    color: "#FFFFFF"
                    radius: 5
                }
            }
        }

        Label {
            id: optionalLabel
            x: 170
            y: 500
            width: 34
            height: 13
            color: "#ffffff"
            text: qsTr("Optional")
            font.pointSize: 7
            visible: true
        }

        Label {
            id: optionalLabel1
            x: 166
            y: 471
            width: 34
            height: 13
            color: "#ffffff"
            text: qsTr("Optional")
            font.pointSize: 7
            visible: true
        }

        Image {
            id: selectFileImgBtn
            x: 126
            y: 366
            width: 70
            height: 20
            fillMode: Image.PreserveAspectFit
            source: "images/sfBtn.png"

            MouseArea {
                id: selectFileMouseArea
                width: 70
                height: 20
                hoverEnabled: true
                onClicked: {
                    //Select a file
                    //var num = 3;
                    mainController.selectAFile2()

                }
                onEntered: {
                    selectFileImgBtn.width = 75
                    selectFileImgBtn.height = 25
                }
                onExited: {
                    selectFileImgBtn.width = 70
                    selectFileImgBtn.height = 20
                }

                onPressed: {
                    selectFileImgBtn.width = 70
                    selectFileImgBtn.height = 20
                }
                onReleased: {
                    selectFileImgBtn.width = 75
                    selectFileImgBtn.height = 25
                }
            }
        }
        Image {
            id: startImgBtn
            x: 210
            y: 576
            width: 70
            height: 20
            fillMode: Image.PreserveAspectFit
            source: "images/startBtn.png"

            MouseArea {
                id: startBtnMouseArea
                y: 0
                width: 70
                height: 20
                hoverEnabled: true

                onClicked: {
                    if(selectMethodDropDown.currentText.trim() === "BLASTp"){
                        mainController.startBlastP(dbSelectDropDown.currentText,
                                                   resultFmtTxtInput.getText(0, resultFmtTxtInput.length),
                                                   seqInputText.getText(0, seqInputText.length),
                                                   jobTitleText.getText(0, jobTitleText.length),
                                                   fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                                   tSubrangeTxt.getText(0,tSubrangeTxt.length))
                    }
                    else if(selectMethodDropDown.currentText.trim() === "BLASTn"){
                        mainController.startBlastN(dbSelectDropDown.currentText,
                                                   resultFmtTxtInput.getText(0, resultFmtTxtInput.length),
                                                   seqInputText.getText(0, seqInputText.length),
                                                   jobTitleText.getText(0, jobTitleText.length),
                                                   fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                                   tSubrangeTxt.getText(0,tSubrangeTxt.length))
                    }
                    else if(selectMethodDropDown.currentText.trim() === "BLASTx"){
                        mainController.startBlastX(dbSelectDropDown.currentText,
                                                   resultFmtTxtInput.getText(0, resultFmtTxtInput.length),
                                                   seqInputText.getText(0, seqInputText.length),
                                                   jobTitleText.getText(0, jobTitleText.length),
                                                   fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                                   tSubrangeTxt.getText(0,tSubrangeTxt.length))
                    }
                    else if(selectMethodDropDown.currentText.trim() === "tBLASTn"){
                        mainController.startTBlastN()
                    }
                    else if(selectMethodDropDown.currentText.trim() === "tBLASTx"){
                        mainController.startTBlastX()
                    }
                }
                onEntered: {
                    startImgBtn.width = 75
                    startImgBtn.height = 25
                }
                onExited: {
                    startImgBtn.width = 70
                    startImgBtn.height = 20
                }

                onPressed: {
                    startImgBtn.width = 70
                    startImgBtn.height = 20
                }
                onReleased: {
                    startImgBtn.width = 75
                    startImgBtn.height = 25
                }
            }
        }
    }

    //Get paths when the program starts
    //Check for saved databases and populate the combobox. This is Triggered by the getMyDocuments function
    Component.onCompleted: {
        mainController.getMyDocumentsPath()
    }


    Rectangle {
        id: sidePanel
        width: 65
        height: 650
        color: "#99000000"
        visible: false
        border.color: "#000000"

        Image {
            id: homeBtnImg
            x: 13
            y: 18
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            source: "images/homeBtnImg.png"

            MouseArea {
                id: homeBtnMouseArea
                width: 40
                height: 40
                hoverEnabled: true
                onEntered: {
                    homeBtnImg.width = 45
                    homeBtnImg.height = 45
                }
                onExited: {
                    homeBtnImg.width = 40
                    homeBtnImg.height = 40
                }
                onClicked: {
                        buildDatabaseWin.visible = false
                        dataViewerWin.visible = false
                        mainWindow.visible = true
                }
            }
        }

        Image {
            id: dbBtnImg
            x: 13
            y: 83
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            source: "images/dbBtnImg.png"

            MouseArea {
                id: mouseArea1
                width: 40
                height: 40
                hoverEnabled: true
                onEntered: {
                    dbBtnImg.width = 45
                    dbBtnImg.height = 45
                }
                onExited: {
                    dbBtnImg.width = 40
                    dbBtnImg.height = 40
                }
                onClicked: {
                        mainWindow.visible = false
                        dataViewerWin.visible = false
                        buildDatabaseWin.visible = true
                }
            }
        }
        Image {
            id: globalsearchBtn
            x: 13
            y: 213
            width: 40
            height: 40
            source: "images/blobalImgBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseArea2
                width: 40
                height: 40
                hoverEnabled: true

                onEntered: {
                    globalsearchBtn.width = 45
                    globalsearchBtn.height = 45
                }
                onExited: {
                    globalsearchBtn.width = 40
                    globalsearchBtn.height = 40
                }
            }
        }

        Image {
            id: globalsearchBtn1
            x: 13
            y: 280
            width: 40
            height: 40
            source: "images/toolsBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseArea3
                width: 40
                height: 40
                hoverEnabled: true

                onEntered: {
                    globalsearchBtn1.width = 45
                    globalsearchBtn1.height = 45
                }
                onExited: {
                    globalsearchBtn1.width = 40
                    globalsearchBtn1.height = 40
                }
            }
        }

        Image {
            id: sidePanelHelpBtn
            x: 13
            y: 347
            width: 40
            height: 40
            source: "images/helpBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseAreaHelpBtn
                width: 40
                height: 40
                hoverEnabled: true

                onEntered: {
                    sidePanelHelpBtn.width = 45
                    sidePanelHelpBtn.height = 45
                }
                onExited: {
                    sidePanelHelpBtn.width = 40
                    sidePanelHelpBtn.height = 40
                }
            }
        }

        Image {
            id: hideMenuImg
            x: 13
            y: 610
            width: 40
            height: 30
            fillMode: Image.PreserveAspectFit
            source: "images/GmenuClose.png"

            MouseArea {
                id: hideMenuMouseArea
                x: 0
                y: 0
                width: 38
                height: 30
                onClicked: {
                    dotsImg.visible = true
                    sidePanel.visible = false
                }
            }
        }

        Image {
            id: dataViewerBtn
            x: 13
            y: 148
            width: 40
            height: 40
            source: "images/dataViewerBtn.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                id: logViewerBtnMouseArea
                width: 40
                height: 40
                hoverEnabled: true
                onExited: {
                            dataViewerBtn.width = 40
                            dataViewerBtn.height = 40
                        }
                onEntered: {
                            dataViewerBtn.width = 45
                            dataViewerBtn.height = 45
                        }
                onClicked: {
                    mainWindow.visible = false
                    buildDatabaseWin.visible = false
                    dataViewerWin.visible = true
                }
            }
        }
    }

    Image {
        id: image4
        x: 905
        y: 594
        width: 95
        height: 56
        source: "images/logo_w_dna.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: dotsImg
        x: 13
        y: 626
        width: 40
        height: 21
        visible: true
        fillMode: Image.PreserveAspectFit
        source: "images/GopenMenuDots.png"

        MouseArea {
            id: dotsMouseArea
            width: 40
            height: 21
            onClicked: {
                dotsImg.visible = false
                sidePanel.visible = true
            }
        }
    }


}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
