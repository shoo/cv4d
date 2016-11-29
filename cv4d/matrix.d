/*******************************************************************************
 * 
 */
module cv4d.matrix;

import cv4d.opencv;
import cv4d.exception, cv4d._internal.misc;

private void error(string msg, string file = __FILE__, size_t line = __LINE__) pure
{
	throw new CvException(msg, file, line);
}


/*******************************************************************************
 * OpenCVを利用した行列
 */
class Matrix
{
protected:
	/***************************************************************************
	 * OpenCVで扱うことのできる生のCvMat*
	 */
	CvMat* _matrix;
	//invariant()
	//{
	//	assert(_matrix);
	//}
	/***************************************************************************
	 * 内部的にであれば何もしないコンストラクタを呼び出すことが可能
	 * 
	 * ただし、必ず _matrix は何らかの画像で初期化される必要があり、
	 * デストラクタが呼ばれる際には、確実に _matrix を null とするか、
	 * cvReleaseMat によって解放されてもよい画像を指定しておくこと
	 */
	this()
	{
		
	}
private:
	static CvMat* retrieveMatrix(void* obj)
	{
		assert(obj);
		CvMat* m = null;
		if ( CV_IS_MAT(obj) )
		{
			m = cast(CvMat*)obj;
		}
		else if( CV_IS_IMAGE(obj) )
		{
			auto img = cast(IplImage*)obj;
			CvMat hdr;
			auto src = cvGetMat( img, &hdr );
			m = cvCreateMat( src.rows, src.cols, src.type );
			cvCopy( src, m );
			cvReleaseImage( &img );
		}
		else
		{
			cvRelease( &obj );
			error( "The object is neither an image, nor a matrix");
		}
		return m;
	}
	
public:
	/***************************************************************************
	 * OpenCVの関数で利用するためのデータ
	 */
	@property CvMat* handle()
	{
		return _matrix;
	}
	
	
	///ditto
	@property const(CvMat)* handle() const
	{
		return _matrix;
	}
	
	
	/***************************************************************************
	 * コンストラクタ
	 */
	this(int rows, int cols, int type)
	{
		_matrix = cvCreateMat( rows, cols, type );
	}
	
	
	///ditto
	this(int rows, int cols, in byte* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_8S);
		foreach (i; 0..this.rows)
		{
			auto d = cast(byte[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in ubyte* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_8U);
		foreach (i; 0..this.rows)
		{
			auto d = cast(ubyte[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in short* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_16S);
		foreach (i; 0..this.rows)
		{
			auto d = cast(short[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in ushort* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_16U);
		foreach (i; 0..this.rows)
		{
			auto d = cast(ushort[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in int* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_32S);
		foreach (i; 0..this.rows)
		{
			auto d = cast(int[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in float* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_32F);
		foreach (i; 0..this.rows)
		{
			auto d = cast(float[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	
	///ditto
	this(int rows, int cols, in double* m)
	{
		_matrix = cvCreateMat( rows, cols, CV_64F);
		foreach (i; 0..this.rows)
		{
			auto d = cast(double[])row(i);
			d[] = m[i*cols..i*cols+d.length];
		}
	}
	
	///ditto
	this(int rows, int cols, int type, CvMemStorage* storage, bool alloc_data=true)
	{
		assert(storage);
		_matrix = cast(CvMat*)cvMemStorageAlloc( storage, CvMat.sizeof );
		cvInitMatHeader( _matrix, rows, cols, type, alloc_data ?
			cvMemStorageAlloc( storage, rows*cols*CV_ELEM_SIZE(type) ) : null );
	}
	
	///ditto
	this(in Matrix m )
	{
		_matrix = cvCloneMat( m._matrix );
	}
	
	
	///ditto
	this(in char[] filename, in char[] matname = null, int color = CV_LOAD_IMAGE_ANYCOLOR)
	{
		CvMat* m = null;
		scope (failure) if (m) cvReleaseMat( &m );
		if (isXmlOrYaml(filename))
		{
			m = retrieveMatrix(cvLoad(toMBSz(filename), null,toMBSz(matname)));
			if( (CV_MAT_CN(m.type) > 1) != (color == 0) )
			{
				error("RGB<->Grayscale conversion is not implemented"
				     ~" for matrices stored in XML/YAML");
			}
		}
		else
		{
			m = cvLoadImageM( toMBSz(filename), color );
		}
		if (!m) error("cannot load");
		_matrix = m;
	}
	
	
	///ditto
	this(CvFileStorage* fs, in char[] mapname, in char[] matname)
	{
		void* obj = null;
		CvMat* m = null;
		scope (failure) if (m) cvReleaseMat( &m );
		if( mapname.length )
		{
			CvFileNode* mapnode = cvGetFileNodeByName( fs, null, toMBSz(mapname) );
			if( mapnode is null ) obj = cvReadByName( fs, mapnode, toMBSz(matname) );
		}
		else
		{
			obj = cvReadByName( fs, null, toMBSz(matname) );
		}
		m = retrieveMatrix(obj);
		if (!m) error("cannot load");
		_matrix = m;
	}
	
	
	///ditto
	this(CvFileStorage* fs, in char[] seqname, int idx)
	{
		void* obj = null;
		CvMat* m = null;
		scope (failure) if (m) cvReleaseMat( &m );
		CvFileNode* seqnode = seqname
			? cvGetFileNodeByName( fs, null, toMBSz(seqname) )
			: cvGetRootFileNode(fs,0);
		if( seqnode && CV_NODE_IS_SEQ(seqnode.tag) )
		{
			obj = cvRead( fs, cast(CvFileNode*)cvGetSeqElem( seqnode.data.seq, idx ));
		}
		m = retrieveMatrix(obj);
		if (!m) error("cannot load");
		_matrix = m;
	}
	
	
	/***************************************************************************
	 * デストラクタ
	 */
	~this()
	{
		if (_matrix)
		{
			if( _matrix.hdr_refcount )
			{
				if( --_matrix.hdr_refcount == 0 )
				{
					cvReleaseMat( &_matrix );
				}
			}
			else if( _matrix.refcount )
			{
				if( --*_matrix.refcount == 0 )
				{
					cvFree( _matrix.refcount );
				}
			}
		}
		_matrix = null;
	}
	
	
	/***************************************************************************
	 * ファイルに保存
	 */
	void save( in char[] filename, in char[] matname) const
	{
		cvSave( toMBSz(filename), _matrix, toMBSz(matname) );
	}
	
	
	///ditto
	void save( in char[] filename) const
	{
		cvSaveImage( toMBSz(filename), _matrix);
	}
	
	
	/***************************************************************************
	 * ストレージに書き出し
	 */
	void write( CvFileStorage* fs, in char[] matname ) const
	{
		cvWrite( fs, toMBSz(matname), _matrix );
	}
	
	
	/***************************************************************************
	 * 行数
	 */
	final @property int rows() const
	{
		return _matrix.rows;
	}
	
	
	/***************************************************************************
	 * 列数
	 */
	final @property int cols() const
	{
		return _matrix.cols;
	}
	
	
	/***************************************************************************
	 * 行x列
	 */
	final @property CvSize size() const
	{
		return cvSize(_matrix.rows, _matrix.cols);
	}
	
	
	/***************************************************************************
	 * 行列のタイプ
	 */
	final @property int type() const
	{
		return CV_MAT_TYPE(_matrix.type);
	}
	
	
	/***************************************************************************
	 * 深度
	 */
	final @property int depth() const
	{
		return CV_MAT_DEPTH(_matrix.type);
	}
	
	
	/***************************************************************************
	 * チャンネル数
	 */
	final @property int channels() const
	{
		return CV_MAT_CN(_matrix.type);
	}
	
	
	/***************************************************************************
	 * 1要素のサイズ
	 */
	final @property int pixSize() const
	{
		return CV_ELEM_SIZE(_matrix.type);
	}
	
	
	/***************************************************************************
	 * 行列データの要素にアクセス
	 */
	final @property void[] data()
	{
		return _matrix.data.ptr[0..pixSize*rows*cols];
	}
	///ditto
	final @property const(void)[] data() const
	{
		return _matrix.data.ptr[0..pixSize*rows*cols];
	}
	/***************************************************************************
	 * 1行のバイト数
	 */
	final @property int step() const
	{
		return _matrix.step;
	}
	
	
	/***************************************************************************
	 * 行列データの要素に行ごとにアクセス
	 */
	final void[] row(int i)
	{
		return data[i*step..i*step+step];
	}
	
	
	///ditto
	final const(void)[] row(int i) const
	{
		return data[i*step..i*step+step];
	}
	
	
	/***************************************************************************
	 * キャストオーバーロード
	 */
	final CvMat* opCast()
	{
		return _matrix;
	}
	///ditto
	final const(CvMat)* opCast() const
	{
		return _matrix;
	}
	
	
	/***************************************************************************
	 * 逆行列にする
	 */
	final Matrix invert()
	{
		cvInvert(_matrix, _matrix);
		return this;
	}
	
	
	/***************************************************************************
	 * 内積を求める
	 */
	final double dot(in Matrix mat)const
	{
		return cvDotProduct(_matrix, mat._matrix);
	}
	
	
	/***************************************************************************
	 * 外積を求める
	 */
	final Matrix cross(in Matrix mat)
	{
		cvCrossProduct(_matrix, mat._matrix, _matrix);
		return this;
	}
	
	
	/***************************************************************************
	 * 正規化する
	 */
	final Matrix normalize(double a=1, double b=0, int norm_type=CV_L2, in CvArr* mask=null)
	{
		cvNormalize(_matrix, _matrix, a, b, norm_type, mask);
		return this;
	}
	
	
	/***************************************************************************
	 * 行列式の結果を返す
	 */
	final double det() const
	{
		return cvDet(_matrix);
	}
	
	
	/***************************************************************************
	 * 加算
	 */
	final void add(in CvScalar scale, in Matrix m)
	{
		cvScaleAdd(_matrix, scale, m._matrix, _matrix);
	}
	
	
	///ditto
	final void add(in Matrix m)
	{
		add(cvRealScalar(1), m);
	}
	
	
	///ditto
	final void add(double scale, in Matrix m)
	{
		add(cvRealScalar(scale), m);
	}
	
	
	/***************************************************************************
	 * 代入演算子
	 */
	final void opOpAssign(string op)(in Matrix m) if (op == "*=")
	{
		cross(m);
	}
	
	
	///ditto
	final void opOpAssign(string op)(in Matrix m) if (op == "+=")
	{
		add(m);
	}
	
	
	/***************************************************************************
	 * 二項演算子
	 */
	final void opBinary(string op)(in Matrix m) const if (op == "*")
	{
		auto ret = new Matrix(this);
		ret *= m;
		return ret;
	}
	
	
	///ditto
	final void opBinary(string op)(in Matrix m) const if (op == "+")
	{
		auto mat = new Matrix(this);
		mat += m;
		return mat;
	}
	
	
	//##########################################################################
	//##### 
	//##### 標準化対応
	//##### 
	//##########################################################################
	/// for swap
	void proxySwap(Matrix m)
	{
		auto tmp = m._matrix;
		_matrix = m._matrix;
		m._matrix = tmp;
	}
	
}

/*******************************************************************************
 * 型付きの行列
 */
class TypedMatrix(T, int CH=1): Matrix
{
	
	static if (is(T==ubyte))
	{
		protected enum TYPE = CV_MAKETYPE(CV_8U,CH);
	}
	else static if (is(T==byte))
	{
		protected enum TYPE = CV_MAKETYPE(CV_8S,CH);
	}
	else static if (is(T==ushort))
	{
		protected enum TYPE = CV_MAKETYPE(CV_16U,CH);
	}
	else static if (is(T==short))
	{
		protected enum TYPE = CV_MAKETYPE(CV_16S,CH);
	}
	else static if (is(T==int))
	{
		protected enum TYPE = CV_MAKETYPE(CV_32S,CH);
	}
	else static if (is(T==float))
	{
		protected enum TYPE = CV_MAKETYPE(CV_32F,CH);
	}
	else static if (is(T==double))
	{
		protected enum TYPE = CV_MAKETYPE(CV_64F,CH);
	}
	
	
	/***************************************************************************
	 * コンストラクタ
	 */
	this(int c, int r)
	{
		super(c,r,TYPE);
	}
	
	
	///ditto
	this(int c, int r, T* data)
	{
		super(c, r, data);
	}
	
	
	///ditto
	this(int rows, int cols, CvMemStorage* storage, bool alloc_data=true)
	{
		super(rows, cols, TYPE, storage, alloc_data);
	}
	
	
	///ditto
	this(in Matrix m )
	{
		assert(m._matrix.type == TYPE);
		super(m);
	}
	
	
	/***************************************************************************
	 * 行列データの要素にアクセス
	 */
	final T[] data()
	{
		return cast(T[])super.data[0..pixSize*rows*cols];
	}
	
	
	/***************************************************************************
	 * 行列データの要素に行ごとにアクセス
	 */
	final T[] row(int i)
	{
		return cast(T[])super.data[i*step..i*step+step];
	}
	
	
	/***************************************************************************
	 * 添え字演算子
	 */
	final T opIndex(size_t i, size_t j)
	{
		return row(i)[j];
	}
	
	
	///ditto
	final void opIndexAssign(T val, size_t i, size_t j)
	{
		row(i)[j] = val;
	}
}


/*******************************************************************************
 * ユーザーデータによる行列
 */
class UserDataMatrix: Matrix
{
	/***************************************************************************
	 * コンストラクタ
	 */
	this(void[] data, int rows, int cols, int type)
	{
		cvCreateMatHeader(rows, cols, type);
		this.data = data;
	}
	
	
	/// ditto
	this(ubyte[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8U,1));
	}
	
	
	/// ditto
	this(ubyte[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8U,2));
	}
	
	
	/// ditto
	this(ubyte[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8U,3));
	}
	
	
	/// ditto
	this(ubyte[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8U,4));
	}
	
	
	/// ditto
	this(byte[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8S,1));
	}
	
	
	/// ditto
	this(byte[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8S,2));
	}
	
	
	/// ditto
	this(byte[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8S,3));
	}
	
	
	/// ditto
	this(byte[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_8S,4));
	}
	
	
	/// ditto
	this(ushort[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16U,1));
	}
	
	
	/// ditto
	this(ushort[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16U,2));
	}
	
	
	/// ditto
	this(ushort[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16U,3));
	}
	
	
	/// ditto
	this(ushort[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16U,4));
	}
	
	
	/// ditto
	this(short[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16S,1));
	}
	
	
	/// ditto
	this(short[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16S,2));
	}
	
	
	/// ditto
	this(short[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16S,3));
	}
	
	
	/// ditto
	this(short[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_16S,4));
	}
	
	
	/// ditto
	this(int[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32S,1));
	}
	
	
	/// ditto
	this(int[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32S,2));
	}
	
	
	/// ditto
	this(int[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32S,3));
	}
	
	
	/// ditto
	this(int[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32S,4));
	}
	
	
	/// ditto
	this(float[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32F,1));
	}
	
	
	/// ditto
	this(float[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32F,2));
	}
	
	
	/// ditto
	this(float[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32F,3));
	}
	
	
	/// ditto
	this(float[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_32F,4));
	}
	
	
	/// ditto
	this(double[1][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_64F,1));
	}
	
	
	/// ditto
	this(double[2][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_64F,2));
	}
	
	
	/// ditto
	this(double[3][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_64F,3));
	}
	
	
	/// ditto
	this(double[4][] data, int rows, int cols)
	{
		this(data, rows, cols, CV_MAKETYPE(CV_64F,4));
	}
	
	
	/***************************************************************************
	 * データの設定/取得
	 */
	alias Matrix.data data;
	/// ditto
	final @property void data(void[] newdata)
	in
	{
		assert(data.length == step * rows);
	}
	body
	{
		handle.data.ptr = cast(ubyte*)newdata.ptr;
	}
}


/*******************************************************************************
 * ユーザーデータによる型付きの行列
 */
class UserDataTypedMatrix(T): TypedMatrix!(T)
{
	this(T[] data, int rows, int cols)
	{
		cvCreateMatHeader(rows, cols, TYPE);
		this.data = data;
	}
	/***************************************************************************
	 * データの設定/取得
	 */
	alias TypedMatrix!(T).data data;
	/// ditto
	final @property void data(T[] data)
	{
		cvSetData(data.ptr);
	}
}

unittest
{
	auto n = new TypedMatrix!(ubyte)(10, 10);
}

alias Matrix CvMatrix;
