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
    readonly property int displayMode: plasmoid.configuration.displayMode
    readonly property int displayOrder: plasmoid.configuration.displayOrder
    readonly property int hebrewFormat: plasmoid.configuration.hebrewFormat
    readonly property int hebrewSizeRatio: plasmoid.configuration.hebrewSizeRatio
    readonly property string gregorianFormat: plasmoid.configuration.gregorianFormat
    readonly property bool showHebrewYear: plasmoid.configuration.showHebrewYear
    readonly property bool showGregorianYear: plasmoid.configuration.showGregorianYear
    readonly property bool showGregorianDayOfWeek: plasmoid.configuration.showGregorianDayOfWeek
    readonly property bool showHebrewDayOfWeek: plasmoid.configuration.showHebrewDayOfWeek
    readonly property bool fontBold: plasmoid.configuration.fontBold
    readonly property bool fontItalic: plasmoid.configuration.fontItalic
    readonly property string userCity: plasmoid.configuration.userCity
    readonly property string userLatitude: plasmoid.configuration.userLatitude
    readonly property string userLongitude: plasmoid.configuration.userLongitude
    readonly property bool autoSizeByContext: plasmoid.configuration.autoSizeByContext
    readonly property int desktopFontSize: plasmoid.configuration.desktopFontSize
    readonly property int panelFontSize: plasmoid.configuration.panelFontSize

    // State
    property string gregorianText: "…"
    property string hebrewText: "…"
    property string lastError: ""

    // Context detection - determine if widget is in panel/tray or on desktop
    readonly property bool isInPanel: {
        return plasmoid.location === PlasmaCore.Types.TopEdge ||
               plasmoid.location === PlasmaCore.Types.BottomEdge ||
               plasmoid.location === PlasmaCore.Types.LeftEdge ||
               plasmoid.location === PlasmaCore.Types.RightEdge
    }

    // Adaptive base font size based on context
    readonly property int adaptiveBaseFontSize: {
        if (!autoSizeByContext) {
            // If auto-sizing disabled, use desktop size as default
            return desktopFontSize
        }
        return isInPanel ? panelFontSize : desktopFontSize
    }

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
                visible: root.displayMode === 0 ||
                        (root.displayMode === 1 && root.displayOrder === 1) ||  // Hebrew only & Hebrew first
                        (root.displayMode === 2 && root.displayOrder === 0)     // Gregorian only & Gregorian first
                text: {
                    if (root.displayMode === 1) return root.hebrewText         // Hebrew only
                    if (root.displayMode === 2) return root.gregorianText      // Gregorian only
                    return root.displayOrder === 0 ? root.gregorianText : root.hebrewText  // Both
                }
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = root.adaptiveBaseFontSize
                    // If showing Hebrew only or Hebrew first in "both" mode
                    if (root.displayMode === 1 || (root.displayMode === 0 && root.displayOrder === 1)) {
                        return baseSize * root.hebrewSizeRatio / 100
                    }
                    return baseSize
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.NoWrap
            }

            // Second line (either Hebrew or Gregorian based on displayOrder)
            QQC2.Label {
                id: secondLine
                Layout.alignment: Qt.AlignHCenter
                visible: root.displayMode === 0  // Only show when displaying both dates
                text: root.displayOrder === 0 ? root.hebrewText : root.gregorianText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = root.adaptiveBaseFontSize
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
                visible: root.displayMode === 0 ||
                        (root.displayMode === 1 && root.displayOrder === 1) ||
                        (root.displayMode === 2 && root.displayOrder === 0)
                text: {
                    if (root.displayMode === 1) return root.hebrewText
                    if (root.displayMode === 2) return root.gregorianText
                    return root.displayOrder === 0 ? root.gregorianText : root.hebrewText
                }
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = root.adaptiveBaseFontSize
                    if (root.displayMode === 1 || (root.displayMode === 0 && root.displayOrder === 1)) {
                        return baseSize * root.hebrewSizeRatio / 100
                    }
                    return baseSize
                }
                horizontalAlignment: Text.AlignHCenter
            }

            QQC2.Label {
                Layout.alignment: Qt.AlignHCenter
                visible: root.displayMode === 0  // Only show when displaying both dates
                text: root.displayOrder === 0 ? root.hebrewText : root.gregorianText
                font.bold: root.fontBold
                font.italic: root.fontItalic
                font.pixelSize: {
                    var baseSize = root.adaptiveBaseFontSize
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
        property string todaySunsetTime: ""  // Store today's sunset time (HH:MM)
        property string sunsetCacheDate: ""  // Date for which sunset is cached
    }

    function scheduleNextUpdate() {
        const now = new Date()
        const currentDate = now.toISOString().split('T')[0]

        // Calculate next strategic update time
        var nextUpdateTime

        // If we have today's sunset time cached
        if (store.sunsetCacheDate === currentDate && store.todaySunsetTime) {
            const sunsetParts = store.todaySunsetTime.split(':')
            const sunsetHour = parseInt(sunsetParts[0])
            const sunsetMinute = parseInt(sunsetParts[1])

            // Create sunset time for today
            const sunsetTime = new Date(now.getFullYear(), now.getMonth(), now.getDate(),
                                       sunsetHour, sunsetMinute, 0)

            // Check if we're before sunset
            if (now < sunsetTime) {
                // Schedule update 30 seconds after sunset
                nextUpdateTime = new Date(sunsetTime.getTime() + 30000)
            } else {
                // We're after sunset, next update at midnight
                nextUpdateTime = new Date(now.getFullYear(), now.getMonth(), now.getDate() + 1,
                                         0, 0, 30)  // 30 seconds after midnight
            }
        } else {
            // No cached sunset time, check again in 4 hours
            nextUpdateTime = new Date(now.getTime() + 4 * 60 * 60 * 1000)
        }

        const msUntilUpdate = Math.max(1000, nextUpdateTime - now)
        updateTimer.interval = msUntilUpdate
        updateTimer.restart()

        // Debug info
        console.log("Hebrew Date Widget: Next update in", Math.round(msUntilUpdate / 1000 / 60), "minutes")
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
            showHebrewDayOfWeek,
            function (ok, data, hebrewStr, err) {
                if (ok) {
                    hebrewText = hebrewStr
                    store.lastHebrewText = hebrewStr
                    store.lastISODate = iso

                    // Cache sunset time for smart polling
                    if (data.sunsetTime) {
                        store.todaySunsetTime = data.sunsetTime
                        store.sunsetCacheDate = iso
                        console.log("Hebrew Date Widget: Cached sunset time:", data.sunsetTime, "for", iso)
                    }
                } else {
                    if (store.lastISODate === iso && store.lastHebrewText) {
                        hebrewText = store.lastHebrewText
                    } else {
                        hebrewText = "Hebrew date unavailable"
                    }
                    lastError = err || ""
                }

                // Schedule next update after API response
                scheduleNextUpdate()
            }
        )
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

        var formattedDate = Qt.formatDate(d, format)

        // Add day-of-week abbreviation if requested
        if (showGregorianDayOfWeek) {
            var dayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
            var dayAbbrev = dayNames[d.getDay()]
            formattedDate = dayAbbrev + ", " + formattedDate
        }

        gregorianText = formattedDate
        store.lastGregorianText = gregorianText
    }

    Component.onCompleted: updateDates()

    Connections {
        target: plasmoid.configuration
        function onDisplayModeChanged() { }  // Just triggers UI update
        function onDisplayOrderChanged() { root.updateDates() }
        function onHebrewFormatChanged() { root.updateDates() }
        function onHebrewSizeRatioChanged() { }  // Just triggers UI update
        function onGregorianFormatChanged() { root.updateDates() }
        function onShowHebrewYearChanged() { root.updateDates() }
        function onShowGregorianYearChanged() { root.updateDates() }
        function onShowGregorianDayOfWeekChanged() { root.updateDates() }
        function onShowHebrewDayOfWeekChanged() { root.updateDates() }
        function onUserLatitudeChanged() {
            // Clear cached sunset time on location change
            store.todaySunsetTime = ""
            store.sunsetCacheDate = ""
            root.updateDates()
        }
        function onUserLongitudeChanged() {
            // Clear cached sunset time on location change
            store.todaySunsetTime = ""
            store.sunsetCacheDate = ""
            root.updateDates()
        }
    }

    Timer {
        id: updateTimer
        interval: 60 * 1000 // Default interval, adjusted dynamically by scheduleNextUpdate()
        repeat: false  // One-shot timer, rescheduled after each update
        running: false
        onTriggered: root.updateDates()
    }
}
