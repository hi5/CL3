# Notes

The Notes plugin must be enabled first and you can change the default hotkey `#n`
via the Setting menu (see Tray menu)

The Notes plugin allows you to append the current clipboard to "Note files" (plain text).  
When you activate the plugin a menu will be shown to select the Note.

## Notes.txt

You can define the "List of Note files" (menu) via a simple text file in `ClipData\Notes\Notes.txt`

**Format:**

`Menu name|path to note file (a text file)|path to icon for menu option (not required)`

Empty lines or lines starting with a semi-colon (;) are ignored so you can add comments or (temporarily) remove a meny entry.

You can use the following AutoHotkey variables in the `path to note file (a text file)`:

- %A_ScriptDir%
- %A_MyDocuments%
- %A_Desktop%
- %A_DesktopCommon%

Example:

`Notes in CL3 folder|%A_ScriptDir%\MyNotesTest.txt`

## NotesTemplate.txt

**Format:**

Define the format of a new entry that will be append to a Notes file will look in  
`ClipData\Notes\NotesTemplate.txt`

This is a simple text file with a number of special variables:

@NoteTime=yyyy-MM-dd hh:mm:ss@
> Option to include date, time or combination thereof in the Note.
> Uses [FormatTime](https://autohotkey.com/docs/commands/FormatTime.htm)
> Can be omitted.

@clipboard@
> Placement of the clipboard contents (text).
> If NotesTemplate.txt is empty or @clipboard@ is not
> included it will automatically be inserted.

@NoteUri@
> If the active window happens to be a browser it will use the URL - using GetActiveBrowserURL()
> otherwise it will use the Windows Title of the currently active Window.  
> Can be omitted.

**Example:**

Standard Note template:

```

-- @NoteTime=yyyy-MM-dd hh:mm:ss@ -- ✄ ------------------------------

@clipboard@

-- @NoteUri@

```


### Credits

GetActiveBrowserURL() by Antonio Bueno. Source @ https://www.autohotkey.com/boards/viewtopic.php?t=3702
