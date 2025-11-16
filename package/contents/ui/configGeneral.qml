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
    property alias cfg_fontBold: fontBoldCheck.checked
    property alias cfg_fontItalic: fontItalicCheck.checked
    property alias cfg_autoSizeByContext: autoSizeCheck.checked
    property alias cfg_desktopFontSize: desktopFontSizeSpinBox.value
    property alias cfg_panelFontSize: panelFontSizeSpinBox.value
    property alias cfg_userCity: userCityField.text
    property alias cfg_userLatitude: userLatField.text
    property alias cfg_userLongitude: userLonField.text

    // Display Order Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Display Settings"
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
        enabled: displayModeCombo.currentIndex === 0  // Only enabled when showing both
        model: [
            "Gregorian then Hebrew",
            "Hebrew then Gregorian"
        ]
    }

    QQC2.ComboBox {
        id: hebrewFormatCombo
        Kirigami.FormData.label: "Hebrew Format"
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

    // Date Format Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Date Formats"
    }

    QQC2.TextField {
        id: gregorianFormatField
        Kirigami.FormData.label: "Gregorian Format"
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
        Kirigami.FormData.label: "Options"
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

    QQC2.CheckBox {
        id: showHebrewYearCheck
        text: "Show Hebrew year"
    }

    QQC2.CheckBox {
        id: showHebrewDayOfWeekCheck
        text: "Show Hebrew day of week (א-ש)"
    }

    QQC2.Label {
        text: "Adds Hebrew letter for day of week before the Hebrew date (א=Sunday, ב=Monday, etc.)\nOnly shown when Hebrew format is selected"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
        Layout.leftMargin: Kirigami.Units.gridUnit * 2
    }

    // Font Settings
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Font Style"
    }

    QQC2.CheckBox {
        id: fontBoldCheck
        Kirigami.FormData.label: "Style"
        text: "Bold"
    }

    QQC2.CheckBox {
        id: fontItalicCheck
        text: "Italic"
    }

    // Font Size Settings
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Font Size"
    }

    QQC2.CheckBox {
        id: autoSizeCheck
        Kirigami.FormData.label: "Auto-sizing"
        text: "Automatically adjust font size based on widget location"
        checked: true
    }

    QQC2.Label {
        text: "When enabled, the widget uses different font sizes for panel/tray vs desktop placement"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    QQC2.SpinBox {
        id: desktopFontSizeSpinBox
        Kirigami.FormData.label: "Desktop Font Size"
        from: 8
        to: 72
        value: 18
        editable: true
    }

    QQC2.Label {
        text: "Font size when widget is placed on the desktop (larger for readability)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    QQC2.SpinBox {
        id: panelFontSizeSpinBox
        Kirigami.FormData.label: "Panel/Tray Font Size"
        from: 6
        to: 36
        value: 11
        editable: true
    }

    QQC2.Label {
        text: "Font size when widget is in a panel or system tray (smaller to fit compact space)"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }

    // Location Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Location (for sunset calculation)"
    }

    QQC2.TextField {
        id: userCityField
        Kirigami.FormData.label: "City"
        placeholderText: "Jerusalem"
    }

    QQC2.TextField {
        id: userLatField
        Kirigami.FormData.label: "Latitude"
        placeholderText: "31.7683"
    }

    QQC2.TextField {
        id: userLonField
        Kirigami.FormData.label: "Longitude"
        placeholderText: "35.2137"
    }

    QQC2.Label {
        text: "Location is used to determine the correct Hebrew date at sundown"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}

