# Hebrew Date KDE Plasma Widget

Simple Plasma 6 widget that shows the current Hebrew (Jewish) calendar date.

Features:
- Displays Hebrew date via Hebcal converter API
- Language options: English, Hebrew, or Both
- Toggle to include/exclude the year
- Updates automatically at local midnight

Install (local user):
1. Ensure Plasma 6 is installed with `kpackagetool6`.
2. Install the package directory:
   - `kpackagetool6 --type Plasma/Applet -i package`
   - To upgrade after changes: `kpackagetool6 --type Plasma/Applet -u package`
   - To remove: `kpackagetool6 --type Plasma/Applet -r org.kde.plasma.hebrewdate`
3. Add the widget from the Plasma widgets list: "Hebrew Date".

Config Options:
- Language: English, Hebrew, or Both
- Show year: include/exclude the Hebrew year

Notes:
- The widget fetches the date from Hebcal (`https://www.hebcal.com`) once per day. If the network is unavailable, it shows a fallback message.
- In environments without network access, you can still install and configure the widget; it will update successfully once connectivity is available.
