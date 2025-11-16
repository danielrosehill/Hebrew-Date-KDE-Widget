The purpose of this repository is to create a date widget for KDE Plasma 6 which displays both the Gregorian date and the date according to the Hebrew calendar. 

For syntax guidance, the date only plugin is provided at /model. 

## Functionalities 

The date only widget has a very nice and straightforward configuration menu that would be great to use for English date.

For Hebrew date display, options can be as follows:

26 / Cheshvan / 5786
26 Chesvan 5786
כ"ה חשון ה'תשפ"ו

Note that the Hebrew version is written without diacritics (perhaps later that can be added).

It would be nice to also adjust:

Order: English then Hebrew or Hebrew then English 

Size: default is Hebrew = 100% of English but can make smaller or larger 

UI/ Display

English and Hebrew dates on separate lines / enforced line break.

Assume this widget will be used in the system tray. Taking up horizontal space is problematic. This has to fit tidily between a clock and the notification icons. 

## Hebrew Date Calculation 

The Hebrew calendar works according to sundown so the computation of a correct display date is a little bit more complicated than it is for the English cal. 

Assume an installation context mirroring mine: Ubuntu + KDE.

The easiest solution is: user provides their location by typing a city name and/or providing a geocoordinate pair:

User location -> HebcalAPI (free ) -> Determine switch time. Important note: sundown is (shkiah) is the new day point. 

We should validate installation on this machine. 