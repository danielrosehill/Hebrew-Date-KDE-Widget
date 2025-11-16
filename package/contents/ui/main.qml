import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import Qt.labs.settings 1.1

import "../code/Hebcal.js" as Hebcal

PlasmoidItem {
    id: root

    // Configuration bindings
    readonly property string language: plasmoid.configuration.language
    readonly property bool showYear: plasmoid.configuration.showYear

    // State
    property string displayText: "…"
    property string lastError: ""

    readonly property date now: new Date()

    preferredRepresentation: fullRepresentation

    fullRepresentation: Item {
        implicitWidth: Math.max(textItem.implicitWidth + 8, 80)
        implicitHeight: textItem.implicitHeight + 8

        QQC2.Label {
            id: textItem
            anchors.centerIn: parent
            text: root.displayText
            elide: Text.ElideRight
            wrapMode: Text.NoWrap
        }
    }

    Settings {
        id: store
        category: "org.kde.plasma.hebrewdate"
        property string lastText: ""
        property string lastISODate: ""
    }

    function scheduleNextUpdate() {
        // Compute ms until next midnight local time
        const now = new Date()
        const next = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1, 0, 0, 1)
        updateTimer.interval = Math.max(1000, next - now)
        updateTimer.restart()
    }

    function updateHebrewDate() {
        lastError = ""
        displayText = "…"
        const d = new Date()
        const iso = d.getFullYear() + "-" + (d.getMonth()+1).toString().padStart(2, '0') + "-" + d.getDate().toString().padStart(2, '0')
        Hebcal.fetchHebrewDate(d, language, showYear, function (ok, text, err) {
            if (ok) {
                displayText = text
                store.lastText = text
                store.lastISODate = iso
            } else {
                if (store.lastISODate === iso && store.lastText) {
                    displayText = store.lastText
                } else {
                    displayText = "Hebrew date unavailable"
                }
                lastError = err || ""
            }
        })
        scheduleNextUpdate()
    }

    Component.onCompleted: updateHebrewDate()

    Connections {
        target: plasmoid.configuration
        function onLanguageChanged() { root.updateHebrewDate() }
        function onShowYearChanged() { root.updateHebrewDate() }
    }

    Timer {
        id: updateTimer
        interval: 60 * 60 * 1000 // fallback hourly
        repeat: true
        running: false
        onTriggered: root.updateHebrewDate()
    }
}
