immutable
	DEFAULT_SRCDIR  = ["cv4d"],
	DEFAULT_OUTPUT  = "cv4d",
	DEFAULT_DOC     = false,
	DEFAULT_TEST    = false,
	DEFAULT_LIB     = true,
	DEFAULT_DEBUG   = false,
	DEFAULT_JSON    = true,
	DEFAULT_RELEASE = true,
	DEFAULT_WARNING = true,
	DEFAULT_OBJDIR  = ".",
	DEFAULT_GUI     = false;

import std.exception;
import std.stdio;
import std.path;
import std.process;
import std.file;
import std.string;
import std.array;
import std.algorithm;
import std.getopt;
import std.conv;

version (BUILD_DUMMY)
{
	void main(){}
}
else:
void main(string[] args)
{
	string[] srcdir;
	Options opt;
	getopt(args,
		std.getopt.config.bundling,
		"test|t", &opt.test,
		"lib|l", &opt.lib,
		"debug|d", &opt.dbg,
		"output|o", &opt.output,
		"object|O", &opt.obj,
		"gui|g", &opt.gui,
		"doc|D", &opt.doc,
		"json|j", &opt.json,
		"warn|w", &opt.warning,
		std.getopt.config.noBundling,
		"src|s", &srcdir);
	if (srcdir) opt.src = srcdir;
	while (!args.empty())
	{
		if (args.front() == "--")
		{
			args.popFront();
			break;
		}
		args.popFront();
	}
	opt.options ~= args[];
	
	int res;
	if (opt.doc)
	{
		res = makedoc(opt);
	}
	else
	{
		res = compile(opt);
		
		if (res == 0 && opt.test)
		{
			writeln("Begin testing...");
			res = system(opt.output);
			writeln("Complete testing!");
		}
		
	}
	stdout.flush();
	enforce(res == 0,
		"Program abnormal terminate with return code: " ~ to!string(res));
	writeln("Complete!");
}

struct Options
{
	bool test     = DEFAULT_TEST;
	bool lib      = DEFAULT_LIB;
	bool dbg      = DEFAULT_DEBUG;
	bool gui      = DEFAULT_GUI;
	bool doc      = DEFAULT_DOC;
	bool json     = DEFAULT_JSON;
	bool warning  = DEFAULT_WARNING;
	string[] src  = DEFAULT_SRCDIR;
	string obj    = DEFAULT_OBJDIR;
	string output = DEFAULT_OUTPUT;
	string[] options;
}


int compile(Options opt)
{
	string[] opts;
	
	if (opt.test)
	{
		opts ~= ["-debug", "-g", "-unittest", "-I."];
		if (opt.warning)     opts ~= "-w";
		if (opt.options)     opts ~= opt.options;
		if (opt.output)      opts ~= ["-of"~opt.output];
		foreach (s; opt.src) opts ~= listdir(s, "*.d");
		if (opt.lib)         opts ~= ["-version=BUILD_DUMMY", "-run", "build.d"];
	}
	else
	{
		if (opt.lib)     opts ~= ["-lib"];
		if (opt.dbg)     opts ~= ["-debug", "-g"];
		if (!opt.dbg)    opts ~= ["-release", "-inline", "-O"];
		if (opt.gui)     opts ~= ["-L/exet:nt/su:windows:4.0"];
		if (opt.output)  opts ~= ["-of"~opt.output];
		if (opt.obj)     opts ~= ["-od"~opt.obj];
		if (opt.warning) opts ~= ["-w"];
		if (opt.json)    opts ~= ["-X", "-Xf"~opt.output];
		if (opt.options) opts ~= opt.options;
		foreach (s; opt.src) opts ~= listdir(s, "*.d");
	}
	
	writeln("dmd " ~ std.string.join(opts, " "));
	
	return system("dmd " ~ std.string.join(opts, " "));
}


int makedoc(Options opt)
{
	string[] opts = ["-D", "-o-", "-c", "-Dddoc",
		"doc/candydoc/modules.ddoc",
		"doc/candydoc/candy.ddoc"];
	
	if (opt.dbg)     opts ~= ["-debug", "-g"];
	if (opt.warning) opts ~= ["-w"];
	if (!opt.dbg)    opts ~= ["-release", "-inline", "-O"];
	if (opt.options) opts ~= opt.options;
	
	string modules = "MODULES =\n";
	foreach (s; opt.src) foreach (ss; listdir(s, "*.d"))
	{
		char[] tmp = ss.dup;
		foreach (ref char c; tmp)
		{
			if (c == '\\') c = '/';
		}
		if (countUntil(tmp, "/_") != -1) continue;
		foreach (ref char c; tmp)
		{
			if (c == '/') c = '.';
		}
		
		auto name = cast(immutable)basename(tmp, ".d");
		modules ~= "	$(MODULE_FULL " ~ name ~ ")\n";
	}
	std.file.write("doc/candydoc/modules.ddoc", modules);
	
	foreach (s; opt.src) foreach (ss; listdir(s, "*.d"))
	{
		char[] tmp = ss.dup;
		foreach (ref char c; tmp)
		{
			if (c == '\\') c = '/';
		}
		if (countUntil(tmp, "/_") != -1) continue;
		foreach (ref char c; tmp)
		{
			if (c == '/') c = '.';
		}
		auto docopt = ["-Df" ~ cast(immutable)basename(tmp, ".d") ~ ".html", ss];
		writeln("dmd " ~ std.string.join(opts ~ docopt, " "));
		
		auto res = system("dmd " ~ std.string.join(opts ~ docopt, " "));
		if (res != 0) return res;
	}
	
	return 0;
}
