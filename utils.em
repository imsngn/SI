/* Utils.em - a small collection of useful editing macros */



/*-------------------------------------------------------------------------
	I N S E R T   H E A D E R

	Inserts a comment header block at the top of the current function. 
	This actually works on any type of symbol, not just functions.

	To use this, define an environment variable "MYNAME" and set it
	to your email name.  eg. set MYNAME=raygr
-------------------------------------------------------------------------*/
//http://blog.csdn.net/tankles/article/details/7269823
macro SwitchCppAndHpp()
{
hwnd = GetCurrentWnd()
hCurOpenBuf = GetCurrentBuf()
if (hCurOpenBuf == 0)// empty buffer
stop 


// 文件类型临时缓冲区
strFileExt = NewBuf("strFileExtBuf")
ClearBuf(strFileExt)

// 头文件
index_hpp_begin = 0 // 头文件开始索引
AppendBufLine(strFileExt, ".h")
AppendBufLine(strFileExt, ".hpp")
AppendBufLine(strFileExt, ".hxx")


index_hpp_end = GetBufLineCount(strFileExt) // 头文件结束索引

// 源文件
index_cpp_begin = index_hpp_end // 源文件开始索引
AppendBufLine(strFileExt, ".c")
AppendBufLine(strFileExt, ".cpp")
AppendBufLine(strFileExt, ".cc")
AppendBufLine(strFileExt, ".cx")
AppendBufLine(strFileExt, ".cxx")
index_cpp_end = GetBufLineCount(strFileExt) // 源文件结束索引




curOpenFileName = GetBufName(hCurOpenBuf)
curOpenFileName = ParseFilenameWithExt(curOpenFileName) // 获得不包括路径的文件名
curOpenFileNameWithoutExt = ParseFilenameWithoutExt(curOpenFileName)
curOpenFileNameLen = strlen(curOpenFileName)
//Msg(cat("current opened no ext filename:", curOpenFileNameWithoutExt))


isCppFile = 0 // 0：未知 1：头文件 2：源文件，默认未知扩展名
curOpenFileExt = "" // 当前打开文件的扩展名
index = index_hpp_begin 
// 遍历文件，判断文件类型
while(index < index_cpp_end) 
{
curExt = GetBufLine(strFileExt, index) 


if(isFileType(curOpenFileName, curExt) == True)// 匹配成功
{
if (index < index_hpp_end)
isCppFile = 1 // 当前打开文件是头文件
else
isCppFile = 2 // 源文件
break 
}
index = index + 1 
}// while(index < index_cpp_end)

// 调试
// AppendBufLine(debugBuf, isCppFile)


index_replace_begin = index_hpp_begin 
index_replace_end = index_hpp_end 

if (isCppFile == 1) // 当前打开文件是头文件 
{
index_replace_begin = index_cpp_begin 
index_replace_end = index_cpp_end 
}
else if(isCppFile == 2) // 当前打开文件是源文件
{
index_replace_begin = index_hpp_begin 
index_replace_end = index_hpp_end 
}
else // 未知类型
{
index_replace_begin = 9999 
index_replace_end = index_replace_begin // 下面循环不会执行
}

index = index_replace_begin 
while(index < index_replace_end)
{
destExt = GetBufLine(strFileExt, index) 
// 尝试当前目标扩展名是否能够打开
destFilename = AddFilenameExt(curOpenFileNameWithoutExt, destExt)


//Msg(destFilename)


hCurOpenBuf = OpenBuf(destFilename)
if(hCurOpenBuf != hNil)
{
SetCurrentBuf(hCurOpenBuf)
break 
}
else
{
//Msg("打开失败")
}

index = index + 1 
}
CloseBuf(strFileExt) // 关闭缓冲区
}




