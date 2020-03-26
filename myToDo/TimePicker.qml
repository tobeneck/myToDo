import QtQuick 2.12
import QtQuick.Window 2.2
import QtQuick.Controls 2.12

Frame {
        id: frame
        padding: 0

        Row {
            id: row

            Tumbler {
                id: hoursTumbler
                model: 24
                delegate: delegateComponent
            }

            Tumbler {
                id: minutesTumbler
                model: 60
                delegate: delegateComponent
            }
        }
}
