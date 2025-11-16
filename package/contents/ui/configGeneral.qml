import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property alias cfg_displayOrder: displayOrderCombo.currentIndex
    property alias cfg_hebrewFormat: hebrewFormatCombo.currentIndex
    property alias cfg_hebrewSizeRatio: hebrewSizeSlider.value
    property alias cfg_gregorianFormat: gregorianFormatField.text
    property alias cfg_showHebrewYear: showHebrewYearCheck.checked
    property alias cfg_showGregorianYear: showGregorianYearCheck.checked
    property alias cfg_fontBold: fontBoldCheck.checked
    property alias cfg_fontItalic: fontItalicCheck.checked
    property alias cfg_userCity: userCityField.text
    property alias cfg_userLatitude: userLatField.text
    property alias cfg_userLongitude: userLonField.text

    // Display Order Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Display Settings"
    }

    QQC2.ComboBox {
        id: displayOrderCombo
        Kirigami.FormData.label: "Date Order"
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
            "כ״ו חשון תשפ״ו (Hebrew)"
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
        text: "Format codes: d/dd (day), M/MM/MMM/MMMM (month), yy/yyyy (year)"
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
        id: showHebrewYearCheck
        text: "Show Hebrew year"
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