macro switch_cpp_hpp()
{
hwnd = GetCurrentWnd()
hCurOpenBuf = GetCurrentBuf()
if (hCurOpenBuf == hNil)// empty buffer
stop 


curOpenFileName = GetBufName(hCurOpenBuf)
curOpenFileNameLen = strlen(curOpenFileName)
// Msg(cat("current opened filename:", curOpenFileName))

// 文件类型临时缓冲区
strFileExt = NewBuf("strFileExtBuf")
ClearBuf(strFileExt)

// 头文件
index_hpp_begin = 0 // 头文件开始索引
AppendBufLine(strFileExt, ".h")
AppendBufLine(strFileExt, ".hpp")
index_hpp_end = GetBufLineCount(strFileExt) // 头文件结束索引

// 源文件
index_cpp_begin = index_hpp_end // 源文件开始索引
AppendBufLine(strFileExt, ".c")
AppendBufLine(strFileExt, ".cpp")
AppendBufLine(strFileExt, ".cc")
AppendBufLine(strFileExt, ".cx")
AppendBufLine(strFileExt, ".cxx")
index_cpp_end = GetBufLineCount(strFileExt) // 源文件结束索引


isCppFile = 0 // 0：未知 1：头文件 2：源文件，默认未知扩展名
curOpenFileExt = "" // 当前打开文件的扩展名
index = index_hpp_begin 
// 遍历头文件，判断是否当前打开文件是头文件类型
while(index < index_cpp_end) 
{
curExt = GetBufLine(strFileExt, index) 
curExtLen = strlen(curExt) 
curOpenFileExt = strmid(curOpenFileName, curOpenFileNameLen-curExtLen, curOpenFileNameLen) // 当前打开文件的扩展名

// 调试
// AppendBufLine(debugBuf, curExt)
// AppendBufLine(debugBuf, curOpenFileExt)



if(curOpenFileExt == curExt) // 匹配成功
{
if (index < index_hpp_end)
isCppFile = 1 // 当前打开文件是头文件
else
isCppFile = 2 // 源文件
break 
}
index = index + 1 
}// while(index < index_cpp_end)

// 调试
// AppendBufLine(debugBuf, isCppFile)


index_replace_begin = index_hpp_begin 
index_replace_end = index_hpp_end 

if (isCppFile == 1) // 当前打开文件是头文件 
{
index_replace_begin = index_cpp_begin 
index_replace_end = index_cpp_end 
}
else if(isCppFile == 2) // 当前打开文件是源文件
{
index_replace_begin = index_hpp_begin 
index_replace_end = index_hpp_end 

// 调试
// AppendBufLine(debugBuf, "cpp")
}
else // 未知类型
{
//CloseBuf(strFileExt) // 关闭缓冲区


//stop 

index_replace_begin = 9999 
index_replace_end = index_replace_begin // 下面循环不会执行
}

index = index_replace_begin 
while(index < index_replace_end)
{
destExt = GetBufLine(strFileExt, index) 
destFileName = strmid(curOpenFileName, 0, curOpenFileNameLen-strlen(curOpenFileExt)) // 不包括扩展名，绝对路径

// 尝试当前目标扩展名是否能够打开
destFilePath = cat(destFileName, destExt) // 文件名（包括扩展名）

// 调试
// AppendBufLine(debugBuf, destFilePath)


hCurOpenBuf = OpenBuf(destFilePath)
if(hCurOpenBuf != 0)
{
SetCurrentBuf(hCurOpenBuf)
break 
}

// 尝试进行目录替换，看能否打开文件（如何设计：支持多个目录）
// ...



index = index + 1 
}
CloseBuf(strFileExt) // 关闭缓冲区
// 调试
// AppendBufLine(debugBuf, "finished")

}


macro ParseFilenameWithExt(longFilename)
{
shortFilename = longFilename
len = strlen(longFilename)-1
if(len > 0)
{
while(True)
{
if(strmid(longFilename, len, len+1) == "\\")
break


len = len - 1
if(len <= 0)
break 
}
}
shortFilename = strmid(longFilename, len+1, strlen(longFilename))

return shortFilename
}
macro ParseFilenameWithoutExt(longFilename)
{
shortFilename = longFilename
len = strlen(longFilename)
dotPos = len
if(len > 0)
{
while(True)
{
len = len - 1
if(strmid(longFilename, len, len+1) == ".")
{
dotPos = len
break
}
if(len <= 0)
break 
}
}
shortFilename = strmid(longFilename, 0, dotPos)

return shortFilename
}
macro AddFilenameExt(filename, ext)
{
return cat(filename, ext)
}


macro isFileType(shortFilename, ext)
{
extLen = strlen(ext)
lastExtFilename = strmid(shortFilename, strlen(shortFilename)-extLen, strlen(shortFilename))
if(toupper(lastExtFilename) == toupper(ext))
return True


return False
}

