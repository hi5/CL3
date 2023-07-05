# Changelog

### v1.108

* New: also show timestamp in tooltip (cycle forward, backward, plugin) and search.
* New: also show number of lines in search results (number only)
* Change: timestamp now has two parts, separated by a pipe character (|)  
  first part (before |): either a character, default @, or a number, for example 128336 for Unicode clock character 🕐  
  second part (after |): time format options - see v1.107
* Change: when cycling back past "z" show number in tooltip instead of character that no longer had any relation to "menu order"

### v1.107

* New: Option to show timestamp in clipboard history menu - https://github.com/hi5/CL3/issues/23  
  See https://www.autohotkey.com/docs/v1/lib/FormatTime.htm#Time_Formats for options (e.g. HH:mm (24hr) or hh:mm tt (12hr AM/PM))
* Fix: Open Template folder - now use commander_path environment variable/registry combined with WinGet ProcessPath/ProcessName, so it should now work with running 32/64 versions. Starts 32bit by default if TC is not running but can be detected.
* Fix: Use MenuWidth setting in DispMenuText() function to check length instead of previously hardcoded value of 60

### v1.106

* Fix: correct path for compiled script (to executable) for tray menu icons
* Adding Try to all Menu, Icon to avoid errors in case they are missing

### v1.105

* Fix: adding missing ico to FileInstall for compiled scripts

### v1.104

* New: basic check for update tray menu option for compiled scripts
* New: ccmdr - Burst, adding \s for space
* Fix: check for duplicates didn't work correctly, now it should
* Fix: ClipChain plugin - fix cancelled "Load from Clipboard (Set Delim)"
* Prepare code for compiling FileInstall icons, ;@Ahk2Exe-IgnoreBegin and ;@Ahk2Exe-IgnoreEnd
  for Private includes (rules marked optional and QEDlg)
  
### v1.103

* Change: Limit Cycle through clipboard history to MaxHistory (useful for smaller values) https://github.com/hi5/CL3/issues/18
* Change: Cycle back/forward through clipboard history now returns to start or end of the MaxHistory value (a->b->c->a) Also #18
* New: Settings to show/hide CL3s "set" menu options "Special, Templates, Yank, More history, and Exit" (see settings menu: Setup menu)

### v1.102

* Fix: Templates in sub-folders weren't read into clipboard to be pasted correctly.

### v1.101

