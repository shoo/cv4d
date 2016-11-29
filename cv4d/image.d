/*******************************************************************************
 * 
 */
module cv4d.image;

import cv4d.opencv;
import cv4d.exception, cv4d.matrix, cv4d._internal.misc;

private void error(string msg, string file = __FILE__, size_t line = __LINE__) pure
{
	throw new CvException(msg, file, line);
}


/*******************************************************************************
 * ビットマップフォーマットのファイルヘッダ
 */
align (1) struct BitmapFileHeader
{
	union
	{
		struct
		{
			ubyte typeH = 0x42;
			ubyte typeL = 0x4d;
		}
		/***********************************************************************
		 * "BM"
		 */
		ushort type;
	}
	/***************************************************************************
	 * ファイルサイズ
	 * 
	 * 要変更
	 */
	uint size = 0;
	/***************************************************************************
	 * 予約
	 * 
	 * 常に0
	 */
	ushort reserved1 = 0;
	/***************************************************************************
	 * 予約
	 * 
	 * 常に0
	 */
	ushort reserved2 = 0;
	/***************************************************************************
	 * データの開始位置のオフセット
	 * 
	 * BitmapInformationHeader以外であれば要変更
	 * BitmapFileHeader.sizeof + BitmapInformationHeader.sizeof
	 */
	uint offset = 54;
}

/*******************************************************************************
 * ビットマップフォーマットの情報ヘッダ
 */
align (1) struct BitmapInformationHeader
{
	/***************************************************************************
	 * この構造体のサイズ
	 * 
	 * 常に40
	 */
	uint size = BitmapInformationHeader.sizeof;
	/***************************************************************************
	 * 画像の横幅
	 * 
	 * 要変更
	 */
	int width = 0;
	/***************************************************************************
	 * 画像の縦幅
	 * 
	 * 要変更
	 */
	int height = 0;
	/***************************************************************************
	 * プレーン数
	 * 
	 * 常に1
	 */
	ushort planes = 1;
	/***************************************************************************
	 * 1ピクセル当たりのビット数
	 * 
	 * 32bit以外であれば要変更
	 */
	ushort bitCount = 32;
	/***************************************************************************
	 * 圧縮
	 * 
	 * 0であれば無圧縮
	 * それ以外であれば要変更
	 */
	uint compression = 0;
	/***************************************************************************
	 * 画像のバイトサイズ
	 * 
	 * 要変更
	 */
	uint sizeImage = 0;
	
	/***************************************************************************
	 * 横方向解像度[pixel/m]
	 * 
	 * 96dpiで3780
	 */
	int xPixPerMeter = 3780;
	/***************************************************************************
	 * 縦方向解像度[pixel/m]
	 * 
	 * 96dpiで3780
	 */
	int yPixPerMeter = 3780;
	/***************************************************************************
	 * 色パレット数
	 * 
	 * パレットを使用する場合は要変更
	 */
	uint clrUsed = 0;
	/***************************************************************************
	 * 重要色数
	 */
	uint cirImportant = 0;
}

/*******************************************************************************
 * ビットマップファイルの構造
 * 
 * 必ずメモリ上にビット列を含めた十分なサイズを設けること。
 * Example:
 * -----------------------------------------------------------------------------
 * auto bmp = cast(BitmapFileData*)new ubyte[bmpsz];
 * -----------------------------------------------------------------------------
 * 等とすること。
 */
struct BitmapFileData
{
	BitmapFileHeader file;
	BitmapInformationHeader info;
	uint[] palette()
	{
		return (cast(uint*)((cast(ubyte*)&info) +
		        BitmapInformationHeader.sizeof))[0..256];
	}
	void[] dib()
	{
		return ((cast(ubyte*)&this) + file.offset)[0..info.sizeImage];
	}
}


/*******************************************************************************
 * OpenCVを利用した画像
 * 
 * C++のCvImageに制限(オブジェクトが存在する限り、必ず画像を持っている)を加え、
 * Dらしさを出せるように手をくわえ、ちょっとしたユーティリティを追加した。
 */
