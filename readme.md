# CL3 <sup>v1.93</sup> - Clipboard caching utility

CL3 started as a lightweight clone of the CLCL clipboard caching utility
which can be found at <http://www.nakka.com/soft/clcl/index_eng.html>.
But some unique [features](#features) have been added making it more versatile "text only" Clipboard manager.

Intended for AutoHotkey Unicode (64-bit version of AutoHotkey is automatically Unicode).

Forum thread [https://autohotkey.com/boards/viewtopic.php?f=6&t=814](https://autohotkey.com/boards/viewtopic.php?f=6&t=814)

### Shortcuts

|Key                                                |Action  |
|---------------------------------------------------|--------|
|<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd>        | Open the Clipboard history menu. |
|<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd>      | Paste the current clipboard content as plain text. |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>h</kbd>        | Open the [Search GUI](#search-plugin-v12) and search the clipboard history. (Also delete and edit entries) |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F12</kbd>      | Open the [Slots GUI](#slots-plugin-v12) and define your 10 texts for quick pasting. Quick pasting via <kbd>RCtrl</kbd>+<kbd>1</kbd>,  <kbd>RCtrl</kbd>+<kbd>2</kbd> to <kbd>RCtrl</kbd>+<kbd>0</kbd>. |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F11</kbd>      | Open/close the [ClipChain GUI](#clipchain-v15) - cycle through a predefined clipboard history - see [Wiki](https://github.com/hi5/CL3/wiki/ClipChain) |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd>      | Start [FIFO](#fifo-v17) (Reverse paste) plugin - <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd> stops FIFO   |
|<kbd>LWin</kbd>+<kbd>v</kbd>, hold <kbd>LWin</kbd> | Repeatedly tap <kbd>v</kbd> to [cycle through the clipboard](#cycle-through-clipboard-history-v13) history. Release <kbd>LWin</kbd> to paste. |
|<kbd>LWin</kbd>+<kbd>c</kbd>, hold <kbd>LWin</kbd> | To cycle forward, repeatedly tap <kbd>c</kbd>. Release <kbd>LWin</kbd> to paste. |
|<kbd>LWin</kbd>+<kbd>f</kbd>, hold <kbd>LWin</kbd> | To cycle through plugins repeatedly tap <kbd>f</kbd>. Release <kbd>LWin</kbd> to paste. You can use this in combination with <kbd>#</kbd>+<kbd>v</kbd> and <kbd>#</kbd>+<kbd>c</kbd> |
|<kbd>LWin</kbd>+<kbd>x</kbd>                       | Cancel "cycle" pasting. (also for plugins <kbd>#</kbd>+<kbd>f</kbd>) |

Note: as of v1.93 you can define these Shortcuts via Settings.ini or use the Tray menu, Settings option

## About CL3

It is not meant to compete with the many clipboard caching utilities that are (freely) available,
but merely as minimal program focussing on text only.

You can call the clipboard history menu by its default hotkey <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd>
If you prefer another hotkey you can change this and the other hotkeys via the Settings menu. Use the
AutoHotkey syntax - more info about they syntax here <https://autohotkey.com/docs/Hotkeys.htm#Symbols>

CL3 gets its name from CLCL CLone = CL3

As of v1.3: Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd> to paste the current clipboard item as 
plain (unformatted) text - this can be useful if you have selected rich / formatted text but don't want
to paste that in your current application.

### Features

- Captures text only
- Limited history (18 items+26 items in secondary menu, does remember more entries in XML history file though)
- Search history (v1.2+)
- 10 Slots with options to save/load several sets (v1.2+)
- Cycle through clipboard - forwards and backwards - with tooltip preview (v1.3+). Cycle through plugins (v1.8+)
- ClipChain with preview GUI, paste items in predefined order, save/load several sets (v1.5+) [Wiki](https://github.com/hi5/CL3/wiki/ClipChain)
- Supports FIFO (first in first out) pasting (v1.7) [#3](https://github.com/hi5/CL3/issues/3)
- Remove (yank) entries from history
- No duplicate entries in clipboard (automatically removed)
- Templates: simply text files which are read at start up
- Plugins: AutoHotkey functions (scripts) defined in separate files

## Templates

Any text file placed in the templates\ directory will be read at start up and
added to the Templates sub-menu - press <kbd>t</kbd> to quickly access them
while the menu is active.

File names act as name of the menu entry and are sorted alphabetically
before being added to the menu. You can influence the order of the menu
entries by naming your files in the order you wish them to appear.

As of v1.9+ Templates now support sub-folders. A Sub-folder will be added as a
sub-menu entry and its text files processed as described above. If a "favicon.ico"
is present in a sub-folder it will be used in the Templates Menu, otherwise it
will use the default Templace icon (res\icon-t.ico)

**Note**: there is one default entry in the Templates menu: "_0. Open templates folder_"
which will open the templates folder in Total Commander - if it is running - or 
the standard file explorer (see the TemplateMenuHandler label)

**Example**

File name: "templates\01_Boiler plate 1.txt" will be a "menu entry:"
as "&a. Boiler plate 1"

If you add new text files to the templates directory you need to
reload the script in order for them to appear in the templates sub-menu.

## Plugins

Plugins are AutoHotkey functions you will need to #include in the 
script in order for them to work. A plugin acts on the current 
clipboard content and changes it before it is being pasted.

**Adding plugins**

As of v1.6 a new method of adding plugins is recommended, see comments in [plugins.ahk](plugins/plugins.ahk) for instructions

Default plugins included with CL3 ([v1.0]):

1. Lower Replace Space (convert to lower case, replace any spaces with an underscore)
2. Lower (convert to lower case)
3. Upper (convert to upper case)
4. Title (convert to title case, basic)
5. see other updates for more

### Search plugin [v1.2+]

As of v1.2 you can now search the CL3 history, hotkey <kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>h</kbd>
simply start typing, press enter will paste the first result or you can use the <kbd>UP</kbd> & <kbd>DOWN</kbd>
keys to navigate the result list. See [screenshot](#screenshots).

As of [v1.6] you delete entries directly via the history search Gui, just press <kbd>Ctrl</kbd>+<kbd>Del</kbd> on the highlighted entry in the list.

As of [v1.8] you edit entries directly via the history search Gui, just press <kbd>F4</kbd> on the highlighted entry in the list to edit.
After editing the entry should stay highlighted so you could paste it directly by pressing enter or the OK button.

### Slots plugin [v1.2+]

Press <kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F12</kbd> to open the Slots GUI and define your 10 texts
for quick pasting. See [screenshot](#screenshots).

To facilitate quick pasting of predefined texts you can use the <kbd>RCtrl</kbd>+<kbd>1</kbd> .. <kbd>RCtrl</kbd>+<kbd>0</kbd>
hotkeys. By default the 10 predefined texts are stored in _slots.xml_ but you can save and load as many slot-files
as you like via the buttons available when the Slots gui is open. The last set used is always stored in _slots.xml_

### Dump History plugin [v1.32+]

You can export the current clipboard history to a plain text file via the Special, Dump History menu option.  
The text file will be placed in the CL3 script folder.

### AutoReplace [v1.4+]

You can use the AutoReplace plugin to modify the text in the clipboard using a find/replace rule before adding
it to the history. You can use StringReplace or a Regular Expression. Settings are stored in _AutoReplace.xml_
**Note: very experimental plugin. The plugin interface (GUI) needs to refined, entire process should be improved.
A Listview would be more logical and flexible. But for now it does the job, albeit crudely.**

### ClipChain [v1.5+]

The CL3 ClipChain plugin allows you to cycle through a predefined clipboard history.  
With each paste it advances to the next item in the chain. The item to be pasted next is indicated in the listview with a ```>>```.  
When the last item is reached it moves back to the start. See [Wiki](https://github.com/hi5/CL3/wiki/ClipChain)  
The most recently used chain is stored in _clipchain.xml_.

### Compact [v1.6+]

If you have a lot of entries in the history or one or more very large (kb) entries. CL3 can become
a bit sluggish. You can use the Compact plugin to:

- remove entries over certain size (user specified)
- keep only the most recent specified number of entries (e.g. 100 -> keep 1..100 most recent, remove all older from history)

### FIFO [v1.7+]

[FIFO](https://github.com/hi5/CL3/issues/3) (first in first out) will allow you to paste entries back in
the order in which the entries were added to the clipboard history.

Press <kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd> to bring up the clipboard history menu (sans plugins
and templates) and select the entry you want FIFO to start with, nothing is pasted yet.  
You can **stop** FIFO by:

* Bringing up the regular Clipboard history <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd>
* Press <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd> (special FIFO shortcut)
* Press <kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd> and choose "Exit (close menu)" (or press <kbd>ESC</kbd>)

You add ```1```, ```2```, ```3```, ```4``` to the clipboard history. The history menu would look like this:

```
a. 4
b. 3
c. 2
d. 1
```

If you start FIFO at 'D' pressing <kbd>Ctrl</kbd>+<kbd>v</kbd> four times will paste 1, 2, 3, 4.  
After pasting the last (here fourth) item, FIFO stops.  
TrayTips will appear at the start and stop of a FIFO cycle.

## Yank (delete) entry

If you select the yank option in the menu you will be presented with a 
simple **a** to **r** menu to indicate which of the most recent items you wish to
delete.

## Cycle through clipboard history [v1.3+]

If you press <kbd>LWin</kbd>+<kbd>v</kbd>, hold <kbd>LWin</kbd> and repeatedly tap <kbd>v</kbd> you can cycle through
backwards through the clipboard history - a tooltip with the text to paste will be shown, if you release <kbd>LWin</kbd>
the text will be pasted.

To cycle forwards press <kbd>LWin</kbd>+<kbd>c</kbd>.  
**Caveat:** if you press <kbd>LWin</kbd>+<kbd>c</kbd> before <kbd>LWin</kbd>+<kbd>v</kbd> nothing will be pasted upon release 
of the <kbd>LWin</kbd> key.

To cancel pasting press <kbd>LWin</kbd>+<kbd>x</kbd>.

## Cycle through plugins [v1.8+]

Press <kbd>LWin</kbd>+<kbd>f</kbd> to cycle through pre-defined plugins, it shows a preview in the tooltip. You can combine
this with <kbd>LWin</kbd>+<kbd>v</kbd> and <kbd>LWin</kbd>+<kbd>c</kbd>. To cancel pasting press <kbd>LWin</kbd>+<kbd>x</kbd>.

In settings.ini you can define and set the order of the plugins you cycle through. The plugins have to be of a
similar format to Lower and Upper for example (e.g. just calling a function to alter the current item).

See [Wiki](https://github.com/hi5/CL3/wiki/CyclePlugins)

## Future plans

None really, but feel free to fork and extend the script and send a pull request.

Some ideas for further development you may wish to consider:

- Extending the number of menu entries in the secondary menu ("more history")
- ~~Allow the user to search the extensive history~~ _v1.2+_
- Include rich text formats
- Include images
- Exclude certain programs
- Introduce various paste methods, also for specific programs 
  for example send each character individually
- More (default) plugins:
	- Improved title case (various scripts are available which could replace the current basic one)
	- Strip HTML
	- ~~Find, Replace in clipboard~~ possible via editor
	- Reformat text, for example email reply format, wrap text etc
	- Plain text and/or Markdown to HTML conversion
	- ...

The [WinClip class](http://www.autohotkey.com/board/topic/74670-class-winclip-direct-clipboard-manipulations/)
by Deo may be of interest to develop some of these ideas.

# Screenshots

![CL3 Menu](https://raw.github.com/hi5/CL3/master/img/cl3.png)

![CL3 Slots](https://raw.github.com/hi5/CL3/master/img/slots.png)

![CL3 Search](https://raw.github.com/hi5/CL3/master/img/search.png)

![CL3 ClipChain](https://raw.github.com/hi5/CL3/master/img/clipchain.png)

# Credits

- Icons from Iconic <https://github.com/somerandomdude/Iconic>
- [XA Save / Load Arrays to/from XML Functions](https://github.com/hi5/XA)
- [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) by [Pulover](https://github.com/Pulover/) - as of v1.5 (for ClipChain)
- [Edit Library](https://autohotkey.com/boards/viewtopic.php?f=6&t=5063) by [jballi](https://autohotkey.com/boards/memberlist.php?mode=viewprofile&u=58) - QEDlg() code also by jballi (for search/edit plugin)

# Changelog

**v1.93.1**

* Fixed issue with History not being updated correctly after pasting template (clipboard content wasn't the same as history[1], now it is)

**v1.93**

* Hotkeys and some other basic settings via settings.ini, accessible via Tray menu Settings
* Basic stats, accessible via Tray menu "Usage statistics"
* Search Plugin: fix for first Down:: (see comment in code plugins\search.ahk)
* Search Plugin: pressing hotkey again toggles Gui (e.g. hide, show like slots and clipchain already do)
* Attempt to have more stable ToolTip (less/no flickering as it no longer continously updates the TT if nothing changes)  
  (Note: using ToolTipFont https://autohotkey.com/boards/viewtopic.php?f=6&t=4777 results in error for these cycle tooltips)
* Updated from OnClipboardChange: to OnClipboardChange() - improved efficiency by turning it on/off at various "actions" and "plugins"
* Improved MaxHistory, not just on OnExit but now continously keep it at set entries - should help with memory consumption and overall speed
* Added some (generic) icons to tray menu
* Fixed issue with Cycle paste not correctly updating History

**v1.92**

* Make it so that we can push public updates without accidentally releasing QEDlg()

**v1.91**

* Merge History items via search menu (select multiple, press <kbd>F5</kbd>)
* Fix for Cycle + Plugins hotkeys <kbd>#</kbd>+<kbd>v</kbd> / <kbd>#</kbd>+<kbd>c</kbd> / <kbd>#</kbd>+<kbd>f</kbd>

**v1.9**

* Folder structure for Templates\
* Adding dpi() for GUIs (Search, ClipChain, Slots) - https://github.com/hi5/dpi

**v1.81**

* Search.ahk Updated rudimentary editor with QEDlg(), a pop-up editor by jballi (see plugins/search.ahk and _functions/)
* CL3.ahk - "AutoTrim, off" to fix AutoTrim issues with Clipboard history :)

**v1.8**

* Search plugin: Added option to Edit entry and update history (shortcut: <kbd>F4</kbd>)
* Cycle through plugins (tooltip): <kbd>#</kbd>+<kbd>f</kbd> - can be used in combination with <kbd>#</kbd>+<kbd>v</kbd> / <kbd>#</kbd>+<kbd>c</kbd>
* AutoReplace plugin: added Try

**v1.71**

* Use A_CaretX and A_CaretY to see if you can popup the menu near caret, fall back to Mouse coordinates (prior behaviour)

**v1.7**

* Added FIFO plugin (first in first out) [#3](https://github.com/hi5/CL3/issues/3)

**v1.62**

* Added DoubleClick to paste and progress in ClipChain

**v1.61**

* Fixed LV_Modify empty parameters because of AutoHotkey v1.1.23.03 update (only in clipchain.ahk)

**v1.6**

* Compact (reduce size of History) accessible via menu, specials - [#1](https://github.com/hi5/CL3/issues/1)
* Delete from search search results (press <kbd>ctrl</kbd>+<kbd>del</kbd>) [#2](https://github.com/hi5/CL3/issues/2)
* Revised method of adding user plugins (see "Adding plugins")

**v1.5**

* Added [ClipChain plugin](https://github.com/hi5/CL3/wiki/ClipChain)
* Moved all xml data files to their own separate folder ClipData\* (History, Slots, ClipChain, AutoReplace)   
  Note: to upgrade, close CL3, run the Migrate.ahk script to move all XML files to their own folder. You only need to do this once.

**v1.43**

* Further refinement of "AutoReplace" plugin
  - You can now enter a list of programs (CSV list of exe's) which will bypass AutoReplace. Excel.exe is a good candidate to avoid "the picture is too large and will be truncated" clipboard warning message

**v1.42**

* Further refinement of "AutoReplace" plugin
  - You can turn it on/off via the Tray menu, the checkmark indicates if it is Active
  - Should now retain formatted clipboard better when no replacements were made

**v1.41**

* Bugfix for Slots (stopped working correctly with v1.4 commit 4a982583)

**v1.4**

* Added "AutoReplace" plugin to perform find/replace on clipboard text before adding it to history

**v1.32**

* Added "Dump History" plugin to export History XML to plain text file

**v1.31**

* Minor refinement for first time press <kbd>#</kbd>+<kbd>c</kbd> (don't show tooltip) and readme

**v1.3**

* <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd>: paste current clipboard as plain (unformatted) text
* <kbd>#</kbd>+<kbd>v</kbd> and <kbd>#</kbd>+<kbd>c</kbd>: cycle through clipboard history - <kbd>#</kbd>+<kbd>x</kbd> to cancel

**v1.2**

* Menu: show icons of the program where text was copied from
* New standard Plugins:
	- Search history
	- Slots
