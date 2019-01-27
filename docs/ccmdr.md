# CCMDR plugin

CCMDR is an optional "expert" plugin which allows for (batch) operations on Clipboard History vs the usual one-by -ne operations via standard CL3 options. Use at your own risk :)

Notes:

- You need to Activate this pluging via the Settings first
- Default hotkey: #j (can be change in settings)

General:

After pressing the CCMDR hotkey a small input Gui will appear - press ESC or Hotkey again to close.  

Each "cmd" will consist of an "Action" by typing one or more letters followed by an "Index" or "Index Range".

Available actions are listed below. Short hints appear while typing.

## Actions:

### P

TODOp : "Paste IDx (repeat) or range (IDx-IDy), e=enter, t=tab"


### Y

y : "Yank IDx or range (IDx-IDy)" yank (delete) items from the CL3 Clipboard history

`y5`   yank the first five items in the CL3 Clipboard history - "a" to "b" in the CL3 menu
`y3-5` yank the 3rd to 5th items in the CL3 Clipboard history - "c" to "e" in the CL3 menu

### I

i: "Insert" will insert/move the current clipboard contents to the "Index" position.

Example:

`i5` will make the current clipboard contents the 5th item in the CL3 Clipboard history - "e" in the CL3 menu

### U L T

u : "Upper case" Index or Range
l : "Lower case" Index or Range
t : "Title case" Index or Range

Examples:

`u2`   will set the 2nd item in the CL3 Clipboard history to upper case - "b" in the CL3 menu 
`u1-5` will set the first five entries (1 to 5) in the CL3 Clipboard history to upper case - "a" to "e" in the CL3 menu 

# S

s : "Store in Slot (1-10)" store Current clipboard contents in Slot 1 to 10

Example:

`s5` will make the current clipboard contents the 5th slot, you can paste this with rightcontrol+1 - see Slots docs

#

b:"Burst seperator (\n, \t, \\, char or word)"
r : "Reverse"

f : "FIFO IDx, e=enter, t=tab"