class Image
{
protected:
	
	
	/***************************************************************************
	 * OpenCVで扱うことのできる生のIplImage*
	 */
	IplImage* _image = null;
	
	
	//invariant()
	//{
	//	assert(_image !is null);
	//}
	
	
	/***************************************************************************
	 * 内部的にであれば何もしないコンストラクタを呼び出すことが可能
	 * 
	 * ただし、必ず _image は何らかの画像で初期化される必要があり、
	 * デストラクタが呼ばれる際には、確実に _image を null とするか、
	 * cvReleaseImage によって解放されてもよい画像を指定しておくこと
	 */
	this()
	{
		
	}
	
	
private:
	
	
	static IplImage* retrieveImage(void* obj)
	{
		IplImage* img = null;
		if( CV_IS_IMAGE(obj) )
		{
			img = cast(IplImage*)obj;
		}
		else if( CV_IS_MAT(obj) )
		{
			CvMat* m = cast(CvMat*)obj;
			img = cvCreateImageHeader(
				cvSize(m.cols,m.rows),
				CV_MAT_DEPTH(m.type),
				CV_MAT_CN(m.type) );
			cvSetData( img, m.data.ptr, m.step );
			img.imageDataOrigin = cast(ubyte*)m.refcount;
			m.data.ptr = null;
			m.step = 0;
			cvReleaseMat( &m );
		}
		else if( obj )
		{
			cvRelease( &obj );
			error( "The object is neither an image, nor a matrix" );
		}
		return img;
	}
	
	
public:
	
	
	/***************************************************************************
	 * OpenCVでの操作用
	 */
	@property IplImage* handle()
	{
		return _image;
	}
	
	
	@property const(IplImage)* handle() const
	{
		return _image;
	}
	
	
	/***************************************************************************
	 * サイズ、色深度、チャンネル数を指定して作成
	 */
	this( CvSize size, int depth=IPL_DEPTH_8U, int channels=3 )
	{
		_image = cvCreateImage( size, depth, channels );
		if (_image is null) error("cannot create image.");
	}
	
	
	/***************************************************************************
	 * 外部の画像からクローンを作成
	 */
	this( in IplImage* img )
	in
	{
		assert(img !is null);
	}
	body
	{
		auto tmp = cvCloneImage(img);
		if (!tmp) error("cannot create clone.");
		_image = tmp;
	}
	
	
	///ditto
	this(in Image img)
	{
		this(img._image);
	}
	
	
	/***************************************************************************
	 * ファイル名と画像名、色から画像をロード
	 */
	this( in char[] filename, in char[] imgname,
	      int color=CV_LOAD_IMAGE_ANYDEPTH | CV_LOAD_IMAGE_ANYCOLOR )
	{
		IplImage* img = null;
		
		if( isXmlOrYaml(filename) )
		{
			img = retrieveImage(cvLoad(toMBSz(filename), null,toMBSz(imgname)));
			scope (failure) cvReleaseImage(&img);
			if( (img.nChannels > 1) != (color == 0) )
			{
				error("RGB<->Grayscale conversion is not "
				     ~"implemented for images stored in XML/YAML" );
			}
		}
		else
		{
			img = cvLoadImage( toMBSz(filename), color );
		}
		_image = img;
		if (!_image) error("cannot load");
	}
	
	
	/***************************************************************************
	 * ファイル名と色から画像をロード
	 */
	this( in char[] filename, int color=CV_LOAD_IMAGE_ANYCOLOR )
	{
		this(filename, null, color);
	}
	
	
	/***************************************************************************
	 * ストレージとマップから画像をロード
	 */
	this( CvFileStorage* fs, in char[] mapname, in char[] imgname )
	{
		void* obj = null;
		if( mapname.length )
		{
			CvFileNode* mapnode =
				cvGetFileNodeByName(fs, null, toMBSz(mapname));
			if( !mapnode ) obj = cvReadByName( fs, mapnode, toMBSz(imgname) );
		}
		else
		{
			obj = cvReadByName( fs, null, toMBSz(imgname) );
		}
		
		if (!obj) error("cannot load");
		_image = retrieveImage(obj);
		if (!_image) error("cannot load");
	}
	
	
	/***************************************************************************
	 * ストレージとシーケンス名からロード
	 */
	this( CvFileStorage* fs, in char[] seqname, int idx )
	{
		void* obj = null;
		
		CvFileNode* seqnode = seqname.length
			? cvGetFileNodeByName(fs, null, toMBSz(seqname))
			: cvGetRootFileNode(fs, 0);
		
		if( seqnode && CV_NODE_IS_SEQ(seqnode.tag) )
		{
			obj = cvRead(fs,
				cast(CvFileNode*)cvGetSeqElem(seqnode.data.seq, idx));
		}
		
		if (!obj) error("cannot load");
		
		_image = retrieveImage(obj);
		if (!_image) error("cannot load");
	}
	
	
	/***************************************************************************
	 * メモリ上のBMPファイルから読み込んで作成
	 */
	this(in void[] imagedata,
	     int color = CV_LOAD_IMAGE_ANYDEPTH | CV_LOAD_IMAGE_ANYCOLOR)
	{
		auto m = cvCreateMatHeader(1, cast(int)imagedata.length, CV_MAKETYPE(CV_8U,1));
		scope (exit) cvReleaseMat(&m);
		cvSetData(m, cast(void*)imagedata.ptr, m.step);
		_image = cvDecodeImage(m, color);
	}
	
	
	/***************************************************************************
	 * デストラクタ
	 * 
	 * 画像を開放する。
	 */
	~this()
	{
		if (_image) cvReleaseImage( &_image );
		_image = null;
	}
	
	
	/***************************************************************************
	 * 画像を指定のファイル名で保存する
	 */
	void save(in char[] filename, in char[] imgname,
		in char[] comment = null, CvAttrList attr=cvAttrList()) const
	{
		cvSave( toMBSz(filename), _image, toMBSz(imgname),
			comment ? toMBSz(comment): null, attr );
	}
	
	
	///ditto
	void save( in char[] filename, in int[] param = null) const
	{
		cvSaveImage( toMBSz(filename), _image, param ? (param~0).ptr : null );
	}
	
	
	///ditto
	void save(void delegate(in void[]) dg,
	          string ext = "png", in int[] param = null)
	{
		auto extptr = (ext~'\0').ptr;
		auto paramptr = param ? (param~0).ptr : null;
		auto m = cvEncodeImage(extptr, _image, paramptr);
		scope (exit) cvReleaseMat(&m);
		dg(m.data.ptr[0..m.cols]);
	}
	
	
	/***************************************************************************
	 * BitmapInformationHeaderを生成
	 */
	void makeBitmapInfo(out BitmapInformationHeader bmi) const
	{
		static int ABS(int a){return a<0?-a:a;}
		bmi.width = width;
		bmi.height = origin ? ABS(height) : -ABS(height);
		assert(pixSize * 8 >= 0);
		assert(pixSize * 8 < 0xffff);
		bmi.bitCount = (pixSize * 8) & 0xffff;
	}
	
	
	/***************************************************************************
	 * 画像の描きだし
	 */
	void write( CvFileStorage* fs, in char[] imgname ) const
	{
		cvWrite( fs, toMBSz(imgname), _image );
	}
	
	
	/***************************************************************************
	 * 画像の横幅を取得
	 */
	@property int width() const
	{
		return _image.width;
	}
	
	
	/***************************************************************************
	 * 画像の縦幅を取得
	 */
	@property int height() const
	{
		return _image.height;
	}
	
	
	/***************************************************************************
	 * 画像のサイズを取得
	 */
	@property CvSize size() const
	{
		return cvSize(_image.width, _image.height);
	}
	
	
	/***************************************************************************
	 * 範囲の矩形のサイズ
	 */
	@property CvSize roiSize() const
	{
		return !_image.roi ? cvSize(_image.width,_image.height) :
			cvSize(_image.roi.width, _image.roi.height);
	}
	
