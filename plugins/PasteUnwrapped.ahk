/*

Plugin            : PasteUnwrapped()
Purpose           : Paste current clipboard (top most in menu) unwrapped (one single line)
Version           : 1.0

History:
- first version 14 June 207

*/

PasteUnwrapped(Text)	{
	 text:=trim(RegExReplace(text,"ims)\s+"," "),"`n`r`t ")
	 return text
	}
	
