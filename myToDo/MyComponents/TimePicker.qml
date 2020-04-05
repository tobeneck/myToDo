import QtQuick 2.14
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1

Item {

    RowLayout {             // centre time label
        anchors.centerIn: parent
        Text {
            id: h
            font.pixelSize: 30
            font.bold: true
            text: outer.currentItem.text
        }
        Text {
            id: div
            font.pixelSize: 30
            font.bold: true
            text: qsTr(":")
        }
        Text {
            id: m
            font.pixelSize: 30
            font.bold: true
            text: inner.currentItem.text
        }

        MouseArea {
            anchors.fill: parent
            onClicked: outer.choiceActive = inner.choiceActive = !outer.choiceActive
        }
    }


    PathView {          // hours path
        id: outer
        property bool pressed: false
        model: 12

        interactive: false
        highlightRangeMode:  PathView.NoHighlightRange
        property bool choiceActive: false

        highlight: Rectangle {
            id: rect
            width: 30 * 1.5
            height: width
            radius: width / 2
            border.color: "darkgray"
            color: "steelblue"
            visible: outer.choiceActive
        }

        delegate: Item {
            id: del
            width: 30
            height: 30
            property bool currentItem: PathView.view.currentIndex == index
            property alias text : textHou.text
            Text {
                id: textHou
                anchors.centerIn: parent
                font.pixelSize: 24
                font.bold: currentItem
                text: index + 1
                color: currentItem ? "black" : "gray"
            }

            MouseArea {
                anchors.fill: parent
                enabled: outer.choiceActive
                onClicked: outer.choiceActive = false
                hoverEnabled: true
                onEntered: outer.currentIndex = index
            }
        }

        path: Path {
            startX: 200; startY: 40
            PathArc {
                x: 80; y: 240
                radiusX: 110; radiusY: 110
                useLargeArc: false
            }
            PathArc {
                x: 200; y: 40
                radiusX: 110; radiusY: 110
                useLargeArc: false
            }
        }
    }

    PathView {          // minutes path
        id: inner
        anchors.centerIn: parent
        property bool pressed: false
        model: 6
        interactive: false
        highlightRangeMode:  PathView.NoHighlightRange
        property bool choiceActive: false

        highlight: Rectangle {
            width: 30 * 1.5
            height: width
            radius: width / 2
            border.color: "darkgray"
            color: "lightgreen"
            visible: inner.choiceActive
        }

        delegate: Item {
            width: 30
            height: 30
            property bool currentItem: PathView.view.currentIndex == index
            property alias text : textMin.text
            Text {
                id: textMin
                anchors.centerIn: parent
                font.pixelSize: 24
                font.bold: currentItem
                text: index * 10
                color: currentItem ? "black" : "gray"
            }

            MouseArea {
                anchors.fill: parent
                enabled: inner.choiceActive
                onClicked: inner.choiceActive = false
                hoverEnabled: true
                onEntered: inner.currentIndex = index
            }
        }

        path: Path {
            startX: 140; startY: 60
            PathArc {
                x: 140; y: 220
                radiusX: 40; radiusY: 40
                useLargeArc: false
            }
            PathArc {
                x: 140; y: 60
                radiusX: 40; radiusY: 40
                useLargeArc: false
            }
        }
    }

    // to set current time!
    onVisibleChanged: {
        var d = new Date();
        outer.currentIndex = d.getUTCHours() % 12
        inner.currentIndex = d.getMinutes() / 10
    }
}