	/***************************************************************************
	 * 範囲の矩形のサイズ
	 */
	@property CvPoint roiOffset() const
	{
		return !_image.roi ? cvPoint(0, 0) :
			cvPoint(_image.roi.xOffset, _image.roi.yOffset);
	}
	
	
	/***************************************************************************
	 * 範囲の矩形プロパティ
	 */
	@property CvRect roi() const
	{
		return !_image.roi
			? cvRect(0,0,_image.width,_image.height)
			: cvRect(_image.roi.xOffset, _image.roi.yOffset,
			         _image.roi.width,   _image.roi.height);
	}
	
	
	///ditto
	@property void roi(CvRect r)
	{
		cvSetImageROI(_image, r);
	}
	
	
	/***************************************************************************
	 * 範囲をリセットする
	 */
	void resetRoi()
	{
		cvResetImageROI(_image);
	}
	
	
	/***************************************************************************
	 * COIのプロパティ
	 */
	@property int coi() const
	{
		return !_image.roi ? 0 : _image.roi.coi;
	}
	
	
	/// ditto
	@property void coi(int c)
	{
		cvSetImageCOI(_image, c);
	}
	
	
	/***************************************************************************
	 * 色深度
	 */
	@property int depth() const
	{
		return _image.depth;
	}
	
	
	/***************************************************************************
	 * チャンネル数
	 */
	@property int channels() const
	{
		return _image.nChannels;
	}
	
	
	/***************************************************************************
	 * 1ピクセルのバイト数
	 */
	@property int pixSize() const
	{
		return ((depth & 255)>>3)*channels;
	}
	
	
	/***************************************************************************
	 * 画素のデータにアクセス
	 */
	@property void[] data()
	{
		return (cast(void*)_image.imageData)
			[0.._image.widthStep*_image.height];
	}
	/// ditto
	@property const(void)[] data() const
	{
		return (cast(void*)_image.imageData)
			[0.._image.widthStep*_image.height];
	}
	
