import QtQuick
import QtQuick.Controls

Window {
    id: root
    width: 320
    height: 480
    visible: true
    title: "KawaiiCalc"

    flags: Qt.FramelessWindowHint | Qt.Window
    color: "transparent"

    Rectangle {
        id: body
        anchors.fill: parent
        color: "#FDE8EE"          // Soft pastel pink
        radius: 28                 // Rounded cute phone corners
        border.color: "#E27396"    // Deep pink outline
        border.width: 3

        MouseArea {
            anchors.fill: parent
            property point clickPos: "0,0"

            onPressed: (mouse) => {
                clickPos = Qt.point(mouse.x, mouse.y)
            }

            onPositionChanged: (mouse) => {
                var delta = Qt.point(mouse.x - clickPos.x, mouse.y - clickPos.y)
                root.x += delta.x
                root.y += delta.y
            }
        }

        Text {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 14
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

        Text {
            anchors.centerIn: parent
            text: "KawaiiCalc"
            font.pixelSize: 22
            font.bold: true
            color: "#7A2048"
        }
    }
}