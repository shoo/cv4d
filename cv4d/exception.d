/*******************************************************************************
 * 
 */
module cv4d.exception;

import cv4d.opencv;
version (Windows)
{
	import std.windows.charset;
}
else
{
	import cv4d._internal.misc;
}

/*******************************************************************************
 * OpenCVから投げられる例外
 */
class CvException: Exception
{
	int status=0;
	char[] func = null;
	
	
	this(string msg, string file=__FILE__, size_t line=__LINE__) @safe pure nothrow
	{
		super(msg, file, line, null);
	}
	
	
	this(string msg, int status, in char[] func,
	     string file=__FILE__, size_t line=__LINE__) @safe pure nothrow
	{
		super(msg, file, line);
	}
}

/*******************************************************************************
 * OpenCVにセットする例外ハンドラ
 */
struct ErrorHandler
{
public:
	alias bool delegate(string msg, int status, string func,
	                    string file, int line) Handler;
private:
	Handler _handler;
	CvErrorCallback _oldCallback;
	void* _oldData;
	
	
	static extern (C) int hndCvEr( int status, in char* func_name,
	                               in char* err_msg, in char* file_name,
	                               int line, void* userdata )
	{
		auto hEr = cast(ErrorHandler*)userdata;
		auto funcName = fromMBSz(cast(immutable)func_name);
		auto errorMsg = fromMBSz(cast(immutable)err_msg);
		auto fileName = fromMBSz(cast(immutable)file_name);
		return hEr._handler(errorMsg, status, funcName, fileName, line);
	}
	
	
public:
	
	
	/***************************************************************************
	 * ハンドラをセットする
	 */
	void set(Handler handler)
	{
		_handler = handler;
		_oldCallback = cvRedirectError(&hndCvEr, cast(void*)&this, &_oldData);
	}
	
	
	/***************************************************************************
	 * ハンドラをリセットする
	 */
	void reset()
	{
		cvRedirectError(_oldCallback, _oldData, null);
	}
}

/*******************************************************************************
 * OpenCVに例外ハンドラを設定する
 */
ErrorHandler setCvErrorHandler(ErrorHandler.Handler hnd)
{
	ErrorHandler er;
	er.set(hnd);
	return er;
}

/*******************************************************************************
 * OpenCVにデフォルトの例外ハンドラを設定する
 */
ErrorHandler setCvErrorHandler()
{
	return setCvErrorHandler(
		delegate bool (string msg,
		              int status, string func, string file, int line)
		{
			throw new CvException(msg, status, func, file, line);
		});
}

