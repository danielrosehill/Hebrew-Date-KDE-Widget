import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: root

    property alias cfg_userCity: userCityField.text
    property alias cfg_userLatitude: userLatField.text
    property alias cfg_userLongitude: userLonField.text

    // Location Section
    Item {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Location for Sunset Calculation"
    }

    QQC2.Label {
        text: "The Hebrew calendar day begins at sundown (shkiah). Enter your location to ensure accurate Hebrew date transitions."
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
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
        text: "You can find your coordinates at: latlong.net"
        font.pointSize: Kirigami.Theme.smallFont.pointSize
        opacity: 0.7
        wrapMode: Text.WordWrap
        Layout.fillWidth: true
    }
}
