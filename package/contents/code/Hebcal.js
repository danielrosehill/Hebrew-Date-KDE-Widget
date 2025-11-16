// Helper for fetching Hebrew date from Hebcal converter API
// Returns via callback: (ok: bool, text: string, err: string)

.pragma library

function pad2(n) { return (n < 10 ? "0" : "") + n }

function composeEnglish(hd, hm, hy, showYear) {
    var s = hm + " " + hd
    if (showYear) s += " " + hy
    return s
}

function stripHebrewYear(hebrewStr) {
    if (!hebrewStr) return ""
    // Heuristic: the year is the last whitespace-separated token(s). Keep first two tokens.
    var parts = hebrewStr.trim().split(/\s+/)
    if (parts.length <= 2) return hebrewStr
    return parts[0] + " " + parts[1]
}

function composeHebrew(hebrewStr, showYear) {
    if (showYear) return hebrewStr
    return stripHebrewYear(hebrewStr)
}

function combine(language, englishStr, hebrewStr) {
    if (language === "english") return englishStr
    if (language === "hebrew") return hebrewStr
    return englishStr + " / " + hebrewStr
}

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
                var english = composeEnglish(data.hd, data.hm, data.hy, showYear)
                var hebrew = composeHebrew(data.hebrew, showYear)
                var text = combine(language, english, hebrew)
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

