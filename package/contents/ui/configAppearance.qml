import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property alias cfg_displayMode: displayModeCombo.currentIndex
    property alias cfg_displayOrder: displayOrderCombo.currentIndex
    property alias cfg_hebrewFormat: hebrewFormatCombo.currentIndex
    property alias cfg_hebrewSizeRatio: hebrewSizeSlider.value
    property alias cfg_gregorianFormat: gregorianFormatField.text
    property alias cfg_showHebrewYear: showHebrewYearCheck.checked
    property alias cfg_showGregorianYear: showGregorianYearCheck.checked
    property alias cfg_showGregorianDayOfWeek: showGregorianDayOfWeekCheck.checked
    property alias cfg_showHebrewDayOfWeek: showHebrewDayOfWeekCheck.checked

    // Display Mode Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Display Mode"
    }

    QQC2.ComboBox {
        id: displayModeCombo
        Kirigami.FormData.label: "Show Dates"
        model: [
            "Both dates (default)",
            "Hebrew only",
            "Gregorian only"
        ]
    }

    QQC2.ComboBox {
        id: displayOrderCombo
        Kirigami.FormData.label: "Date Order"
        enabled: displayModeCombo.currentIndex === 0
        model: [
            "Gregorian then Hebrew",
            "Hebrew then Gregorian"
        ]
    }

    // Hebrew Format Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Hebrew Date Format"
    }

    QQC2.ComboBox {
        id: hebrewFormatCombo
        Kirigami.FormData.label: "Format Style"
        model: [
            "26 / Cheshvan / 5786",
            "26 Cheshvan 5786",
            "כ״ו חשוון תשפ״ו (Hebrew)"
        ]
    }

    RowLayout {
        Kirigami.FormData.label: "Hebrew Size"
        QQC2.Slider {
            id: hebrewSizeSlider
            from: 50
            to: 150
            stepSize: 10
            value: 100
            Layout.fillWidth: true
        }
        QQC2.Label {
            text: hebrewSizeSlider.value + "%"
            Layout.minimumWidth: 50
        }
    }

    QQC2.CheckBox {
        id: showHebrewYearCheck
        Kirigami.FormData.label: "Hebrew Options"
        text: "Show Hebrew year"
    }

    QQC2.CheckBox {
        id: showHebrewDayOfWeekCheck
        text: "Show Hebrew day of week (א-ש)"
    }

    QQC2.Label {
        text: "Adds Hebrew letter for day of week (א=Sunday, ב=Monday, etc.)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit * 2
    }

    // Gregorian Format Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Gregorian Date Format"
    }

    QQC2.TextField {
        id: gregorianFormatField
        Kirigami.FormData.label: "Format String"
        placeholderText: "dd MMM yyyy"
    }

    QQC2.Label {
        text: "Format codes: d/dd (day), M/MM/MMM/MMMM (month), yy/yyyy (year), ddd/dddd (day of week)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    QQC2.CheckBox {
        id: showGregorianYearCheck
        Kirigami.FormData.label: "Gregorian Options"
        text: "Show Gregorian year"
    }

    QQC2.CheckBox {
        id: showGregorianDayOfWeekCheck
        text: "Show Gregorian day of week (e.g., Mon)"
    }

    QQC2.Label {
        text: "Adds abbreviated day of week before the Gregorian date (e.g., 'Mon, 16 Nov 2025')"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit * 2
    }
}