	/***************************************************************************
	 * 1行何バイトか
	 */
	@property int step() const
	{
		return _image.widthStep;
	}
	
	
	/***************************************************************************
	 * データ開始点
	 */
	@property int origin() const
	{
		return _image.origin;
	}
	
	
	/***************************************************************************
	 * 範囲の画素のデータにアクセス
	 */
	void[] roiRow(int y)
		out(r)
		{
			assert(r.length % _image.nChannels == 0);
		}
		body
	{
		assert(0<=y);
		assert(_image.roi ? y<_image.roi.height : y<_image.height);
		
		if (!_image.roi)
		{
			return (cast(void*)(_image.imageData + y*_image.widthStep))
				[0.._image.width*pixSize];
		}
		else
		{
			auto st = _image.roi.xOffset*pixSize;
			auto ed = st + _image.roi.width*pixSize;
			auto ofs = (y+_image.roi.yOffset)*_image.widthStep;
			return (cast(void*)(_image.imageData + ofs))[st..ed];
		}
	}
	
	
	///ditto
	const(void)[] roiRow(int y) const
	{
		assert(0<=y);
		assert(_image.roi ? y<_image.roi.height : y<_image.height);
		
		if (!_image.roi)
		{
			return (cast(void*)(_image.imageData + y*_image.widthStep))
				[0.._image.width*pixSize];
		}
		else
		{
			auto st = _image.roi.xOffset*pixSize;
			auto ed = st + _image.roi.width*pixSize;
			auto ofs = (y+_image.roi.yOffset)*_image.widthStep;
			return (cast(void*)(_image.imageData + ofs))[st..ed];
		}
	}
	
	
	//##########################################################################
	//##### 
	//##### 基本的な画像処理
	//##### 
	//##########################################################################
	
