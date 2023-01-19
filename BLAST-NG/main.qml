import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtMultimedia 5.15
import QtQuick.Layouts 1.12

Window {
    width: 1000
    height: 650

    maximumHeight: 650
    maximumWidth: 1000
    visible: true
    title: qsTr("BLAST-NG")

    //Main Controller Connections
    Connections {
        target: mainController

        onSelectedFileDataToQml:{
            blastOutputText.text = _fileContents
            //Make the log data text in the terminal window auto scroll
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
        onSeqFileNameToQml:{
            selectedFileText.text = _seqFileName
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
        }

        Rectangle {
            id: rectangle
            x: 240
            y: 65
            width: 575
            height: 292
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: scrollView1
                x: 3
                y: 3
                width: 572
                height: 289

                TextArea {
                    id: buildDbOutputText
                    x: -10
                    y: -6
                    width: 572
                    height: 287
                    color: "#ffffff"
                    text: ""
                    wrapMode: Text.Wrap
                    clip: true
                    placeholderText: qsTr("")
                    visible: true
                    selectByMouse: true
                    selectionColor: "#ffffff"
                    //persistentSelection: true
                }
                clip: false
                ScrollBar.vertical.position: 0
            }
        }

        Button {
            id: backBtn
            x: 14
            y: 15
            width: 91
            height: 36
            text: qsTr("Back")
            palette.buttonText: "#ffffff"
            layer.enabled: true
            visible: true
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

        ComboBox {
            id: controlDb
            x: 452
            y: 412
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
            visible: true
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
            id: rectangle7
            x: 647
            y: 412
            width: 168
            height: 21
            color: "#000000"

            TextEdit {
                id: dbNameTxtEdit
                x: 2
                y: 2
                width: 165
                height: 19
                color: "#ffffff"
                text: qsTr("")
                selectedTextColor: "#000000"
                selectionColor: "#ffffff"
                cursorVisible: false
                clip: true
                font.pixelSize: 15
                selectByMouse:  true
                //persistentSelection: true
            }
            border.color: "#ffffff"
        }

        Label {
            id: label6
            x: 647
            y: 384
            width: 168
            height: 22
            color: "#ffffff"
            text: qsTr("Database Name")
            font.pointSize: 11
        }

        Label {
            id: label7
            x: 452
            y: 384
            width: 152
            height: 22
            color: "#ffffff"
            text: qsTr("Select Database Type")
            font.pointSize: 12
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
            visible: true
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
            id: image1
            x: 442
            y: 21
            width: 172
            height: 25
            source: "images/add_db_text.png"
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
            visible: true
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
                    threadsTxtInput.deselect()
                    eValueTxtInput.deselect()
                    resultFmtTxtInput.deselect()
                    otherCmdTxtInput.deselect()
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
            source: "images/bg_1000X650.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image
            x: 450
            y: 8
            width: 156
            height: 25
            visible: true
            source: "images/logo.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: rectangle1
            x: 126
            y: 45
            width: 739
            height: 301
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            ScrollView {
                id: scrollView
                x: 3
                y: 3
                width: 736
                height: 295
                clip: false
                ScrollBar.vertical.policy: ScrollBar.AsNeeded
                ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

                ScrollBar.vertical.position: 0
                TextArea {
                    id: blastOutputText
                    visible: true
                    wrapMode: Text.Wrap
                    clip: true
                    color: "#FFFFFF"
                    text: ""
                    font.pointSize: 10
                    placeholderText: qsTr("")
                    selectByMouse: true
                    selectionColor: "#ffffff"
                    //persistentSelection: true
                }
                //ScrollBar.vertical.position: ScrollBar.setPosition(100)
            }
        }

        Button {
            id: startBtn
            x: 403
            y: 550
            width: 100
            height: 35
            visible: true
            text: qsTr("Start")

            background: Rectangle {
                color: "#000000"
                radius: 50
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
                //video.play()
                //video1.play()
                if(selectMethodDropDown.currentText.trim() === "BLASTp"){
                    mainController.startBlastP(dbSelectDropDown.currentText,
                                               resultFmtTxtInput.getText(0, resultFmtTxtInput.length),
                                               eValueTxtInput.getText(0, eValueTxtInput.length),
                                               threadsTxtInput.getText(0, threadsTxtInput.length),
                                               otherCmdTxtInput.getText(0, otherCmdTxtInput.length),
                                               seqInputText.getText(0, seqInputText.length))
                }
                else if(selectMethodDropDown.currentText.trim() === "BLASTn"){
                    mainController.startBlastN()
                }
                else if(selectMethodDropDown.currentText.trim() === "BLASTx"){
                    mainController.startBlastX()
                }
                else if(selectMethodDropDown.currentText.trim() === "tBLASTn"){
                    mainController.startTBlastN()
                }
                else if(selectMethodDropDown.currentText.trim() === "tBLASTx"){
                    mainController.startTBlastX()
                }
            }
        }

        Button {
            id: selectFileBtn
            x: 126
            y: 446
            width: 78
            height: 21
            visible: true
            text: qsTr("Select File")
            background: Rectangle {
                color: "#000000"
                radius: 50
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
            x: 595
            y: 550
            width: 100
            height: 35
            visible: true
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
            x: 209
            y: 517
            width: 116
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
            id: label
            x: 209
            y: 502
            width: 113
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Select Database")
        }

        Label {
            id: label2
            x: 345
            y: 502
            width: 60
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Threads")
        }

        Rectangle {
            id: rectangle3
            x: 345
            y: 517
            width: 62
            height: 21
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            TextEdit {
                id: threadsTxtInput
                x: 3
                y: 1
                width: 57
                height: 18
                color: "#ffffff"
                text: qsTr("")
                selectedTextColor: "#000000"
                selectionColor: "#ffffff"
                readOnly: false
                font.pixelSize: 15
                clip: true
                cursorVisible: false
                selectByMouse: true

            }
        }

        Label {
            id: label3
            x: 431
            y: 502
            width: 60
            height: 16
            visible: true
            color: "#ffffff"
            text: qsTr("E-Value")
        }

        Rectangle {
            id: rectangle4
            x: 431
            y: 517
            width: 62
            height: 21
            visible: true
            color: "#000000"
            border.color: "#ffffff"

            TextEdit {
                id: eValueTxtInput
                x: 3
                y: 1
                width: 57
                height: 18
                color: "#ffffff"
                text: qsTr("")
                selectionColor: "#ffffff"
                selectedTextColor: "#000000"
                font.pixelSize: 15
                clip: true
                cursorVisible: false
                selectByMouse: true
            }
        }

        Label {
            id: label4
            x: 509
            y: 502
            width: 96
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Output Format")
        }

        Rectangle {
            id: rectangle5
            x: 509
            y: 517
            width: 96
            height: 21
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            TextEdit {
                id: resultFmtTxtInput
                x: 3
                y: 1
                width: 91
                height: 18
                color: "#ffffff"
                text: qsTr("")
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
            x: 618
            y: 502
            width: 77
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Other cmd")
        }

        Rectangle {
            id: rectangle6
            x: 618
            y: 517
            width: 77
            height: 21
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            TextEdit {
                id: otherCmdTxtInput
                x: 3
                y: 1
                width: 74
                height: 18
                color: "#ffffff"
                text: qsTr("")
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
            y: 355
            width: 358
            height: 17
            color: "#ffffff"
            text: qsTr("Enter accession numbers(s), gi(s), FASTA sequences(s) or select a file")
            visible: true
        }

        Rectangle {
            id: sidePanel
            width: 70
            height: 600
            color: "#a6000000"
            visible: false
            border.color: "#000000"

            Image {
                id: image4
                x: 8
                y: 95
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                source: "images/dbBtnImg.png"
            }

            Image {
                id: image5
                x: 8
                y: 14
                width: 50
                height: 50
                fillMode: Image.PreserveAspectFit
                source: "images/homeBtnImg.png"
            }
        }

        Button {
            id: addDbBtn
            x: 210
            y: 550
            width: 100
            height: 35
            visible: true
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
            x: 760
            y: 355
            width: 81
            height: 17
            color: "#ffffff"
            text: qsTr("Query Subrange")
            visible: true
        }

        Rectangle {
            id: rectangle8
            x: 735
            y: 373
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: resultFmtTxtInput1
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
            x: 736
            y: 419
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: resultFmtTxtInput2
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
            x: 703
            y: 375
            width: 28
            height: 19
            color: "#ffffff"
            text: qsTr("From")
            visible: true
        }

        Label {
            id: label11
            x: 716
            y: 421
            width: 15
            height: 19
            color: "#ffffff"
            text: qsTr("To")
            visible: true
        }

        Rectangle {
            id: selectedFileRect
            x: 210
            y: 447
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
                font.pixelSize: 12
            }
            visible: true
        }

        Rectangle {
            id: jobTitleRect
            x: 210
            y: 475
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
                font.pixelSize: 12
            }
            visible: true
        }

        Label {
            id: label12
            x: 157
            y: 479
            width: 47
            height: 17
            color: "#ffffff"
            text: qsTr("Job Title")
            visible: true
        }

        Rectangle {
            id: seqInputRect
            x: 126
            y: 373
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
    }
    //Get paths when the program starts
    //Check for saved databases and populate the combobox. This is Triggered by the getMyDocuments function
    Component.onCompleted: {
        mainController.getMyDocumentsPath()
    }
}





/*##^##
Designer {
    D{i:0;formeditorZoom:0.75}
}
##^##*/
