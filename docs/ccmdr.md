# CCMDR plugin

CCMDR is an optional "expert" plugin which allows for (batch) operations on Clipboard History vs the usual one-by-one operations via standard CL3 options. Use at your own risk :)

Notes:

- You need to Activate this plugin via the Settings first (tick the checkbox)
- Default hotkey: <kbd>#</kbd>+<kbd>j</kbd> (change in settings)

General:

After pressing the CCMDR hotkey, a small input Gui will appear - press ESC or Hotkey again to close.  

Each "cmd" will consist of an "Action" by typing one or more letters followed by an "Index" or "Index Range".

Available actions are listed below. Short hints appear while typing.

## Actions:

### P

p : "Paste IDx (repeat) or range (IDx-IDy), e=enter, t=tab"

Example:

`p3` will paste the current clipboard 3 times  
`p3e` will paste the current clipboard 3 times with `enter` in between  
`p3t` will paste the current clipboard 3 times with `tab` in between  
`p1-3t` will paste the first three entries in the clipboard history with `tab` in between

Note: be careful as you can't stop the pasting action once it starts so p1000 will paste 1000 times!

### F

f : "FIFO IDx, e=enter, t=tab"

Similar to paste, only using the FIFO method.

Example:

`f3e` will paste the three most recent entries in the clipboard history in FIFO order: Item "c", "b" and "a" with `enter` in between

### Y

y : "Yank IDx or range (IDx-IDy)" yank (delete) items from the CL3 Clipboard history

`y5`   yank the first five items in the CL3 Clipboard history - "a" to "b" in the CL3 menu  
`y3-5` yank the 3rd to 5th items in the CL3 Clipboard history - "c" to "e" in the CL3 menu

### I

i : "Insert" will insert/move the current clipboard contents to the "Index" position.

Example:

`i5` will make the current clipboard contents the 5th item in the CL3 Clipboard history - "e" in the CL3 menu

### U L T

u : "Upper case" Index or Range  
l : "Lower case" Index or Range  
t : "Title case" Index or Range

Examples:

`u2`   will set the 2nd item in the CL3 Clipboard history to upper case - "b" in the CL3 menu  
`u1-5` will set the first five entries (1 to 5) in the CL3 Clipboard history to upper case - "a" to "e" in the CL3 menu

### S

s : "Store in Slot (1-10)" store Current clipboard contents in Slot 1 to 10

Example:

`s5` will make the current clipboard contents the 5th slot, you can paste this with <kbd>Right Control</kbd>+<kbd>5</kbd> - see Slots in the docs

### B

b : "Burst separator (\n, \t, \\, char or word)"  
rb: "Reverse burst"

Burst (split) the current clipboard contents into individual entries.

Example:

The clipboard contents is `apple,pear,cherry`

`b,` cherry, pear and apple are now items "a", "b" and "c" in the clipboard history:

```
a. cherry
b. pear
c. apple
```

`rb,` reverse it so, apple, pear and cherry are now items "a", "b" and "c" in the clipboard history:

```
a. apple
b. pear
c. cherry
```

