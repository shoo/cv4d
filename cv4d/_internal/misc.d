module cv4d._internal.misc;

import cv4d.opencv;
import core.memory;
static import std.utf, std.uni, std.path, std.string;
static import core.stdc.stdlib, core.stdc.stddef, core.stdc.locale;

private
{
	alias char mbchar;
	alias mbchar[] mbstring;
	alias mbchar* mbstringz;
	alias core.stdc.stddef.wchar_t wchar_t;
	alias std.utf.toUTF16 toString16;
	alias core.stdc.locale.setlocale setlocale;
	alias core.stdc.locale.LC_CTYPE LC_CTYPE;
	alias core.stdc.locale.LC_ALL LC_ALL;
	version (Windows)
	{
		static import core.sys.windows.windows;
		alias core.sys.windows.windows.MultiByteToWideChar MultiByteToWideChar;
		alias core.sys.windows.windows.WideCharToMultiByte WideCharToMultiByte;
		alias core.sys.windows.windows.IsDBCSLeadByte IsDBCSLeadByte;
		alias core.sys.windows.windows.CHAR CHAR;
		alias core.sys.windows.windows.WCHAR WCHAR;
		alias core.sys.windows.windows.LPCSTR LPCSTR;
		alias core.sys.windows.windows.LPCWSTR LPCWSTR;
		alias core.sys.windows.windows.BYTE BYTE;
	}
	else
	{
		static import core.stdc.limits;
		alias core.stdc.limits.MB_LEN_MAX MB_LEN_MAX;
		static import core.stdc.string;
		alias core.stdc.string.mbstate_t mbstate_t;
		alias core.stdc.string.wcrtomb wcrtomb;
		alias core.stdc.string.mbrtowc mbrtowc;
		alias core.stdc.string.mbsrtowcs mbsrtowcs;
		alias core.stdc.string.wcsrtombs wcsrtombs;
		alias tango.text.convert.Utf.toString32 toString32;
	}
}

version (Windows) {} else
{
	private Mutex g_LocaleMutex;
	static this()
	{
		g_LocaleMutex = new Mutex;
	}
	static ~this()
	{
		delete g_LocaleMutex;
	}
	private struct LocaleHandle
	{
		int category;
		char* oldloc;
		typeof(g_LocaleMutex) mutex;
	}
	void* setLocale(int category, string locale)
	{
		auto loc = locale ~ "\0";
		auto hnd = new LocaleHandle;
		hnd.category = category;
		hnd.mutex = g_LocaleMutex;
		hnd.mutex.lock();
		hnd.oldloc = setlocale(category, null);
		setlocale(category, loc.ptr);
		return cast(void*) hnd;
	}
	void* setLocale(string locale)
	{
		return setLocale(LC_CTYPE, locale);
	}
	void resetLocale(void* handle)
	{
		auto hnd = cast(LocaleHandle*)handle;
		scope (exit)
		{
			hnd.mutex.unlock;
			delete hnd;
		}
		setlocale(hnd.category, hnd.oldloc);
	}
}

mbstring toMBS(in char[] srcstr)
{
	version (Windows)
	{
		auto str = toString16(srcstr);
		auto srclen = cast(int)str.length;
		auto sz = WideCharToMultiByte(0, 0,
			str.ptr, srclen, null, 0, null, null);
		CHAR* tmp = cast(CHAR*)GC.malloc((sz+1)*CHAR.sizeof);
		auto len = WideCharToMultiByte(0, 0,
			str.ptr, srclen, tmp, sz+1, null, null);
		tmp[len] = '\0';
		return cast(mbstring)tmp[0..len];
	}
	else
	{
		static if (is(wchar_t == char))
		{
			auto str = srcstr;
		}
		else static if (is(wchar_t == wchar))
		{
			auto str = toString16(srcstr);
		}
		else
		{
			auto str = toString32(srcstr);
		}
		auto hLoc = setLocale(LC_CTYPE, "");
		scope (exit) resetLocale(hLoc);
		auto src = (str ~ "\0");
		mbstate_t dMbstate;
		auto psrc = src.ptr;
		auto sz = wcsrtombs(null, &psrc, 0, &dMbstate);
		if (sz == cast(size_t)-1) return null;
		mbchar* tmp = cast(mbchar*)GC.malloc((sz+1)*mbchar.sizeof);
		sz = wcsrtombs(cast(char*)tmp, &psrc, sz+1, &dMbstate);
		if (sz == cast(size_t)-1) return null;
		tmp[sz] = '\0';
		return cast(mbstring)tmp[0..sz];
	}
}