macro InsertHeader()
{
	// Get the owner's name from the environment variable: MYNAME.
	// If the variable doesn't exist, then the owner field is skipped.
	szMyName = getenv(MYNAME)
	
	// Get a handle to the current file buffer and the name
	// and location of the current symbol where the cursor is.
	hbuf = GetCurrentBuf()
	szFunc = GetCurSymbol()
	ln = GetSymbolLine(szFunc)

	// begin assembling the title string
	sz = "/*   "
	
	/* convert symbol name to T E X T   L I K E   T H I S */
	cch = strlen(szFunc)
	ich = 0
	while (ich < cch)
		{
		ch = szFunc[ich]
		if (ich > 0)
			if (isupper(ch))
				sz = cat(sz, "   ")
			else
				sz = cat(sz, " ")
		sz = Cat(sz, toupper(ch))
		ich = ich + 1
		}
	
	sz = Cat(sz, "   */")
	InsBufLine(hbuf, ln, sz)
	InsBufLine(hbuf, ln+1, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	if (strlen(szMyName) > 0)
		{
		InsBufLine(hbuf, ln+2, "    Owner: @szMyName@")
		InsBufLine(hbuf, ln+3, " ")
		ln = ln + 4
		}
	else
		ln = ln + 2
	
	InsBufLine(hbuf, ln,   "    ") // provide an indent already
	InsBufLine(hbuf, ln+1, "-------------------------------------------------------------------------*/")
	
	// put the insertion point inside the header comment
	SetBufIns(hbuf, ln, 4)
}


/* InsertFileHeader:

   Inserts a comment header block at the top of the current function. 
   This actually works on any type of symbol, not just functions.

   To use this, define an environment variable "MYNAME" and set it
   to your email name.  eg. set MYNAME=raygr
*/

macro InsertFileHeader()
{
	szMyName = getenv(MYNAME)
	
	hbuf = GetCurrentBuf()

	InsBufLine(hbuf, 0, "/*-------------------------------------------------------------------------")
	
	/* if owner variable exists, insert Owner: name */
	InsBufLine(hbuf, 1, "    ")
	if (strlen(szMyName) > 0)
		{
		sz = "    Owner: @szMyName@"
		InsBufLine(hbuf, 2, " ")
		InsBufLine(hbuf, 3, sz)
		ln = 4
		}
	else
		ln = 2
	
	InsBufLine(hbuf, ln, "-------------------------------------------------------------------------*/")
}



// Inserts "Returns True .. or False..." at the current line
macro ReturnTrueOrFalse()
{
	hbuf = GetCurrentBuf()
	ln = GetBufLineCur(hbuf)

	InsBufLine(hbuf, ln, "    Returns True if successful or False if errors.")
}



/* Inserts ifdef REVIEW around the selection */
macro IfdefReview()
{
	IfdefSz("REVIEW");
}


/* Inserts ifdef BOGUS around the selection */
macro IfdefBogus()
{
	IfdefSz("BOGUS");
}


/* Inserts ifdef NEVER around the selection */
macro IfdefNever()
{
	IfdefSz("NEVER");
}


// Ask user for ifdef condition and wrap it around current
// selection.
macro InsertIfdef()
{
	sz = Ask("Enter ifdef condition:")
	if (sz != "")
		IfdefSz(sz);
}

macro InsertCPlusPlus()
{
	IfdefSz("__cplusplus");
}


// Wrap ifdef <sz> .. endif around the current selection
macro IfdefSz(sz)
{
	hwnd = GetCurrentWnd()
	lnFirst = GetWndSelLnFirst(hwnd)
	lnLast = GetWndSelLnLast(hwnd)
	 
	hbuf = GetCurrentBuf()
	InsBufLine(hbuf, lnFirst, "#ifdef @sz@")
	InsBufLine(hbuf, lnLast+2, "#endif /* @sz@ */")
}


// Delete the current line and appends it to the clipboard buffer
macro KillLine()
{
	hbufCur = GetCurrentBuf();
	lnCur = GetBufLnCur(hbufCur)
	hbufClip = GetBufHandle("Clipboard")
	AppendBufLine(hbufClip, GetBufLine(hbufCur, lnCur))
	DelBufLine(hbufCur, lnCur)
}


// Paste lines killed with KillLine (clipboard is emptied)
macro PasteKillLine()
{
	Paste
	EmptyBuf(GetBufHandle("Clipboard"))
}



// delete all lines in the buffer
macro EmptyBuf(hbuf)
{
	lnMax = GetBufLineCount(hbuf)
	while (lnMax > 0)
		{
		DelBufLine(hbuf, 0)
		lnMax = lnMax - 1
		}
}


// Ask the user for a symbol name, then jump to its declaration
macro JumpAnywhere()
{
	symbol = Ask("What declaration would you like to see?")
	JumpToSymbolDef(symbol)
}

	
// list all siblings of a user specified symbol
// A sibling is any other symbol declared in the same file.
macro OutputSiblingSymbols()
{
	symbol = Ask("What symbol would you like to list siblings for?")
	hbuf = ListAllSiblings(symbol)
	SetCurrentBuf(hbuf)
}


// Given a symbol name, open the file its declared in and 
// create a new output buffer listing all of the symbols declared
// in that file.  Returns the new buffer handle.
macro ListAllSiblings(symbol)
{
	loc = GetSymbolLocation(symbol)
	if (loc == "")
		{
		msg ("@symbol@ not found.")
		stop
		}
	
	hbufOutput = NewBuf("Results")
	
	hbuf = OpenBuf(loc.file)
	if (hbuf == 0)
		{
		msg ("Can't open file.")
		stop
		}
		
	isymMax = GetBufSymCount(hbuf)
	isym = 0;
	while (isym < isymMax)
		{
		AppendBufLine(hbufOutput, GetBufSymName(hbuf, isym))
		isym = isym + 1
		}

	CloseBuf(hbuf)
	
	return hbufOutput

}
