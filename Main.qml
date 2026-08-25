import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Window {
    id: root
    width: 330
    height: 500
    visible: true
    title: "KawaiiCalc"

    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    Rectangle {
        id: deviceBody
        anchors.fill: parent
        color: "#FDE8EE"          // Pastel pink base
        radius: 30
        border.color: "#E27396"    // Border outline
        border.width: 3

        MouseArea {
            anchors.fill: parent
            property point clickPos: "0,0"

            onPressed: (mouse) => clickPos = Qt.point(mouse.x, mouse.y)
            onPositionChanged: (mouse) => {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                root.x += delta.x
                root.y += delta.y
            }
        }

        RowLayout {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: 12
            anchors.leftMargin: 20
            anchors.rightMargin: 16

            Text {
                text: "✨ KawaiiCalc ✨"
                font.pixelSize: 14
                font.bold: true
                color: "#B05574"
            }

            Item { Layout.fillWidth: true }

            Text {
                text: "✕"
                font.pixelSize: 16
                font.bold: true
                color: "#E27396"

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Qt.quit()
                }
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 38
            anchors.bottomMargin: 16
            anchors.leftMargin: 16
            anchors.rightMargin: 16
            spacing: 12

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 70
                color: "#FFF9FA"
                radius: 12
                border.color: "#EA9AB2"
                border.width: 2

                Text {
                    anchors.fill: parent
                    anchors.margins: 12
                    text: calc.displayText
                    color: "#7A2048"
                    font.pixelSize: 28
                    font.bold: true
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideLeft
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 4
                rowSpacing: 8
                columnSpacing: 8

                Repeater {
                    model: [
                        "C", "(", ")", "/",
                        "7", "8", "9", "*",
                        "4", "5", "6", "-",
                        "1", "2", "3", "+",
                        "⌫", "0", ".", "="
                    ]

                    delegate: Button {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        text: modelData

                        background: Rectangle {
                            color: parent.down ? "#F8BBD0" : (modelData === "=" ? "#EA9AB2" : "#FFFFFF")
                            radius: 10
                            border.color: "#EA9AB2"
                            border.width: 1.5
                        }

                        contentItem: Text {
                            text: parent.text
                            font.pixelSize: 18
                            font.bold: true
                            color: (modelData === "=") ? "#FFFFFF" : ((modelData === "C" || modelData === "⌫") ? "#D81B60" : "#7A2048")
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            if (modelData === "=") {
                                calc.calculate();
                            } else if (modelData === "C") {
                                calc.clear();
                            } else if (modelData === "⌫") {
                                calc.backspace();
                            } else {
                                calc.appendChar(modelData);
                            }
                        }
                    }
                }
            }
        }
    }
}