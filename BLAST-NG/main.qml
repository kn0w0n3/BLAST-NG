import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls
//import QtGraphicalEffects 1.15
import Qt5Compat.GraphicalEffects
//import QtMultimedia 5.15
import QtQuick.Layouts 1.15

Window {

    width: 1280
    height: 720

    maximumWidth: 1280
    maximumHeight: 720

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
            //console.log("Trying to add file names to combo box...")
            modelLogView.append({text: dataFileName})
        }
        onFileViewerData2Qml:{
            dataViewerTxtArea.text += fileData + "/n"
        }
        onSettingsDirPath2Qml:{
            dbSaveLocationTxt.text = updatedCurSavedDbPath
        }
        onUpdateCurSavedDbPath:{
            curSavedDbLocationTxt.text = curDbPath
        }
        onSelectedSaveToPath:{
            selectFileResultsLocationTxt.text = savePath
        }
        onSelectedDbFileToQml:{
            selectDBTxtEdit.text = _dbFilePath
        }
        onSelectedDPathbForIndex:{
            selectDbIndexTxtEdit.text = dbPathForIndex
        }
        onCreateDbIndexStatus:{
            buildDbOutputText.text += responseData
        }
    }

    Rectangle {
        id: settingsWin
        x: 0
        y: 0
        width: 1280
        height: 720
        visible: false
        color: "#ffffff"

        Image {
            id: image1
            x: 0
            y: 0
            width: 1280
            height: 720
            source: "images/bg_1280x720.png"
            fillMode: Image.PreserveAspectFit
        }
        MouseArea {
            x: 310
            y: 518
            width: 77
            height: 24
            visible: false
            onEntered: {
                //dbSelectDirBtn.width = 79
                //dbSelectDirBtn.height = 26
            }
            onExited: {
                //dbSelectDirBtn.width = 77
                //dbSelectDirBtn.height = 24
            }
            onClicked: {
                mainController.settingsSelectDir()
            }
            hoverEnabled: true
        }

        Rectangle {
            id: dirPathRect1
            x: 313
            y: 483
            width: 656
            height: 21
            visible: false
            color: "#000000"
            border.color: "#ffffff"
        }

        Image {
            id: settingsTextImg
            x: 571
            y: 8
            width: 138
            height: 44
            source: "images/settings-text.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: dirPathRect2
            x: 313
            y: 425
            width: 656
            height: 21
            visible: false
            color: "#000000"
            border.color: "#ffffff"
        }

        Image {
            id: saveBtn
            x: 423
            y: 518
            width: 77
            height: 24
            visible: false
            source: "images/saveBtn.png"
            fillMode: Image.PreserveAspectFit
        }
        Label {
            id: label15
            x: 312
            y: 384
            width: 188
            height: 21
            visible: false
            color: "#ffffff"
            text: qsTr("Saved Databases Location:")
            font.bold: true
            font.pointSize: 11
        }

        Label {
            id: label17
            x: 312
            y: 408
            width: 98
            height: 17
            visible: false
            color: "#ffffff"
            text: qsTr("Current location:")
            font.pointSize: 10
        }

        Label {
            id: label18
            x: 313
            y: 465
            width: 116
            height: 20
            visible: false
            color: "#ffffff"
            text: qsTr("Select new location:")
            font.pointSize: 10
        }

        Rectangle {
            id: rectangle3
            x: 310
            y: 70
            width: 659
            height: 300
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: scrollView3
                x: 2
                y: 3
                width: 654
                height: 292

                TextArea {
                    id: settingsTxtArea
                    x: 0
                    y: 0
                    color: "#ffffff"
                    text: ""
                    font.bold: false
                    font.pointSize: 8
                    placeholderText: qsTr("Text Area")
                    background: Rectangle {color: "black"}
                }
            }
        }
        Component.onCompleted: {
            //load the current save location
            //mainController.loadDatabaseSettings()
        }
        Image {
            id: dbSelectDirBtn
            x: 310
            y: 518
            width: 77
            height: 24
            visible: false
            source: "images/selectDirBtn.png"
            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: dbSaveLocationTxt
            x: 316
            y: 486
            width: 650
            height: 17
            visible: false
            color: "#ffffff"
            text: qsTr("")
            font.pointSize: 8
            clip: true
        }

        Label {
            id: curSavedDbLocationTxt
            x: 316
            y: 428
            width: 650
            height: 17
            visible: false
            color: "#777474"
            text: qsTr("")
            font.pointSize: 8
            clip: true
        }

        MouseArea {
            x: 431
            y: 580
            width: 77
            height: 24
            onEntered: {
                saveBtn.width = 79
                saveBtn.height = 26
            }
            onExited: {
                saveBtn.width = 77
                saveBtn.height = 24
            }
            onClicked: {
                var dbText = dbSaveLocationTxt.text
                //console.log("The db save location text is: " + dbText)
                if(dbText === ""){
                    // settingsTxtArea.text += "Select the location of saved databases /n"
                }
                else{
                    //mainController.saveDatabaseSettings(dbText)
                }
            }
            hoverEnabled: true
        }
    }

    Rectangle {
        id: dataViewerWin
        x: 0
        y: 0
        width: 1280
        height: 720
        opacity: 1
        visible: false
        color: "#000000"

        Image {
            id: dataViewerWinBg
            x: 0
            y: 0
            width: 1280
            height: 720
            source: "images/bg_1280x720.png"
            fillMode: Image.PreserveAspectFit

            ComboBox {
                id: controlLogView
                x: 222
                y: 26
                width: 263
                height: 21
                visible: false
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
                    //mainController.populateDataFiles()
                }
                onSelectTextByMouseChanged: {

                }
            }

            Image {
                id: image5
                x: 554
                y: 8
                width: 172
                height: 32
                source: "images/dataviewertext.png"
                fillMode: Image.PreserveAspectFit
            }

            Image {
                id: dvw_OpenBtn
                x: 217
                y: 495
                width: 77
                height: 24
                source: "images/open_file_btn.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    x: 0
                    y: 0
                    width: 77
                    height: 24
                    hoverEnabled: true
                    onExited: {
                        dvw_OpenBtn.width = 77
                        dvw_OpenBtn.height = 24
                    }
                    onClicked: {
                        mainController.selectFileDataViewer()

                    }
                    onEntered: {
                        dvw_OpenBtn.width = 79
                        dvw_OpenBtn.height = 26
                    }
                }
            }

            Image {
                id: dvw_CloseBtn
                x: 602
                y: 495
                width: 77
                height: 24
                source: "images/close_file_btn.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    x: 0
                    y: 0
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
            }

            Image {
                id: dvw_HelpBtn
                x: 986
                y: 495
                width: 77
                height: 24
                source: "images/elpBtn.png"
                fillMode: Image.PreserveAspectFit

                MouseArea {
                    x: 0
                    y: 0
                    width: 77
                    height: 24
                    hoverEnabled: true
                    onExited: {
                        dvw_OpenBtn.width = 77
                        dvw_OpenBtn.height = 24
                    }
                    onClicked: {

                    }
                    onEntered: {
                        dvw_OpenBtn.width = 79
                        dvw_OpenBtn.height = 26
                    }
                }
            }
        }

        Rectangle {
            id: rectangle2
            x: 221
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
        Component.onCompleted: {
            //mainController.populateDataFiles()
        }
    }

    Rectangle {
        id: buildDatabaseWin
        width: 1280
        height: 720
        color: "#000000"
        visible: false

        Image {
            id: image3
            width: 1280
            height: 720
            visible: true
            source: "images/bg_1280x720.png"
            fillMode: Image.PreserveAspectFit

            Label {
                id: label
                x: 352
                y: 440
                width: 51
                height: 12
                color: "#ffffff"
                text: qsTr("Additional")
                font.pointSize: 8
            }

            Label {
                id: label1
                x: 350
                y: 451
                width: 58
                height: 15
                color: "#ffffff"
                text: qsTr("Commands")
                font.pointSize: 8
            }

            Text {
                id: text1
                x: 421
                y: 553
                color: "#ffffff"
                text: qsTr("Build index for megaBLAST")
                font.pixelSize: 12
                font.underline: false
            }
        }

        Rectangle {
            id: rectangle
            x: 338
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


        Rectangle {
            id: dbNameRect
            x: 766
            y: 379
            width: 168
            height: 21
            color: "#000000"
            border.color: "#ffffff"

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
        }

        Label {
            id: label6
            x: 796
            y: 360
            width: 109
            height: 22
            color: "#ffffff"
            text: qsTr("Database Name")
            font.pointSize: 11
        }

        Label {
            id: label7
            x: 607
            y: 360
            width: 144
            height: 22
            color: "#ffffff"
            text: qsTr("Select Database Type")
            font.pointSize: 11
        }

        Image {
            id: buildDbTxt
            x: 549
            y: 17
            width: 183
            height: 33
            source: "images/build_db_text.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: filePathRect
            x: 421
            y: 379
            width: 168
            height: 21
            color: "#000000"
            border.color: "#ffffff"
        }
        Image {
            id: db_selectFileBtn
            x: 338
            y: 378
            width: 77
            height: 24
            source: "images/sfBtn-adb.png"
            fillMode: Image.PreserveAspectFit
        }
        Image {
            id: db_buildDbBtn
            x: 421
            y: 480
            width: 77
            height: 24
            source: "images/buildDBBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: buildDbMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                hoverEnabled: true
                onClicked: {
                    //var curText = dbNameTxtEdit.getText(0,dbNameTxtEdit.length)
                    var dbStoragePath  = dirPathLabel.text
                    var selectedFile = filePathLabel.text
                    var dbName = dbNameTxtEdit.text
                    console.log("1 The db path text is: " + dbStoragePath)
                    //console.log("2 The db name text is: " + curText)

                    if(selectedFile === ""){
                        buildDbOutputText.text = "Select a database file before proceeding"
                    }

                    else if(controlDb.currentText.trim() === ""){
                        buildDbOutputText.text = "Select a database type before proceeding"
                    }
                    else if(dbName === ""){
                        buildDbOutputText.text = "Enter a name for the database. The databse name must not contain spaces."
                    }
                    else if(dbStoragePath === ""){
                        buildDbOutputText.text = "Select a location to store the database before proceeding"
                    }
                    else{
                        if(controlDb.currentText.trim() === "Protein Sequence"){
                            mainController.buildDatabase("prot", dbName, dbStoragePath)

                        }else{
                            mainController.buildDatabase("nucl", dbName, dbStoragePath)
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
        }
        Image {
            id: db_helpBtn
            x: 857
            y: 480
            width: 77
            height: 24
            source: "images/elpBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: helpMouseArea
                x: 0
                y: 0
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
        }

        Rectangle {
            id: dirPathRect
            x: 421
            y: 410
            width: 513
            height: 21
            color: "#000000"
            border.color: "#ffffff"

            Label {
                id: dirPathLabel
                x: 2
                y: 2
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
            x: 338
            y: 410
            width: 77
            height: 24
            visible: true
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
        ComboBox {
            id: controlDb
            x: 602
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

        Label {
            id: filePathLabel
            x: 424
            y: 382
            width: 163
            height: 17
            color: "#ffffff"
            text: qsTr("")
            clip: true
            font.pointSize: 8
        }

        MouseArea {
            id: addDbSelectFileMouseArea
            x: 338
            y: 378
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

        Rectangle {
            id: additionalCommandTRect
            x: 421
            y: 442
            width: 513
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: additionalCommandTxtEdit
                x: 2
                y: 2
                width: 508
                height: 17
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 13
                selectionColor: "#ffffff"
                clip: true
                cursorVisible: false
                selectedTextColor: "#000000"
                selectByMouse: true
            }
        }

        Image {
            id: selectDBtnIndex
            x: 338
            y: 568
            width: 77
            height: 24
            source: "images/select_db.png"
            MouseArea {
                id: selectDbIndexMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                hoverEnabled: true
                onExited: {
                    selectDBtnIndex.width = 77
                    selectDBtnIndex.height = 24
                }
                onReleased: {
                    selectDBtnIndex.width = 80
                    selectDBtnIndex.height = 28
                }
                onEntered: {
                    selectDBtnIndex.width = 80
                    selectDBtnIndex.height = 28
                }
                onPressed: {
                    selectDBtnIndex.width = 77
                    selectDBtnIndex.height = 24
                }
                onClicked: {
                    mainController.selectDbDirForCreateIndex()
                }
            }
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: selectDBIndexRect
            x: 421
            y: 569
            width: 513
            height: 21
            visible: true
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: selectDbIndexTxtEdit
                x: 2
                y: 2
                width: 509
                height: 17
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 11
                clip: true
                selectionColor: "#ffffff"
                selectByMouse: true
                selectedTextColor: "#000000"
            }
        }

        Image {
            id: startBuildIndexBtn
            x: 416
            y: 607
            width: 77
            height: 24
            source: "images/startBtn.png"
            fillMode: Image.PreserveAspectFit
            MouseArea {
                id: buildIndexMouseArea
                x: 0
                y: 0
                width: 77
                height: 24
                onEntered: {
                    startBuildIndexBtn.width = 80
                    startBuildIndexBtn.height = 28
                }
                onReleased: {
                    startBuildIndexBtn.width = 80
                    startBuildIndexBtn.height = 28
                }
                onExited: {
                    startBuildIndexBtn.width = 77
                    startBuildIndexBtn.height = 24
                }
                hoverEnabled: true
                onPressed: {
                    startBuildIndexBtn.width = 77
                    startBuildIndexBtn.height = 24
                }
                onClicked: {

                    if(selectDbIndexTxtEdit.text === ""){
                        buildDbOutputText.text += "Select a databse to build an index before proceeding"
                    }else{
                        buildDbOutputText.clear();
                        mainController.buildDbIndex(selectDbIndexTxtEdit.text)
                    }
                }
            }
        }
    }


    Rectangle {
        id: mainWindow
        x: 0
        y: 0
        width: 1280
        height: 720
        visible: true
        color: "#000000"
        border.color: "#e7d8d8"

        Image {
            id: bg
            x: 0
            y: 0
            width: 1280
            height: 720
            visible: true
            source: "images/bg_1280x720.png"
            fillMode: Image.PreserveAspectFit
        }

        Image {
            id: mainLogoImg
            x: 631
            y: 10
            width: 75
            height: 33
            visible: true
            source: "images/hometext.png"
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: rectangle1
            x: 299
            y: 47
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

        ComboBox {
            id: dbSelectDropDown
            x: 647
            y: 682
            width: 485
            height: 21
            visible: false
            editable: false
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
            x: 299
            y: 22
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
            id: enterAccessionNumLabel
            x: 300
            y: 278
            width: 358
            height: 17
            color: "#ffffff"
            text: qsTr("Enter accession numbers(s), gi(s), FASTA sequences(s) or select a file")
            visible: true
        }


        Rectangle {
            id: rectangle8
            x: 909
            y: 294
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            visible: true
        }

        Rectangle {
            id: rectangle9
            x: 909
            y: 340
            width: 130
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            visible: true
        }

        Label {
            id: label10
            x: 875
            y: 302
            width: 28
            height: 19
            color: "#ffffff"
            text: qsTr("From")
            visible: true
        }

        Label {
            id: label11
            x: 888
            y: 342
            width: 15
            height: 19
            color: "#ffffff"
            text: qsTr("To")
            visible: true
        }



        Label {
            id: label12
            x: 334
            y: 396
            width: 43
            height: 17
            color: "#ffffff"
            text: qsTr("Job Title")
            visible: true
        }

        Rectangle {
            id: seqInputRect
            x: 300
            y: 295
            width: 569
            height: 67
            color: "#000000"
            border.color: "#ffffff"

            ScrollView {
                id: scrollView2
                x: 3
                y: 3
                width: 564
                height: 61

                TextArea {
                    id: seqInputText
                    x: 0
                    y: 0
                    width: 563
                    height: 63
                    color: "#ffffff"
                    text: ""
                    font.pointSize: 9
                    clip: true
                    selectByMouse: true
                    placeholderText: qsTr("")
                    selectionColor: "#ffffff"
                    wrapMode: Text.Wrap
                    visible: true
                    background: Rectangle {color: "black"}

                }
            }
            visible: true
        }


        Label {
            id: organismTxtLabel
            x: 328
            y: 458
            width: 52
            height: 15
            color: "#ffffff"
            text: qsTr("Organism")
            visible: true
        }

        Label {
            id: label14
            x: 647
            y: 659
            width: 47
            height: 17
            color: "#ffffff"
            text: qsTr("Database")
            visible: false
        }

        CheckBox {
            id: checkBox
            x: 375
            y: 490
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
            x: 506
            y: 490
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
            x: 739
            y: 490
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
            x: 338
            y: 488
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
            id: organismCommonNameLabel
            x: 382
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
            x: 381
            y: 519
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
            x: 381
            y: 548
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
            x: 341
            y: 502
            width: 34
            height: 13
            color: "#ffffff"
            text: qsTr("Optional")
            font.pointSize: 7
            visible: true
        }

        Label {
            id: organismOptionalLabel
            x: 337
            y: 472
            width: 34
            height: 13
            color: "#ffffff"
            text: qsTr("Optional")
            font.pointSize: 7
            visible: true
        }

        Image {
            id: selectFileImgBtn
            x: 299
            y: 368
            width: 70
            height: 20
            fillMode: Image.PreserveAspectFit
            source: "images/sfBtn.png"

            MouseArea {
                id: selectFileMouseArea
                x: 0
                y: 0
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

        Rectangle {
            id: selectDirResultsRect
            x: 381
            y: 589
            width: 485
            height: 21
            visible: true
            color: "#000000"
            border.color: "#ffffff"
        }

        Label {
            id: label19
            x: 381
            y: 571
            width: 449
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Select location to store results")
            font.pointSize: 8
            font.bold: false
        }

        Image {
            id: selectDirResultsBtn
            x: 299
            y: 591
            width: 70
            height: 20
            source: "images/selectDirBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                x: 0
                y: 0
                width: 70
                height: 20
                onReleased: {
                    selectDirResultsBtn.width = 75
                    selectDirResultsBtn.height = 25
                }
                hoverEnabled: true
                onPressed: {
                    selectDirResultsBtn.width = 70
                    selectDirResultsBtn.height = 20
                }
                onClicked: {
                    //Select a file
                    //var num = 3;
                    mainController.selectDirSaveData()

                }
                onEntered: {
                    selectDirResultsBtn.width = 75
                    selectDirResultsBtn.height = 25
                }
                onExited: {
                    selectDirResultsBtn.width = 70
                    selectDirResultsBtn.height = 20
                }
            }
        }

        Rectangle {
            id: additionalCommentsRect
            x: 381
            y: 626
            width: 485
            height: 21
            visible: true
            color: "#000000"
            border.color: "#ffffff"
        }

        Label {
            id: label20
            x: 381
            y: 612
            width: 449
            height: 14
            visible: true
            color: "#ffffff"
            text: qsTr("Additional commands")
            font.pointSize: 8
            font.bold: false
        }
        Label {
            id: label9
            x: 921
            y: 277
            width: 81
            height: 17
            color: "#ffffff"
            text: qsTr("Query Subrange")
            visible: true
        }

        TextEdit {
            id: fSubrangeTxt
            x: 912
            y: 295
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

        TextEdit {
            id: tSubrangeTxt
            x: 912
            y: 341
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
        Rectangle {
            id: selectedFileRect
            x: 383
            y: 367
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            visible: true

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
        }
        Rectangle {
            id: jobTitleRect
            x: 383
            y: 394
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            visible: true

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
        }
        Rectangle {
            id: organismRect
            x: 382
            y: 460
            width: 485
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            visible: true

            TextEdit {
                id: organismTxt
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
        }
        Image {
            id: startImgBtn
            x: 379
            y: 662
            width: 70
            height: 20
            fillMode: Image.PreserveAspectFit
            source: "images/startBtn.png"
        }

        MouseArea {
            id: startBtnMouseArea
            x: 379
            y: 662
            width: 70
            height: 20
            hoverEnabled: true

            onClicked: {

                if(selectMethodDropDown.currentText.trim() === "Select Method"){
                    blastOutputText.text += "Select a method before proceeding\n"
                }
                //else if(selectedFileText.text === "" ){
                    //blastOutputText.text += "Select a sequence file before proceeding\n"
                //}
                else if(selectDBTxtEdit.text === ""){
                    blastOutputText.text += "Select a database before proceeding\n"
                }
                else if(selectFileResultsLocationTxt.text === ""){
                    blastOutputText.text += "Select a location to store results before proceeding\n"
                }

                else if(selectMethodDropDown.currentText.trim() === "BLASTp"){
                    mainController.startBlastP(selectDBTxtEdit.text,
                                               selectOutputFormat.currentText,
                                               seqInputText.getText(0, seqInputText.length),
                                               jobTitleText.getText(0, jobTitleText.length),
                                               fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                               tSubrangeTxt.getText(0,tSubrangeTxt.length),
                                               selectFileResultsLocationTxt.text)
                }
                else if(selectMethodDropDown.currentText.trim() === "BLASTn"){
                    mainController.startBlastN(selectDBTxtEdit.text,
                                               selectOutputFormat.currentText,
                                               seqInputText.getText(0, seqInputText.length),
                                               jobTitleText.getText(0, jobTitleText.length),
                                               fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                               tSubrangeTxt.getText(0,tSubrangeTxt.length),
                                               selectFileResultsLocationTxt.text)
                }
                else if(selectMethodDropDown.currentText.trim() === "BLASTx"){
                    mainController.startBlastX(selectDBTxtEdit.text,
                                               selectOutputFormat.currentText,
                                               seqInputText.getText(0, seqInputText.length),
                                               jobTitleText.getText(0, jobTitleText.length),
                                               fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                               tSubrangeTxt.getText(0,tSubrangeTxt.length),
                                               selectFileResultsLocationTxt.text)
                }
                else if(selectMethodDropDown.currentText.trim() === "tBLASTn"){
                    mainController.startTBlastN(selectDBTxtEdit.text,
                                                selectOutputFormat.currentText,
                                                seqInputText.getText(0, seqInputText.length),
                                                jobTitleText.getText(0, jobTitleText.length),
                                                fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                                tSubrangeTxt.getText(0,tSubrangeTxt.length),
                                                selectFileResultsLocationTxt.text)
                }
                else if(selectMethodDropDown.currentText.trim() === "tBLASTx"){
                    mainController.startTBlastX(selectDBTxtEdit.text,
                                                selectOutputFormat.currentText,
                                                seqInputText.getText(0, seqInputText.length),
                                                jobTitleText.getText(0, jobTitleText.length),
                                                fSubrangeTxt.getText(0,fSubrangeTxt.length),
                                                tSubrangeTxt.getText(0,tSubrangeTxt.length),
                                                selectFileResultsLocationTxt.text)
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

        TextEdit {
            id: selectFileResultsLocationTxt
            x: 383
            y: 591
            width: 481
            height: 17
            color: "#ffffff"
            text: qsTr("")
            font.pixelSize: 11
            clip: true
            selectedTextColor: "#000000"
            selectByMouse: true
            selectionColor: "#ffffff"
        }

        TextEdit {
            id: additionalCommandsTxt
            x: 383
            y: 628
            width: 481
            height: 17
            color: "#ffffff"
            text: qsTr("")
            font.pixelSize: 11
            clip: true
            selectedTextColor: "#000000"
            selectByMouse: true
            selectionColor: "#ffffff"
        }

        Image {
            id: selectDBBtn
            x: 301
            y: 424
            width: 70
            height: 20
            source: "images/select_db.png"
            MouseArea {
                id: selectDBMouseArea
                x: 0
                y: 0
                width: 70
                height: 20
                onExited: {
                    selectDBBtn.width = 70
                    selectDBBtn.height = 20
                }
                onPressed: {
                    selectDBBtn.width = 70
                    selectDBBtn.height = 20
                }
                onReleased: {
                    selectDBBtn.width = 75
                    selectDBBtn.height = 25
                }
                onClicked: {
                    //Select a file
                    //var num = 3;
                    mainController.selectDatabaseFile()

                }
                onEntered: {
                    selectDBBtn.width = 75
                    selectDBBtn.height = 25
                }
                hoverEnabled: true
            }
            fillMode: Image.PreserveAspectFit
        }

        Rectangle {
            id: selectDBRect
            x: 383
            y: 421
            width: 485
            height: 21
            visible: true
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: selectDBTxtEdit
                x: 2
                y: 2
                width: 481
                height: 17
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 11
                selectionColor: "#ffffff"
                clip: true
                selectByMouse: true
                selectedTextColor: "#000000"
            }
        }
    }

    //Get paths when the program starts
    //Check for saved databases and populate the combobox. This is Triggered by the getMyDocuments function
    Component.onCompleted: {
        mainController.setDirs()
    }



    Rectangle {
        id: sidePanel
        x: 0
        y: 0
        width: 65
        height: 720
        color: "#99000000"
        visible: true
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
                    settingsWin.visible = false
                    mainWindow.visible = true
                }
            }
        }

        Image {
            id: dbBtnImg
            x: 13
            y: 147
            width: 40
            height: 40
            fillMode: Image.PreserveAspectFit
            source: "images/dbBtnImg.png"

            MouseArea {
                id: mouseArea1
                x: 0
                y: 0
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
                    settingsWin.visible = false
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
            visible: false
            source: "images/blobalImgBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseArea2
                width: 40
                height: 40
                visible: false
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
            id: settingsBtn
            x: 13
            y: 280
            width: 40
            height: 40
            visible: false
            source: "images/toolsBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseAreaSettingsBtn
                width: 40
                height: 40
                visible: false
                hoverEnabled: true

                onEntered: {
                    settingsBtn.width = 45
                    settingsBtn.height = 45
                }
                onExited: {
                    settingsBtn.width = 40
                    settingsBtn.height = 40
                }
                onClicked: {
                    mainWindow.visible = false
                    dataViewerWin.visible = false
                    buildDatabaseWin.visible = false
                    settingsWin.visible = true
                }
            }
        }

        Image {
            id: sidePanelHelpBtn
            x: 13
            y: 347
            width: 40
            height: 40
            visible: false
            source: "images/helpBtn.png"
            fillMode: Image.PreserveAspectFit

            MouseArea {
                id: mouseAreaHelpBtn
                width: 40
                height: 40
                visible: false
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
            y: 672
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
                    dotsMouseArea.visible = true
                    hideMenuImg.visible = false
                    hideMenuMouseArea.visible = false
                    sidePanel.visible = false
                }
            }
        }

        Image {
            id: dataViewerBtn
            x: 13
            y: 83
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
                    settingsWin.visible = false
                    dataViewerWin.visible = true
                }
            }
        }
    }


    Image {
        id: image4
        x: 1185
        y: 664
        width: 95
        height: 56
        visible: true
        source: "images/logo_w_dna.png"
        fillMode: Image.PreserveAspectFit
    }


    Image {
        id: dotsImg
        x: 13
        y: 689
        width: 40
        height: 21
        visible: false
        fillMode: Image.PreserveAspectFit
        source: "images/GopenMenuDots.png"

        MouseArea {
            id: dotsMouseArea
            width: 40
            height: 21
            visible: false
            onClicked: {
                dotsImg.visible = false
                dotsMouseArea.visible = false
                hideMenuImg.visible = true
                hideMenuMouseArea.visible = true
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
