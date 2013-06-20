module cv4d.util;

import cv4d.opencv;
import cv4d.image, cv4d.matrix, cv4d.exception;


/*******************************************************************************
 * IplImageをImageに変換する
 * 
 * 内部でcvReleaseImageされるため、この関数を通したIplImageは開放してはならない
 */
Image toImage(IplImage* img)
{
	return new class Image
	{
		this()
		{
			_image = img;
		}
	};
}


/*******************************************************************************
 * IplImageを参照するImageを生成
 * 
 * IplImageを参照するImageを生成するため、Matrixが削除された後に必ず
 * cvReleaseImageなどを呼び出してIplImageを開放すること
 */
Image refImage(IplImage* img)
{
	return new class Image
	{
		this()
		{
			_image = img;
		}
		~this()
		{
			_image = null;
		}
	};
}


/*******************************************************************************
 * CvMatをMatrixに変換する
 * 
 * 内部でcvReleaseMatされるため、この関数を通したCvMatは開放してはならない
 */
Matrix toMatrix(CvMat* mat)
{
	return new class Matrix
	{
		this()
		{
			_matrix = mat;
		}
	};
}


/*******************************************************************************
 * CvMatを参照するMatrixを生成
 * 
 * CvMatを参照するMatrixを生成するため、Matrixが削除された後に必ず
 * cvReleaseMatなどを呼び出してCvMatを開放すること
 */
Matrix refMatrix(CvMat* mat)
{
	return new class Matrix
	{
		this()
		{
			_matrix = mat;
		}
		~this()
		{
			_matrix = null;
		}
	};
}


/*******************************************************************************
 * 画像を指定の形式にエンコード
 */
Matrix encodeImage(Image img, char[] ext, in int[] params = null)
{
	auto extptr = (ext~'\0').ptr;
	auto paramptr = params ? (params~0).ptr : null;
	return toMatrix(cvEncodeImage(extptr, img.handle, paramptr));
}


/*******************************************************************************
 * 二つの画像の画素を巡回するイテレータを生成する
 */
auto byPairPixels(Color = ubyte)(Image a, Image b)
{
	struct Range
	{
		private Image a, b;
		int opApply(int delegate(ref Color, ref Color) dg)
		{
			int r;
			for (int y = 0; y<a.height; ++y)
			{
				assert(a.roiRow(y).length % Color.sizeof == 0);
				assert(b.roiRow(y).length % Color.sizeof == 0);
				auto pixelsa = cast(Color[]) a.roiRow(y),
				     pixelsb = cast(Color[]) b.roiRow(y),
				     pa = pixelsa.ptr,
				     pb = pixelsb.ptr,
				     pend = pa + pixelsa.length;
				while (pa !is pend)
				{
					if ((r = dg(*pa++, *pb++)) != 0) return r;
				}
			}
			return r;
		}
	}
	return Range(a, b);
}


/*******************************************************************************
 * レベル補正
 * 
 * 最低値から最大値の間のヒストグラムを引きのばします
 */
void levelCorrection(Image img, int low=0, int high=255)
	in
	{
		assert(img);
		assert(low < high);
		assert(high <= 256);
	}
	body
{
	static real divpt(real min, real max, real pt)
	{
		auto x =  (1-pt)*min+pt*max;
		return x;
	}
	int ch;
	switch (img.channels)
	{
	case 1: ch = CV_8UC1; break;
	case 3: ch = CV_8UC3; break;
	case 4: ch = CV_8UC4; break;
	default: throw new CvException("incorrect channels");
	}
	auto lut = new Matrix(1, 256, ch);
	immutable h = high;
	immutable l = low;
	switch (img.channels)
	{
	case 1:
		(cast(ubyte[])lut.data)[0..l] = 0;
		for (int i=l; i<h; ++i)
		{
			assert((i-l)/cast(double)(h-l) <= 1);
			assert(0 <= (i-l)/cast(double)(h-l));
			auto v = cast(ubyte)cvRound(divpt(0, 255, (i-l)/cast(double)(h-l)));
			(cast(ubyte[])lut.data)[i] = v;
		}
		(cast(ubyte[])lut.data)[h..$] = 255;
		break;
	case 3:
		for (int i=0; i<l; ++i)
		{
			(cast(ubyte[3][])lut.data)[i][] = 0;
		}
		for (int i=l; i<h; ++i)
		{
			assert((i-l)/cast(double)(h-l) <= 1);
			assert(0 <= (i-l)/cast(double)(h-l));
			auto v = cast(ubyte)cvRound(divpt(0, 255, (i-l)/cast(double)(h-l)));
			(cast(ubyte[3][])lut.data)[i][] = v;
		}
		for (int i=h; i<256; ++i)
		{
			(cast(ubyte[3][])lut.data)[i][] = 255;
		}
		break;
	case 4:
		for (int i=0; i<l; ++i)
		{
			(cast(ubyte[4][])lut.data)[i][] = 0;
		}
		for (int i=l; i<h; ++i)
		{
			assert((i-l)/cast(double)(h-l) <= 1);
			assert(0 <= (i-l)/cast(double)(h-l));
			auto v = cast(ubyte)cvRound(divpt(0, 255, (i-l)/cast(double)(h-l)));
			(cast(ubyte[4][])lut.data)[i][] = v;
		}
		for (int i=h; i<256; ++i)
		{
			(cast(ubyte[4][])lut.data)[i][] = 255;
		}
		break;
	default: throw new CvException("incorrect channels");
	}
	
	img.applyLUT(lut);
	delete lut;
}


/*******************************************************************************
 * アルファブレンディング
 * 
 * brendfunc関数はpixelごとの処理を行い、 base = berendfunc(base, sup);をする
 */
void alphaBrending(alias brendfunc)(Image base, Image sup)
{
	switch (base.channels)
	{
	case 1:
		foreach (s, ref d; byPairPixels!(ubyte)(sup, base))
		{
			d = brendfunc(d, s);
		}
		break;
	case 3:
		struct BGR
		{
		align(1):
			ubyte b,g,r;
		}
		foreach (ref s, ref d; byPairPixels!(BGR)(sup, base))
		{
			d.b = brendfunc(d.b, s.b, 255);
			d.g = brendfunc(d.g, s.g, 255);
			d.r = brendfunc(d.r, s.r, 255);
		}
		break;
	case 4:
		struct BGRA
		{
			align(1):
			ubyte b,g,r,a;
		}
		foreach (s, ref d; byPairPixels!(BGRA)(sup, base))
		{
			d.b = brendfunc(d.b, s.b, ((cast(int)s.a)*d.a)/255);
			d.g = brendfunc(d.g, s.g, ((cast(int)s.a)*d.a)/255);
			d.r = brendfunc(d.r, s.r, ((cast(int)s.a)*d.a)/255);
		}
		break;
	default:
		throw new CvException("incorrect channels");
	}
}


/*******************************************************************************
 * トーンカーブ
 */
void toneCurve(alias curvefunc)(Image img)
{
	
}


/*******************************************************************************
 * グロー効果
 */
void glowEffect(Image img)
{
	auto tmp = new Image(img);
	scope (exit) delete tmp;
	levelCorrection(tmp, 224, 256);
	tmp.smooth(CV_GAUSSIAN, 0, 0, 10, 0);
	static ubyte brendfunc(int d, int s, int a = 255)
	{
		auto v = s+d-s*d/a;
		if (v < 0) v = 0;
		if (v > 255) v = 255;
		return cast(ubyte)v;
	}
	alphaBrending!brendfunc(img, tmp);
}
