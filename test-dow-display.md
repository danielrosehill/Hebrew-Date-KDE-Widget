# Day-of-Week Display Testing Guide

## Features Added

1. **Gregorian Day-of-Week**: Shows abbreviated day name (Mon, Tue, etc.) before the Gregorian date
2. **Hebrew Day-of-Week**: Shows Hebrew letter (א-ש) before the Hebrew date

## Configuration Options

The widget configuration now includes two new checkboxes:

- **Show Gregorian day of week (e.g., Mon)**: Adds abbreviated day before Gregorian date
- **Show Hebrew day of week (א-ש)**: Adds Hebrew letter before Hebrew date

## Hebrew Day-of-Week Letters

- א (Aleph) = Sunday (Yom Rishon)
- ב (Bet) = Monday (Yom Sheni)
- ג (Gimel) = Tuesday (Yom Shlishi)
- ד (Dalet) = Wednesday (Yom Revi'i)
- ה (Heh) = Thursday (Yom Chamishi)
- ו (Vav) = Friday (Yom Shishi)
- ש (Shin) = Saturday (Shabbat)

## Testing Steps

1. Open the widget configuration (right-click widget → Configure)
2. Enable "Show Gregorian day of week"
3. Verify the Gregorian date shows with day abbreviation (e.g., "Sat, 16 Nov 2025")
4. Enable "Show Hebrew day of week"
5. Verify the Hebrew date shows with Hebrew letter prefix

### Test Cases

**Format 1: "26 / Cheshvan / 5786"**
- With day-of-week: "ש, 26 / Cheshvan / 5786"

**Format 2: "26 Cheshvan 5786"**
- With day-of-week: "ש, 26 Cheshvan 5786"

**Format 3: "כ״ו חשון תשפ״ו"**
- With day-of-week: "ש, כ״ו חשון תשפ״ו"

## Expected Behavior

- Day-of-week appears before the date with comma separator
- Gregorian day-of-week uses 3-letter English abbreviation (Sun, Mon, Tue, etc.)
- Hebrew day-of-week uses single Hebrew letter (א-ש)
- Both options work independently (can enable one without the other)
- Changes apply immediately when configuration is saved

## Notes

- Hebrew day-of-week convention: Sunday=א (Aleph), Monday=ב (Bet), etc.
- The day calculation is based on the Gregorian calendar's day-of-week
- Format follows Hebrew calendar convention where א=Sunday
