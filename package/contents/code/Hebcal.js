// Helper for fetching Hebrew date and Gregorian date from Hebcal API
// Enhanced to support sunset-based date transitions and multiple formats
// Returns via callback: (ok: bool, gregorianStr: string, hebrewStr: string, err: string)

.pragma library

function pad2(n) { return (n < 10 ? "0" : "") + n }

// Get Hebrew day-of-week letter (א-ו for Sunday-Friday, ש for Saturday)
function getHebrewDayOfWeek(dateObj) {
    var dayIndex = dateObj.getDay() // 0=Sunday, 1=Monday, ..., 6=Saturday
    var hebrewDays = ["א", "ב", "ג", "ד", "ה", "ו", "ש"]
    return hebrewDays[dayIndex]
}

// Format Hebrew date based on format option
// format: 0 = "26 / Cheshvan / 5786", 1 = "26 Cheshvan 5786", 2 = Hebrew characters
// showDayOfWeek: if true and format is 2 (Hebrew), prepend day-of-week letter with comma
function formatHebrewDate(hd, hm, hy, format, showYear, showDayOfWeek, dateObj) {
    var yearPart = showYear ? hy : ""
    var result = ""

    switch (format) {
        case 0:  // "26 / Cheshvan / 5786"
            result = showYear ? (hd + " / " + hm + " / " + hy) : (hd + " / " + hm)
            break
        case 1:  // "26 Cheshvan 5786"
            result = showYear ? (hd + " " + hm + " " + hy) : (hd + " " + hm)
            break
        case 2:  // Will use Hebrew characters from API
            return null  // Signal to use API's hebrew field
        default:
            result = showYear ? (hd + " " + hm + " " + hy) : (hd + " " + hm)
    }

    // Add day-of-week for non-Hebrew formats if requested
    // (For format 2, this will be handled separately since we use API's hebrew field)
    if (showDayOfWeek && dateObj && format !== 2) {
        var dayOfWeek = getHebrewDayOfWeek(dateObj)
        result = dayOfWeek + ", " + result
    }

    return result
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
// - showHebrewDayOfWeek: boolean
// - cb: callback(ok, gregorianData, hebrewData, err)
function fetchDualDate(dateObj, latitude, longitude, hebrewFormat, showHebrewYear, showHebrewDayOfWeek, cb) {
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
                    // Add Hebrew day-of-week if requested (only for Hebrew character format)
                    if (showHebrewDayOfWeek) {
                        var dayOfWeek = getHebrewDayOfWeek(dateObj)
                        hebrewStr = dayOfWeek + ", " + hebrewStr
                    }
                } else {
                    // Use transliterated format
                    hebrewStr = formatHebrewDate(data.hd, data.hm, data.hy, hebrewFormat, showHebrewYear, showHebrewDayOfWeek, dateObj)
                }

                // Return data object for main.qml to format Gregorian date
                var result = {
                    hebrewDay: data.hd,
                    hebrewMonth: data.hm,
                    hebrewYear: data.hy,
                    hebrewString: hebrewStr,
                    gregorianDate: dateObj,
                    sunsetTime: sunsetTime || ""  // Pass sunset time to main.qml for caching
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