	/***************************************************************************
	 * 各画素に与えられた値をセットする
	 */
	void set(CvScalar value, in Image mask = null)
	{
		cvSet(_image, value, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 全ての画素値を0にする
	 */
	void setZero()
	{
		cvZero(_image);
	}
	
	
	/***************************************************************************
	 * コピー
	 */
	void copy(in Image src, in Image mask = null)
	in
	{
		assert(depth == src.depth);
		assert(roiSize == src.roiSize);
		assert(channels == src.channels);
		if (mask)
		{
			assert(mask.channels == 1);
			assert(mask.depth == IPL_DEPTH_8U || mask.depth == IPL_DEPTH_8S);
		}
	}
	body
	{
		cvCopy(src._image, _image, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 画像のリサンプル
	 */
	void resample(in Image img, int interpolation=CV_INTER_LINEAR)
	{
		cvResize(img._image, _image, interpolation);
	}
	
	
	/***************************************************************************
	 * 縦横比固定でリサンプル(クロップする)
	 */
	void fixedResample(in Image img,
		int interpolation=CV_INTER_LINEAR, CvScalar scalar = cvScalarAll(0))
	{
		if (roiSize != img.roiSize)
		{
			auto w = roiSize.width;
			auto h = roiSize.height;
			auto myAspect = w/cast(double)h;
			auto imgAspect = img.roiSize.width/cast(double)img.roiSize.height;
			if (img.roiSize.width == cvRound(img.roiSize.height*myAspect))
			{
				// アスペクト比同じでサイズ違い
				resample(img, interpolation);
			}
			else if (imgAspect < myAspect)
			{
				// 縦長
				bool resetroi = _image.roi is null;
				auto oldroi = roi;
				scope (exit)
				{
					if (resetroi)
					{
						resetRoi();
					}
					else
					{
						roi = oldroi;
					}
				}
				// プリントする新しい横幅
				auto newW = cast(int)cvRound(h * imgAspect);
				// 横のクロップの広さ
				auto blackw = (w - newW)/2;
				if (blackw)
				{
					roi = cvRect(oldroi.x, oldroi.y, blackw, h);
					set(scalar);
				}
				roi = cvRect(oldroi.x+blackw, oldroi.y, newW, h);
				resample(img);
				if (w-newW-blackw)
				{
					roi = cvRect(oldroi.x+newW+blackw, oldroi.y,
					             w-newW-blackw, h);
					set(scalar);
				}
			}
			else
			{
				// 横長
				bool resetroi = _image.roi is null;
				auto oldroi = roi;
				scope (exit)
				{
					if (resetroi)
					{
						resetRoi();
					}
					else
					{
						roi = oldroi;
					}
				}
				// 新しい縦幅
				auto newH = cast(int)cvRound(w / imgAspect);
				
				// 横の黒帯の広さ
				auto blackh = (h - newH)/2;
				if (blackh)
				{
					roi = cvRect(oldroi.x, oldroi.y, w, blackh);
					set(scalar);
				}
				roi = cvRect(oldroi.x, oldroi.y+blackh, w, newH);
				resample(img, interpolation);
				if (h-newH-blackh)
				{
					roi = cvRect(oldroi.x, oldroi.y+newH+blackh,
					             w, h-newH-blackh);
					set(scalar);
				}
			}
		}
		else
		{
			copy(img);
		}
	}
	
	
	/***************************************************************************
	 * 画像を指定位置に描写する
	 */
	void draw(in Image src, CvPoint pt = cvPoint(0, 0))
	in
	{
		assert(depth == src.depth);
		assert(channels == src.channels);
		assert(pixSize == src.pixSize);
	}
	body
	{
		int sh, sw, sxmin, symin, sxmax;
		int dh, dw, dxmin, dymin, dxmax, dymax;
		int sz = pixSize;
		auto roisz = src.roiSize;
		with (roisz)
		{
			sh = height;
			sw = width;
		}
		roisz = roiSize;
		with (roisz)
		{
			dh = height;
			dw = width;
		}
		with (pt)
		{
			if (x < 0)
			{
				dxmin = 0;
				dxmax = x+dw<sw ? (x+dw)*sz : sw*sz;
				sxmin = -x*sz;
			}
			else
			{
				dxmin = x*sz;
				dxmax = dw<sw ? dw*sz : sw*sz;
				sxmin = 0;
			}
			if (dxmax<=0) return;
			if (y < 0)
			{
				dymin = 0;
				dymax = y+dh<sh ? y+dh : sh;
				symin = -y;
			}
			else
			{
				dymin = y;
				dymax = dh<sh ? dh : sh;
				symin = 0;
			}
			if (dymax<=0)return;
			if (x+dw < sw)
			{
				sxmax = (x+dw)*sz;
			}
			else
			{
				sxmax = sw*sz;
			}
		}
		for (int dy=dymin, sy=symin; dy<dymax; ++dy, ++sy)
		{
			roiRow(dy)[dxmin..dxmax] = src.roiRow(sy)[sxmin..sxmax];
		}
	}
	
	
	/***************************************************************************
	 * 左右反転
	 */
	void flipH(in Image img = null)
	{
		if (img)
		{
			cvFlip(img.handle, _image, 1);
		}
		else
		{
			cvFlip(_image, null, 1);
		}
	}
	
	
	/***************************************************************************
	 * 上下反転
	 */
	void flipV(in Image img = null)
	{
		if (img)
		{
			cvFlip(img.handle, _image, 0);
		}
		else
		{
			cvFlip(_image, null, 0);
		}
	}
	
	
	/***************************************************************************
	 * 180度回転
	 */
	void flipVH(in Image img = null)
	{
		if (img)
		{
			cvFlip(img.handle, _image, -1);
		}
		else
		{
			cvFlip(_image, null, -1);
		}
	}
	
	
	/***************************************************************************
	 * チャンネルの抽出
	 * 
	 * マルチチャンネルの配列を、複数のシングルチャンネルの配列に分割する。
	 * または、配列から一つのチャンネルを取り出す。
	 */
	void split(Image c1, Image c2 = null, Image c3 = null, Image c4 = null)
	{
		cvSplit(_image,
			c1 ? c1._image: null,
			c2 ? c2._image: null,
			c3 ? c3._image: null,
			c4 ? c4._image: null);
	}
	
	
	/***************************************************************************
	 * チャンネルの統合
	 * 
	 * 複数のシングルチャンネルの配列からマルチチャンネル配列を構成する。
	 * または、配列に一つのシングルチャンネルを挿入する
	 */
	void merge(in Image c1,
	           in Image c2 = null,
	           in Image c3 = null,
	           in Image c4 = null)
	{
		cvMerge(
			c1 ? c1._image: null,
			c2 ? c2._image: null,
			c3 ? c3._image: null,
			c4 ? c4._image: null,
			_image);
	}
	
	
	/***************************************************************************
	 * スムージング
	 */
	void smooth( int smoothtype = CV_GAUSSIAN,
	               int size1 = 3,
	               int size2 = 0,
	               double sigma1 = 0,
	               double sigma2 = 0)
	{
		cvSmooth(_image, _image, smoothtype, size1, size2, sigma1, sigma2);
	}
	
	
	/***************************************************************************
	 * フィルタ処理
	 */
	void filter(in CvMat* mat)
	{
		cvFilter2D(_image, _image, mat);
	}
	
	
	/***************************************************************************
	 * フィルタ処理
	 */
	void filter(in Matrix mat)
	{
		filter(mat.handle);
	}
	
	
	/***************************************************************************
	 * 2値化処理
	 */
	void threshold(double threshold,
	               double max_value = 1.0,
	               int threshold_type = CV_THRESH_BINARY)
	{
		auto a = ((1<<(depth&255))-1);
		cvThreshold(_image, _image, threshold*a, max_value*a, threshold_type);
	}
	
	
	/***************************************************************************
	 * 色変換
	 */
	void convertColor(in Image src, int code)
	{
		int afch = 0;
		switch( code )
		{
		case CV_BGR2BGRA:
		case CV_RGB2BGRA:
		case CV_BGRA2RGBA:
		case CV_BGR5652BGRA:
		case CV_BGR5552BGRA:
		case CV_BGR5652RGBA:
		case CV_BGR5552RGBA:
		case CV_GRAY2BGRA:
			afch = 4;
			break;
		case CV_BGRA2BGR:
		case CV_RGBA2BGR:
		case CV_RGB2BGR:
		case CV_BGR5652BGR:
		case CV_BGR5552BGR:
		case CV_BGR5652RGB:
		case CV_BGR5552RGB:
		case CV_GRAY2BGR:
		case CV_BGR2YCrCb:
		case CV_RGB2YCrCb:
		case CV_BGR2XYZ:
		case CV_RGB2XYZ:
		case CV_BGR2HSV:
		case CV_RGB2HSV:
		case CV_BGR2Lab:
		case CV_RGB2Lab:
		case CV_BGR2Luv:
		case CV_RGB2Luv:
		case CV_BGR2HLS:
		case CV_RGB2HLS:
		case CV_BayerBG2BGR:
		case CV_BayerGB2BGR:
		case CV_BayerRG2BGR:
		case CV_BayerGR2BGR:
			afch = 3;
			break;
		case CV_YCrCb2BGR:
		case CV_YCrCb2RGB:
		case CV_XYZ2BGR:
		case CV_XYZ2RGB:
		case CV_HSV2BGR:
		case CV_HSV2RGB:
		case CV_Lab2BGR:
		case CV_Lab2RGB:
		case CV_Luv2BGR:
		case CV_Luv2RGB:
		case CV_HLS2BGR:
		case CV_HLS2RGB:
			afch = 3;
			break;
		case CV_BGR2BGR565:
		case CV_BGR2BGR555:
		case CV_RGB2BGR565:
		case CV_RGB2BGR555:
		case CV_BGRA2BGR565:
		case CV_BGRA2BGR555:
		case CV_RGBA2BGR565:
		case CV_RGBA2BGR555:
		case CV_GRAY2BGR565:
		case CV_GRAY2BGR555:
			afch = 2;
			break;
		case CV_BGR2GRAY:
		case CV_BGRA2GRAY:
		case CV_RGB2GRAY:
		case CV_RGBA2GRAY:
		case CV_BGR5652GRAY:
		case CV_BGR5552GRAY:
			afch = 1;
			break;
		default:
			error("Unknown/unsupported color conversion code");
		}
		if (afch == channels)
		{
			cvCvtColor(src._image, _image, code);
		}
		else
		{
			error("cannot convert color");
		}
	}
	
	
	///ditto
	void convertColor(int code)
	{
		convertColor(this, code);
	}
	
	
	/***************************************************************************
	 * 輝度値の変更
	 */
	void convert(in Image src, double scale = 1, double shift = 0)
	{
		cvConvertScale(src._image, _image, scale, shift);
	}
	
	
	///ditto
	void convert(in Matrix src, double scale = 1, double shift = 0)
	{
		cvConvertScale(src.handle, _image, scale, shift);
	}
	
	
	/***************************************************************************
	 * 自動レベル補正(イコライズ)
	 */
	void equalize()
	{
		cvEqualizeHist(_image, _image);
	}
	
	
	/***************************************************************************
	 * Look up tableの適用
	 */
	void applyLUT(Matrix lut)
	{
		cvLUT(_image, _image, lut.handle);
	}
	
	
	//##########################################################################
	//##### 
	//##### 演算
	//##### 
	//##########################################################################
	
	
	/***************************************************************************
	 * 加算
	 */
	void add( in Image img, in Image mask = null)
	{
		cvAdd(_image, img._image, _image, mask ? mask._image: null);
	}
	
	
	///ditto
	void add( in CvScalar value, in Image mask = null)
	{
		cvAddS(_image, value, _image, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 減算
	 */
	void sub( in Image img, in Image mask = null)
	{
		cvSub(_image, img._image, _image, mask ? mask._image: null);
	}
	
	
	///ditto
	void sub( in CvScalar value, in Image mask = null)
	{
		cvSubS(_image, value, _image, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 乗算
	 */
	void mul( in Image img, double scale = 1.0)
	{
		cvMul(_image, img._image, _image, scale);
	}
	
	
	/***************************************************************************
	 * 除算
	 */
	void div( in Image img, double scale = 1.0)
	{
		cvDiv(_image, img._image, _image, scale);
	}
	
	
	/***************************************************************************
	 * 累乗
	 */
	void pow( double power)
	{
		cvPow(_image, _image, power);
	}
	
	
	/***************************************************************************
	 * 理論積
	 */
	void and(in Image img, in Image mask = null)
	{
		cvAnd(_image, img._image, _image, mask ? mask._image: null);
	}
	
	
	///ditto
	void and(in CvScalar value, in Image mask = null)
	{
		cvAndS(_image, value, _image, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 理論和
	 */
	void or(in Image img, in Image mask = null)
	{
		cvOr(_image, img._image, _image, mask ? mask._image: null);
	}
	
	
	///ditto
	void or(in CvScalar value, in Image mask = null)
	{
		cvOrS(_image, value, _image, mask ? mask._image: null);
	}
	
	
	/***************************************************************************
	 * 排他理論和
	 */
	void xor(in Image img, in Image mask = null)
	{
		cvXor(_image, img._image, _image, mask ? mask._image: null);
	}
	
	
	///ditto
	void xor(in CvScalar value, in Image mask = null)
	{
		cvXorS(_image, value, _image, mask ? mask._image: null);
	}
	
	
	//##########################################################################
	//##### 
	//##### 演算
	//##### 
	//##########################################################################
	
	
	/***************************************************************************
	 * 代入演算子
	 */
	void opOpAssign(string op)(in Image img) if (op == "+")
	{
		add(img);
	}
	
	
	///ditto
	void opOpAssign(string op)(in Image img) if (op == "-")
	{
		sub(img);
	}
	
	
	///ditto
	void opOpAssign(string op)(in Image img) if (op == "&")
	{
		and(img);
	}
	
	
	///ditto
	void opOpAssign(string op)(in Image img) if (op == "|")
	{
		or(img);
	}
	
	
	///ditto
	void opOpAssign(string op)(in Image img) if (op == "^")
	{
		xor(img);
	}
	
	
	/***************************************************************************
	 * 二項演算子
	 */
	Image opBinary(string op)(in Image img) const if (op == "+")
	{
		auto ret = new Image(this);
		ret += img;
		return ret;
	}
	
	
	///ditto
	Image opBinary(string op)(in Image img) const if (op == "-")
	{
		auto ret = new Image(this);
		ret -= img;
		return ret;
	}
	
	
	///ditto
	Image opBinary(string op)(in Image img) const if (op == "&")
	{
		auto ret = new Image(this);
		ret &= img;
		return ret;
	}
	
	
	///ditto
	Image opBinary(string op)(in Image img) const if (op == "|")
	{
		auto ret = new Image(this);
		ret |= img;
		return ret;
	}
	
	
	///ditto
	Image opBinary(string op)(in Image img) const if (op == "^")
	{
		auto ret = new Image(this);
		ret ^= img;
		return ret;
	}
	
	
	//##########################################################################
	//##### 
	//##### 標準化対応
	//##### 
	//##########################################################################
	/// for swap
	void proxySwap(Image img)
	{
		auto tmp = _image;
		_image = img._image;
		img._image = tmp;
	}
	
}


/*******************************************************************************
 * ユーザーデータによる画像
 * 
 * データの割り当てを自分で行うことができる。
 */
class UserDataImage: Image
{
	/***************************************************************************
	 * コンストラクタ
	 * 
	 * このコンストラクタではヘッダ部分のみ生成する。
	 * データは別途セットする必要がある
	 */
	this(void[] data, CvSize size, int depth, int channels,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		_image = cast(IplImage*)cvAlloc(IplImage.sizeof);
		cvInitImageHeader(_image, size, depth, channels, aOrigin, alignment);
		this.data = data;
		super();
	}
	
	
	///ditto
	this(ubyte[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_8U, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(byte[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_8S, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(ushort[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_16U, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(short[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_16S, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(int[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_32S, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(float[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_32F, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(double[] data, CvSize size, int channels=3,
		int aOrigin = IPL_ORIGIN_TL, int alignment = 4)
	{
		this(data, size, IPL_DEPTH_64F, channels, aOrigin, alignment);
	}
	
	
	///ditto
	this(ubyte[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ubyte[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(byte[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(byte[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(ushort[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ushort[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(short[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(short[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(int[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(int[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(float[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(float[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(double[1][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(double[])data, size, 1, aOrigin, 1);
	}
	
	
	///ditto
	this(ubyte[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ubyte[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(byte[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(byte[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(ushort[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ushort[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(short[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(short[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(int[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(int[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(float[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(float[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(double[3][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(double[])data, size, 3, aOrigin, 1);
	}
	
	
	///ditto
	this(ubyte[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ubyte[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(byte[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(byte[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(ushort[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(ushort[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(short[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(short[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(int[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(int[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(float[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(float[])data, size, 4, aOrigin, 1);
	}
	
	
	///ditto
	this(double[4][] data, CvSize size, int aOrigin = IPL_ORIGIN_TL)
	{
		this(cast(double[])data, size, 4, aOrigin, 1);
	}
	
	
	/***************************************************************************
	 * データの取得/設定
	 * 
	 * Imageが画像の取得だけに対して、このクラスでは設定も可能である
	 */
	alias Image.data data;
	
	
	///ditto
	@property void data(void[] attachdata)
	in
	{
		assert(attachdata.length == handle.imageSize);
	}
	body
	{
		handle.imageData = cast(ubyte*)attachdata.ptr;
	}
}

/*******************************************************************************
 * ヒストグラム
 */
class Histogram
{
protected:
	
	
	CvHistogram* _histogram;
	
	
	///invariant()
	///{
	///	assert(_histogram);
	///}
	
	
	this()
	{
		
	}
	
	
public:
	
	
	@property CvHistogram* handle()
	{
		return _histogram;
	}
	
	
	/***************************************************************************
	 * ビンに直接アクセス
	 */
	@property CvArr* bins()
	{
		return _histogram.bins;
	}
	
	
	/***************************************************************************
	 * コンストラクタ
	 */
	this(in int[] sizes, int type,
		in float[][] ranges=null, int uniform=1)
	{
		auto rangeptrs = new float*[ranges.length];
		foreach (int i, r; ranges)
		{
			rangeptrs[i] = r.dup.ptr;
		}
		_histogram = cvCreateHist(cast(int)sizes.length, sizes.dup.ptr, type,
		                           rangeptrs.ptr, uniform);
	}
	
	
	/***************************************************************************
	 * デストラクタ
	 */
	~this()
	{
		if (_histogram) cvReleaseHist(&_histogram);
		_histogram = null;
	}
	
	
	/***************************************************************************
	 * ヒストグラムのビンのレンジをセットする
	 */
	void setBinRanges(in float[][] ranges=null, int uniform=1)
	{
		auto rangeptrs = new float*[ranges.length];
		foreach (i, r; ranges)
		{
			rangeptrs[i] = r.dup.ptr;
		}
		cvSetHistBinRanges(_histogram, rangeptrs.ptr, uniform);
	}
	
	
	/***************************************************************************
	 * ヒストグラムをクリアする
	 */
	void clear()
	{
		cvClearHist(_histogram);
	}
	
	
	/***************************************************************************
	 * ヒストグラムのビンの値の問い合わせを行う
	 */
	real queryHistValue1D(int idx0)
	{
		return cvGetReal1D( _histogram.bins, idx0);
	}
	
	
	///ditto
	real queryValue2D(int idx0, int idx1)
	{
		return cvGetReal2D( _histogram.bins, idx0, idx1);
	}
	
	
	///ditto
	real queryValue3D(int idx0, int idx1, int idx2)
	{
		return cvGetReal3D( _histogram.bins, idx0, idx1, idx2);
	}
	
	
	///ditto
	real queryValue(in int[] idx)
	{
		return cvGetRealND( _histogram.bins, idx.ptr);
	}
	
	
	/***************************************************************************
	 * ヒストグラムのビンへのポインタを返す
	 */
	ubyte* getValue1D(int idx0)
	{
		return cvPtr1D( _histogram.bins, idx0, null );
	}
	
	
	///ditto
	ubyte* getValue2D(int idx0, int idx1)
	{
		return cvPtr2D( _histogram.bins, idx0, idx1, null );
	}
	
	
	///ditto
	ubyte* getValue3D(int idx0, int idx1, int idx2)
	{
		return cvPtr3D( _histogram.bins, idx0, idx1, idx2, null );
	}
	
	
	///ditto
	ubyte* getValue(int[] idx)
	{
		return cvPtrND( _histogram.bins, idx.ptr );
	}
	
	
	/***************************************************************************
	 * 最大値，最小値を持つビンを求める
	 */
	void getMinMaxValue( out real minValue, out real maxValue,
	                     int* minIdx=null, int* maxIdx=null )
	{
		float min, max;
		cvGetMinMaxHistValue(_histogram, &min, &max, minIdx, maxIdx);
		minValue = min;
		maxValue = max;
	}
	
	
	/***************************************************************************
	 * ヒストグラムの正規化を行う
	 */
	void normalize(double factor)
	{
		cvNormalizeHist(_histogram, factor);
	}
	
	
	/***************************************************************************
	 * ヒストグラムの閾値処理を行う
	 */
	void threshold(double val)
	{
		cvThreshHist(_histogram, val);
	}
	
	
	/***************************************************************************
	 * 二つの密なヒストグラムを比較する
	 */
	real compare(in Histogram h2, int method = CV_COMP_CORREL)
	{
		return cvCompareHist(_histogram, h2._histogram, method);
	}
	
	
	/***************************************************************************
	 * ヒストグラムのコピーを行う
	 */
	void copy(in Histogram src)
	{
		cvCopyHist(src._histogram, &_histogram);
	}
	
	
	/***************************************************************************
	 * 画像（群）のヒストグラムを計算する
	 */
	void calculate(Image img, int accumulate=0, in Image mask=null)
	{
		auto src = img.handle;
		cvCalcHist(&src, _histogram, accumulate, mask?mask.handle:null);
	}
	
	
	//##########################################################################
	//##### 
	//##### 標準化対応
	//##### 
	//##########################################################################
	/// for swap
	void proxySwap(Histogram hist)
	{
		auto tmp = _histogram;
		_histogram = hist._histogram;
		hist._histogram = tmp;
	}
}

/*******************************************************************************
 * バックプロジェクションの計算
 */
void calcBackProject(Image img, Image dst, Histogram hist)
{
	cvCalcBackProject(&img._image, cast(CvArr*)dst._image, hist._histogram);
}

/*******************************************************************************
 * ヒストグラムの比較に基づき画像内部でのテンプレート位置を求める
 */
void calcBackProjectPatch(Image img, Image dst, CvSize patchSize,
                          Histogram hist, int method, float factor)
{
	cvCalcBackProjectPatch(&img._image, cast(CvArr*)dst._image, patchSize,
	                       hist._histogram, method, factor);
}

///
void calcProbDensity(Histogram hist1, Histogram hist2,
                     Histogram dst, double scale=255)
{
	cvCalcProbDensity(hist1.handle, hist2.handle, dst.handle, scale);
}

alias Image CvImage;
