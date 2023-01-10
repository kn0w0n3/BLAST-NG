import QtQuick 2.12
import QtQuick.Window 2.12

import QtQuick.Controls 2.12
//import QtQuick.Controls.Material 2.12
//import QtQuick.Controls.Styles 1.4
//import QtQml.Models 2.12
import QtGraphicalEffects 1.12


Window {
    width: 1055
    height: 600
    visible: true
    title: qsTr("BLAST-NG")

    //Main Controller Connections
    Connections {
        target: mainController

        onSelectedFileDataToQml:{
            fileContentsText.text += _fileContents + "\n"
            //fileContentsText.text = _fileContents

            //Make the log data text in the terminal window auto scroll

           //scrollView.ScrollBar.vertical.position = 1.0 - scrollView.ScrollBar.vertical.size
        }
        onThreadStateToQml:{
                threadStateLabel.text = _threadState
        }
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: 1055
        height: 600
        visible: true
        color: "#000000"
        border.color: "#000000"


        Image {
            id: image
            x: 455
            y: 8
            width: 156
            height: 25
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
                    id: fileContentsText
                    visible: true
                    wrapMode: Text.Wrap
                    clip: true
                    color: "#FFFFFF"
                    placeholderText: qsTr("")

                }
                //ScrollBar.vertical.position: ScrollBar.setPosition(100)
            }
        }


        Rectangle {
            id: rectangle2
            x: 126
            y: 410
            width: 811
            height: 23
            color: "#000000"
            border.color: "#ffffff"

            TextEdit {
                id: textEdit4
                x: 2
                y: 2
                width: 807
                height: 18
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 15
                clip: true
            }
        }


        Button {
            id: button
            x: 125
            y: 454
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
        }

        Button {
            id: button1
            x: 352
            y: 454
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
                mainController.selectAFile()
            }
        }

        Button {
            id: button2
            x: 591
            y: 454
            width: 125
            height: 40
            visible: true
            text: qsTr("Build Database")
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
        }

        Button {
            id: button3
            x: 812
            y: 454
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
        }

        ComboBox {
            id: control
            x: 125
            y: 378
            width: 116
            height: 21
            visible: true
            model: ["         ", " DB One", " DB Two", " DB Three"]

            delegate: ItemDelegate {
                width: control.width
                contentItem: Text {
                    text: control.textRole
                          ? (Array.isArray(control.model) ? modelData[control.textRole] : model[control.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: control.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: control.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas
                x: control.width - width - control.rightPadding
                y: control.topPadding + (control.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: control.indicator.width + control.spacing

                text: control.displayText
                font: control.font
                color: control.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: control.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: control.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: control.height - 1
                width: control.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: control.popup.visible ? control.delegateModel : null
                    currentIndex: control.highlightedIndex

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
            id: control2
            x: 260
            y: 378
            width: 150
            height: 21
            visible: true
            model: ["               ", " BLASTn", " BLASTp", " BLASTx", " tBLASTn", " tBLASTx"]

            delegate: ItemDelegate {
                width: control2.width
                contentItem: Text {
                    text: control2.textRole
                          ? (Array.isArray(control2.model) ? modelData[control2.textRole] : model[control2.textRole])
                          : modelData
                    color: "#000000" //Change the text color of the model data in the drop down box.
                    font: control2.font
                    elide: Text.ElideRight
                    verticalAlignment: Text.AlignVCenter
                }
                highlighted: control2.highlightedIndex === index
            }

            indicator: Canvas {
                id: canvas2
                x: control2.width - width - control2.rightPadding
                y: control2.topPadding + (control2.availableHeight - height) / 2
                width: 12
                height: 8
                contextType: "2d"

                Connections {
                    target: control2
                    function onPressedChanged() { canvas.requestPaint(); }
                }

                //This will change the color of the triangle indicator.
                onPaint: {
                    context.reset();
                    context.moveTo(0, 0);
                    context.lineTo(width, 0);
                    context.lineTo(width / 2, height);
                    context.closePath();
                    context.fillStyle = control2.pressed ? "#FFFFFF" : "#FFFFFF";
                    context.fill();
                }
            }
            //The second color is the main color. The first item is what color the changes to once clicked.
            //This will change the text color of main text in the box.
            contentItem: Text {
                leftPadding: 0
                rightPadding: control2.indicator.width + control2.spacing

                text: control2.displayText
                font: control2.font
                color: control2.pressed ? "#FFFFFF" : "#FFFFFF"
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            //This will change the main box background color, border color,  and the border color when pressed.
            //The second color is the main color. The first item is what color the changes to once clicked.
            background: Rectangle {
                implicitWidth: 120
                implicitHeight: 40
                color: "#000000"
                border.color: control2.pressed ? "#FFFFFF" : "#FFFFFF"
                border.width: control2.visualFocus ? 2 : 1
                radius: 2
            }

            popup: Popup {
                y: control2.height - 1
                width: control2.width
                implicitHeight: contentItem.implicitHeight
                padding: 1

                contentItem: ListView {
                    clip: true
                    implicitHeight: contentHeight
                    model: control2.popup.visible ? control2.delegateModel : null
                    currentIndex: control2.highlightedIndex

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
            x: 125
            y: 356
            width: 113
            height: 22
            visible: true
            color: "#ffffff"
            text: qsTr("Select Database")
        }

        Label {
            id: label2
            x: 433
            y: 356
            width: 60
            height: 22
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
            border.color: "#ffffff"

            TextEdit {
                id: textEdit
                x: 2
                y: 2
                width: 58
                height: 18
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 15
                clip: true
                cursorVisible: false
            }
        }

        Label {
            id: label3
            x: 515
            y: 356
            width: 60
            height: 22
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
                id: textEdit1
                x: 2
                y: 2
                width: 58
                height: 18
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 15
                clip: true
                cursorVisible: false
            }
        }

        Label {
            id: label4
            x: 596
            y: 356
            width: 96
            height: 19
            visible: true
            color: "#ffffff"
            text: qsTr("Result Format")
        }

        Rectangle {
            id: rectangle5
            x: 597
            y: 378
            width: 96
            height: 21
            color: "#000000"
            border.color: "#ffffff"
            TextEdit {
                id: textEdit2
                x: 2
                y: 2
                width: 92
                height: 18
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 15
                clip: true
                cursorVisible: false
            }
        }

        Label {
            id: label5
            x: 715
            y: 356
            width: 77
            height: 22
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
            border.color: "#ffffff"
            TextEdit {
                id: textEdit3
                x: 2
                y: 2
                width: 218
                height: 18
                color: "#ffffff"
                text: qsTr("")
                font.pixelSize: 15
                clip: true
                cursorVisible: false
            }
        }

        Label {
            id: label1
            x: 260
            y: 356
            width: 106
            height: 22
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
            font.pointSize: 11
        }
    }
}

/*##^##
Designer {
    D{i:0;formeditorZoom:0.8999999761581421}
}
##^##*/
