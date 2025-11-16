# Hebrew Date KDE Plasma 6 Widget

A KDE Plasma 6 widget that displays both Gregorian and Hebrew calendar dates in your system tray. Perfect for keeping track of both calendars at a glance.

![Hebrew Date Widget](screenshots/widget-example.png)

## Features

- **Dual Date Display**: Shows both Gregorian and Hebrew dates on separate lines
- **Multiple Hebrew Formats**:
  - `26 / Cheshvan / 5786` (with slashes)
  - `26 Cheshvan 5786` (simple format)
  - `כ״ו חשון תשפ״ו` (Hebrew characters)
- **Customizable Display**:
  - Choose date order (Gregorian first or Hebrew first)
  - Adjust Hebrew date size (50-150% of Gregorian size)
  - Show/hide year for either calendar
  - Font styling (bold/italic)
- **Location-Aware**: Accounts for sunset (shkiah) when calculating Hebrew date transitions
- **Compact Design**: Optimized for system tray placement
- **Auto-Updates**: Refreshes every minute to catch sunset transitions

## Installation

### Quick Install

```bash
./install.sh
```

### Manual Installation

```bash
kpackagetool6 --type Plasma/Applet --install package
```

To upgrade after making changes:
```bash
kpackagetool6 --type Plasma/Applet --upgrade package
```

To remove:
```bash
kpackagetool6 --type Plasma/Applet --remove com.danielrosehill.hebrewdate
```

After installation, restart plasmashell:
```bash
kquitapp6 plasmashell && kstart plasmashell
```

## Adding to Your Panel

1. Right-click on your panel or desktop
2. Select "Add Widgets"
3. Search for "Hebrew Date Widget"
4. Drag it to your system tray or panel

## Configuration

Right-click the widget and select "Configure" to access settings:

### Display Settings
- **Date Order**: Choose whether Gregorian or Hebrew date appears first
- **Hebrew Format**: Select from 3 format options
- **Hebrew Size**: Adjust the relative size of the Hebrew date (50-150%)

### Date Formats
- **Gregorian Format**: Customize using Qt date format codes:
  - `d`/`dd` - day as number (1-31 or 01-31)
  - `M`/`MM`/`MMM`/`MMMM` - month (1, 01, Jan, January)
  - `yy`/`yyyy` - year (00-99 or 0000-9999)
  - `dddd` - day of week (Monday-Sunday)
- **Show Gregorian Year**: Toggle year display for Gregorian date
- **Show Hebrew Year**: Toggle year display for Hebrew date

### Font Style
- Bold
- Italic

### Location Settings
Configure your location for accurate sunset-based date transitions:
- **City**: Your city name (for reference)
- **Latitude**: Your latitude (e.g., 31.7683 for Jerusalem)
- **Longitude**: Your longitude (e.g., 35.2137 for Jerusalem)

**Important**: The Hebrew calendar day begins at sundown (shkiah). The widget uses your location to determine the exact transition time.

## How It Works

The widget uses the [Hebcal API](https://www.hebcal.com) to:
1. Convert Gregorian dates to Hebrew calendar dates
2. Determine sunset times based on your location
3. Automatically switch to the next Hebrew date after sundown

The widget updates every minute to ensure accurate date display, especially around sunset time.

## Technical Details

- **Platform**: KDE Plasma 6
- **API**: Hebcal Converter API
- **Update Frequency**: Every minute
- **Fallback**: Caches last successful date if API is unavailable
- **Languages**: Supports both English transliteration and Hebrew characters

## Example Display

Depending on your configuration, the widget can display dates like:

```
Sunday 16 November 2025
26 Cheshvan 5786
```

or

```
כ״ו חשון תשפ״ו
16 November 2025
```

## Requirements

- KDE Plasma 6
- `kpackagetool6`
- Internet connection (for Hebcal API)
- Qt 6.x

## Troubleshooting

**Widget doesn't appear after installation**
- Restart plasmashell: `kquitapp6 plasmashell && kstart plasmashell`

**Hebrew date shows "unavailable"**
- Check internet connection
- Verify location settings (latitude/longitude)
- Widget will use cached date if API is temporarily unavailable

**Date doesn't update at sunset**
- Verify your latitude/longitude are correct
- Widget updates every minute, so changes should appear within 60 seconds

## License

GPL-3.0+

## Author

Daniel Rosehill
- Website: [danielrosehill.com](https://danielrosehill.com)
- Email: public@danielrosehill.com