* Change: added `Try` to most `HotKey` commands. Allows the user to bypass default features/plugins by deleting the associated hotkey and avoid 'HotKey Error' crashes.
* New setting: Allow Duplicates, do not automatically delete identical entries.
* New ClipChain option: enter (multiple) delimiter(s) to split elements from clipboard.
* New ClipChain option: define send key(s) after paste (AutoHotkey notation) e.g. {tab}.
* New ClipChain option: define Trim options
* New Named Slots, setup via ccmdr (sNAME) e.g. store current clipboard content as "name". Access via QuickSlotsMenu setting and Slots menu (if any named slots are created)
* New Slots setting for QuickSlotsMenu, show all Slots (0-9) and named Slots
* New API: ChainClear (Clear ClipChain), SlotPaste (paste specific slot ID)
* New (expert) setting: define the `ClipData` and `Templates` Folders to separate the script from the user history, plugin, and template data (cloud, network, or other drive; appdata etc.)
* New (Experimental, hidden): [HistoryRules](https://github.com/hi5/CL3/blob/master/docs/HistoryRules.md) to allow CL3 to filter clipboard content before adding it to history, allowing or skipping text.

### v1.100

* New setting: number of entries in "z. More history" (default 26 for a to z), repeating menu accelerators. Use a negative value e.g. -30 to avoid repeating menu accelerators.
* New setting: second Show Menu hotkey to be able to define mouse button for example (Winkey+LButton).
* If there are over 26 templates in a folder, repeating menu accelerators (a-z).
* New: Check if a sub-folder in \templates\ has a "settings.ini" with a "shortcut" key, if so, setup hotkey to show sub-templates menu directly bypassing the main menu, templates, folder navigation.
* Now using CRC32 to avoid duplicate entries, hopefully faster and more efficient.
* Fix: Compact(ing) adding lines and crc to compacted history as well.

### v1.99.1

* Adding correct Settings GUI to GitHub

### v1.99

* New setting: Exclude programs so copied text will not be added to the clipboard history (useful for password managers for example).  
  A "*" is added to the Menu and "Cycle" tooltips for the first entry (a*.) to indicate the current clipboard has different content as to what is shown.  
  Selecting 'a*' will still paste the selected text, not the actual current clipboard.
* New setting: Lineformat (edit control under "Show Lines") \t placeholder for tab to right align, \l placeholder for number of lines.  
  Default: \t(\l line),\t(\l lines)
  Comma separated for single and multiple lines.
* New setting: Show "TrayTip" using OSDTIP_Pop when AutoReplace has been executed on a new clipboard entry.
* New setting: Auto Backup every X Minutes - automatically backup History. ClipChain, AutoReplace, and Slots only when there is an edit. Keep 5 most recent copies - saved as *.xml.bak in respective ClipData folders.
* Update XA - https://github.com/hi5/XA
* Fix ClipChain "Pause" should work correctly now while pressing hotkey (didn't work after v1.95 update of hotkey setup it seems)

### v1.98

* Modified XA to account for empty XML files due to previous instance of CL3 not being able to save XML data correctly (system crash, forced shutdown, etc) - https://github.com/hi5/CL3/issues/15
* Fix (attempt) error "This picture is too large and will be truncated" in Excel (Check for CF_METAFILEPICT in clipboard)
* oldtext, ttext cleanup ...

### v1.97

* New setting: CopyDelay to set time in milliseconds to wait before adding a copy of a new clipboard entry to the CL3 history.  
  This may resolve some conflicts when other programs or scripts access the clipboard.  
  Increasing this value may work around this issue.  
  The previously hardcoded PasteDelay (50ms) can now also be set.

### v1.96

* API: added CL3Api_State to turn clipboard history on/off - incl. changing tray icon
* Tray menu: Pause clipboard history - option to turn clipboard history on/off - incl. changing tray icon
* Change: Slots - Restore current clipboard from History after pasting Slot entry
* New option to paste unmodified clipboard entry, retains all formatting - see Note 3 in readme.md
* Added WatchFolder() to automatically reload CL3 when a file in the Template folder is updated/added/removed

### v1.95.2

* Fix: Changed to #If for ClipChain paste hotkey

### v1.95.1

* Fix: change "contains" to "in" for keylist in settings.ahk

### v1.95

* Change: Clipchain: you can now define a hotkey (via settings) to "progress to next item" - this will allow you to keep ^v for normal copy/paste functionality - see Clipchain HK (settings)
* Change: AutoReplace added "excel.exe" as fixed Bypass option to prevent errors. Ensure AutoReplace is always updated/saved - https://github.com/hi5/CL3/issues/13
* Fix: CheckHistory OnClipboardChange for first entry & clipboard now also uses == (see v1.94.4)

### v1.94.5

* Fix: FIFO activation via Hotkey trigger

### v1.94.4

* Fix: DispToolTipText removed StringReplace ;
* Change: Added Stringcasesense, On; also in Checkhistory as ==
* Change: Cycle through plugins: Insert changed clip vs overwrite/replace
* Change: (try) to keep original Icon of SOURCE of the clip vs where used LAST
* Change: CheckHistory now as label, no longer need to .remove entries in ClipboardHandler
* Change: move templates\01_Example.txt to res\ folder and check at startup if we have any templates, if not copy (avoids the need to remove it after each update)

### v1.94.3

* Fix: Not correctly updating lines of first entry after pasting from menu + adding Lines to other actions (api, ccmdr)

### v1.94.2

* Fix: Typo/syntax error notes.ahk plugin

### v1.94.1

* Fix: Duplicate IniRead value for Settings (notes/ccmdr)
* Fix: use Notes_Example.txt in repo to prevent overwrites in future of notes.txt

### v1.94

* New: Sort plugin, also illustrating easy way to add submenu to a plugin - see plugins\sort.ahk
* New: Option to show number of lines of an entry in CL3 Menu (see settings)
* New: API see docs\cl3api.md
* New: [Experimental] Notes plugin, append clipboard to (selectable via menu) note file(s) - see docs\notes.md
* New: [Experimental] ccmdr plugin to allow batch operations and more on clipboard history, you need to activate this manually - see docs\ccmdr.md
* Changelog.md split from readme.md

### v1.93.1

* Fixed issue with History not being updated correctly after pasting template (clipboard content wasn't the same as history[1], now it is)

### v1.93

* Hotkeys and some other basic settings via settings.ini, accessible via Tray menu Settings
* Basic stats, accessible via Tray menu "Usage statistics"
* Search Plugin: fix for first Down:: (see comment in code plugins\search.ahk)
* Search Plugin: pressing hotkey again toggles Gui (e.g. hide, show like slots and Clipchain already do)
* Attempt to have more stable ToolTip (less/no flickering as it no longer continuously updates the TT if nothing changes)  
  (Note: using ToolTipFont https://autohotkey.com/boards/viewtopic.php?f=6&t=4777 results in error for these cycle tooltips)
* Updated from OnClipboardChange: to OnClipboardChange() - improved efficiency by turning it on/off at various "actions" and "plugins"
* Improved MaxHistory, not just on OnExit but now continuously keep it at set entries - should help with memory consumption and overall speed
* Added some (generic) icons to tray menu
* Fixed issue with Cycle paste not correctly updating History

### v1.92

* Make it so that we can push public updates without accidentally releasing QEDlg()

### v1.91

* Merge History items via search menu (select multiple, press <kbd>F5</kbd>)
* Fix for Cycle + Plugins hotkeys <kbd>#</kbd>+<kbd>v</kbd> / <kbd>#</kbd>+<kbd>c</kbd> / <kbd>#</kbd>+<kbd>f</kbd>

### v1.9

* Folder structure for Templates\
* Adding dpi() for GUIs (Search, ClipChain, Slots) - https://github.com/hi5/dpi

### v1.81

* Search.ahk Updated rudimentary editor with QEDlg(), a pop-up editor by jballi (see plugins/search.ahk and _functions/)
* CL3.ahk - "AutoTrim, off" to fix AutoTrim issues with Clipboard history :)

### v1.8

* Search plugin: Added option to Edit entry and update history (shortcut: <kbd>F4</kbd>)
* Cycle through plugins (tooltip): <kbd>#</kbd>+<kbd>f</kbd> - can be used in combination with <kbd>#</kbd>+<kbd>v</kbd> / <kbd>#</kbd>+<kbd>c</kbd>
* AutoReplace plugin: added Try

### v1.71

* Use A_CaretX and A_CaretY to see if you can popup the menu near caret, fall back to Mouse coordinates (prior behaviour)

### v1.7

* Added FIFO plugin (first in first out) [#3](https://github.com/hi5/CL3/issues/3)

### v1.62

* Added DoubleClick to paste and progress in ClipChain

### v1.61

* Fixed LV_Modify empty parameters because of AutoHotkey v1.1.23.03 update (only in clipchain.ahk)

### v1.6

* Compact (reduce size of History) accessible via menu, specials - [#1](https://github.com/hi5/CL3/issues/1)
* Delete from search search results (press <kbd>ctrl</kbd>+<kbd>del</kbd>) [#2](https://github.com/hi5/CL3/issues/2)
* Revised method of adding user plugins (see "Adding plugins")

### v1.5

* Added [ClipChain plugin](https://github.com/hi5/CL3/wiki/ClipChain)
* Moved all xml data files to their own separate folder ClipData\* (History, Slots, ClipChain, AutoReplace)   
  Note: to upgrade, close CL3, run the Migrate.ahk script to move all XML files to their own folder. You only need to do this once.

### v1.43

* Further refinement of "AutoReplace" plugin
  - You can now enter a list of programs (CSV list of exe's) which will bypass AutoReplace. Excel.exe is a good candidate to avoid "the picture is too large and will be truncated" clipboard warning message

### v1.42

* Further refinement of "AutoReplace" plugin
  - You can turn it on/off via the Tray menu, the checkmark indicates if it is Active
  - Should now retain formatted clipboard better when no replacements were made

### v1.41

* Bugfix for Slots (stopped working correctly with v1.4 commit 4a982583)

### v1.4

* Added "AutoReplace" plugin to perform find/replace on clipboard text before adding it to history

### v1.32

* Added "Dump History" plugin to export History XML to plain text file

### v1.31

* Minor refinement for first time press <kbd>#</kbd>+<kbd>c</kbd> (don't show tooltip) and readme

### v1.3

* <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd>: paste current clipboard as plain (unformatted) text
* <kbd>#</kbd>+<kbd>v</kbd> and <kbd>#</kbd>+<kbd>c</kbd>: cycle through clipboard history - <kbd>#</kbd>+<kbd>x</kbd> to cancel

### v1.2

* Menu: show icons of the program where text was copied from
* New standard Plugins:
	- Search history
	- Slots
