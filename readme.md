# CL3 <sup>v1.112</sup> - Clipboard caching utility

CL3 started as a lightweight clone of the CLCL clipboard caching utility
which can be found at <http://www.nakka.com/soft/clcl/index_eng.html>.
But some unique [features](#features) have been added making it a more versatile "text only" Clipboard manager.

Intended for AutoHotkey Unicode (the 64-bit version of AutoHotkey is automatically Unicode).

💡 Relies on standard copy/paste shortcuts for the applications you are using, so <kbd>Ctrl</kbd>+<kbd>c</kbd> and <kbd>Ctrl</kbd>+<kbd>v</kbd>, and right click "copy" via mouse actions.
Programs that rely on other shortcuts to store and restore clipboard contents may not work (e.g. vim).

💬 Forum thread [https://autohotkey.com/boards/viewtopic.php?f=6&t=814](https://autohotkey.com/boards/viewtopic.php?f=6&t=814)

💡 _The [changelog.md](changelog.md) contains some additional information about certain features._

### Shortcuts

|Key<sup>[1](#note1)</sup>                           |Action  |
|----------------------------------------------------|--------|
|<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd>         | Open the Clipboard history menu. |
|<kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd>       | Paste the current clipboard content as plain text.<sup>[2](#note2)</sup> |
|<kbd>*Undefined*</kbd>                              | Paste most recent item added to the clipboard unmodified.<sup>[3](#note3)</sup> |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>h</kbd>         | Open the [Search GUI](#search-plugin-v12) and search the clipboard history. (Also delete and edit entries) |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F12</kbd>       | Open the [Slots GUI](#slots-plugin-v12) and define your 10 texts for quick pasting. Quick pasting via <kbd>RCtrl</kbd>+<kbd>1</kbd>,  <kbd>RCtrl</kbd>+<kbd>2</kbd> to <kbd>RCtrl</kbd>+<kbd>0</kbd>. |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F11</kbd>       | Open/close the [ClipChain GUI](#clipchain-v15) - cycle through a predefined clipboard history - see [Wiki](https://github.com/hi5/CL3/wiki/ClipChain) |
|<kbd>Ctrl</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd>       | Start [FIFO](#fifo-v17) (Reverse paste) plugin - <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Win</kbd>+<kbd>F10</kbd> stops FIFO.   |
|<kbd>LWin</kbd>+<kbd>v</kbd>, hold <kbd>LWin</kbd>  | Repeatedly tap <kbd>v</kbd> to [cycle through the clipboard](#cycle-through-clipboard-history-v13) history. Release <kbd>LWin</kbd> to paste. |
|<kbd>LWin</kbd>+<kbd>c</kbd>, hold <kbd>LWin</kbd>  | To cycle forward, repeatedly tap <kbd>c</kbd>. Release <kbd>LWin</kbd> to paste. |
|<kbd>LWin</kbd>+<kbd>f</kbd>, hold <kbd>LWin</kbd>  | To cycle through plugins repeatedly tap <kbd>f</kbd>. Release <kbd>LWin</kbd> to paste. You can use this in combination with <kbd>#</kbd>+<kbd>v</kbd> and <kbd>#</kbd>+<kbd>c</kbd> |
|<kbd>LWin</kbd>+<kbd>x</kbd>                        | Cancel "cycle" pasting. (also for plugins <kbd>#</kbd>+<kbd>f</kbd>) |

<a name='note1'></a>
Note 1: as of v1.93 you can define these Shortcuts via Settings.ini or use the Tray menu, Settings option.

<a name='note2'></a>
Note 2: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>v</kbd> pastes the current clipboard item as plain (unformatted)
text - this can be useful if you have selected rich / formatted text but don't want to paste that in your
current application.

<a name='note3'></a>
Note 3: As CL3 might modify the clipboard content when using AutoReplace, the most recently copied
item to the clipboard (after <kbd>Ctrl</kbd>+<kbd>c</kbd>) is also stored unmodified thus preserving
the original format (layout, images, etc) - Define a hotkey in the Settings to paste this unmodified Clipboard.  
Suggestion: <kbd>Ctrl</kbd>+<kbd>Shift</kbd>+<kbd>Capslock</kbd>, define as: ^+CAPSLOCK  
This may be useful in Word processing or other specific formats if you notice formatting is
lost or changed upon a regular paste (<kbd>Ctrl</kbd>+<kbd>v</kbd>).

## About CL3

It is not meant to compete with the many clipboard caching utilities that are (freely) available,
but merely as minimal program focusing on text only.

You can call the clipboard history menu by its default hotkey <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd>
If you prefer another hotkey you can change this and the other hotkeys via the Settings menu. Use the
AutoHotkey syntax - more info about they syntax here <https://autohotkey.com/docs/Hotkeys.htm#Symbols>

_CL3 gets its name from CLCL CLone = CL3_

### Features

- Captures text only
- Limited history (18 items+26 items in secondary menu, does remember more entries in XML history file)
- Search history (v1.2+)
- 10 Slots with options to save/load several sets (v1.2+)
- Cycle through the clipboard history - forwards and backwards - with tooltip preview (v1.3+). Cycle through plugins (v1.8+)
- ClipChain with preview GUI, paste items in predefined order, save/load several sets (v1.5+) [Wiki](https://github.com/hi5/CL3/wiki/ClipChain)
- Supports FIFO (first in first out) pasting (v1.7) [#3](https://github.com/hi5/CL3/issues/3)
- Remove (yank) entries from history
- No duplicate entries in the clipboard history (automatically removed)
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
will use the default Template icon (res\icon-t.ico)  
As of v1.100+: Add `settings.ini` to (each) sub-folder with a shortcut key (AutoHotkey syntax) to be able to display the templates in the sub-folder directly to avoid the need to bring up the main menu (allowing for faster access)

```ini
[settings]
shortcut=#Numpad8
```

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

* Copying files by Pasting - if you have copied file paths to the clipboard (^c in file explorer for example) you can copy (paste) these files if you wish. Basic instructions on how to set it up here https://www.autohotkey.com/boards/viewtopic.php?p=314316#p314316

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

SlotsMenu [v1.101+]

To display the Slots as a menu, define a Hotkey in the Settings, this will also include any `Named` Slots you defined via `ccmdr` (see [docs\ccmdr.md](docs\ccmdr.md))

### Dump History plugin [v1.32+]

You can export the current clipboard history to a plain text file via the Special, Dump History menu option.  
The text file will be placed in the CL3 script folder.

### AutoReplace [v1.4+]

You can use the AutoReplace plugin to modify the text in the clipboard using a find/replace rule before adding
it to the history. You can use StringReplace or a Regular Expression. Settings are stored in _AutoReplace.xml_
**Note: very experimental plugin. The plugin interface (GUI) needs to be refined, entire process should be improved.
A Listview would be more logical and flexible. But for now it does the job, albeit crudely.**

Feedback available via "Tray Tip" - see settings.

### ClipChain [v1.5+]

The CL3 ClipChain plugin allows you to cycle through a predefined clipboard history.  
With each paste it advances to the next item in the chain. The item to be pasted next is indicated in the listview with a ```>>```.  
When the last item is reached it moves back to the start. See [Wiki](https://github.com/hi5/CL3/wiki/ClipChain)  
The most recently used chain is stored in _clipchain.xml_.

#### ClipChain Hotkey

By default <kbd>Ctrl</kbd>+<kbd>v</kbd> will paste and proceed to the next item in the chain. 
You can define another hotkey in the Settings menu. This will allow you to keep <kbd>Ctrl</kbd>+<kbd>v</kbd>
for normal copy/paste functionality.

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
TrayTips will appear at the start and end of a FIFO cycle.

### Sort [v1.94+]

Sort via a number of predefined settings or set specific options via small Gui (see "Set Delimiter and other options" in Sort menu).  
See [Sort](https://www.autohotkey.com/docs/commands/Sort.htm) documentation for explanation.

## Yank (delete) entry

If you select the yank option in the menu you will be presented with a 
simple **a** to **r** menu to indicate which of the most recent items you wish to
delete. To delete the entire history select "Clear History" (v1.111+)

## Cycle through clipboard history [v1.3+]

If you press <kbd>LWin</kbd>+<kbd>v</kbd>, hold <kbd>LWin</kbd> and repeatedly tap <kbd>v</kbd> you can cycle through
backwards through the clipboard history - a tooltip with the text to paste will be shown, if you release <kbd>LWin</kbd>
the text will be pasted.

To cycle forwards press <kbd>LWin</kbd>+<kbd>c</kbd>.  
**Caveat:** if you press <kbd>LWin</kbd>+<kbd>c</kbd> before <kbd>LWin</kbd>+<kbd>v</kbd> nothing will be pasted upon release 
of the <kbd>LWin</kbd> key.

To cancel pasting press <kbd>LWin</kbd>+<kbd>x</kbd>.

After reaching "Max History" it will cycle back to the first entry in the history (for a Max History of three: a->b->c->a).

To apply a plugin (see below), hold <kbd>LWin</kbd> and press <kbd>f</kbd> repeatedly to _select_ a plugin.

See [Wiki](https://github.com/hi5/CL3/wiki/Cycle-history)

## Cycle through plugins [v1.8+]

Press <kbd>LWin</kbd>+<kbd>f</kbd> to cycle through pre-defined plugins, it shows a preview in the tooltip. You can combine
this with <kbd>LWin</kbd>+<kbd>v</kbd> and <kbd>LWin</kbd>+<kbd>c</kbd>. To cancel pasting press <kbd>LWin</kbd>+<kbd>x</kbd>.

In settings.ini you can define and set the order of the plugins you cycle through. The plugins have to be of a
similar format to Lower and Upper for example (e.g. just calling a function to alter the current item).

See [Wiki](https://github.com/hi5/CL3/wiki/CyclePlugins)

## Future plans

None really, but feel free to fork and extend the script and send a pull request.

Some ideas for further development you may wish to consider:

- ~~Allow the user to search the extensive history~~ _v1.2+_
- ~~Exclude certain programs~~ _v1.99+_
- ~~Extending the number of menu entries in the secondary menu ("more history")~~ _v1.100+_
- Include rich text formats
- Include images - rough guide to add it (very alpha) here https://www.autohotkey.com/boards/viewtopic.php?p=314319#p314319
- ~~Introduce various paste methods, also for specific programs? 
  for example send each character individually~~ _v1.112+_
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

Animations:

* ClipChain: https://github.com/hi5/CL3/wiki/ClipChain
* CyclePlugins: https://github.com/hi5/CL3/wiki/CyclePlugins

# Credits

- Icons from Iconic <https://github.com/somerandomdude/Iconic>
- [XA Save / Load Arrays to/from XML Functions](https://github.com/hi5/XA)
- [Class LV_Rows](http://www.autohotkey.com/board/topic/94364-class-lv-rows-copy-cut-paste-and-drag-listviews/) by [Pulover](https://github.com/Pulover/) - as of v1.5 (for ClipChain)
- [Edit Library](https://autohotkey.com/boards/viewtopic.php?f=6&t=5063) by [jballi](https://autohotkey.com/boards/memberlist.php?mode=viewprofile&u=58) - QEDlg() code also by jballi (for search/edit plugin)
- API: [ObjRegisterActive()](https://www.autohotkey.com/boards/viewtopic.php?t=6148) by Lexikos 
- API: [JSON/JXON](https://github.com/cocobelgica/AutoHotkey-JSON) by cocobelgica
- Notes: [GetActiveBrowserURL()](https://www.autohotkey.com/boards/viewtopic.php?t=3702) by Antonio Bueno
- [WatchFolder()](https://github.com/AHK-just-me/WatchFolder) by just me
- [OSDTIP_Pop()](https://www.autohotkey.com/boards/viewtopic.php?t=76881#p333577) by SKAN
- [CRC32()](https://github.com/ahkscript/libcrypt.ahk/blob/master/src/CRC32.ahk) by jNizM

# OCR-TIP

If you need to "grab" text from Images, Screens, Locked PDFs etc you can use one of these nifty AutoHotkey scripts:

1) Vis2 by iseahound
- Download: https://github.com/iseahound/Vis2 
- Forum: https://www.autohotkey.com/boards/viewtopic.php?f=6&t=36047 (shows demo animation)

I've added the following code to "plugins\myplugins.ahk" to start Vis2 when I need it:

```autohotkey
#capslock:: ; winkey-capslock
Run %A_ScriptDir%\vis2\runocr.ahk ; path to vis2 code, see github link above
If !stats.visocr ; for statistics if you're interested in how many times you use it, you can omit this
	stats.visocr:=0
stats.visocr++
return
```

2) Windows 10 OCR tool by malcev, teadrinker, and flyingDman

- Download from the forum https://www.autohotkey.com/boards/viewtopic.php?p=325660#p325660

You can 'add' it to CL3 as shown above with the Vis2 example Run ...

Look for the line `msgbox % text` and change it to:

```autohotkey
clipboard:=text
Sleep 100
ExitApp ; to close the script after OCR
```

After the OCR is complete it is added to the clipboard and thus the CL3 clipboard history.

# General TIPs

As noted above, adding plugins via `plugins\MyPlugins.ahk` is the recommended method, see comments in [plugins.ahk](plugins/plugins.ahk) for instructions.

Apart from plugins, `plugins\MyPlugins.ahk` is also a useful method to add additional functions and/or hotkeys to CL3 without the risk of losing them when updating.
(MyPlugins.ahk will never be part of the public CL3 repository)

1. Copy or Cut and Append to clipboard

Some text editors already offer this functionality, but you can make it available everywhere using CL3.  
Add the following code for copy and/or cut to `plugins\MyPlugins.ahk`

```autohotkey
; copy text and append to clipboard item so a, ab, abc, abcd etc
^+c::
OnClipboardChange("FuncOnClipboardChange", 0)
Send ^c
Sleep, 100
ClipText:=History[1].text . Clipboard ; if you want to use a separator insert it here e.g. "`n" or "|" 
StrReplace(ClipText, "`n", "`n", Count)
crc:=crc32(ClipText)
History[1,"text"]:=ClipText
History[1,"lines"]:=Count+1,
History[1,"crc"]:=crc
History[1,"time"]:=A_Now
Clipboard:=ClipText
Sleep, 100
ClipText:="",Count:="",crc:=""
OnClipboardChange("FuncOnClipboardChange", 1)
Return

; cut text and append to clipboard so a, ab, abc, abcd etc
^+x::
OnClipboardChange("FuncOnClipboardChange", 0)
Send ^x
Sleep, 100
ClipText:=History[1].text . Clipboard ; if you want to use a separator insert it here e.g. "`n" or "|" 
StrReplace(ClipText, "`n", "`n", Count)
crc:=crc32(ClipText)
History[1,"text"]:=ClipText
History[1,"lines"]:=Count+1,
History[1,"crc"]:=crc
History[1,"time"]:=A_Now
Clipboard:=ClipText
Sleep, 100
ClipText:="",Count:="",crc:=""
OnClipboardChange("FuncOnClipboardChange", 1)
Return

```

2. Adding shortcuts for pasting clipboard entries directly

```autohotkey
; forum post https://www.autohotkey.com/boards/viewtopic.php?f=76&t=90231&p=398527#p398527
^+1:: ; current clipboard
^+2:: ; second entry in clipboard history (b. in the menu)
^+3:: ; third entry in clipboard history (c. in the menu)
^+4::
^+5::
^+6::
^+7::
^+8::
^+9::
; add more if you wish, note that you need to modify the logic for "SubStr(A_ThisHotkey,0)" in that case
OnClipboardChange("FuncOnClipboardChange", 0)
Clipboard:=History[SubStr(A_ThisHotkey,0)].text
Sleep 200
PasteIt()
Sleep 200
Clipboard:=History[1].text
OnClipboardChange("FuncOnClipboardChange", 1)
Return
```


# PastePrivateRules.ahk

Add an optional include file that "does something" before it actually pastes.  
The file is not present in the repository and a new file has to be created in `cl3\plugins\` with the name `PastePrivateRules.ahk`

Examples:

* Pasting file(s) from CL3 history https://www.autohotkey.com/boards/viewtopic.php?p=314316#p314316 using `ClipboardSetFiles()` and `If WinActive()`
* Append to File name in "Open/Save as" dialogs - https://github.com/hi5/CL3/issues/14
* Paste in putty.exe (as of v1.112 can be care of using PasteShortCuts.ini) - https://github.com/hi5/CL3/issues/27

Note: your `PastePrivateRules.ahk` will never be part of this GitHub repository so anything you add won't be overwritten if you update CL3 in the future. 

# PasteShortCuts.ini

Note: a default setup can be found in `res\PasteShortCuts.ini` (online [here](https://github.com/hi5/CL3/blob/master/res/PasteShortCuts.ini)) - copy the file to the CL3 folder and restart CL3.

To setup CL3 for programs where you don't want to use the standard Windows shortcut (Ctrl+v) to paste
create or edit `PasteShortCuts.ini` in the CL3 program folder. Details below and in the ini file as well.

```ini
[SectionName] - Create a section (any name)
Programs=       CSV list of program executables
Key=            Use AHK notation (^=ctrl +=shift !=alt), if KEY is empty or "[SEND]" (no quotes)
                CL3 will use SendRaw to send the clipboard to the application - results may vary
```
Terminal programs often prefer <kbd>Shift</kbd>+<kbd>Insert</kbd> (`+{Ins}`) as Paste shortcut

Using `PastePrivateRules.ahk` is another option, see examples listed above.

# Experimental

* [HistoryRules](https://github.com/hi5/CL3/blob/master/docs/HistoryRules.md) to allow CL3 to filter clipboard content before adding it to history, allowing or skipping text.

# Changelog

The changelog is available here: [changelog.md](changelog.md)
