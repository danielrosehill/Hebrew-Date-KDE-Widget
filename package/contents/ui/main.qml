import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.kirigami as Kirigami
import Qt.labs.settings 1.1

import "../code/Hebcal.js" as Hebcal

PlasmoidItem {
    id: root

    // Configuration bindings
    readonly property int displayOrder: plasmoid.configuration.displayOrder
    readonly property int hebrewFormat: plasmoid.configuration.hebrewFormat
    readonly property int hebrewSizeRatio: plasmoid.configuration.hebrewSizeRatio
    readonly property string gregorianFormat: plasmoid.configuration.gregorianFormat
    readonly property bool showHebrewYear: plasmoid.configuration.showHebrewYear
    readonly property bool showGregorianYear: plasmoid.configuration.showGregorianYear
    readonly property bool fontBold: plasmoid.configuration.fontBold
    readonly property bool fontItalic: plasmoid.configuration.fontItalic
    readonly property string userCity: plasmoid.configuration.userCity
    readonly property string userLatitude: plasmoid.configuration.userLatitude
    readonly property string userLongitude: plasmoid.configuration.userLongitude

    // State
    property string gregorianText: "…"
    property string hebrewText: "…"
    property string lastError: ""

    preferredRepresentation: compactRepresentation

    compactRepresentation: Item {
        Layout.fillWidth: false
        Layout.fillHeight: true
        Layout.minimumWidth: dateColumn.implicitWidth
        Layout.preferredWidth: dateColumn.implicitWidth
        Layout.maximumWidth: dateColumn.implicitWidth

        ColumnLayout {
            id: dateColumn
            anchors.centerIn: parent
            spacing: 0

            // First line (either Gregorian or Hebrew based on displayOrder)
            QQC2.Label {
                id: firstLine
                Layout.alignment: Qt.AlignHCenter
                text: root.displayOrder === 0 ? root.gregorianText : root.hebrewText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: Kirigami.Theme.smallFont.pixelSize
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
            }

            // Second line (either Hebrew or Gregorian based on displayOrder)
            QQC2.Label {
                id: secondLine
                Layout.alignment: Qt.AlignHCenter
                text: root.displayOrder === 0 ? root.hebrewText : root.gregorianText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = Kirigami.Theme.smallFont.pixelSize
                    return root.displayOrder === 0 ?
                        (baseSize * root.hebrewSizeRatio / 100) :
                        baseSize
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
                opacity: 0.85
            }
        }
    }

    fullRepresentation: Item {
        Layout.preferredWidth: Kirigami.Units.gridUnit * 15
        Layout.preferredHeight: Kirigami.Units.gridUnit * 6

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing

            QQC2.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.displayOrder === 0 ? root.gregorianText : root.hebrewText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
                horizontalAlignment: Text.AlignHCenter
            }

            QQC2.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.displayOrder === 0 ? root.hebrewText : root.gregorianText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = Kirigami.Theme.defaultFont.pixelSize * 1.2
                    return root.displayOrder === 0 ?
                        (baseSize * root.hebrewSizeRatio / 100) :
                        baseSize
                }
                horizontalAlignment: Text.AlignHCenter
                opacity: 0.9
            }
        }
    }

    Settings {
        id: store
        category: "org.kde.plasma.hebrewdate"
        property string lastGregorianText: ""
        property string lastHebrewText: ""
        property string lastISODate: ""
    }

    function scheduleNextUpdate() {
        // Update every minute to catch sunset transition
        // Also schedule a midnight update
        const now = new Date()
        const nextMinute = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
                                     now.getHours(), now.getMinutes() + 1, 1)
        updateTimer.interval = Math.max(1000, nextMinute - now)
        updateTimer.restart()
    }

    function updateDates() {
        lastError = ""
        const d = new Date()
        const iso = d.getFullYear() + "-" + (d.getMonth()+1).toString().padStart(2, '0') + "-" + d.getDate().toString().padStart(2, '0')

        // Update Gregorian date
        updateGregorianDate(d)

        // Fetch Hebrew date from API
        Hebcal.fetchDualDate(
            d,
            userLatitude,
            userLongitude,
            hebrewFormat,
            showHebrewYear,
            function (ok, data, hebrewStr, err) {
                if (ok) {
                    hebrewText = hebrewStr
                    store.lastHebrewText = hebrewStr
                    store.lastISODate = iso
                } else {
                    if (store.lastISODate === iso && store.lastHebrewText) {
                        hebrewText = store.lastHebrewText
                    } else {
                        hebrewText = "Hebrew date unavailable"
                    }
                    lastError = err || ""
                }
            }
        )

        scheduleNextUpdate()
    }

    function updateGregorianDate(d) {
        // Format the Gregorian date according to user preference
        var format = gregorianFormat || "dddd dd MMMM yyyy"

        // Handle showGregorianYear setting
        if (!showGregorianYear) {
            // Remove year patterns from format
            format = format.replace(/yyyy/g, "").replace(/yy/g, "").trim()
            // Clean up any trailing/leading separators
            format = format.replace(/[\s,\/-]+$/, "").replace(/^[\s,\/-]+/, "")
        }

        gregorianText = Qt.formatDate(d, format)
        store.lastGregorianText = gregorianText
    }

    Component.onCompleted: updateDates()

    Connections {
        target: plasmoid.configuration
        function onDisplayOrderChanged() { root.updateDates() }
        function onHebrewFormatChanged() { root.updateDates() }
        function onHebrewSizeRatioChanged() { }  // Just triggers UI update
        function onGregorianFormatChanged() { root.updateDates() }
        function onShowHebrewYearChanged() { root.updateDates() }
        function onShowGregorianYearChanged() { root.updateDates() }
        function onUserLatitudeChanged() { root.updateDates() }
        function onUserLongitudeChanged() { root.updateDates() }
    }

    Timer {
        id: updateTimer
        interval: 60 * 1000 // Update every minute
        repeat: true
        running: false
        onTriggered: root.updateDates()
    }
}
