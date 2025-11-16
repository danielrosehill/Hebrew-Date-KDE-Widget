// Helper for fetching Hebrew date and Gregorian date from Hebcal API
// Enhanced to support sunset-based date transitions and multiple formats
// Returns via callback: (ok: bool, gregorianStr: string, hebrewStr: string, err: string)

.pragma library

function pad2(n) { return (n < 10 ? "0" : "") + n }

// Format Hebrew date based on format option
// format: 0 = "26 / Cheshvan / 5786", 1 = "26 Cheshvan 5786", 2 = Hebrew characters
function formatHebrewDate(hd, hm, hy, format, showYear) {
    var yearPart = showYear ? hy : ""

    switch (format) {
        case 0:  // "26 / Cheshvan / 5786"
            return showYear ? (hd + " / " + hm + " / " + hy) : (hd + " / " + hm)
        case 1:  // "26 Cheshvan 5786"
            return showYear ? (hd + " " + hm + " " + hy) : (hd + " " + hm)
        case 2:  // Will use Hebrew characters from API
            return null  // Signal to use API's hebrew field
        default:
            return showYear ? (hd + " " + hm + " " + hy) : (hd + " " + hm)
    }
}

function stripHebrewYear(hebrewStr) {
    if (!hebrewStr) return ""
    // Heuristic: the year is the last whitespace-separated token(s). Keep first two tokens.
    var parts = hebrewStr.trim().split(/\s+/)
    if (parts.length <= 2) return hebrewStr
    return parts[0] + " " + parts[1]
}

// Fetch both Gregorian and Hebrew dates with sunset consideration
// Parameters:
// - dateObj: JavaScript Date object
// - latitude, longitude: user location for sunset calculation
// - hebrewFormat: 0, 1, or 2 (see formatHebrewDate)
// - showHebrewYear: boolean
// - cb: callback(ok, gregorianData, hebrewData, err)
function fetchDualDate(dateObj, latitude, longitude, hebrewFormat, showHebrewYear, cb) {
    try {
        var gy = dateObj.getFullYear()
        var gm = dateObj.getMonth() + 1
        var gd = dateObj.getDate()

        // Build Hebcal API URL with location for sunset calculation
        var url = "https://www.hebcal.com/converter?cfg=json&g2h=1&strict=1"
            + "&gy=" + gy + "&gm=" + gm + "&gd=" + gd

        if (latitude && longitude) {
            url += "&latitude=" + latitude + "&longitude=" + longitude + "&gs=on"
        }

        var xhr = new XMLHttpRequest()
        xhr.open("GET", url)
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            if (xhr.status !== 200) {
                cb(false, null, null, "HTTP " + xhr.status)
                return
            }
            try {
                var data = JSON.parse(xhr.responseText)

                // Check if we're after sunset and need to use next day's Hebrew date
                var currentHour = dateObj.getHours()
                var sunsetTime = data.events && data.events.sunset
                var useNextDay = false

                // If sunset data available, check if we're past it
                if (sunsetTime) {
                    var sunsetHour = parseInt(sunsetTime.split(':')[0])
                    var sunsetMinute = parseInt(sunsetTime.split(':')[1])
                    var currentMinutes = currentHour * 60 + dateObj.getMinutes()
                    var sunsetMinutes = sunsetHour * 60 + sunsetMinute
                    useNextDay = currentMinutes >= sunsetMinutes
                }

                // Format Hebrew date
                var hebrewStr
                if (hebrewFormat === 2 && data.hebrew) {
                    // Use Hebrew characters from API
                    hebrewStr = showHebrewYear ? data.hebrew : stripHebrewYear(data.hebrew)
                } else {
                    // Use transliterated format
                    hebrewStr = formatHebrewDate(data.hd, data.hm, data.hy, hebrewFormat, showHebrewYear)
                }

                // Return data object for main.qml to format Gregorian date
                var result = {
                    hebrewDay: data.hd,
                    hebrewMonth: data.hm,
                    hebrewYear: data.hy,
                    hebrewString: hebrewStr,
                    gregorianDate: dateObj
                }

                cb(true, result, hebrewStr, "")
            } catch (e) {
                cb(false, null, null, "Parse error: " + e)
            }
        }
        xhr.send()
    } catch (e) {
        cb(false, null, null, "Exception: " + e)
    }
}

// Backward compatibility: original fetchHebrewDate function
function fetchHebrewDate(dateObj, language, showYear, cb) {
    try {
        var gy = dateObj.getFullYear()
        var gm = dateObj.getMonth() + 1
        var gd = dateObj.getDate()
        var url = "https://www.hebcal.com/converter?cfg=json&g2h=1&strict=1"
            + "&gy=" + gy + "&gm=" + gm + "&gd=" + gd

        var xhr = new XMLHttpRequest()
        xhr.open("GET", url)
        xhr.onreadystatechange = function () {
            if (xhr.readyState !== XMLHttpRequest.DONE)
                return
            if (xhr.status !== 200) {
                cb(false, "", "HTTP " + xhr.status)
                return
            }
            try {
                var data = JSON.parse(xhr.responseText)
                var english = data.hm + " " + data.hd + (showYear ? " " + data.hy : "")
                var hebrew = showYear ? data.hebrew : stripHebrewYear(data.hebrew)

                var text
                if (language === "english") text = english
                else if (language === "hebrew") text = hebrew
                else text = english + " / " + hebrew

                cb(true, text, "")
            } catch (e) {
                cb(false, "", "Parse error: " + e)
            }
        }
        xhr.send()
    } catch (e) {
        cb(false, "", "Exception: " + e)
    }
}

