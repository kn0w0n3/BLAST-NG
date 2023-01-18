import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtGraphicalEffects 1.12
import QtMultimedia 5.15
import QtQuick.Layouts 1.12

Window {
    width: 1055
    height: 600
    maximumHeight: 600
    maximumWidth: 1055
    visible: true
    title: qsTr("BLAST-NG")

    //Main Controller Connections
    Connections {
        target: mainController

        onSelectedFileDataToQml:{
            blastOutputText.text = _fileContents
            //blastOutputText.getText(0,blastOutputText.length) +
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
    }

    Rectangle {
        id: buildDatabaseWin
        width: 1055
        height: 600
        color: "#000000"
        visible: false

        MouseArea {
            id: buildDbWinMouseArea
            width: 1055
            height: 600
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
            width: 1061
            height: 605
            source: "images/bg_9.png"
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
        width: 1055
        height: 600
        visible: true
        color: "#000000"
        border.color: "#000000"

        MouseArea {
            id: mainWinMouseArea
            x: 0
            y: 1
            width: 1055
            height: 600
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
                    seqTxtInput.deselect()
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
            width: 1060
            height: 605
            source: "images/bg_9.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: image
            x: 455
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
            width: 811
            height: 301
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            ScrollView {
                id: scrollView
                x: 3
                y: 3
                width: 805
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
                    placeholderText: qsTr("")
                    selectByMouse: true
                    selectionColor: "#ffffff"
                    //persistentSelection: true
                }
                //ScrollBar.vertical.position: ScrollBar.setPosition(100)
            }
        }

        Rectangle {
            id: rectangle2
            x: 127
            y: 433
            width: 812
            height: 23
            color: "#000000"
            visible: true
            border.color: "#ffffff"


            TextEdit {
                id: seqTxtInput
                x: 3
                y: 1
                width: 807
                height: 19
                color: "#ffffff"
                text: qsTr("")
                selectedTextColor: "#000000"
                selectionColor: "#ffffff"
                font.pixelSize: 15
                clip: true
                selectByMouse: true
                //persistentSelection: true
            }
        }

        Button {
            id: startBtn
            x: 570
            y: 482
            width: 125
            height: 40
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
                                               seqTxtInput.getText(0, otherCmdTxtInput.length))
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
            x: 335
            y: 482
            width: 125
            height: 40
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
            id: addDbBtn
            x: 125
            y: 482
            width: 125
            height: 40
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

        Button {
            id: helpBtn
            x: 812
            y: 482
            width: 125
            height: 40
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
            x: 125
            y: 378
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
            x: 260
            y: 378
            width: 150
            height: 21
            editable: false
            visible: true
            model: ["               ", " BLASTn", " BLASTp", " BLASTx", " tBLASTn", " tBLASTx"]

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
            x: 126
            y: 361
            width: 113
            height: 18
            visible: true
            color: "#ffffff"
            text: qsTr("Select Database")
        }

        Label {
            id: label2
            x: 433
            y: 361
            width: 60
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("Threads")
        }

        Rectangle {
            id: rectangle3
            x: 433
            y: 378
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
            x: 515
            y: 361
            width: 60
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("E-Value")
        }

        Rectangle {
            id: rectangle4
            x: 514
            y: 378
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
            x: 599
            y: 361
            width: 96
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("Output Format")
        }

        Rectangle {
            id: rectangle5
            x: 597
            y: 378
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
            x: 717
            y: 361
            width: 77
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("Other cmd")
        }

        Rectangle {
            id: rectangle6
            x: 715
            y: 378
            width: 222
            height: 21
            color: "#000000"
            visible: true
            border.color: "#ffffff"

            TextEdit {
                id: otherCmdTxtInput
                x: 3
                y: 1
                width: 217
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
            x: 262
            y: 361
            width: 106
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("Select  Method")
        }

        Label {
            id: threadStateLabel
            x: 126
            y: 20
            width: 155
            height: 19
            color: "#ffffff"
            text: qsTr("")
            visible: true
            font.pointSize: 11

        }

        Label {
            id: label8
            x: 127
            y: 415
            width: 142
            height: 19
            color: "#ffffff"
            text: qsTr("Enter sequence or select file")
            visible: true
        }
    }
    //Get paths when the program starts
    Component.onCompleted: {
       mainController.getMyDocumentsPath()
        //Check for saved databases and populate the combobox
     }
}


