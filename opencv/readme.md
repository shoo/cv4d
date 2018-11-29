# File structions

This package can be used to solve dependent binaries.

- bin32/\*.dll (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x86/vc14/bin/\*.dll`)
- bin64/\*.dll (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x64/vc14/bin/\*.dll`)
- lib32-mscoff-dyamic (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x86/vc14/lib/\*.lib`)
- lib32-mscoff-static (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x86/vc14/staticlib/\*.lib`)
- lib64-mscoff-dynamic (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x64/vc14/lib/\*.lib`)
- lib64-mscoff-static (eg. `opencv-2.4.13.6-vc14.exe/opencv/build/x64/vc14/staticlib/\*.lib`)
- lib32-omf-dynamic (eg. `coffimplib opencv-2.4.13.6-vc14.exe/opencv/build/x86/vc14/lib/\*.lib` for help, coffimpliball.bat)


# Configurations

## dub.json

```json
{
	"dependencies": {
		"cv4d": {"version": "*", "optional": true}
	},
	"subConfigurations": {
		"cv4d": "win-dynamic"
	}
}
```

## dub.selection.json

```json
{
	"dependencies": {
		"cv4d":        {"path": "cv4d"},
		"cv4d:opencv": {"path": "cv4d/opencv"},
	}
}
```