mbstringz toMBSz(in char[] str)
{
	auto tmp = toMBS(str);
	return (tmp ~ cast(mbchar)'\0').ptr;
}

string fromMBS(in mbchar[] str)
{
	version (Windows)
	{
		auto srclen = cast(int)str.length;
		auto sz = MultiByteToWideChar(0, 0, str.ptr, srclen, null, 0);
		WCHAR* tmp = cast(wchar*)GC.malloc((sz+1)*WCHAR.sizeof);
		auto len = MultiByteToWideChar(0, 0, str.ptr, srclen, tmp, sz+1);
		tmp[len] = '\0';
		return std.utf.toUTF8(cast(wstring)tmp[0..len]);
	}
	else
	{
		static if (is(wchar_t == char))
		{
			char[] dst;
		}
		else static if (is(wchar_t == wchar))
		{
			wchar[] dst;
		}
		else
		{
			dchar[] dst;
		}
		auto hLoc = setLocale(LC_CTYPE, "");
		scope (exit) resetLocale(hLoc);
		auto src = (str ~ "\0");
		mbstate_t dMbstate;
		auto psrc = src.ptr;
		auto sz = mbsrtowcs(null, &psrc, 0, &dMbstate);
		if (sz == cast(size_t)-1) return null;
		wchar_t* tmp = cast(wchar_t*)GC.malloc((sz+1)*wchar_t.sizeof);
		sz = mbsrtowcs(cast(char*)tmp, &psrc, sz+1, &dMbstate);
		if (sz == cast(size_t)-1) return null;
		tmp[sz] = '\0';
		return std.utf.toUTF8(cast(immutable(wchar_t)[])tmp[0..sz]);
	}
}

string fromMBSz(in mbchar* str)
{
	int i=0;
	while (str[i] != '\0') ++i;
	return fromMBS(str[0..i]);
}

bool isXmlOrYaml( in char[] filename )
{
	auto suffix = std.path.extension(filename.idup).dup;
	foreach (ref c; suffix) c = cast(char)std.uni.toLower(c);
	switch (suffix)
	{
	case ".xml":
	case ".yml":
	case ".yaml":
		return true;
	default:
		{
		}
	}
	return false;
}

void changeEndian(T)(ref T b)
{
	static if (is(T U: U[]))
	{
		foreach (ref x; b) changeEndian(x);
	}
	else
	{
		static if (T.sizeof == 16)
		{
			b = ((b & 0xff00)>>8) | (b & 0x0f);
		}
		else static if (T.sizeof == 32)
		{
			b = ((b & 0xff000000)>>24) | ((b & 0x00ff0000)>>8) | ((b & 0x0000ff00)<<8) | ((b & 0x0000000f)<<24);
		}
		else static if (T.sizeof == 64)
		{
			b = ((b & 0xff00000000000000L)>>54) | ((b & 0x00ff000000000000L)>>40) | ((b & 0x0000ff0000000000L)>>24) | ((b & 0x000000ff00000000L)>>8)
			  | ((b & 0x00000000000000ffL)<<54) | ((b & 0x000000000000ff00L)<<40) | ((b & 0x0000000000ff0000L)<<24) | ((b & 0x00000000ff000000L)<<8);
		}
		else static if (T.sizeof == 80)
		{
			union X
			{
				ubyte[10] b;
				U x;
			}
			X x;
			x.x = b;
			x.b[] = x.b.reverse[];
			b = x.x;
		}
	}
}
