import QtQuick 2.0
import QtQuick.Controls 2.13//ToolBar, RadioButton

ToolBar {
    contentHeight: toolButton.implicitHeight

    ToolButton {
        id: toolButton
        text: "\u25C0" // "\u2630"
        font.pixelSize: Qt.application.font.pixelSize * 1.6
        onClicked: stackView.pop()
    }

    Label {
        text: stackView.currentItem.title
        anchors.centerIn: parent
    }
}
