# CL3 API Functions v1.0

You can modify CL3's clipboard history via external scripts by using this API.

Notes:

- You need to Activate "API" via the Settings option first (tick the checkbox)
- Data returned from API functions is always an object. Not all functions return data, see available functions below.

## Getting started

You need to `#include cl3api.ahk` in your own script and call `CL3Api()` to connect to CL3 like so:

```autohotkey
CL3Api_Init()

; your functions

#include cl3api.ahk
CL3Api_Close()
```

## Available functions

### CL3Api_Paste(Data)

Data: A single entry or Array.

```autohotkey
CL3Api_Paste(2)             ; Single, paste the 2nd entry from the Clipboard history
CL3Api_Paste([2,4])         ; Multiple, paste the 2nd and 4th entries from the Clipboard history
```

### CL3Api_Get(Data)

CL3Api_Get() always returns an Array (Object)

Data: A single entry or Array.

```autohotkey
Array:=CL3Api_Get(2)        ; Single entry: get the second entry from the Clipboard history
MsgBox % Array[1]

Array:=CL3Api_Get([2,4])    ; Multiple, CSV: get the second and fourth entries from the Clipboard history
MsgBox % Array[1] "`n" Array[2]

```

### CL3Api_Upper(Data), CL3Api_Lower(Data), CL3Api_Title(Data)

Data: A single entry or Array.

```autohotkey
CL3Api_Upper(2)              ; Change 2nd entry in History to Upper case
CL3Api_Upper([2,5,8])        ; Change 2nd, 5th and 8th entries in History to Upper case
```

### CL3Api_Chain(Data)

Create a new Chain for the ClipChain paste plugin from the Array you're passing on.
More information about ClipChain here https://github.com/hi5/CL3#clipchain-v15

```autohotkey
Array:=["Apple","Pear","Orange"]
CL3Api_Chain(Array)          ; Create/Update new ClipChain
```

### CL3Api_ChainInsertAt(Index,String)

Insert "String" at "Index" position in the current ClipChain.

```autohotkey
CL3Api_ChainInsertAt(3,"Banana") ; Insert "Banana" at 3rd position in the current ClipChain
```

### CL3Api_ChainRemove(Index)

Index: A single entry or Array.

```autohotkey
CL3Api_ChainRemove(3)        ; Remove third item from History
CL3Api_ChainRemove([2,3,4])  ; Remove 2nd, 3rd and 4th item from ClipChain
```

### CL3Api_Slot(Index,String)

Insert "String" at "Index" position in the current Slot.
More information about Slots here https://github.com/hi5/CL3#slots-plugin-v12

```autohotkey
CL3Api_Slot(2,"AutoHotkey scripting language") ; Update 2nd slot with new text, to paste: Right-Control+2
```

### CL3Api_Burst(Object,Reverse=0)

You can add an Array to the Clipboard history using the burst function. Each item in the Array will be added as an individual entry in the history.
You can reverse the order so that the first item in the array is also the first item in the Clipboard history.

```autohotkey
Array:=["Apple","Pear","Orange"]
CL3Api_Burst(Array)
/*
Clipboard history will be:
a. Orange
b. Pear
c. Apple
*/

CL3Api_Burst(Array,1) ; reverse order
/*
Clipboard history will be:
a. Apple
b. Pear
c. Orange
*/

```

### CL3Api_FIFO(Index)

Turn FIFO on/off. Once started it will starting pasting entries in "first in first out" mode.
More about FIFO here https://github.com/hi5/CL3#FIFO-v17

```autohotkey
CL3Api_FIFO(4)              ; Activate FIFO from 4th entry.
; now you can start pasting in FIFO mode
CL3Api_FIFO(0)              ; Turn FIFO off at any time.
```

### CL3Api_InsertAt(Idx,Data)

Insert "Data" at "Index" position in the Clipboard History.

```autohotkey
CL3Api_InsertAt(3,"Banana") ; Insert "Banana" at 3rd position in the Clipboard History - e.g. "c"
```


### CL3Api_Remove(Data)

Remove entries from the Clipboard history.

Data: A single entry or Array.

```autohotkey
CL3Api_Remove(2)            ; Remove 2nd entry
CL3Api_Remove([2,3,4])      ; Remove 2nd, 3rd and 4th item from History
```

### CL3Api_Search(String,Results="-1")

Search the Clipboard history for "string" and return the **text** in an Array.
String is converted to a case insensitive regular expression and will find words independent on their position.
(e.g. "search this" will resturn all entries with the words 'search' AND 'this' somewhere in the text.
By default it returns all results, but you can limit the number of results.

```autohotkey
Array:=CL3Api_Search("find text")
MsgBox % Array[1]           ; 1st result, which is text, say the text of the 3rd entry.
```
### CL3Api_SearchIdx(String,Results="-1")

Search the Clipboard history for "string" - as CL3Api_Search() but return the **Index-es** in an Array.
By default it returns all results, but you can limit the number of results.

```autohotkey
Array:=CL3Api_SearchIdx("find text")
MsgBox % Array[1]           ; 1st result, which is a number, say '3', the index of the entry in the clipboard history.
```
