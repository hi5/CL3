# CL3 - clipboard caching AutoHotkey script

CL3 is a lightweight clone of the CLCL clipboard caching utility
which can be found at <http://www.nakka.com/soft/clcl/index_eng.html>
written in AutoHotkey (Source: <https://github.com/hi5/CL3>)

<div style="float: right">
    ![CL3 menu](https://raw.github.com/hi5/CL3/master/img/cl3.png)
</div>

It is not meant to compete with the many clipboard caching utilities
that are (freely) available, but merely as minimal program with some
basic very features.

You can call the clipboard history menu by its default hotkey <kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>v</kbd>
If you prefer another hotkey simply change it in the main script, look for the
line "__; show clipboard history menu__" and change **!^v** to something of your preference.
More on they hotkey syntax here <http://l.autohotkey.net/docs/Hotkeys.htm#Symbols>

CL3 gets its name from CLCL CLone = CL3

**Features**

- Captures text only
- Limited history (18 items+26 items in secondary menu, does remember more entries in XML history file though)
- Remove (yank) entries from history
- No duplicate entries in clipboard (automatically removed)
- Templates: simply textfiles which are read at start up
- Plugins: AutoHotkey functions (scripts) defined in seperate files

## Templates

Any text file placed in the templates\ directory will be read at
start up and added to the Templates sub-menu (<kbd>Alt</kbd>+<kbd>t</kbd>)

File names act as name of the menu entry and are sorted alphabetically
before being added to the menu. You can influence the order of the menu
entries by naming your files in the order you wish them to appear.

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

To add a plugin:

1. Create a script and place it in the plugins\ directory
2. edit plugins\plugins.ahk and add the name of script TWICE
   in the "join list" at the top and in the #include section below it as well.
   The order in which they are listed is used for the menu entries

Default plugins included with CL3:

1. Lower Replace Space (convert to lower case, replace any spaces with an underscore)
2. Lower (convert to lower case)
3. Upper (convert to upper case)
4. Title (convert to title case, basic)

## Yank (delete) entry

If you select the yank option in the menu you will be presented with a 
simple a to r menu to indicate which of the most recent items you wish to
delete.

## Future plans

None really, but feel free to fork and extend the script and send a pull request.

Some ideas for further development you may wish to consider:

- Extending the number of menu entries in the secondary menu ("more history")
- Allow the user to search the extensive history 
- Include rich text formats
- Include images
- Exclude certain programs
- Introduce various paste methods, also for specific programs 
  for example send each character indivually
- More (default) plugins:
    - Improved title case (various scripts are available which could replace the current basic one)
	- Strip HTML
	- Find, Replace in clipboard
	- Reformat text, for example email reply format, wrap text etc
	- Plain text and/or Markdown to HTML conversion
	- ...

The [WinClip class](http://www.autohotkey.com/board/topic/74670-class-winclip-direct-clipboard-manipulations/)
by Deo may be of interest to develop some of these ideas.

# Credits

- Icons from Iconic <https://github.com/somerandomdude/Iconic>
- [XA Save / Load Arrays to/from XML Functions - trueski](http://www.autohotkey.com/board/topic/85461-ahk-l-saveload-arrays/) - using a 'fixed' version as forum post is messed up
