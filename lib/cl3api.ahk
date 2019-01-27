/*

#include CL3API.ahk

You can modify CL3's clipboard History, Slots and ClipChain via external scripts by using this API.
See docs\cl3api.md

Version           : 1.0
CL3 version       : 1.9.4

History:
- 1.0 initial version

*/

CL3Api_Init()
	{
	 global cl3api,CL3_MaxHistory
	 cl3api:=ComObjActive("{01DA04FA-790F-40B6-9FB7-CE6C1D53DC38}")
	}

CL3Api_Close()
	{
	 global cl3api
	 cl3api:=""
	}

CL3Api_Paste(Data,key="")
	{
	 global cl3api
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 cl3api.paste(jxon_dump(Data),key)
	 return 1
	}
	 
CL3Api_Upper(Data)
	{
	 global cl3api
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 cl3api.upper(jxon_dump(Data))
	 return 1
	}

CL3Api_Lower(Data)
	{
	 global cl3api
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 cl3api.lower(jxon_dump(Data))
	 return 1
	}

CL3Api_Title(Data)
	{
	 global cl3api
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 cl3api.title(jxon_dump(Data))
	 return 1
	}

CL3Api_Chain(Data)
	{
	 global cl3api
	 cl3api.chain(jxon_dump(Data))
	 return 1
	}

CL3Api_ChainInsertAt(Idx,Data)
	{
	 global cl3api
	 cl3api.ChainInsertAt(Idx,Data)
	 return 1
	}

CL3Api_ChainRemove(Idx)
	{
	 global cl3api
	 if !IsObject(Idx)
		cl3api.ChainRemove(Idx)
	 else
		for k, v in Idx
			cl3api.ChainRemove(v)
	 return 1
	}

CL3Api_Slot(Idx,Data)
	{
	 global cl3api
	 cl3api.slot(Idx,Data)
	 return 1
	}


CL3Api_Burst(Data,reverse=0)
	{
	 global cl3api
	 cl3api.burst(Data,reverse)
	 return 1
	}

CL3Api_Fifo(Data)
	{
	 global cl3api
	 cl3api.Fifo(Data)
	 return 1
	}

CL3Api_Get(Data)
	{
	 global cl3api,CL3_MaxHistory
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 return jxon_load(cl3api.get(jxon_dump(Data)))
	}

CL3Api_InsertAt(Idx,Data)
	{
	 global cl3api
	 cl3api.InsertAt(Idx,Data)
	 return 1
	}

CL3Api_Remove(Data)
	{
	 global cl3api
	 if !IsObject(Data)
		Data:=jxon_load("[" Data "]")
	 return jxon_load(cl3api.remove(jxon_dump(Data)))
	}

CL3Api_Search(String,Results="-1")
	{
	 global cl3api
	 return jxon_load(cl3api.search(String,Results))
	}

CL3Api_SearchIdx(String,Results="-1")
	{
	 global cl3api
	 return jxon_load(cl3api.searchIdx(String,Results))
	}

CL3Api_GetSetting(setting) ; not used 
	{
	 global cl3api
	 return cl3api.GetSetting(setting)
	}
