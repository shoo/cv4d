module cv4d.opencv.core;

//##############################################################################
//##### opencv2/core/type_c.h
//##############################################################################

/*M///////////////////////////////////////////////////////////////////////////////////////
//
//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
//
//  By downloading, copying, installing or using the software you agree to this license.
//  If you do not agree to this license, do not download, install,
//  copy or use the software.
//
//
//                          License Agreement
//                For Open Source Computer Vision Library
//
// Copyright (C) 2000-2008, Intel Corporation, all rights reserved.
// Copyright (C) 2009, Willow Garage Inc., all rights reserved.
// Third party copyrights are property of their respective owners.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//   * The name of the copyright holders may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// This software is provided by the copyright holders and contributors "as is" and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the Intel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business interruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
//M*/

static import std.math, std.algorithm;
extern (C):

/* CvArr* is used to pass arbitrary
 * array-like data structures
 * into functions where the particular
 * array type is recognized at runtime:
 */
alias void CvArr;

union Cv32suf
{
	int i;
	uint u;
	float f;
}

union Cv64suf
{
	long i;
	ulong u;
	double f;
}

alias int CVStatus;

enum
{
	CV_StsOk=                       0,  /* everithing is ok                */
	CV_StsBackTrace=               -1,  /* pseudo error for back trace     */
	CV_StsError=                   -2,  /* unknown /unspecified error      */
	CV_StsInternal=                -3,  /* internal error (bad state)      */
	CV_StsNoMem=                   -4,  /* insufficient memory             */
	CV_StsBadArg=                  -5,  /* function arg/param is bad       */
	CV_StsBadFunc=                 -6,  /* unsupported function            */
	CV_StsNoConv=                  -7,  /* iter. didn't converge           */
	CV_StsAutoTrace=               -8,  /* tracing                         */
	CV_HeaderIsNull=               -9,  /* image header is NULL            */
	CV_BadImageSize=              -10, /* image size is invalid           */
	CV_BadOffset=                 -11, /* offset is invalid               */
	CV_BadDataPtr=                -12, /* */
	CV_BadStep=                   -13, /* */
	CV_BadModelOrChSeq=           -14, /* */
	CV_BadNumChannels=            -15, /* */
	CV_BadNumChannel1U=           -16, /* */
	CV_BadDepth=                  -17, /* */
	CV_BadAlphaChannel=           -18, /* */
	CV_BadOrder=                  -19, /* */
	CV_BadOrigin=                 -20, /* */
	CV_BadAlign=                  -21, /* */
	CV_BadCallBack=               -22, /* */
	CV_BadTileSize=               -23, /* */
	CV_BadCOI=                    -24, /* */
	CV_BadROISize=                -25, /* */
	CV_MaskIsTiled=               -26, /* */
	CV_StsNullPtr=                -27, /* null pointer */
	CV_StsVecLengthErr=           -28, /* incorrect vector length */
	CV_StsFilterStructContentErr= -29, /* incorr. filter structure content */
	CV_StsKernelStructContentErr= -30, /* incorr. transform kernel content */
	CV_StsFilterOffsetErr=        -31, /* incorrect filter ofset value */
	CV_StsBadSize=                -201, /* the input/output structure size is incorrect  */
	CV_StsDivByZero=              -202, /* division by zero */
	CV_StsInplaceNotSupported=    -203, /* in-place operation is not supported */
	CV_StsObjectNotFound=         -204, /* request can't be completed */
	CV_StsUnmatchedFormats=       -205, /* formats of input/output arrays differ */
	CV_StsBadFlag=                -206, /* flag is wrong or not supported */  
	CV_StsBadPoint=               -207, /* bad CvPoint */ 
	CV_StsBadMask=                -208, /* bad format of mask (neither 8uC1 nor 8sC1)*/
	CV_StsUnmatchedSizes=         -209, /* sizes of input/output structures do not match */
	CV_StsUnsupportedFormat=      -210, /* the data format/type is not supported by the function*/
	CV_StsOutOfRange=             -211, /* some of parameters are out of range */
	CV_StsParseError=             -212, /* invalid syntax/structure of the parsed file */
	CV_StsNotImplemented=         -213, /* the requested function/feature is not implemented */
	CV_StsBadMemBlock=            -214, /* an allocated block has been corrupted */
	CV_StsAssert=                 -215, /* assertion failed */    
	CV_GpuNotSupported=           -216,  
	CV_GpuApiCallError=           -217,
	CV_OpenGlNotSupported=        -218,
	CV_OpenGlApiCallError=        -219
};

/****************************************************************************************\
*                             Common macros and inline functions                         *
\****************************************************************************************/

alias std.math.PI CV_PI;
alias std.math.LN2 CV_LOG2;
alias std.algorithm.swap CV_SWAP;
alias std.algorithm.min MIN;
alias std.algorithm.max MAX;
T CV_IMIN(T)(T a, T b){return a^ ((a^b) & ((a < b) - 1));}
T CV_IMAX(T)(T a, T b){return a ^ ((a^b) & ((a > b) - 1));}
T CV_IABS(T)(T a){return (a ^ (a < 0 ? -1 : 0)) - (a < 0 ? -1 : 0);}
T CV_CMP(T)(T a, T b){return (a > b) - (a < b);}
T CV_SIGN(T)(T a){return CV_CMP(a,0);}
alias std.math.lrint cvRound;
int cvFloor(double value)
{
	int i = cast(int)value;
	return i - (i > value);
}
int cvCeil(double value)
{
	int i = cast(int)value;
	return i + (i < value);
}
T cvInvSqrt(T)(T value){return 1.0/std.math.sqrt(value);}
alias std.math.sqrt cvSqrt;
alias std.math.isNaN cvIsNaN;
alias std.math.isInfinity cvIsInf;

/*************** Random number generation *******************/
alias ulong CvRNG;


enum CV_RNG_COEFF = 4164903690U;
CvRNG cvRNG(long seed=-1)
{
	CvRNG rng = seed ? cast(ulong)seed : cast(ulong)-1;
	return rng;
}

/* Return random 32-bit unsigned integer: */
uint cvRandInt( CvRNG* rng )
{
	ulong temp = *rng;
	temp = cast(ulong)cast(uint)temp*CV_RNG_COEFF + (temp >> 32);
	*rng = temp;
	return cast(uint)temp;
}

/* Returns random floating-point number between 0 and 1: */
double cvRandReal( CvRNG* rng )
{
	return cvRandInt(rng)*2.3283064365386962890625e-10 /* 2^-32 */;
}

/****************************************************************************************\
*                                  Image type (IplImage)                                 *
\****************************************************************************************/

/*
 * The following definitions (until #endif)
 * is an extract from IPL headers.
 * Copyright (c) 1995 Intel Corporation.
 */
enum
{
	IPL_DEPTH_SIGN = 0x80000000,
	
	IPL_DEPTH_1U   =  1,
	IPL_DEPTH_8U   =  8,
	IPL_DEPTH_16U  = 16,
	IPL_DEPTH_32F  = 32,
	
	IPL_DEPTH_8S  = IPL_DEPTH_SIGN| 8,
	IPL_DEPTH_16S = IPL_DEPTH_SIGN|16,
	IPL_DEPTH_32S = IPL_DEPTH_SIGN|32,
	
	IPL_DATA_ORDER_PIXEL = 0,
	IPL_DATA_ORDER_PLANE = 1,
	
	IPL_ORIGIN_TL = 0,
	IPL_ORIGIN_BL = 1,
	
	IPL_ALIGN_4BYTES  =  4,
	IPL_ALIGN_8BYTES  =  8,
	IPL_ALIGN_16BYTES = 16,
	IPL_ALIGN_32BYTES = 32,
	
	IPL_ALIGN_DWORD = IPL_ALIGN_4BYTES,
	IPL_ALIGN_QWORD = IPL_ALIGN_8BYTES,
	
	IPL_BORDER_CONSTANT  = 0,
	IPL_BORDER_REPLICATE = 1,
	IPL_BORDER_REFLECT   = 2,
	IPL_BORDER_WRAP      = 3,
}


struct IplImage
{
	int  nSize;             /* sizeof(IplImage) */
	int  ID;                /* version (=0)*/
	int  nChannels;         /* Most of OpenCV functions support 1,2,3 or 4 channels */
	int  alphaChannel;      /* Ignored by OpenCV */
	int  depth;             /* Pixel depth in bits: IPL_DEPTH_8U, IPL_DEPTH_8S, IPL_DEPTH_16S,
	                           IPL_DEPTH_32S, IPL_DEPTH_32F and IPL_DEPTH_64F are supported.  */
	char[4] colorModel;     /* Ignored by OpenCV */
	char[4] channelSeq;     /* ditto */
	int  dataOrder;         /* 0 - interleaved color channels, 1 - separate color channels.
	                           cvCreateImage can only create interleaved images */
	int  origin;            /* 0 - top-left origin,
	                           1 - bottom-left origin (Windows bitmaps style).  */
	int  alignment;         /* Alignment of image rows (4 or 8).
	                           OpenCV ignores it and uses widthStep instead.    */
	int  width;             /* Image width in pixels.                           */
	int  height;            /* Image height in pixels.                          */
	IplROI* roi;            /* Image ROI. If NULL, the whole image is selected. */
	IplImage* maskROI;      /* Must be NULL. */
	void* imageId;          /* "           " */
	IplTileInfo* tileInfo;  /* "           " */
	int  imageSize;         /* Image data size in bytes
	                           (==image->height*image->widthStep
	                           in case of interleaved data)*/
	ubyte* imageData;       /* Pointer to aligned image data.         */
	int  widthStep;         /* Size of aligned image row in bytes.    */
	int[4]  BorderMode;     /* Ignored by OpenCV.                     */
	int[4]  BorderConst;    /* Ditto.                                 */
	ubyte* imageDataOrigin; /* Pointer to very origin of image data
	                           (not necessarily aligned) -
	                           needed for correct deallocation */
}

struct IplTileInfo{}

struct IplROI
{
	int coi; /* 0 - no COI (all channels are selected), 1 - 0th channel is selected ...*/
	int xOffset;
	int yOffset;
	int width;
	int height;
}

struct IplConvKernel
{
	int  nCols;
	int  nRows;
	int  anchorX;
	int  anchorY;
	int* values;
	int  nShiftR;
}

struct IplConvKernelFP
{
	int  nCols;
	int  nRows;
	int  anchorX;
	int  anchorY;
	float* values;
}

enum
{
	IPL_IMAGE_HEADER = 1,
	IPL_IMAGE_DATA   = 2,
	IPL_IMAGE_ROI    = 4,
}


/* extra border mode */
enum
{
	IPL_BORDER_REFLECT_101   = 4,
	IPL_BORDER_TRANSPARENT   = 5,
}

enum IPL_IMAGE_MAGIC_VAL = IplImage.sizeof;
enum CV_TYPE_NAME_IMAGE = "opencv-image";

bool CV_IS_IMAGE_HDR(in CvArr* img)
{
	return img !is null && (cast(const IplImage*)img).nSize == IplImage.sizeof;
}

bool CV_IS_IMAGE(CvArr* img)
{
	return CV_IS_IMAGE_HDR(img) && (cast(IplImage*)img).imageData !is null;
}

enum IPL_DEPTH_64F = 64;
ELM CV_IMAGE_ELEM(ELM)(IplImage* image, int row, int col)
{
	return (cast(ELM*)(image.imageData + image.widthStep*row))[col];
}

/****************************************************************************************\
*                                  Matrix type (CvMat)                                   *
\****************************************************************************************/

enum
{
	CV_CN_MAX    = 512,
	CV_CN_SHIFT  = 3,
	CV_DEPTH_MAX = 1 << CV_CN_SHIFT,
	
	CV_8U  = 0,
	CV_8S  = 1,
	CV_16U = 2,
	CV_16S = 3,
	CV_32S = 4,
	CV_32F = 5,
	CV_64F = 6,
	CV_USRTYPE1 = 7,
	
	CV_MAT_DEPTH_MASK      = CV_DEPTH_MAX - 1,
}
uint CV_MAT_DEPTH(uint flags) { return flags & CV_MAT_DEPTH_MASK; }
uint CV_MAKETYPE(uint depth, uint cn) { return CV_MAT_DEPTH(depth) + ((cn-1) << CV_CN_SHIFT); }
alias CV_MAKETYPE CV_MAKE_TYPE;
enum
{
	CV_8UC1 = CV_MAKETYPE(CV_8U,1),
	CV_8UC2 = CV_MAKETYPE(CV_8U,2),
	CV_8UC3 = CV_MAKETYPE(CV_8U,3),
	CV_8UC4 = CV_MAKETYPE(CV_8U,4),
}
uint CV_8UC(uint n) { return CV_MAKETYPE(CV_8U,n); }

enum
{
	CV_8SC1 = CV_MAKETYPE(CV_8S,1),
	CV_8SC2 = CV_MAKETYPE(CV_8S,2),
	CV_8SC3 = CV_MAKETYPE(CV_8S,3),
	CV_8SC4 = CV_MAKETYPE(CV_8S,4),
}
uint CV_8SC(uint n) { return CV_MAKETYPE(CV_8S,n); }

enum
{
	CV_16UC1 = CV_MAKETYPE(CV_16U,1),
	CV_16UC2 = CV_MAKETYPE(CV_16U,2),
	CV_16UC3 = CV_MAKETYPE(CV_16U,3),
	CV_16UC4 = CV_MAKETYPE(CV_16U,4),
}
uint CV_16UC(uint n) { return CV_MAKETYPE(CV_16U,n); }

enum
{
	CV_16SC1 = CV_MAKETYPE(CV_16S,1),
	CV_16SC2 = CV_MAKETYPE(CV_16S,2),
	CV_16SC3 = CV_MAKETYPE(CV_16S,3),
	CV_16SC4 = CV_MAKETYPE(CV_16S,4),
}
uint CV_16SC(uint n) { return CV_MAKETYPE(CV_16S,n); }

enum
{
	CV_32SC1 = CV_MAKETYPE(CV_32S,1),
	CV_32SC2 = CV_MAKETYPE(CV_32S,2),
	CV_32SC3 = CV_MAKETYPE(CV_32S,3),
	CV_32SC4 = CV_MAKETYPE(CV_32S,4),
}
uint CV_32SC(uint n) { return CV_MAKETYPE(CV_32S,n); }

enum
{
	CV_32FC1 = CV_MAKETYPE(CV_32F,1),
	CV_32FC2 = CV_MAKETYPE(CV_32F,2),
	CV_32FC3 = CV_MAKETYPE(CV_32F,3),
	CV_32FC4 = CV_MAKETYPE(CV_32F,4),
}
uint CV_32FC(uint n) { return CV_MAKETYPE(CV_32F,n); }

enum
{
	CV_64FC1 = CV_MAKETYPE(CV_64F,1),
	CV_64FC2 = CV_MAKETYPE(CV_64F,2),
	CV_64FC3 = CV_MAKETYPE(CV_64F,3),
	CV_64FC4 = CV_MAKETYPE(CV_64F,4),
}
uint CV_64FC(uint n) { return CV_MAKETYPE(CV_64F,n); }

enum
{
	CV_AUTO_STEP = 0x7fffffff,
	CV_WHOLE_ARR = cvSlice( 0, 0x3fffffff ),
}
enum CV_MAT_CN_MASK         = (CV_CN_MAX - 1) << CV_CN_SHIFT;
uint CV_MAT_CN(uint flags) { return ((flags & CV_MAT_CN_MASK) >> CV_CN_SHIFT) + 1; }
enum CV_MAT_TYPE_MASK       = CV_DEPTH_MAX*CV_CN_MAX - 1;
uint CV_MAT_TYPE(uint flags) { return flags & CV_MAT_TYPE_MASK; }
enum CV_MAT_CONT_FLAG_SHIFT = 14;
enum CV_MAT_CONT_FLAG       = 1 << CV_MAT_CONT_FLAG_SHIFT;
uint CV_IS_MAT_CONT(uint flags) { return flags & CV_MAT_CONT_FLAG; }
alias CV_IS_MAT_CONT CV_IS_CONT_MAT;
enum CV_SUBMAT_FLAG_SHIFT   = 15;
enum CV_SUBMAT_FLAG         = 1 << CV_SUBMAT_FLAG_SHIFT;
uint CV_IS_SUBMAT(uint flags) {return flags & CV_SUBMAT_FLAG; }

enum CV_MAGIC_MASK      = 0xFFFF0000;
enum CV_MAT_MAGIC_VAL   = 0x42420000;
enum CV_TYPE_NAME_MAT   = "opencv-matrix";

struct CvMat
{
	int type;
	int step;
	
	/* for internal use only */
	int* refcount;
	int hdr_refcount;

	union DataImpl
	{
		ubyte* ptr;
		short* s;
		int* i;
		float* fl;
		double* db;
	}
	DataImpl data;
	
	union
	{
		int rows;
		int height;
	}
	
	union
	{
		int cols;
		int width;
	}
}


bool CV_IS_MAT_HDR(CvArr* mat)
{
	return mat !is null && 
		((cast(const CvMat*)mat).type & CV_MAGIC_MASK) == CV_MAT_MAGIC_VAL &&
		(cast(const CvMat*)mat).cols > 0 && (cast(const CvMat*)mat).rows > 0;
}

bool CV_IS_MAT_HDR_Z(CvArr* mat)
{
	return mat !is null &&
		((cast(const CvMat*)mat).type & CV_MAGIC_MASK) == CV_MAT_MAGIC_VAL &&
		(cast(const CvMat*)mat).cols >= 0 && (cast(const CvMat*)mat).rows >= 0;
}

bool CV_IS_MAT(CvArr* mat)
{
	return CV_IS_MAT_HDR(mat) && (cast(const CvMat*)mat).data.ptr !is null;
}

bool CV_IS_MASK_ARR(MAT)(MAT mat)
{
	return (mat.type & (CV_MAT_TYPE_MASK & ~CV_8SC1)) == 0;
}

bool CV_ARE_TYPES_EQ(MAT1, MAT2)(MAT1 mat1, MAT2 mat2)
{
	return ((mat1.type ^ mat2.type) & CV_MAT_TYPE_MASK) == 0;
}

bool CV_ARE_CNS_EQ(MAT1, MAT2)(MAT1 mat1, MAT2 mat2)
{
	return ((mat1.type ^ mat2.type) & CV_MAT_CN_MASK) == 0;
}

bool CV_ARE_DEPTHS_EQ(MAT1, MAT2)(MAT1 mat1, MAT2 mat2)
{
	return ((mat1.type ^ mat2.type) & CV_MAT_DEPTH_MASK) == 0;
}

bool CV_ARE_SIZES_EQ(MAT1, MAT2)(MAT1 mat1, MAT2 mat2)
{
	return mat1.rows == mat2.rows && mat1.cols == mat2.cols;
}

bool CV_IS_MAT_CONST(MAT)(MAT mat)
{
	return (mat.rows|mat.cols) == 1;
}

/* Size of each channel item,
   0x124489 = 1000 0100 0100 0010 0010 0001 0001 ~ array of sizeof(arr_type_elem) */
int CV_ELEM_SIZE1(uint type)
{
	return (((size_t.sizeof<<28)|0x8442211) >> CV_MAT_DEPTH(type)*4) & 15;
}

/* 0x3a50 = 11 10 10 01 01 00 00 ~ array of log2(sizeof(arr_type_elem)) */
int CV_ELEM_SIZE(uint type)
{
	return CV_MAT_CN(type) << ((((size_t.sizeof/4+1)*16384|0x3a50) >> CV_MAT_DEPTH(type)*2) & 3);
}

int IPL2CV_DEPTH(int depth)
{
	return ((CV_8U+(CV_16U<<4)+(CV_32F<<8)+(CV_64F<<16)+(CV_8S<<20)+
		(CV_16S<<24)+(CV_32S<<28)) >> (((depth & 0xF0) >> 2) +
		((depth & IPL_DEPTH_SIGN) ? 20 : 0))) & 15;
}

/* Inline constructor. No data is allocated internally!!!
 * (Use together with cvCreateData, or use cvCreateMat instead to
 * get a matrix with allocated data):
 */
CvMat cvMat( int rows, int cols, int type, void* data = null)
{
	CvMat m;
	
	assert( cast(uint)CV_MAT_DEPTH(type) <= CV_64F );
	type = CV_MAT_TYPE(type);
	m.type = CV_MAT_MAGIC_VAL | CV_MAT_CONT_FLAG | type;
	m.cols = cols;
	m.rows = rows;
	m.step = m.cols*CV_ELEM_SIZE(type);
	m.data.ptr = cast(ubyte*)data;
	m.refcount = null;
	m.hdr_refcount = 0;
	
	return m;
}

ubyte* CV_MAT_ELEM_PTR_FAST(MAT)(MAT mat, int row, int col, int pix_size )
{
	assert( cast(uint)row < cast(uint)mat.rows &&
	        cast(uint)col < cast(uint)mat.cols );
	return mat.data.ptr + cast(size_t)(mat.step*row + pix_size*col);
}

ubyte* CV_MAT_ELEM_PTR(MAT)(MAT mat, row, col )
{
	return CV_MAT_ELEM_PTR_FAST( mat, row, col, CV_ELEM_SIZE(mat.type) );
}

ELM CV_MAT_ELEM(ELM, MAT)(MAT mat, row, col )
{
	return *cast(ELM*)CV_MAT_ELEM_PTR_FAST( mat, row, col, ELM.sizeof);
}

double cvmGet( const CvMat* mat, int row, int col )
{
	int type;
	
	type = CV_MAT_TYPE(mat.type);
	assert( cast(uint)row < cast(uint)mat.rows &&
	        cast(uint)col < cast(uint)mat.cols );

	if( type == CV_32FC1 )
	{
		return (cast(float*)(mat.data.ptr + cast(size_t)mat.step*row))[col];
	}
	else
	{
		assert( type == CV_64FC1 );
		return (cast(double*)(mat.data.ptr + cast(size_t)mat.step*row))[col];
	}
}

void  cvmSet( CvMat* mat, int row, int col, double value )
{
	int type;
	type = CV_MAT_TYPE(mat.type);
	assert( cast(uint)row < cast(uint)mat.rows &&
	        cast(uint)col < cast(uint)mat.cols );
	
	if( type == CV_32FC1 )
	{
		(cast(float*)(mat.data.ptr + cast(size_t)mat.step*row))[col] = cast(float)value;
	}
	else
	{
		assert( type == CV_64FC1 );
		(cast(double*)(mat.data.ptr + cast(size_t)mat.step*row))[col] = cast(double)value;
	}
}

int cvIplDepth( int type )
{
	int depth = CV_MAT_DEPTH(type);
	return CV_ELEM_SIZE1(depth)*8 | (depth == CV_8S || depth == CV_16S ||
		depth == CV_32S ? IPL_DEPTH_SIGN : 0);
}

/****************************************************************************************\
*                       Multi-dimensional dense array (CvMatND)                          *
\****************************************************************************************/

enum CV_MATND_MAGIC_VAL   = 0x42430000;
enum CV_TYPE_NAME_MATND   = "opencv-nd-matrix";

enum CV_MAX_DIM           = 32;
enum CV_MAX_DIM_HEAP      = 1024;

struct CvMatND
{
	int type;
	int dims;
	
	int* refcount;
	int hdr_refcount;
	
	union DataImpl
	{
		ubyte* ptr;
		float* fl;
		double* db;
		int* i;
		short* s;
	}
	DataImpl data;
	
	struct DimImpl
	{
		int size;
		int step;
	}
	DimImpl[CV_MAX_DIM] dim;
}

bool CV_IS_MATND_HDR(CvArr* mat)
{
	return mat !is null && ((cast(const CvMatND*)mat).type & CV_MAGIC_MASK) == CV_MATND_MAGIC_VAL;
}

bool CV_IS_MATND(CvArr* mat)
{
	return CV_IS_MATND_HDR(mat) && (cast(const CvMatND*)mat).data.ptr != null;
}

/****************************************************************************************\
*                      Multi-dimensional sparse array (CvSparseMat)                      *
\****************************************************************************************/

enum CV_SPARSE_MAT_MAGIC_VAL   = 0x42440000;
enum CV_TYPE_NAME_SPARSE_MAT   = "opencv-sparse-matrix";

struct CvSparseMat
{
	int type;
	int dims;
	int* refcount;
	int hdr_refcount;
	
	CvSet* heap;
	void** hashtable;
	int hashsize;
	int valoffset;
	int idxoffset;
	int[CV_MAX_DIM] size;
}

bool CV_IS_SPARSE_MAT_HDR(MAT)(MAT mat)
{
	return mat !is null &&
		((cast(const CvSparseMat*)mat).type & CV_MAGIC_MASK) == CV_SPARSE_MAT_MAGIC_VAL;
}

alias CV_IS_SPARSE_MAT_HDR CV_IS_SPARSE_MAT;

/**************** iteration through a sparse array *****************/

struct CvSparseNode
{
	uint hashval;
	CvSparseNode* next;
}

struct CvSparseMatIterator
{
	CvSparseMat* mat;
	CvSparseNode* node;
	int curidx;
}

void* CV_NODE_VAL(CvSparseMat* mat, CvSparseNode* node)
{
	return cast(void*)((cast(ubyte*)node) + mat.valoffset);
}

int* CV_NODE_IDX(CvSparseMat* mat, CvSparseNode* node)
{
	return cast(int*)((cast(ubyte*)node + mat.idxoffset));
}

/****************************************************************************************\
*                                         Histogram                                      *
\****************************************************************************************/

alias int CvHistType;

enum CV_HIST_MAGIC_VAL    = 0x42450000;
enum CV_HIST_UNIFORM_FLAG = 1 << 10;

/* indicates whether bin ranges are set already or not */
enum CV_HIST_RANGES_FLAG  = 1 << 11;

enum CV_HIST_ARRAY        = 0;
enum CV_HIST_SPARSE       = 1;
enum CV_HIST_TREE         = CV_HIST_SPARSE;

/* should be used as a parameter only,
   it turns to CV_HIST_UNIFORM_FLAG of hist->type */
enum CV_HIST_UNIFORM      = 1;

struct CvHistogram
{
	int     type;
	CvArr*  bins;
	float[2][CV_MAX_DIM]   thresh;  /* For uniform histograms.                      */
	float** thresh2;                /* For non-uniform histograms.                  */
	CvMatND mat;                    /* Embedded matrix header for array histograms. */
}

bool CV_IS_HIST( CvArr* hist )
{
	return hist !is null &&
		((cast(CvHistogram*)hist).type & CV_MAGIC_MASK) == CV_HIST_MAGIC_VAL &&
		(cast(CvHistogram*)hist).bins !is null;
}

bool CV_IS_UNIFORM_HIST( CvHistogram* hist )
{
	return (hist.type & CV_HIST_UNIFORM_FLAG) != 0;
}

bool CV_IS_SPARSE_HIST( CvHistogram* hist )
{
	return CV_IS_SPARSE_MAT(hist.bins);
}

bool CV_HIST_HAS_RANGES( CvHistogram* hist )
{
	return (hist.type & CV_HIST_RANGES_FLAG) != 0;
}

/****************************************************************************************\
*                      Other supplementary data type definitions                         *
\****************************************************************************************/

/*************************************** CvRect *****************************************/

struct CvRect
{
	int x;
	int y;
	int width;
	int height;
}

CvRect cvRect( int x, int y, int width, int height )
{
	return CvRect(x,y,width,height);
}

IplROI cvRectToROI( CvRect rect, int coi )
{
	IplROI roi;
	roi.xOffset = rect.x;
	roi.yOffset = rect.y;
	roi.width = rect.width;
	roi.height = rect.height;
	roi.coi = coi;
	
	return roi;
}

CvRect cvROIToRect( IplROI roi )
{
	return cvRect( roi.xOffset, roi.yOffset, roi.width, roi.height );
}

/*********************************** CvTermCriteria *************************************/

enum CV_TERMCRIT_ITER   = 1;
enum CV_TERMCRIT_NUMBER = CV_TERMCRIT_ITER;
enum CV_TERMCRIT_EPS    = 2;

struct CvTermCriteria
{
	int    type;  /* may be combination of
	                 CV_TERMCRIT_ITER
	                 CV_TERMCRIT_EPS */
	int    max_iter;
	double epsilon;
}

CvTermCriteria cvTermCriteria( int type, int max_iter, double epsilon )
{
	return CvTermCriteria(type, max_iter, cast(float)epsilon);
}

/******************************* CvPoint and variants ***********************************/

struct CvPoint
{
	int x;
	int y;
}

CvPoint cvPoint( int x, int y )
{
	return CvPoint(x,y);
}

struct CvPoint2D32f
{
	float x;
	float y;
}

CvPoint2D32f cvPoint2D32f( double x, double y )
{
	return CvPoint2D32f(cast(float)x, cast(float)y);
}

CvPoint2D32f cvPointTo32f( CvPoint point )
{
	return cvPoint2D32f( cast(float)point.x, cast(float)point.y );
}


CvPoint cvPointFrom32f( CvPoint2D32f point )
{
	return CvPoint(cast(int)cvRound(point.x), cast(int)cvRound(point.y));
}


struct CvPoint3D32f
{
	float x;
	float y;
	float z;
}


CvPoint3D32f cvPoint3D32f( double x, double y, double z )
{
	return CvPoint3D32f(x,y,z);
}

struct CvPoint2D64f
{
	double x;
	double y;
}

CvPoint2D64f cvPoint2D64f( double x, double y )
{
	return CvPoint2D64f(x, y);
}

struct CvPoint3D64f
{
	double x;
	double y;
	double z;
}


CvPoint3D64f cvPoint3D64f( double x, double y, double z )
{
	return CvPoint3D64f(x, y, z);
}

/******************************** CvSize's & CvBox **************************************/

struct CvSize
{
	int width;
	int height;
}

CvSize cvSize( int width, int height )
{
	return CvSize(width, height);
}

struct CvSize2D32f
{
	float width;
	float height;
}

CvSize2D32f cvSize2D32f( double width, double height )
{
	return CvSize2D32f(cast(float)width, cast(float)height);
}

struct CvBox2D
{
	CvPoint2D32f center;  /* Center of the box.                          */
	CvSize2D32f  size;    /* Box width and length.                       */
	float angle;          /* Angle between the horizontal axis           */
	                      /* and the first side (i.e. length) in degrees */
}

/* Line iterator state: */
struct CvLineIterator
{
	/* Pointer to the current point: */
	ubyte* ptr;
	
	/* Bresenham algorithm state: */
	int  err;
	int  plus_delta;
	int  minus_delta;
	int  plus_step;
	int  minus_step;
}


/************************************* CvSlice ******************************************/

struct CvSlice
{
	int  start_index, end_index;
}

CvSlice cvSlice( int start, int end )
{
	return CvSlice(start, end);
}

enum CV_WHOLE_SEQ_END_INDEX = 0x3fffffff;
enum CV_WHOLE_SEQ = cvSlice(0, CV_WHOLE_SEQ_END_INDEX);


/************************************* CvScalar *****************************************/

struct CvScalar
{
	double[4] val;
}

CvScalar cvScalar( double val0,     double val1 = 0,
                   double val2 = 0, double val3 = 0)
{
	return CvScalar([val0, val1, val2, val3]);
}

CvScalar cvRealScalar( double val0 )
{
	return CvScalar([val0, 0, 0, 0]);
}

CvScalar cvScalarAll( double val0123 )
{
	return CvScalar([val0123, val0123, val0123, val0123]);
}

/****************************************************************************************\
*                                   Dynamic Data structures                              *
\****************************************************************************************/

/******************************** Memory storage ****************************************/

struct CvMemBlock
{
	CvMemBlock*  prev;
	CvMemBlock*  next;
}

enum CV_STORAGE_MAGIC_VAL   = 0x42890000;

struct CvMemStorage
{
	int signature;
	CvMemBlock* bottom;           /* First allocated block.                   */
	CvMemBlock* top;              /* Current memory block - top of the stack. */
	CvMemStorage* parent; /* We get new blocks from parent as needed. */
	int block_size;               /* Block size.                              */
	int free_space;               /* Remaining free space in current block.   */
}

bool CV_IS_STORAGE(CvArr* storage)
{
	return storage !is null &&
		((cast(CvMemStorage*)storage).signature & CV_MAGIC_MASK) == CV_STORAGE_MAGIC_VAL;
}

struct CvMemStoragePos
{
	CvMemBlock* top;
	int free_space;
}

/*********************************** Sequence *******************************************/

struct CvSeqBlock
{
	CvSeqBlock*  prev; /* Previous sequence block.                   */
	CvSeqBlock*  next; /* Next sequence block.                       */
	int  start_index;  /* Index of the first element in the block +  */
	                   /* sequence->first->start_index.              */
	int    count;      /* Number of elements in the block.           */
	byte*  data;       /* Pointer to the first element of the block. */
}


mixin template CV_TREE_NODE_FIELDS(node_type)
{
	int        flags;            /* Miscellaneous flags.     */
	int        header_size;      /* Size of sequence header. */
	node_type* h_prev;           /* Previous sequence.       */
	node_type* h_next;           /* Next sequence.           */
	node_type* v_prev;           /* 2nd previous sequence.   */
	node_type* v_next;           /* 2nd next sequence.       */
}

/*
   Read/Write sequence.
   Elements can be dynamically inserted to or deleted from the sequence.
*/
template CV_SEQUENCE_FIELDS()
{
	mixin CV_TREE_NODE_FIELDS!(CvSeq);
	int       total;          /* Total number of elements.            */
	int       elem_size;      /* Size of sequence element in bytes.   */
	byte*    block_max;      /* Maximal bound of the last block.     */
	byte*    ptr;            /* Current write pointer.               */
	int       delta_elems;    /* Grow seq this many at a time.        */
	CvMemStorage* storage;    /* Where the seq is stored.             */
	CvSeqBlock* free_blocks;  /* Free blocks list.                    */
	CvSeqBlock* first;        /* Pointer to the first sequence block. */
}

struct CvSeq
{
	mixin CV_SEQUENCE_FIELDS!();
}

enum CV_TYPE_NAME_SEQ            = "opencv-sequence";
enum CV_TYPE_NAME_SEQ_TREE       = "opencv-sequence-tree";


/*************************************** Set ********************************************/
/*
  Set.
  Order is not preserved. There can be gaps between sequence elements.
  After the element has been inserted it stays in the same place all the time.
  The MSB(most-significant or sign bit) of the first field (flags) is 0 iff the element exists.
*/
mixin template CV_SET_ELEM_FIELDS(elem_type)
{
	int  flags;
	elem_type* next_free;
}

struct CvSetElem
{
	mixin CV_SET_ELEM_FIELDS!(CvSetElem);
}

mixin template CV_SET_FIELDS()
{
	mixin CV_SEQUENCE_FIELDS!();
	CvSetElem* free_elems;
	int active_count;
}

struct CvSet
{
	mixin CV_SET_FIELDS!();
}


enum CV_SET_ELEM_IDX_MASK =  (1 << 26) - 1;
enum CV_SET_ELEM_FREE_FLAG =  1 << (int.sizeof*8-1);

/* Checks whether the element pointed by ptr belongs to a set or not */
bool CV_IS_SET_ELEM(SETELM)( SETELM ptr )
{
	return (cast(CvSetElem*)ptr).flags >= 0;
}

/************************************* Graph ********************************************/

/*
  We represent a graph as a set of vertices.
  Vertices contain their adjacency lists (more exactly, pointers to first incoming or
  outcoming edge (or 0 if isolated vertex)). Edges are stored in another set.
  There is a singly-linked list of incoming/outcoming edges for each vertex.

  Each edge consists of

     o   Two pointers to the starting and ending vertices
         (vtx[0] and vtx[1] respectively).

	 A graph may be oriented or not. In the latter case, edges between
	 vertex i to vertex j are not distinguished during search operations.

     o   Two pointers to next edges for the starting and ending vertices, where
         next[0] points to the next edge in the vtx[0] adjacency list and
         next[1] points to the next edge in the vtx[1] adjacency list.
*/
mixin template CV_GRAPH_EDGE_FIELDS()
{
	int flags;
	float weight;
	CvGraphEdge*[2] next;
	CvGraphVtx*[2] vtx;
}

mixin template CV_GRAPH_VERTEX_FIELDS()
{
	int flags;
	CvGraphEdge* first;
}

struct CvGraphEdge
{
	mixin CV_GRAPH_EDGE_FIELDS!();
}

struct CvGraphVtx
{
	mixin CV_GRAPH_VERTEX_FIELDS!();
}

struct CvGraphVtx2D
{
	mixin CV_GRAPH_VERTEX_FIELDS!();
	CvPoint2D32f* ptr;
}

/*
   Graph is "derived" from the set (this is set a of vertices)
   and includes another set (edges)
*/
mixin template  CV_GRAPH_FIELDS()
{
	mixin CV_SET_FIELDS!();
	CvSet* edges;
}

struct CvGraph
{
	mixin CV_GRAPH_FIELDS!();
}

enum CV_TYPE_NAME_GRAPH = "opencv-graph";

/*********************************** Chain/Countour *************************************/

struct CvChain
{
	mixin CV_SEQUENCE_FIELDS!();
	CvPoint  origin;
}

mixin template CV_CONTOUR_FIELDS()
{
	mixin CV_SEQUENCE_FIELDS!();
	CvRect rect;
	int color;
	int[3] reserved;
}

struct CvContour
{
	mixin CV_CONTOUR_FIELDS!();
}

alias CvContour CvPoint2DSeq;

/****************************************************************************************\
*                                    Sequence types                                      *
\****************************************************************************************/

enum CV_SEQ_MAGIC_VAL =             0x42990000;

bool CV_IS_SEQ(SEQ)(SEQ seq)
{
	return seq !is null
		&& ((cast(CvSeq*)seq).flags & CV_MAGIC_MASK) == CV_SEQ_MAGIC_VAL;
}

enum CV_SET_MAGIC_VAL =            0x42980000;
bool CV_IS_SET(SET)(SET set)
{
	return set !is null
		&& ((cast(CvSeq*)set).flags & CV_MAGIC_MASK) == CV_SET_MAGIC_VAL;
}

enum CV_SEQ_ELTYPE_BITS =          12;
enum CV_SEQ_ELTYPE_MASK =          ((1 << CV_SEQ_ELTYPE_BITS) - 1);

enum CV_SEQ_ELTYPE_POINT =         CV_32SC2;  /* (x,y) */
enum CV_SEQ_ELTYPE_CODE =          CV_8UC1;   /* freeman code: 0..7 */
enum CV_SEQ_ELTYPE_GENERIC =       0;
enum CV_SEQ_ELTYPE_PTR =           CV_USRTYPE1;
enum CV_SEQ_ELTYPE_PPOINT =        CV_SEQ_ELTYPE_PTR;  /* &(x,y) */
enum CV_SEQ_ELTYPE_INDEX =         CV_32SC1;  /* #(x,y) */
enum CV_SEQ_ELTYPE_GRAPH_EDGE =    0;  /* &next_o, &next_d, &vtx_o, &vtx_d */
enum CV_SEQ_ELTYPE_GRAPH_VERTEX =  0;  /* first_edge, &(x,y) */
enum CV_SEQ_ELTYPE_TRIAN_ATR =     0;  /* vertex of the binary tree   */
enum CV_SEQ_ELTYPE_CONNECTED_COMP =0;  /* connected component  */
enum CV_SEQ_ELTYPE_POINT3D =       CV_32FC3;  /* (x,y,z)  */

enum CV_SEQ_KIND_BITS =       2;
enum CV_SEQ_KIND_MASK =       (((1 << CV_SEQ_KIND_BITS) - 1)<<CV_SEQ_ELTYPE_BITS);

/* types of sequences */
enum CV_SEQ_KIND_GENERIC =    0 << CV_SEQ_ELTYPE_BITS;
enum CV_SEQ_KIND_CURVE =      1 << CV_SEQ_ELTYPE_BITS;
enum CV_SEQ_KIND_BIN_TREE =   2 << CV_SEQ_ELTYPE_BITS;

/* types of sparse sequences (sets) */
enum CV_SEQ_KIND_GRAPH =      1 << CV_SEQ_ELTYPE_BITS;
enum CV_SEQ_KIND_SUBDIV2D =   2 << CV_SEQ_ELTYPE_BITS;

enum CV_SEQ_FLAG_SHIFT =      CV_SEQ_KIND_BITS + CV_SEQ_ELTYPE_BITS;

/* flags for curves */
enum CV_SEQ_FLAG_CLOSED =    1 << CV_SEQ_FLAG_SHIFT;
enum CV_SEQ_FLAG_SIMPLE =    0 << CV_SEQ_FLAG_SHIFT;
enum CV_SEQ_FLAG_CONVEX =    0 << CV_SEQ_FLAG_SHIFT;
enum CV_SEQ_FLAG_HOLE =      2 << CV_SEQ_FLAG_SHIFT;

/* flags for graphs */
enum CV_GRAPH_FLAG_ORIENTED = 1 << CV_SEQ_FLAG_SHIFT;

enum CV_GRAPH =              CV_SEQ_KIND_GRAPH;
enum CV_ORIENTED_GRAPH =     CV_SEQ_KIND_GRAPH|CV_GRAPH_FLAG_ORIENTED;

/* point sets */
enum CV_SEQ_POINT_SET =      CV_SEQ_KIND_GENERIC| CV_SEQ_ELTYPE_POINT;
enum CV_SEQ_POINT3D_SET =    CV_SEQ_KIND_GENERIC| CV_SEQ_ELTYPE_POINT3D;
enum CV_SEQ_POLYLINE =       CV_SEQ_KIND_CURVE  | CV_SEQ_ELTYPE_POINT;
enum CV_SEQ_POLYGON =        CV_SEQ_FLAG_CLOSED | CV_SEQ_POLYLINE;
enum CV_SEQ_CONTOUR =        CV_SEQ_POLYGON;
enum CV_SEQ_SIMPLE_POLYGON = CV_SEQ_FLAG_SIMPLE | CV_SEQ_POLYGON;

/* chain-coded curves */
enum CV_SEQ_CHAIN =          CV_SEQ_KIND_CURVE  | CV_SEQ_ELTYPE_CODE;
enum CV_SEQ_CHAIN_CONTOUR =  CV_SEQ_FLAG_CLOSED | CV_SEQ_CHAIN;

/* binary tree for the contour */
enum CV_SEQ_POLYGON_TREE =   CV_SEQ_KIND_BIN_TREE | CV_SEQ_ELTYPE_TRIAN_ATR;

/* sequence of the connected components */
enum CV_SEQ_CONNECTED_COMP = CV_SEQ_KIND_GENERIC | CV_SEQ_ELTYPE_CONNECTED_COMP;

/* sequence of the integer numbers */
enum CV_SEQ_INDEX =          CV_SEQ_KIND_GENERIC | CV_SEQ_ELTYPE_INDEX;

auto CV_SEQ_ELTYPE(SEQ)( SEQ seq )
{
	return seq.flags & CV_SEQ_ELTYPE_MASK;
}
auto CV_SEQ_KIND(SEQ)(SEQ seq )
{
	return seq.flags & CV_SEQ_KIND_MASK;
}

/* flag checking */
enum CV_IS_SEQ_INDEX(SEQ)( SEQ seq )
{
	return (CV_SEQ_ELTYPE(seq) == CV_SEQ_ELTYPE_INDEX) &&
		(CV_SEQ_KIND(seq) == CV_SEQ_KIND_GENERIC);
}

bool CV_IS_SEQ_CURVE(SEQ)( SEQ seq )  { return CV_SEQ_KIND(seq) == CV_SEQ_KIND_CURVE; }
bool CV_IS_SEQ_CLOSED(SEQ)( SEQ seq ) { return (seq.flags & CV_SEQ_FLAG_CLOSED) != 0; }
bool CV_IS_SEQ_CONVEX(SEQ)( SEQ seq ) { return false; }
bool CV_IS_SEQ_HOLE(SEQ)( SEQ seq )   { return (seq.flags & CV_SEQ_FLAG_HOLE) != 0; }
bool CV_IS_SEQ_SIMPLE(SEQ)( SEQ seq ) { return true; }

/* type checking macros */
bool CV_IS_SEQ_POINT_SET(SEQ)( SEQ seq )
{
	return CV_SEQ_ELTYPE(seq) == CV_32SC2 || CV_SEQ_ELTYPE(seq) == CV_32FC2;
}
bool  CV_IS_SEQ_POINT_SUBSET(SEQ)( SEQ seq )
{
	return CV_IS_SEQ_INDEX( seq ) || CV_SEQ_ELTYPE(seq) == CV_SEQ_ELTYPE_PPOINT;
}
bool CV_IS_SEQ_POLYLINE(SEQ)( SEQ seq )
{
	return CV_SEQ_KIND(seq) == CV_SEQ_KIND_CURVE && CV_IS_SEQ_POINT_SET(seq);
}
bool CV_IS_SEQ_POLYGON(SEQ)( SEQ seq )
{
	return CV_IS_SEQ_POLYLINE(seq) && CV_IS_SEQ_CLOSED(seq);
}
bool CV_IS_SEQ_CHAIN(SEQ)( SEQ seq )
{
	return CV_SEQ_KIND(seq) == CV_SEQ_KIND_CURVE && seq.elem_size == 1;
}
bool CV_IS_SEQ_CONTOUR(SEQ)( SEQ seq )
{
	return CV_IS_SEQ_CLOSED(seq) && (CV_IS_SEQ_POLYLINE(seq) || CV_IS_SEQ_CHAIN(seq));
}
bool CV_IS_SEQ_CHAIN_CONTOUR(SEQ)( SEQ seq )
{
	return CV_IS_SEQ_CHAIN( seq ) && CV_IS_SEQ_CLOSED( seq );
}
bool CV_IS_SEQ_POLYGON_TREE(SEQ)( SEQ seq )
{
	return CV_SEQ_ELTYPE (seq) ==  CV_SEQ_ELTYPE_TRIAN_ATR &&
		CV_SEQ_KIND( seq ) ==  CV_SEQ_KIND_BIN_TREE;
}
bool CV_IS_GRAPH(SEQ)( SEQ seq )
{
	return CV_IS_SET(seq) && CV_SEQ_KIND(cast(CvSet*)seq) == CV_SEQ_KIND_GRAPH;
}
bool CV_IS_GRAPH_ORIENTED(SEQ)( SEQ seq )
{
	return (seq.flags & CV_GRAPH_FLAG_ORIENTED) != 0;
}

bool CV_IS_SUBDIV2D(SEQ)( SEQ seq )
{
	return CV_IS_SET(seq) && CV_SEQ_KIND(cast(CvSet*)seq) == CV_SEQ_KIND_SUBDIV2D;
}

/****************************************************************************************/
/*                            Sequence writer & reader                                  */
/****************************************************************************************/

mixin template CV_SEQ_WRITER_FIELDS()
{
	int          header_size;
	CvSeq*       seq;        /* the sequence written */
	CvSeqBlock*  block;      /* current block */
	byte*       ptr;        /* pointer to free space */
	byte*       block_min;  /* pointer to the beginning of block*/
	byte*       block_max;  /* pointer to the end of block */
}

struct CvSeqWriter
{
	mixin CV_SEQ_WRITER_FIELDS!();
}


mixin template CV_SEQ_READER_FIELDS()
{
	int          header_size;
	CvSeq*       seq;        /* sequence, beign read */
	CvSeqBlock*  block;      /* current block */
	byte*       ptr;        /* pointer to element be read next */
	byte*       block_min;  /* pointer to the beginning of block */
	byte*       block_max;  /* pointer to the end of block */
	int          delta_index;/* = seq->first->start_index   */
	byte*       prev_elem;  /* pointer to previous element */
}

struct CvSeqReader
{
	mixin CV_SEQ_READER_FIELDS!();
}

/****************************************************************************************/
/*                                Operations on sequences                               */
/****************************************************************************************/

auto CV_SEQ_ELEM(elem_type, SEQ)( SEQ seq, size_t index )
{
	/* assert gives some guarantee that <seq> parameter is valid */
	assert(seq.first[0].sizeof == CvSeqBlock.sizeof &&
		seq.elem_size == elem_type.sizeof);
	return cast(elem_type*)(seq.first && cast(size_t)index < (cast(size_t)seq.first.count)
		? seq.first.data + index * elem_type.sizeof
		: cvGetSeqElem( cast(CvSeq*)(seq), index ));
}
auto CV_GET_SEQ_ELEM(elem_type, SEQ)( SEQ seq, size_t index )
{
	CV_SEQ_ELEM!(elem_type)( seq, index);
}

/* Add element to sequence: */
void CV_WRITE_SEQ_ELEM_VAR(ELMPTR, WRITER)(ELMPTR elem_ptr, WRITER writer)
{
	if( writer.ptr >= writer.block_max )
	{
		cvCreateSeqBlock( &writer);
	}
	writer.ptr[0..writer.seq.elem_size] = elem_ptr[0..writer.seq.elem_size];
	writer.ptr += writer.seq.elem_size;
}
void CV_WRITE_SEQ_ELEM(ELM, WRITER)( ELM elem, WRITER writer )
{
	assert( writer.seq.elem_size == elem.sizeof);
	if( writer.ptr >= writer.block_max )
	{
		cvCreateSeqBlock( &writer);
	}
	assert( writer.ptr <= writer.block_max - elem.sizeof);
	writer.ptr[0..writer.seq.elem_size] = (&elem)[0..elem.sizeof];
	writer.ptr += elem.sizeof;
}



/* Move reader position forward: */
void CV_NEXT_SEQ_ELEM(READER)( size_t elem_size, READER reader )
{
	if( (reader.ptr += elem_size) >= reader.block_max )
	{
		cvChangeSeqBlock( &reader, 1 );
	}
}


/* Move reader position backward: */
void CV_PREV_SEQ_ELEM(READER)( size_t elem_size, READER reader )
{
	if( (reader.ptr -= elem_size) < reader.block_min )
	{
		cvChangeSeqBlock( &reader, -1 );
	}
}

/* Read element and move read position forward: */
void CV_READ_SEQ_ELEM(ELM, READER)( ELM elem, READER reader )
{
	assert( reader.seq.elem_size == ELM.sizeof);
	(cast(ubyte*)&elem)[0..ELM.sizeof] = (cast(ubyte*)reader.ptr)[0..ELM.sizeof];
	CV_NEXT_SEQ_ELEM( elem.sizeof, reader );
}

/* Read element and move read position backward: */
void CV_REV_READ_SEQ_ELEM(ELM, READER)( ELM elem, READER reader )
{
	assert( reader.seq.elem_size == elem.sizeof);
	(cast(ubyte*)&elem)[0..ELM.sizeof] = (cast(ubyte*)reader.ptr)[0..ELM.sizeof];
	CV_PREV_SEQ_ELEM( elem.sizeof, reader );
}


void CV_READ_CHAIN_POINT(PT, READER)( ref PT _pt, READER reader )
{
	_pt = reader.pt;
	if( reader.ptr )
	{
		CV_READ_SEQ_ELEM( reader.code, reader);
		assert( (reader.code & ~7) == 0 );
		reader.pt.x += reader.deltas[cast(int)reader.code][0];
		reader.pt.y += reader.deltas[cast(int)reader.code][1];
	}
}

CvPoint CV_CURRENT_POINT(READER)( READER reader ) { return *(cast(CvPoint*)reader.ptr); }
CvPoint CV_PREV_POINT(READER)( READER reader )    { return *(cast(CvPoint*)reader.prev_elem); }

void CV_READ_EDGE(PT1, PT2, READER)( PT1 pt1, PT2 pt2, READER reader )
{
	assert( pt1.sizeof == CvPoint.sizeof &&
	        pt2.sizeof == CvPoint.sizeof &&
	        reader.seq.elem_size == CvPoint.sizeof);
	pt1 = CV_PREV_POINT( reader );
	pt2 = CV_CURRENT_POINT( reader );
	reader.prev_elem = reader.ptr;
	CV_NEXT_SEQ_ELEM( CvPoint.sizeof, reader);
}

/************ Graph macros ************/

/* Return next graph edge for given vertex: */
auto CV_NEXT_GRAPH_EDGE(EDGE,VTX)( EDGE edge, VTX vertex )
{
	assert(edge.vtx[0] == vertex || edge.vtx[1] == vertex);
	return edge.next[edge.vtx[1] == vertex];
}



/****************************************************************************************\
*             Data structures for persistence (a.k.a serialization) functionality        *
\****************************************************************************************/

/* "black box" file storage */
struct CvFileStorage {}

/* Storage flags: */
enum
{
	CV_STORAGE_READ          = 0,
	CV_STORAGE_WRITE         = 1,
	CV_STORAGE_WRITE_TEXT    = CV_STORAGE_WRITE,
	CV_STORAGE_WRITE_BINARY  = CV_STORAGE_WRITE,
	CV_STORAGE_APPEND        = 2,
}

/* List of attributes: */
struct CvAttrList
{
	const(char)** attr;  /* NULL-terminated array of (attribute_name,attribute_value) pairs. */
	CvAttrList* next;    /* Pointer to next chunk of the attributes list.                    */
}

CvAttrList cvAttrList( const(char)**  attr = null, CvAttrList* next = null )
{
	CvAttrList l;
	l.attr = attr;
	l.next = next;

	return l;
}

enum
{
	CV_NODE_NONE        = 0,
	CV_NODE_INT         = 1,
	CV_NODE_INTEGER     = CV_NODE_INT,
	CV_NODE_REAL        = 2,
	CV_NODE_FLOAT       = CV_NODE_REAL,
	CV_NODE_STR         = 3,
	CV_NODE_STRING      = CV_NODE_STR,
	CV_NODE_REF         = 4, /* not used */
	CV_NODE_SEQ         = 5,
	CV_NODE_MAP         = 6,
	CV_NODE_TYPE_MASK   = 7,
}

auto CV_NODE_TYPE(FLG)(FLG flags) { return flags & CV_NODE_TYPE_MASK; }

/* file node flags */
enum
{
	CV_NODE_FLOW       = 8, /* Used only for writing structures in YAML format. */
	CV_NODE_USER       = 16,
	CV_NODE_EMPTY      = 32,
	CV_NODE_NAMED      = 64,
}

auto CV_NODE_IS_INT(FLG)(FLG flags)        { return CV_NODE_TYPE(flags) == CV_NODE_INT; }
auto CV_NODE_IS_REAL(FLG)(FLG flags)       { return CV_NODE_TYPE(flags) == CV_NODE_REAL; }
auto CV_NODE_IS_STRING(FLG)(FLG flags)     { return CV_NODE_TYPE(flags) == CV_NODE_STRING; }
auto CV_NODE_IS_SEQ(FLG)(FLG flags)        { return CV_NODE_TYPE(flags) == CV_NODE_SEQ; }
auto CV_NODE_IS_MAP(FLG)(FLG flags)        { return CV_NODE_TYPE(flags) == CV_NODE_MAP; }
auto CV_NODE_IS_COLLECTION(FLG)(FLG flags) { return CV_NODE_TYPE(flags) >= CV_NODE_SEQ; }
auto CV_NODE_IS_FLOW(FLG)(FLG flags)       { return (flags & CV_NODE_FLOW) != 0; }
auto CV_NODE_IS_EMPTY(FLG)(FLG flags)      { return (flags & CV_NODE_EMPTY) != 0; }
auto CV_NODE_IS_USER(FLG)(FLG flags)       { return (flags & CV_NODE_USER) != 0; }
auto CV_NODE_HAS_NAME(FLG)(FLG flags)      { return (flags & CV_NODE_NAMED) != 0; }

enum CV_NODE_SEQ_SIMPLE = 256;
auto CV_NODE_SEQ_IS_SIMPLE(SEQ)(SEQ seq)   { return (seq.flags & CV_NODE_SEQ_SIMPLE) != 0; }

struct CvString
{
	int len;
	char* ptr;
}

/* All the keys (names) of elements in the readed file storage
   are stored in the hash to speed up the lookup operations: */
struct CvStringHashNode
{
	uint hashval;
	CvString str;
	CvStringHashNode* next;
}

struct CvGenericHash {}
alias CvGenericHash CvFileNodeHash;

/* Basic element of the file storage - scalar or collection: */
struct CvFileNode
{
	int tag;
	CvTypeInfo* info; /* type information
	        (only for user-defined object, for others it is 0) */
	union DataImpl
	{
		double f; /* scalar floating-point number */
		int i;    /* scalar integer number */
		CvString str; /* text string */
		CvSeq* seq; /* sequence (ordered collection of file nodes) */
		CvFileNodeHash* map; /* map (collection of named file nodes) */
	}
	DataImpl data;
}

extern (C)
{
	alias int function( const void* struct_ptr ) CvIsInstanceFunc;
	alias void function( void** struct_dblptr ) CvReleaseFunc;
	alias void* function( CvFileStorage* storage, CvFileNode* node ) CvReadFunc;
	alias void function( CvFileStorage* storage, const char* name,
	                     const void* struct_ptr, CvAttrList attributes ) CvWriteFunc;
	alias void* function( const void* struct_ptr ) CvCloneFunc;
}


struct CvTypeInfo
{
	int flags;
	int header_size;
	CvTypeInfo* prev;
	CvTypeInfo* next;
	const(char)* type_name;
	CvIsInstanceFunc is_instance;
	CvReleaseFunc release;
	CvReadFunc read;
	CvWriteFunc write;
	CvCloneFunc clone;
}


/**** System data types ******/

struct CvPluginFuncInfo
{
	void** func_addr;
	void* default_func_addr;
	const(char)* func_names;
	int search_modules;
	int loaded_from;
}

struct CvModuleInfo
{
	CvModuleInfo* next;
	const(char)* name;
	const(char)* ver;
	CvPluginFuncInfo* func_tab;
}




//##############################################################################
//##### opencv2/core/core_c.h
//##############################################################################


/*M///////////////////////////////////////////////////////////////////////////////////////
//
//  IMPORTANT: READ BEFORE DOWNLOADING, COPYING, INSTALLING OR USING.
//
//  By downloading, copying, installing or using the software you agree to this license.
//  If you do not agree to this license, do not download, install,
//  copy or use the software.
//
//
//                           License Agreement
//                For Open Source Computer Vision Library
//
// Copyright (C) 2000-2008, Intel Corporation, all rights reserved.
// Copyright (C) 2009, Willow Garage Inc., all rights reserved.
// Third party copyrights are property of their respective owners.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
//   * The name of the copyright holders may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
//
// This software is provided by the copyright holders and contributors "as is" and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the Intel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business interruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
//M*/


/****************************************************************************************\
*          Array allocation, deallocation, initialization and access to elements         *
\****************************************************************************************/

/* <malloc> wrapper.
   If there is no enough memory, the function
   (as well as other OpenCV functions that call cvAlloc)
   raises an error. */
void* cvAlloc( size_t size );

/* <free> wrapper.
   Here and further all the memory releasing functions
   (that all call cvFree) take double pointer in order to
   to clear pointer to the data after releasing it.
   Passing pointer to NULL pointer is Ok: nothing happens in this case
*/
void  cvFree_( void* ptr );
void cvFree(PTR)(ref PTR ptr)
{
	cvFree_(ptr);
	ptr = null;
}

/* Allocates and initializes IplImage header */
IplImage* cvCreateImageHeader( CvSize size, int depth, int channels );

/* Inializes IplImage header */
IplImage* cvInitImageHeader( IplImage* image, CvSize size, int depth,
                             int channels, int origin = 0,
                             int alignment = 4);

/* Creates IPL image (header and data) */
IplImage* cvCreateImage( CvSize size, int depth, int channels );

/* Releases (i.e. deallocates) IPL image header */
void cvReleaseImageHeader( IplImage** image );

/* Releases IPL image header and data */
void cvReleaseImage( IplImage** image );

/* Creates a copy of IPL image (widthStep may differ) */
IplImage* cvCloneImage( const IplImage* image );

/* Sets a Channel Of Interest (only a few functions support COI) -
   use cvCopy to extract the selected channel and/or put it back */
void cvSetImageCOI( IplImage* image, int coi );

/* Retrieves image Channel Of Interest */
int cvGetImageCOI( const IplImage* image );

/* Sets image ROI (region of interest) (COI is not changed) */
void cvSetImageROI( IplImage* image, CvRect rect );

/* Resets image ROI and COI */
void cvResetImageROI( IplImage* image );

/* Retrieves image ROI */
CvRect cvGetImageROI( const IplImage* image );

/* Allocates and initalizes CvMat header */
CvMat* cvCreateMatHeader( int rows, int cols, int type );

enum CV_AUTOSTEP = 0x7fffffff;

/* Initializes CvMat header */
CvMat* cvInitMatHeader( CvMat* mat, int rows, int cols,
                              int type, void* data = null,
                              int step = CV_AUTOSTEP );

/* Allocates and initializes CvMat header and allocates data */
CvMat* cvCreateMat( int rows, int cols, int type );

/* Releases CvMat header and deallocates matrix data
   (reference counting is used for data) */
void cvReleaseMat( CvMat** mat );

/* Decrements CvMat data reference counter and deallocates the data if
   it reaches 0 */
void  cvDecRefData( CvArr* arr )
{
	if( CV_IS_MAT( arr ))
	{
		CvMat* mat = cast(CvMat*)arr;
		mat.data.ptr = null;
		if( mat.refcount != null && --*mat.refcount == 0 )
			cvFree( mat.refcount );
		mat.refcount = null;
	}
	else if( CV_IS_MATND( arr ))
	{
		CvMatND* mat = cast(CvMatND*)arr;
		mat.data.ptr = null;
		if( mat.refcount != null && --*mat.refcount == 0 )
			cvFree( mat.refcount );
		mat.refcount = null;
	}
}

/* Increments CvMat data reference counter */
int  cvIncRefData( CvArr* arr )
{
	int refcount = 0;
	if( CV_IS_MAT( arr ))
	{
		CvMat* mat = cast(CvMat*)arr;
		if( mat.refcount != null )
			refcount = ++*mat.refcount;
	}
	else if( CV_IS_MATND( arr ))
	{
		CvMatND* mat = cast(CvMatND*)arr;
		if( mat.refcount != null )
			refcount = ++*mat.refcount;
	}
	return refcount;
}


/* Creates an exact copy of the input matrix (except, may be, step value) */
CvMat* cvCloneMat( const CvMat* mat );


/* Makes a new matrix from <rect> subrectangle of input array.
   No data is copied */
CvMat* cvGetSubRect( const CvArr* arr, CvMat* submat, CvRect rect );
alias cvGetSubRect cvGetSubArr;

/* Selects row span of the input array: arr(start_row:delta_row:end_row,:)
    (end_row is not included into the span). */
CvMat* cvGetRows( const CvArr* arr, CvMat* submat,
                  int start_row, int end_row,
                  int delta_row = 1);

CvMat* cvGetRow( const CvArr* arr, CvMat* submat, int row )
{
	return cvGetRows( arr, submat, row, row + 1, 1 );
}


/* Selects column span of the input array: arr(:,start_col:end_col)
   (end_col is not included into the span) */
CvMat* cvGetCols( const CvArr* arr, CvMat* submat,
                  int start_col, int end_col );

CvMat* cvGetCol( const CvArr* arr, CvMat* submat, int col )
{
	return cvGetCols( arr, submat, col, col + 1 );
}

/* Select a diagonal of the input array.
   (diag = 0 means the main diagonal, >0 means a diagonal above the main one,
   <0 - below the main one).
   The diagonal will be represented as a column (nx1 matrix). */
CvMat* cvGetDiag( const CvArr* arr, CvMat* submat,
                  int diag = 0);

/* low-level scalar <-> raw data conversion functions */
void cvScalarToRawData( const CvScalar* scalar, void* data, int type,
                        int extend_to_12 = 0 );

void cvRawDataToScalar( const void* data, int type, CvScalar* scalar );

/* Allocates and initializes CvMatND header */
CvMatND* cvCreateMatNDHeader( int dims, const int* sizes, int type );

/* Allocates and initializes CvMatND header and allocates data */
CvMatND* cvCreateMatND( int dims, const int* sizes, int type );

/* Initializes preallocated CvMatND header */
CvMatND* cvInitMatNDHeader( CvMatND* mat, int dims, const int* sizes,
                            int type, void* data = null );

/* Releases CvMatND */
void cvReleaseMatND( CvMatND** mat )
{
    cvReleaseMat( cast(CvMat**)mat );
}

/* Creates a copy of CvMatND (except, may be, steps) */
CvMatND* cvCloneMatND( const CvMatND* mat );

/* Allocates and initializes CvSparseMat header and allocates data */
CvSparseMat* cvCreateSparseMat( int dims, const int* sizes, int type );

/* Releases CvSparseMat */
void cvReleaseSparseMat( CvSparseMat** mat );

/* Creates a copy of CvSparseMat (except, may be, zero items) */
CvSparseMat* cvCloneSparseMat( const CvSparseMat* mat );

/* Initializes sparse array iterator
   (returns the first node or NULL if the array is empty) */
CvSparseNode* cvInitSparseMatIterator( const CvSparseMat* mat,
                                       CvSparseMatIterator* mat_iterator );

// returns next sparse array node (or NULL if there is no more nodes)
CvSparseNode* cvGetNextSparseNode( CvSparseMatIterator* mat_iterator )
{
	if( mat_iterator.node.next )
	    return mat_iterator.node = mat_iterator.node.next;
	else
	{
		int idx;
		for( idx = ++mat_iterator.curidx; idx < mat_iterator.mat.hashsize; idx++ )
		{
			CvSparseNode* node = cast(CvSparseNode*)mat_iterator.mat.hashtable[idx];
			if( node )
			{
				mat_iterator.curidx = idx;
				return mat_iterator.node = node;
			}
		}
		return null;
	}
}

/**************** matrix iterator: used for n-ary operations on dense arrays *********/

enum CV_MAX_ARR = 10;

struct CvNArrayIterator
{
	int count; /* number of arrays */
	int dims; /* number of dimensions to iterate */
	CvSize size; /* maximal common linear size: { width = size, height = 1 } */
	ubyte*[CV_MAX_ARR] ptr; /* pointers to the array slices */
	int[CV_MAX_DIM] stack; /* for internal use */
	CvMatND*[CV_MAX_ARR] hdr; /* pointers to the headers of the
	                             matrices that are processed */
}

enum
{
	CV_NO_DEPTH_CHECK    = 1,
	CV_NO_CN_CHECK       = 2,
	CV_NO_SIZE_CHECK     = 4,
}

/* initializes iterator that traverses through several arrays simulteneously
   (the function together with cvNextArraySlice is used for
    N-ari element-wise operations) */
int cvInitNArrayIterator( int count, CvArr** arrs,
                          const CvArr* mask, CvMatND* stubs,
                          CvNArrayIterator* array_iterator,
                          int flags = 0 );

/* returns zero value if iteration is finished, non-zero (slice length) otherwise */
int cvNextNArraySlice( CvNArrayIterator* array_iterator );


/* Returns type of array elements:
   CV_8UC1 ... CV_64FC4 ... */
int cvGetElemType( const CvArr* arr );

/* Retrieves number of an array dimensions and
   optionally sizes of the dimensions */
int cvGetDims( const CvArr* arr, int* sizes = null );


/* Retrieves size of a particular array dimension.
   For 2d arrays cvGetDimSize(arr,0) returns number of rows (image height)
   and cvGetDimSize(arr,1) returns number of columns (image width) */
int cvGetDimSize( const CvArr* arr, int index );


/* ptr = &arr(idx0,idx1,...). All indexes are zero-based,
   the major dimensions go first (e.g. (y,x) for 2D, (z,y,x) for 3D */
ubyte* cvPtr1D( const CvArr* arr, int idx0, int* type = null);
ubyte* cvPtr2D( const CvArr* arr, int idx0, int idx1, int* type = null );
ubyte* cvPtr3D( const CvArr* arr, int idx0, int idx1, int idx2,
                int* type = null);

/* For CvMat or IplImage number of indices should be 2
   (row index (y) goes first, column index (x) goes next).
   For CvMatND or CvSparseMat number of infices should match number of <dims> and
   indices order should match the array dimension order. */
ubyte* cvPtrND( const CvArr* arr, const int* idx, int* type = null,
                int create_node = 1,
                uint* precalc_hashval = null);

/* value = arr(idx0,idx1,...) */
CvScalar cvGet1D( const CvArr* arr, int idx0 );
CvScalar cvGet2D( const CvArr* arr, int idx0, int idx1 );
CvScalar cvGet3D( const CvArr* arr, int idx0, int idx1, int idx2 );
CvScalar cvGetND( const CvArr* arr, const int* idx );

/* for 1-channel arrays */
double cvGetReal1D( const CvArr* arr, int idx0 );
double cvGetReal2D( const CvArr* arr, int idx0, int idx1 );
double cvGetReal3D( const CvArr* arr, int idx0, int idx1, int idx2 );
double cvGetRealND( const CvArr* arr, const int* idx );

/* arr(idx0,idx1,...) = value */
void cvSet1D( CvArr* arr, int idx0, CvScalar value );
void cvSet2D( CvArr* arr, int idx0, int idx1, CvScalar value );
void cvSet3D( CvArr* arr, int idx0, int idx1, int idx2, CvScalar value );
void cvSetND( CvArr* arr, const int* idx, CvScalar value );

/* for 1-channel arrays */
void cvSetReal1D( CvArr* arr, int idx0, double value );
void cvSetReal2D( CvArr* arr, int idx0, int idx1, double value );
void cvSetReal3D( CvArr* arr, int idx0,
                        int idx1, int idx2, double value );
void cvSetRealND( CvArr* arr, const int* idx, double value );

/* clears element of ND dense array,
   in case of sparse arrays it deletes the specified node */
void cvClearND( CvArr* arr, const int* idx );

/* Converts CvArr (IplImage or CvMat,...) to CvMat.
   If the last parameter is non-zero, function can
   convert multi(>2)-dimensional array to CvMat as long as
   the last array's dimension is continous. The resultant
   matrix will be have appropriate (a huge) number of rows */
CvMat* cvGetMat( const CvArr* arr, CvMat* header,
                 int* coi = null,
                 int allowND = 0);

/* Converts CvArr (IplImage or CvMat) to IplImage */
IplImage* cvGetImage( const CvArr* arr, IplImage* image_header );


/* Changes a shape of multi-dimensional array.
   new_cn == 0 means that number of channels remains unchanged.
   new_dims == 0 means that number and sizes of dimensions remain the same
   (unless they need to be changed to set the new number of channels)
   if new_dims == 1, there is no need to specify new dimension sizes
   The resultant configuration should be achievable w/o data copying.
   If the resultant array is sparse, CvSparseMat header should be passed
   to the function else if the result is 1 or 2 dimensional,
   CvMat header should be passed to the function
   else CvMatND header should be passed */
CvArr* cvReshapeMatND( const CvArr* arr,
                       int sizeof_header, CvArr* header,
                       int new_cn, int new_dims, int* new_sizes );

auto cvReshapeND(HEADER)( const CvArr* arr, HEADER header, int new_cn, int new_dims, int* new_sizes )
{
	return cvReshapeMatND( arr, (*header).sizeof, header, new_cn, new_dims, new_sizes);
}

CvMat* cvReshape( const CvArr* arr, CvMat* header,
                  int new_cn, int new_rows = 0 );

/* Repeats source 2d array several times in both horizontal and
   vertical direction to fill destination array */
void cvRepeat( const CvArr* src, CvArr* dst );

/* Allocates array data */
void cvCreateData( CvArr* arr );

/* Releases array data */
void cvReleaseData( CvArr* arr );

/* Attaches user data to the array header. The step is reffered to
   the pre-last dimension. That is, all the planes of the array
   must be joint (w/o gaps) */
void cvSetData( CvArr* arr, void* data, int step );

/* Retrieves raw data of CvMat, IplImage or CvMatND.
   In the latter case the function raises an error if
   the array can not be represented as a matrix */
void cvGetRawData( const CvArr* arr, ubyte** data,
                   int* step = null,
                   CvSize* roi_size = null);

/* Returns width and height of array in elements */
CvSize cvGetSize( const CvArr* arr );

/* Copies source array to destination array */
void cvCopy( const CvArr* src, CvArr* dst,
             const CvArr* mask = null );

/* Sets all or "masked" elements of input array
   to the same value*/
void cvSet( CvArr* arr, CvScalar value,
            const CvArr* mask = null );

/* Clears all the array elements (sets them to 0) */
void cvSetZero( CvArr* arr );
alias cvSetZero cvZero;


/* Splits a multi-channel array into the set of single-channel arrays or
   extracts particular [color] plane */
void cvSplit( const CvArr* src, CvArr* dst0, CvArr* dst1,
              CvArr* dst2, CvArr* dst3 );

/* Merges a set of single-channel arrays into the single multi-channel array
   or inserts one particular [color] plane to the array */
void cvMerge( const CvArr* src0, const CvArr* src1,
              const CvArr* src2, const CvArr* src3,
              CvArr* dst );

/* Copies several channels from input arrays to
   certain channels of output arrays */
void cvMixChannels( const CvArr** src, int src_count,
                    CvArr** dst, int dst_count,
                    const int* from_to, int pair_count );

/* Performs linear transformation on every source array element:
   dst(x,y,c) = scale*src(x,y,c)+shift.
   Arbitrary combination of input and output array depths are allowed
   (number of channels must be the same), thus the function can be used
   for type conversion */
void cvConvertScale( const CvArr* src, CvArr* dst,
                     double scale = 1,
                     double shift = 0 );
alias cvConvertScale cvCvtScale;
alias cvConvertScale cvScale;
void cvConvert( const CvArr* src, CvArr* dst ) { cvConvertScale( src, dst, 1, 0 ); }


/* Performs linear transformation on every source array element,
   stores absolute value of the result:
   dst(x,y,c) = abs(scale*src(x,y,c)+shift).
   destination array must have 8u type.
   In other cases one may use cvConvertScale + cvAbsDiffS */
void cvConvertScaleAbs( const CvArr* src, CvArr* dst,
                        double scale = 1,
                        double shift = 0 );
alias cvConvertScaleAbs cvCvtScaleAbs;


/* checks termination criteria validity and
   sets eps to default_eps (if it is not set),
   max_iter to default_max_iters (if it is not set)
*/
CvTermCriteria cvCheckTermCriteria( CvTermCriteria criteria,
                                    double default_eps,
                                    int default_max_iters );

/****************************************************************************************\
*                   Arithmetic, logic and comparison operations                          *
\****************************************************************************************/

/* dst(mask) = src1(mask) + src2(mask) */
void cvAdd( const CvArr* src1, const CvArr* src2, CvArr* dst,
            const CvArr* mask = null);

/* dst(mask) = src(mask) + value */
void cvAddS( const CvArr* src, CvScalar value, CvArr* dst,
             const CvArr* mask = null);

/* dst(mask) = src1(mask) - src2(mask) */
void cvSub( const CvArr* src1, const CvArr* src2, CvArr* dst,
            const CvArr* mask = null);

/* dst(mask) = src(mask) - value = src(mask) + (-value) */
void  cvSubS( const CvArr* src, CvScalar value, CvArr* dst,
              const CvArr* mask = null)
{
	cvAddS( src, cvScalar( -value.val[0], -value.val[1], -value.val[2], -value.val[3]),
		dst, mask );
}

/* dst(mask) = value - src(mask) */
void cvSubRS( const CvArr* src, CvScalar value, CvArr* dst,
              const CvArr* mask = null);

/* dst(idx) = src1(idx) * src2(idx) * scale
   (scaled element-wise multiplication of 2 arrays) */
void cvMul( const CvArr* src1, const CvArr* src2,
            CvArr* dst, double scale = 1 );

/* element-wise division/inversion with scaling:
    dst(idx) = src1(idx) * scale / src2(idx)
    or dst(idx) = scale / src2(idx) if src1 == 0 */
void cvDiv( const CvArr* src1, const CvArr* src2,
            CvArr* dst, double scale = 1);

/* dst = src1 * scale + src2 */
void cvScaleAdd( const CvArr* src1, CvScalar scale,
                 const CvArr* src2, CvArr* dst );
void cvAXPY( const CvArr* a, double real_scalar, const CvArr* b, CvArr* c )
{
	cvScaleAdd(a, cvRealScalar(real_scalar), b, c);
}

/* dst = src1 * alpha + src2 * beta + gamma */
void cvAddWeighted( const CvArr* src1, double alpha,
                    const CvArr* src2, double beta,
                    double gamma, CvArr* dst );

/* result = sum_i(src1(i) * src2(i)) (results for all channels are accumulated together) */
double cvDotProduct( const CvArr* src1, const CvArr* src2 );

/* dst(idx) = src1(idx) & src2(idx) */
void cvAnd( const CvArr* src1, const CvArr* src2,
            CvArr* dst, const CvArr* mask = null);

/* dst(idx) = src(idx) & value */
void cvAndS( const CvArr* src, CvScalar value,
             CvArr* dst, const CvArr* mask = null);

/* dst(idx) = src1(idx) | src2(idx) */
void cvOr( const CvArr* src1, const CvArr* src2,
           CvArr* dst, const CvArr* mask = null);

/* dst(idx) = src(idx) | value */
void cvOrS( const CvArr* src, CvScalar value,
            CvArr* dst, const CvArr* mask = null);

/* dst(idx) = src1(idx) ^ src2(idx) */
void cvXor( const CvArr* src1, const CvArr* src2,
            CvArr* dst, const CvArr* mask = null);

/* dst(idx) = src(idx) ^ value */
void cvXorS( const CvArr* src, CvScalar value,
             CvArr* dst, const CvArr* mask = null);

/* dst(idx) = ~src(idx) */
void cvNot( const CvArr* src, CvArr* dst );

/* dst(idx) = lower(idx) <= src(idx) < upper(idx) */
void cvInRange( const CvArr* src, const CvArr* lower,
                const CvArr* upper, CvArr* dst );

/* dst(idx) = lower <= src(idx) < upper */
void cvInRangeS( const CvArr* src, CvScalar lower,
                 CvScalar upper, CvArr* dst );

enum
{
	CV_CMP_EQ  = 0,
	CV_CMP_GT  = 1,
	CV_CMP_GE  = 2,
	CV_CMP_LT  = 3,
	CV_CMP_LE  = 4,
	CV_CMP_NE  = 5,
}

/* The comparison operation support single-channel arrays only.
   Destination image should be 8uC1 or 8sC1 */

/* dst(idx) = src1(idx) _cmp_op_ src2(idx) */
void cvCmp( const CvArr* src1, const CvArr* src2, CvArr* dst, int cmp_op );

/* dst(idx) = src1(idx) _cmp_op_ value */
void cvCmpS( const CvArr* src, double value, CvArr* dst, int cmp_op );

/* dst(idx) = min(src1(idx),src2(idx)) */
void cvMin( const CvArr* src1, const CvArr* src2, CvArr* dst );

/* dst(idx) = max(src1(idx),src2(idx)) */
void cvMax( const CvArr* src1, const CvArr* src2, CvArr* dst );

/* dst(idx) = min(src(idx),value) */
void cvMinS( const CvArr* src, double value, CvArr* dst );

/* dst(idx) = max(src(idx),value) */
void cvMaxS( const CvArr* src, double value, CvArr* dst );

/* dst(x,y,c) = abs(src1(x,y,c) - src2(x,y,c)) */
void cvAbsDiff( const CvArr* src1, const CvArr* src2, CvArr* dst );

/* dst(x,y,c) = abs(src(x,y,c) - value(c)) */
void cvAbsDiffS( const CvArr* src, CvArr* dst, CvScalar value );
void cvAbs( const CvArr* src, CvArr* dst ) { cvAbsDiffS( src, dst, cvScalarAll(0)); }

/****************************************************************************************\
*                                Math operations                                         *
\****************************************************************************************/

/* Does cartesian->polar coordinates conversion.
   Either of output components (magnitude or angle) is optional */
void cvCartToPolar( const CvArr* x, const CvArr* y,
                    CvArr* magnitude, CvArr* angle = null,
                    int angle_in_degrees = 0);

/* Does polar->cartesian coordinates conversion.
   Either of output components (magnitude or angle) is optional.
   If magnitude is missing it is assumed to be all 1's */
void cvPolarToCart( const CvArr* magnitude, const CvArr* angle,
                    CvArr* x, CvArr* y,
                    int angle_in_degrees = 0);

/* Does powering: dst(idx) = src(idx)^power */
void cvPow( const CvArr* src, CvArr* dst, double power );

/* Does exponention: dst(idx) = exp(src(idx)).
   Overflow is not handled yet. Underflow is handled.
   Maximal relative error is ~7e-6 for single-precision input */
void cvExp( const CvArr* src, CvArr* dst );

/* Calculates natural logarithms: dst(idx) = log(abs(src(idx))).
   Logarithm of 0 gives large negative number(~-700)
   Maximal relative error is ~3e-7 for single-precision output
*/
void cvLog( const CvArr* src, CvArr* dst );

/* Fast arctangent calculation */
float cvFastArctan( float y, float x );

/* Fast cubic root calculation */
float cvCbrt( float value );

/* Checks array values for NaNs, Infs or simply for too large numbers
   (if CV_CHECK_RANGE is set). If CV_CHECK_QUIET is set,
   no runtime errors is raised (function returns zero value in case of "bad" values).
   Otherwise cvError is called */
enum CV_CHECK_RANGE = 1;
enum CV_CHECK_QUIET = 2;
int cvCheckArr( const CvArr* arr, int flags = 0,
                double min_val = 0, double max_val = 0);
alias cvCheckArr cvCheckArray;

enum CV_RAND_UNI     = 0;
enum CV_RAND_NORMAL  = 1;
void cvRandArr( CvRNG* rng, CvArr* arr, int dist_type,
                CvScalar param1, CvScalar param2 );

void cvRandShuffle( CvArr* mat, CvRNG* rng,
                    double iter_factor = 1.0);
enum
{
	CV_SORT_EVERY_ROW    = 0,
	CV_SORT_EVERY_COLUMN = 1,
	CV_SORT_ASCENDING    = 0,
	CV_SORT_DESCENDING   = 16,
}

void cvSort( const CvArr* src, CvArr* dst = null,
                    CvArr* idxmat = null,
                    int flags = 0);

/* Finds real roots of a cubic equation */
int cvSolveCubic( const CvMat* coeffs, CvMat* roots );

/* Finds all real and complex roots of a polynomial equation */
void cvSolvePoly(const CvMat* coeffs, CvMat *roots2,
                 int maxiter = 20, int fig = 100);

/****************************************************************************************\
*                                Matrix operations                                       *
\****************************************************************************************/

/* Calculates cross product of two 3d vectors */
void cvCrossProduct( const CvArr* src1, const CvArr* src2, CvArr* dst );

/* Matrix transform: dst = A*B + C, C is optional */
void cvMatMulAdd( const CvArr* src1, const CvArr* src2, const CvArr* src3, CvArr* dst ) { cvGEMM( src1, src2, 1.0, src3, 1.0, dst, 0 ); }
void cvMatMul( const CvArr* src1, const CvArr* src2, CvArr* dst ) { cvMatMulAdd( src1, src2, null, dst); }

enum
{
	CV_GEMM_A_T = 1,
	CV_GEMM_B_T = 2,
	CV_GEMM_C_T = 4,
}
/* Extended matrix transform:
   dst = alpha*op(A)*op(B) + beta*op(C), where op(X) is X or X^T */
void cvGEMM( const CvArr* src1, const CvArr* src2, double alpha,
             const CvArr* src3, double beta, CvArr* dst,
             int tABC = 0);
alias cvGEMM cvMatMulAddEx;

/* Transforms each element of source array and stores
   resultant vectors in destination array */
void cvTransform( const CvArr* src, CvArr* dst,
                  const CvMat* transmat,
                  const CvMat* shiftvec = null);
alias cvTransform cvMatMulAddS;

/* Does perspective transform on every element of input array */
void cvPerspectiveTransform( const CvArr* src, CvArr* dst,
                             const CvMat* mat );

/* Calculates (A-delta)*(A-delta)^T (order=0) or (A-delta)^T*(A-delta) (order=1) */
void cvMulTransposed( const CvArr* src, CvArr* dst, int order,
                      const CvArr* delta = null,
                      double scale = 1.0 );

/* Tranposes matrix. Square matrices can be transposed in-place */
void cvTranspose( const CvArr* src, CvArr* dst );
alias cvTranspose cvT;

/* Completes the symmetric matrix from the lower (LtoR=0) or from the upper (LtoR!=0) part */
void cvCompleteSymm( CvMat* matrix, int LtoR = 0 );

/* Mirror array data around horizontal (flip=0),
   vertical (flip=1) or both(flip=-1) axises:
   cvFlip(src) flips images vertically and sequences horizontally (inplace) */
void cvFlip( const CvArr* src, CvArr* dst = null,
                     int flip_mode = 0);
alias cvFlip cvMirror;

enum
{
	CV_SVD_MODIFY_A  = 1,
	CV_SVD_U_T       = 2,
	CV_SVD_V_T       = 4,
}

/* Performs Singular Value Decomposition of a matrix */
void  cvSVD( CvArr* A, CvArr* W, CvArr* U = null,
             CvArr* V = null, int flags = 0);

/* Performs Singular Value Back Substitution (solves A*X = B):
   flags must be the same as in cvSVD */
void  cvSVBkSb( const CvArr* W, const CvArr* U,
                const CvArr* V, const CvArr* B,
                CvArr* X, int flags );

enum
{
	CV_LU       = 0,
	CV_SVD      = 1,
	CV_SVD_SYM  = 2,
	CV_CHOLESKY = 3,
	CV_QR       = 4,
	CV_NORMAL   = 16,
}

/* Inverts matrix */
double cvInvert( const CvArr* src, CvArr* dst,
                         int method = CV_LU);
alias cvInvert cvInv;

/* Solves linear system (src1)*(dst) = (src2)
   (returns 0 if src1 is a singular and CV_LU method is used) */
int cvSolve( const CvArr* src1, const CvArr* src2, CvArr* dst,
             int method = CV_LU);

/* Calculates determinant of input matrix */
double cvDet( const CvArr* mat );

/* Calculates trace of the matrix (sum of elements on the main diagonal) */
CvScalar cvTrace( const CvArr* mat );

/* Finds eigen values and vectors of a symmetric matrix */
void cvEigenVV( CvArr* mat, CvArr* evects, CvArr* evals,
                double eps = 0,
                int lowindex = -1,
                int highindex = -1);

///* Finds selected eigen values and vectors of a symmetric matrix */
//void cvSelectedEigenVV( CvArr* mat, CvArr* evects, CvArr* evals,
//                                int lowindex, int highindex );

/* Makes an identity matrix (mat_ij = i == j) */
void cvSetIdentity( CvArr* mat, CvScalar value = cvRealScalar(1) );

/* Fills matrix with given range of numbers */
CvArr* cvRange( CvArr* mat, double start, double end );

/* Calculates covariation matrix for a set of vectors */
/* transpose([v1-avg, v2-avg,...]) * [v1-avg,v2-avg,...] */
enum CV_COVAR_SCRAMBLED = 0;

/* [v1-avg, v2-avg,...] * transpose([v1-avg,v2-avg,...]) */
enum CV_COVAR_NORMAL   = 1;

/* do not calc average (i.e. mean vector) - use the input vector instead
   (useful for calculating covariance matrix by parts) */
enum CV_COVAR_USE_AVG  = 2;

/* scale the covariance matrix coefficients by number of the vectors */
enum CV_COVAR_SCALE    = 4;

/* all the input vectors are stored in a single matrix, as its rows */
enum CV_COVAR_ROWS     = 8;

/* all the input vectors are stored in a single matrix, as its columns */
enum CV_COVAR_COLS    = 16;

void cvCalcCovarMatrix( const CvArr** vects, int count,
                                CvArr* cov_mat, CvArr* avg, int flags );

enum
{
	CV_PCA_DATA_AS_ROW = 0,
	CV_PCA_DATA_AS_COL = 1,
	CV_PCA_USE_AVG     = 2,
}

void cvCalcPCA( const CvArr* data, CvArr* mean,
                CvArr* eigenvals, CvArr* eigenvects, int flags );

void cvProjectPCA( const CvArr* data, const CvArr* mean,
                   const CvArr* eigenvects, CvArr* result );

void cvBackProjectPCA( const CvArr* proj, const CvArr* mean,
                       const CvArr* eigenvects, CvArr* result );

/* Calculates Mahalanobis(weighted) distance */
double cvMahalanobis( const CvArr* vec1, const CvArr* vec2, const CvArr* mat );
alias cvMahalanobis cvMahalonobis;

/****************************************************************************************\
*                                    Array Statistics                                    *
\****************************************************************************************/

/* Finds sum of array elements */
CvScalar cvSum( const CvArr* arr );

/* Calculates number of non-zero pixels */
int cvCountNonZero( const CvArr* arr );

/* Calculates mean value of array elements */
CvScalar cvAvg( const CvArr* arr, const CvArr* mask = null );

/* Calculates mean and standard deviation of pixel values */
void cvAvgSdv( const CvArr* arr, CvScalar* mean, CvScalar* std_dev,
                       const CvArr* mask = null );

/* Finds global minimum, maximum and their positions */
void cvMinMaxLoc( const CvArr* arr, double* min_val, double* max_val,
                  CvPoint* min_loc = null,
                  CvPoint* max_loc = null,
                  const CvArr* mask = null );

/* types of array norm */
enum
{
	CV_C           = 1,
	CV_L1          = 2,
	CV_L2          = 4,
	CV_NORM_MASK   = 7,
	CV_RELATIVE    = 8,
	CV_DIFF        = 16,
	CV_MINMAX      = 32,
	
	CV_DIFF_C      = CV_DIFF | CV_C,
	CV_DIFF_L1     = CV_DIFF | CV_L1,
	CV_DIFF_L2     = CV_DIFF | CV_L2,
	CV_RELATIVE_C  = CV_RELATIVE | CV_C,
	CV_RELATIVE_L1 = CV_RELATIVE | CV_L1,
	CV_RELATIVE_L2 = CV_RELATIVE | CV_L2,
}

/* Finds norm, difference norm or relative difference norm for an array (or two arrays) */
double cvNorm( const CvArr* arr1, const CvArr* arr2 = null,
               int norm_type = CV_L2,
               const CvArr* mask = null );

void cvNormalize( const CvArr* src, CvArr* dst,
                  double a = 1.0, double b = 0.0,
                  int norm_type = CV_L2,
                  const CvArr* mask = null );


enum
{
	CV_REDUCE_SUM = 0,
	CV_REDUCE_AVG = 1,
	CV_REDUCE_MAX = 2,
	CV_REDUCE_MIN = 3,
}

void cvReduce( const CvArr* src, CvArr* dst, int dim = -1,
               int op = CV_REDUCE_SUM );

/****************************************************************************************\
*                      Discrete Linear Transforms and Related Functions                  *
\****************************************************************************************/

enum
{
	CV_DXT_FORWARD  = 0,
	CV_DXT_INVERSE  = 1,
	CV_DXT_SCALE    = 2, /* divide result by size of array */
	CV_DXT_INV_SCALE = (CV_DXT_INVERSE + CV_DXT_SCALE),
	CV_DXT_INVERSE_SCALE = CV_DXT_INV_SCALE,
	CV_DXT_ROWS     = 4, /* transform each row individually */
	CV_DXT_MUL_CONJ = 8, /* conjugate the second argument of cvMulSpectrums */
}

/* Discrete Fourier Transform:
    complex->complex,
    real->ccs (forward),
    ccs->real (inverse) */
void cvDFT( const CvArr* src, CvArr* dst, int flags,
            int nonzero_rows = 0 );
alias cvDFT cvFFT;

/* Multiply results of DFTs: DFT(X)*DFT(Y) or DFT(X)*conj(DFT(Y)) */
void cvMulSpectrums( const CvArr* src1, const CvArr* src2,
                     CvArr* dst, int flags );

/* Finds optimal DFT vector size >= size0 */
int cvGetOptimalDFTSize( int size0 );

/* Discrete Cosine Transform */
void cvDCT( const CvArr* src, CvArr* dst, int flags );

/****************************************************************************************\
*                              Dynamic data structures                                   *
\****************************************************************************************/

/* Calculates length of sequence slice (with support of negative indices). */
int cvSliceLength( CvSlice slice, const CvSeq* seq );


/* Creates new memory storage.
   block_size == 0 means that default,
   somewhat optimal size, is used (currently, it is 64K) */
CvMemStorage* cvCreateMemStorage( int block_size = 0);


/* Creates a memory storage that will borrow memory blocks from parent storage */
CvMemStorage* cvCreateChildMemStorage( CvMemStorage* parent );


/* Releases memory storage. All the children of a parent must be released before
   the parent. A child storage returns all the blocks to parent when it is released */
void cvReleaseMemStorage( CvMemStorage** storage );


/* Clears memory storage. This is the only way(!!!) (besides cvRestoreMemStoragePos)
   to reuse memory allocated for the storage - cvClearSeq,cvClearSet ...
   do not free any memory.
   A child storage returns all the blocks to the parent when it is cleared */
void cvClearMemStorage( CvMemStorage* storage );

/* Remember a storage "free memory" position */
void cvSaveMemStoragePos( const CvMemStorage* storage, CvMemStoragePos* pos );

/* Restore a storage "free memory" position */
void cvRestoreMemStoragePos( CvMemStorage* storage, CvMemStoragePos* pos );

/* Allocates continuous buffer of the specified size in the storage */
void* cvMemStorageAlloc( CvMemStorage* storage, size_t size );

/* Allocates string in memory storage */
CvString cvMemStorageAllocString( CvMemStorage* storage, const char* ptr,
                                  int len = -1 );

/* Creates new empty sequence that will reside in the specified storage */
CvSeq* cvCreateSeq( int seq_flags, size_t header_size,
                    size_t elem_size, CvMemStorage* storage );

/* Changes default size (granularity) of sequence blocks.
   The default size is ~1Kbyte */
void cvSetSeqBlockSize( CvSeq* seq, int delta_elems );


/* Adds new element to the end of sequence. Returns pointer to the element */
byte* cvSeqPush( CvSeq* seq, const void* element = null);


/* Adds new element to the beginning of sequence. Returns pointer to it */
byte* cvSeqPushFront( CvSeq* seq, const void* element = null);


/* Removes the last element from sequence and optionally saves it */
void cvSeqPop( CvSeq* seq, void* element = null);


/* Removes the first element from sequence and optioanally saves it */
void cvSeqPopFront( CvSeq* seq, void* element = null);

enum
{
	CV_FRONT = 1,
	CV_BACK  = 0,
}
/* Adds several new elements to the end of sequence */
void cvSeqPushMulti( CvSeq* seq, const void* elements,
                     int count, int in_front = 0 );

/* Removes several elements from the end of sequence and optionally saves them */
void cvSeqPopMulti( CvSeq* seq, void* elements,
                    int count, int in_front = 0 );

/* Inserts a new element in the middle of sequence.
   cvSeqInsert(seq,0,elem) == cvSeqPushFront(seq,elem) */
byte* cvSeqInsert( CvSeq* seq, int before_index,
                   const void* element = null);

/* Removes specified sequence element */
void cvSeqRemove( CvSeq* seq, int index );


/* Removes all the elements from the sequence. The freed memory
   can be reused later only by the same sequence unless cvClearMemStorage
   or cvRestoreMemStoragePos is called */
void cvClearSeq( CvSeq* seq );


/* Retrieves pointer to specified sequence element.
   Negative indices are supported and mean counting from the end
   (e.g -1 means the last sequence element) */
byte* cvGetSeqElem( const CvSeq* seq, int index );

/* Calculates index of the specified sequence element.
   Returns -1 if element does not belong to the sequence */
int cvSeqElemIdx( const CvSeq* seq, const void* element,
                  CvSeqBlock** block = null );

/* Initializes sequence writer. The new elements will be added to the end of sequence */
void cvStartAppendToSeq( CvSeq* seq, CvSeqWriter* writer );


/* Combination of cvCreateSeq and cvStartAppendToSeq */
void cvStartWriteSeq( int seq_flags, int header_size,
                      int elem_size, CvMemStorage* storage,
                      CvSeqWriter* writer );

/* Closes sequence writer, updates sequence header and returns pointer
   to the resultant sequence
   (which may be useful if the sequence was created using cvStartWriteSeq))
*/
CvSeq* cvEndWriteSeq( CvSeqWriter* writer );


/* Updates sequence header. May be useful to get access to some of previously
   written elements via cvGetSeqElem or sequence reader */
void  cvFlushSeqWriter( CvSeqWriter* writer );


/* Initializes sequence reader.
   The sequence can be read in forward or backward direction */
void cvStartReadSeq( const CvSeq* seq, CvSeqReader* reader,
                     int reverse = 0 );


/* Returns current sequence reader position (currently observed sequence element) */
int cvGetSeqReaderPos( CvSeqReader* reader );


/* Changes sequence reader position. It may seek to an absolute or
   to relative to the current position */
void  cvSetSeqReaderPos( CvSeqReader* reader, int index,
                         int is_relative = 0);

/* Copies sequence content to a continuous piece of memory */
void* cvCvtSeqToArray( const CvSeq* seq, void* elements,
                       CvSlice slice = CV_WHOLE_SEQ );

/* Creates sequence header for array.
   After that all the operations on sequences that do not alter the content
   can be applied to the resultant sequence */
CvSeq* cvMakeSeqHeaderForArray( int seq_type, int header_size,
                                int elem_size, void* elements, int total,
                                CvSeq* seq, CvSeqBlock* block );

/* Extracts sequence slice (with or without copying sequence elements) */
CvSeq* cvSeqSlice( const CvSeq* seq, CvSlice slice,
                   CvMemStorage* storage = null,
                   int copy_data = 0);

CvSeq* cvCloneSeq( const CvSeq* seq, CvMemStorage* storage = null)
{
	return cvSeqSlice( seq, CV_WHOLE_SEQ, storage, 1 );
}

/* Removes sequence slice */
void cvSeqRemoveSlice( CvSeq* seq, CvSlice slice );

/* Inserts a sequence or array into another sequence */
void cvSeqInsertSlice( CvSeq* seq, int before_index, const CvArr* from_arr );

/* a < b ? -1 : a > b ? 1 : 0 */
alias int function(const void* a, const void* b, void* userdata ) CvCmpFunc;

/* Sorts sequence in-place given element comparison function */
void cvSeqSort( CvSeq* seq, CvCmpFunc func, void* userdata = null );

/* Finds element in a [sorted] sequence */
byte* cvSeqSearch( CvSeq* seq, const void* elem, CvCmpFunc func,
                   int is_sorted, int* elem_idx,
                   void* userdata = null );

/* Reverses order of sequence elements in-place */
void cvSeqInvert( CvSeq* seq );

/* Splits sequence into one or more equivalence classes using the specified criteria */
int cvSeqPartition( const CvSeq* seq, CvMemStorage* storage,
                    CvSeq** labels, CvCmpFunc is_equal, void* userdata );

/************ Internal sequence functions ************/
void cvChangeSeqBlock( void* reader, int direction );
void cvCreateSeqBlock( CvSeqWriter* writer );


/* Creates a new set */
CvSet* cvCreateSet( int set_flags, int header_size,
                    int elem_size, CvMemStorage* storage );

/* Adds new element to the set and returns pointer to it */
int cvSetAdd( CvSet* set_header, CvSetElem* elem = null,
              CvSetElem** inserted_elem = null );

/* Fast variant of cvSetAdd */
CvSetElem* cvSetNew( CvSet* set_header )
{
	CvSetElem* elem = set_header.free_elems;
	if( elem )
	{
		set_header.free_elems = elem.next_free;
		elem.flags = elem.flags & CV_SET_ELEM_IDX_MASK;
		set_header.active_count++;
	}
	else
	{
		cvSetAdd( set_header, null, cast(CvSetElem**)&elem );
	}
	return elem;
}

/* Removes set element given its pointer */
void cvSetRemoveByPtr( CvSet* set_header, void* elem )
{
	CvSetElem* _elem = cast(CvSetElem*)elem;
	assert( _elem.flags >= 0 /*&& (elem.flags & CV_SET_ELEM_IDX_MASK) < set_header.total*/ );
	_elem.next_free = set_header.free_elems;
	_elem.flags = (_elem.flags & CV_SET_ELEM_IDX_MASK) | CV_SET_ELEM_FREE_FLAG;
	set_header.free_elems = _elem;
	set_header.active_count--;
}

/* Removes element from the set by its index  */
void  cvSetRemove( CvSet* set_header, int index );

/* Returns a set element by index. If the element doesn't belong to the set,
   NULL is returned */
CvSetElem* cvGetSetElem( const CvSet* set_header, int index )
{
	CvSetElem* elem = cast(CvSetElem*)cvGetSeqElem( cast(CvSeq*)set_header, index );
	return elem && CV_IS_SET_ELEM( elem ) ? elem : null;
}

/* Removes all the elements from the set */
void cvClearSet( CvSet* set_header );

/* Creates new graph */
CvGraph* cvCreateGraph( int graph_flags, int header_size,
                        int vtx_size, int edge_size,
                        CvMemStorage* storage );

/* Adds new vertex to the graph */
int cvGraphAddVtx( CvGraph* graph, const CvGraphVtx* vtx = null,
                   CvGraphVtx** inserted_vtx = null );


/* Removes vertex from the graph together with all incident edges */
int cvGraphRemoveVtx( CvGraph* graph, int index );
int cvGraphRemoveVtxByPtr( CvGraph* graph, CvGraphVtx* vtx );


/* Link two vertices specifed by indices or pointers if they
   are not connected or return pointer to already existing edge
   connecting the vertices.
   Functions return 1 if a new edge was created, 0 otherwise */
int cvGraphAddEdge( CvGraph* graph,
                    int start_idx, int end_idx,
                    const CvGraphEdge* edge = null,
                    CvGraphEdge** inserted_edge = null );

int cvGraphAddEdgeByPtr( CvGraph* graph,
                         CvGraphVtx* start_vtx, CvGraphVtx* end_vtx,
                         const CvGraphEdge* edge = null,
                         CvGraphEdge** inserted_edge = null );

/* Remove edge connecting two vertices */
void cvGraphRemoveEdge( CvGraph* graph, int start_idx, int end_idx );
void cvGraphRemoveEdgeByPtr( CvGraph* graph, CvGraphVtx* start_vtx,
                             CvGraphVtx* end_vtx );

/* Find edge connecting two vertices */
CvGraphEdge* cvFindGraphEdge( const CvGraph* graph, int start_idx, int end_idx );
CvGraphEdge* cvFindGraphEdgeByPtr( const CvGraph* graph,
                                   const CvGraphVtx* start_vtx,
                                   const CvGraphVtx* end_vtx );
alias cvFindGraphEdge cvGraphFindEdge;
alias cvFindGraphEdgeByPtr cvGraphFindEdgeByPtr;

/* Remove all vertices and edges from the graph */
void cvClearGraph( CvGraph* graph );


/* Count number of edges incident to the vertex */
int cvGraphVtxDegree( const CvGraph* graph, int vtx_idx );
int cvGraphVtxDegreeByPtr( const CvGraph* graph, const CvGraphVtx* vtx );


/* Retrieves graph vertex by given index */
CvGraphVtx* cvGetGraphVtx(G)( G graph, size_t idx ) { return cast(CvGraphVtx*)cvGetSetElem(cast(CvSet*)graph, idx); }

/* Retrieves index of a graph vertex given its pointer */
auto cvGraphVtxIdx(G, V)( G graph, V vtx ) { return vtx.flags & CV_SET_ELEM_IDX_MASK; }

/* Retrieves index of a graph edge given its pointer */
auto cvGraphEdgeIdx(G, E)( G graph, E edge ) {return edge.flags & CV_SET_ELEM_IDX_MASK; }

auto cvGraphGetVtxCount(G)( G graph ) { return graph.active_count; }
auto cvGraphGetEdgeCount(G)( G graph ) { return graph.edges.active_count; }

enum
{
	CV_GRAPH_VERTEX       = 1,
	CV_GRAPH_TREE_EDGE    = 2,
	CV_GRAPH_BACK_EDGE    = 4,
	CV_GRAPH_FORWARD_EDGE = 8,
	CV_GRAPH_CROSS_EDGE   = 16,
	CV_GRAPH_ANY_EDGE     = 30,
	CV_GRAPH_NEW_TREE     = 32,
	CV_GRAPH_BACKTRACKING = 64,
	CV_GRAPH_OVER         = -1,

	CV_GRAPH_ALL_ITEMS    = -1,
}

/* flags for graph vertices and edges */
enum CV_GRAPH_ITEM_VISITED_FLAG = 1 << 30;
enum CV_IS_GRAPH_VERTEX_VISITED(V)(V vtx)
{
	return (cast(CvGraphVtx*)vtx).flags & CV_GRAPH_ITEM_VISITED_FLAG;
}
enum CV_IS_GRAPH_EDGE_VISITED(E)(E edge)
{
	return (cast(CvGraphEdge*)edge).flags & CV_GRAPH_ITEM_VISITED_FLAG;
}
enum CV_GRAPH_SEARCH_TREE_NODE_FLAG  = 1 << 29;
enum CV_GRAPH_FORWARD_EDGE_FLAG      = 1 << 28;

struct CvGraphScanner
{
	CvGraphVtx* vtx;       /* current graph vertex (or current edge origin) */
	CvGraphVtx* dst;       /* current graph edge destination vertex */
	CvGraphEdge* edge;     /* current edge */
	
	CvGraph* graph;        /* the graph */
	CvSeq*   stack;        /* the graph vertex stack */
	int      index;        /* the lower bound of certainly visited vertices */
	int      mask;         /* event mask */
}

/* Creates new graph scanner. */
CvGraphScanner* cvCreateGraphScanner( CvGraph* graph,
                                      CvGraphVtx* vtx = null,
                                      int mask = CV_GRAPH_ALL_ITEMS);

/* Releases graph scanner. */
void cvReleaseGraphScanner( CvGraphScanner** scanner );

/* Get next graph element */
int cvNextGraphItem( CvGraphScanner* scanner );

/* Creates a copy of graph */
CvGraph* cvCloneGraph( const CvGraph* graph, CvMemStorage* storage );

/****************************************************************************************\
*                                     Drawing                                            *
\****************************************************************************************/

/****************************************************************************************\
*       Drawing functions work with images/matrices of arbitrary type.                   *
*       For color images the channel order is BGR[A]                                     *
*       Antialiasing is supported only for 8-bit image now.                              *
*       All the functions include parameter color that means rgb value (that may be      *
*       constructed with CV_RGB macro) for color images and brightness                   *
*       for grayscale images.                                                            *
*       If a drawn figure is partially or completely outside of the image, it is clipped.*
\****************************************************************************************/

auto CV_RGB( int r, int g, int b ) { return cvScalar( b, g, r, 0 ); }
enum CV_FILLED = -1;

enum CV_AA = 16;

/* Draws 4-connected, 8-connected or antialiased line segment connecting two points */
void cvLine( CvArr* img, CvPoint pt1, CvPoint pt2,
             CvScalar color, int thickness = 1,
             int line_type = 8, int shift = 0 );

/* Draws a rectangle given two opposite corners of the rectangle (pt1 & pt2),
   if thickness<0 (e.g. thickness == CV_FILLED), the filled box is drawn */
void cvRectangle( CvArr* img, CvPoint pt1, CvPoint pt2,
                  CvScalar color, int thickness = 1,
                  int line_type = 8,
                  int shift = 0);

/* Draws a rectangle specified by a CvRect structure */
void cvRectangleR( CvArr* img, CvRect r,
                   CvScalar color, int thickness = 1,
                   int line_type = 8,
                   int shift = 0);
    
    
/* Draws a circle with specified center and radius.
   Thickness works in the same way as with cvRectangle */
void cvCircle( CvArr* img, CvPoint center, int radius,
               CvScalar color, int thickness = 1,
               int line_type = 8, int shift = 0);

/* Draws ellipse outline, filled ellipse, elliptic arc or filled elliptic sector,
   depending on <thickness>, <start_angle> and <end_angle> parameters. The resultant figure
   is rotated by <angle>. All the angles are in degrees */
void cvEllipse( CvArr* img, CvPoint center, CvSize axes,
                double angle, double start_angle, double end_angle,
                CvScalar color, int thickness = 1,
                int line_type = 8, int shift = 0);

void  cvEllipseBox( CvArr* img, CvBox2D box, CvScalar color,
                    int thickness = 1,
                    int line_type = 8, int shift = 0 )
{
	CvSize axes;
	axes.width = cast(int)cvRound(box.size.width*0.5);
	axes.height = cast(int)cvRound(box.size.height*0.5);
	
	cvEllipse( img, cvPointFrom32f( box.center ), axes, box.angle,
	           0, 360, color, thickness, line_type, shift );
}

/* Fills convex or monotonous polygon. */
void cvFillConvexPoly( CvArr* img, const CvPoint* pts, int npts, CvScalar color,
                       int line_type = 8, int shift = 0);

/* Fills an area bounded by one or more arbitrary polygons */
void cvFillPoly( CvArr* img, CvPoint** pts, const int* npts,
                 int contours, CvScalar color,
                 int line_type = 8, int shift = 0 );

/* Draws one or more polygonal curves */
void cvPolyLine( CvArr* img, CvPoint** pts, const int* npts, int contours,
                 int is_closed, CvScalar color, int thickness = 1,
                 int line_type = 8, int shift = 0 );

alias cvRectangle cvDrawRect;
alias cvLine cvDrawLine;
alias cvCircle cvDrawCircle;
alias cvEllipse cvDrawEllipse;
alias cvPolyLine cvDrawPolyLine;

/* Clips the line segment connecting *pt1 and *pt2
   by the rectangular window
   (0<=x<img_size.width, 0<=y<img_size.height). */
int cvClipLine( CvSize img_size, CvPoint* pt1, CvPoint* pt2 );

/* Initializes line iterator. Initially, line_iterator.ptr will point
   to pt1 (or pt2, see left_to_right description) location in the image.
   Returns the number of pixels on the line between the ending points. */
int cvInitLineIterator( const CvArr* image, CvPoint pt1, CvPoint pt2,
                        CvLineIterator* line_iterator,
                        int connectivity = 8,
                        int left_to_right = 0);

/* Moves iterator to the next line point */
auto CV_NEXT_LINE_POINT(LI)( ref LI line_iterator )
{
	int _line_iterator_mask = line_iterator.err < 0 ? -1 : 0;
	line_iterator.err += line_iterator.minus_delta +
	    (line_iterator.plus_delta & _line_iterator_mask);
	line_iterator.ptr += line_iterator.minus_step +
	    (line_iterator.plus_step & _line_iterator_mask);
}


/* basic font types */
enum
{
	CV_FONT_HERSHEY_SIMPLEX        = 0,
	CV_FONT_HERSHEY_PLAIN          = 1,
	CV_FONT_HERSHEY_DUPLEX         = 2,
	CV_FONT_HERSHEY_COMPLEX        = 3,
	CV_FONT_HERSHEY_TRIPLEX        = 4,
	CV_FONT_HERSHEY_COMPLEX_SMALL  = 5,
	CV_FONT_HERSHEY_SCRIPT_SIMPLEX = 6,
	CV_FONT_HERSHEY_SCRIPT_COMPLEX = 7,
}

/* font flags */
enum CV_FONT_ITALIC                = 16;

enum CV_FONT_VECTOR0    = CV_FONT_HERSHEY_SIMPLEX;


/* Font structure */
struct CvFont
{
	const(char)* nameFont;          //Qt:nameFont
	CvScalar color;                 //Qt:ColorFont -> cvScalar(blue_component, green_component, red\_component[, alpha_component])
	int         font_face;          //Qt: bool italic         /* =CV_FONT_* */
	const(int)*  ascii;             /* font data and metrics */
	const(int)*  greek;
	const(int)*  cyrillic;
	float       hscale, vscale;
	float       shear;              /* slope coefficient: 0 - normal, >0 - italic */
	int         thickness;          //Qt: weight               /* letters thickness */
	float       dx;                 /* horizontal interval between letters */
	int         line_type;          //Qt: PointSize
}


/* Initializes font structure used further in cvPutText */
void cvInitFont( CvFont* font, int font_face,
                 double hscale, double vscale,
                 double shear = 0,
                 int thickness = 1,
                 int line_type = 8);

CvFont cvFont( double scale, int thickness = 1 )
{
	CvFont font;
	cvInitFont( &font, CV_FONT_HERSHEY_PLAIN, scale, scale, 0, thickness, CV_AA );
	return font;
}

/* Renders text stroke with specified font and color at specified location.
   CvFont should be initialized with cvInitFont */
void cvPutText( CvArr* img, const char* text, CvPoint org,
                const CvFont* font, CvScalar color );

/* Calculates bounding box of text stroke (useful for alignment) */
void cvGetTextSize( const char* text_string, const CvFont* font,
                    CvSize* text_size, int* baseline );


/* Unpacks color value, if arrtype is CV_8UC?, <color> is treated as
   packed color value, otherwise the first channels (depending on arrtype)
   of destination scalar are set to the same value = <color> */
CvScalar cvColorToScalar( double packed_color, int arrtype );

/* Returns the polygon points which make up the given ellipse.  The ellipse is define by
   the box of size 'axes' rotated 'angle' around the 'center'.  A partial sweep
   of the ellipse arc can be done by spcifying arc_start and arc_end to be something
   other than 0 and 360, respectively.  The input array 'pts' must be large enough to
   hold the result.  The total number of points stored into 'pts' is returned by this
   function. */
int cvEllipse2Poly( CvPoint center, CvSize axes,
                    int angle, int arc_start, int arc_end, CvPoint * pts, int delta );

/* Draws contour outlines or filled interiors on the image */
void cvDrawContours( CvArr *img, CvSeq* contour,
                     CvScalar external_color, CvScalar hole_color,
                     int max_level, int thickness = 1,
                     int line_type = 8,
                     CvPoint offset = cvPoint(0,0));

/* Does look-up transformation. Elements of the source array
   (that should be 8uC1 or 8sC1) are used as indexes in lutarr 256-element table */
void cvLUT( const CvArr* src, CvArr* dst, const CvArr* lut );


/******************* Iteration through the sequence tree *****************/
struct CvTreeNodeIterator
{
	const(void)* node;
	int level;
	int max_level;
}


void cvInitTreeNodeIterator( CvTreeNodeIterator* tree_iterator,
                             const void* first, int max_level );
void* cvNextTreeNode( CvTreeNodeIterator* tree_iterator );
void* cvPrevTreeNode( CvTreeNodeIterator* tree_iterator );

/* Inserts sequence into tree with specified "parent" sequence.
   If parent is equal to frame (e.g. the most external contour),
   then added contour will have null pointer to parent. */
void cvInsertNodeIntoTree( void* node, void* parent, void* frame );

/* Removes contour from tree (together with the contour children). */
void cvRemoveNodeFromTree( void* node, void* frame );

/* Gathers pointers to all the sequences,
   accessible from the <first>, to the single sequence */
CvSeq* cvTreeToNodeSeq( const void* first, int header_size,
                        CvMemStorage* storage );

/* The function implements the K-means algorithm for clustering an array of sample
   vectors in a specified number of classes */
enum CV_KMEANS_USE_INITIAL_LABELS   = 1;
int cvKMeans2( const CvArr* samples, int cluster_count, CvArr* labels,
               CvTermCriteria termcrit, int attempts = 1,
               CvRNG* rng = null, int flags = 0,
               CvArr* _centers = null, double* compactness = null );

/****************************************************************************************\
*                                    System functions                                    *
\****************************************************************************************/

/* Add the function pointers table with associated information to the IPP primitives list */
int cvRegisterModule( const CvModuleInfo* module_info );

/* Loads optimized functions from IPP, MKL etc. or switches back to pure C code */
int cvUseOptimized( int on_off );

/* Retrieves information about the registered modules and loaded optimized plugins */
void cvGetModuleInfo( const char* module_name,
                      const char** ver,
                      const char** loaded_addon_plugins );

alias void* function(size_t size, void* userdata) CvAllocFunc;
alias int function(void* pptr, void* userdata) CvFreeFunc;

/* Set user-defined memory managment functions (substitutors for malloc and free) that
   will be called by cvAlloc, cvFree and higher-level functions (e.g. cvCreateImage) */
void cvSetMemoryManager( CvAllocFunc alloc_func = null,
                         CvFreeFunc free_func = null,
                         void* userdata = null);


alias IplImage* function(int,int,int,char*,char*,int,int,int,int,int,
                         IplROI*,IplImage*,void*,IplTileInfo*) Cv_iplCreateImageHeader;
alias void function(IplImage*,int,int) Cv_iplAllocateImageData;
alias void function(IplImage*,int) Cv_iplDeallocate;
alias IplROI* function(int,int,int,int,int) Cv_iplCreateROI;
alias IplImage* function(const IplImage*) Cv_iplCloneImage;

/* Makes OpenCV use IPL functions for IplImage allocation/deallocation */
void cvSetIPLAllocators( Cv_iplCreateImageHeader create_header,
                         Cv_iplAllocateImageData allocate_data,
                         Cv_iplDeallocate deallocate,
                         Cv_iplCreateROI create_roi,
                         Cv_iplCloneImage clone_image );

//void CV_TURN_ON_IPL_COMPATIBILITY()
//{
//	cvSetIPLAllocators( iplCreateImageHeader, iplAllocateImage,
//	                    iplDeallocate, iplCreateROI, iplCloneImage );
//}

/****************************************************************************************\
*                                    Data Persistence                                    *
\****************************************************************************************/

/********************************** High-level functions ********************************/

/* opens existing or creates new file storage */
CvFileStorage* cvOpenFileStorage( const char* filename, CvMemStorage* memstorage,
                                  int flags, const char* encoding = null);

/* closes file storage and deallocates buffers */
void cvReleaseFileStorage( CvFileStorage** fs );

/* returns attribute value or 0 (NULL) if there is no such attribute */
const(char)* cvAttrValue( const CvAttrList* attr, const char* attr_name );

/* starts writing compound structure (map or sequence) */
void cvStartWriteStruct( CvFileStorage* fs, const char* name,
                         int struct_flags, const char* type_name = null,
                         CvAttrList attributes = cvAttrList());

/* finishes writing compound structure */
void cvEndWriteStruct( CvFileStorage* fs );

/* writes an integer */
void cvWriteInt( CvFileStorage* fs, const char* name, int value );

/* writes a floating-point number */
void cvWriteReal( CvFileStorage* fs, const char* name, double value );

/* writes a string */
void cvWriteString( CvFileStorage* fs, const char* name,
                    const char* str, int quote = 0 );

/* writes a comment */
void cvWriteComment( CvFileStorage* fs, const char* comment,
                     int eol_comment );

/* writes instance of a standard type (matrix, image, sequence, graph etc.)
   or user-defined type */
void cvWrite( CvFileStorage* fs, const char* name, const void* ptr,
              CvAttrList attributes = cvAttrList());

/* starts the next stream */
void cvStartNextStream( CvFileStorage* fs );

/* helper function: writes multiple integer or floating-point numbers */
void cvWriteRawData( CvFileStorage* fs, const void* src,
                     int len, const char* dt );

/* returns the hash entry corresponding to the specified literal key string or 0
   if there is no such a key in the storage */
CvStringHashNode* cvGetHashedKey( CvFileStorage* fs, const char* name,
                                  int len = -1,
                                  int create_missing = 0);

/* returns file node with the specified key within the specified map
   (collection of named nodes) */
CvFileNode* cvGetRootFileNode( const CvFileStorage* fs,
                               int stream_index = 0 );

/* returns file node with the specified key within the specified map
   (collection of named nodes) */
CvFileNode* cvGetFileNode( CvFileStorage* fs, CvFileNode* map,
                           const CvStringHashNode* key,
                           int create_missing = 0 );

/* this is a slower version of cvGetFileNode that takes the key as a literal string */
CvFileNode* cvGetFileNodeByName( const CvFileStorage* fs,
                                 const CvFileNode* map,
                                 const char* name );

int cvReadInt( const CvFileNode* node, int default_value = 0 )
{
	return cast(int)(!node ? default_value :
		CV_NODE_IS_INT(node.tag) ? node.data.i :
		CV_NODE_IS_REAL(node.tag) ? cvRound(node.data.f) : 0x7fffffff);
}


int cvReadIntByName( const CvFileStorage* fs, const CvFileNode* map,
                     const char* name, int default_value = 0 )
{
	return cvReadInt( cvGetFileNodeByName( fs, map, name ), default_value );
}


double cvReadReal( const CvFileNode* node, double default_value = 0.0 )
{
	return !node ? default_value :
		CV_NODE_IS_INT(node.tag) ? cast(double)node.data.i :
		CV_NODE_IS_REAL(node.tag) ? node.data.f : 1e300;
}


double cvReadRealByName( const CvFileStorage* fs, const CvFileNode* map,
                         const char* name, double default_value = 0.0 )
{
	return cvReadReal( cvGetFileNodeByName( fs, map, name ), default_value );
}


const(char)* cvReadString( const CvFileNode* node,
                           const(char)* default_value = null )
{
	return !node ? default_value : CV_NODE_IS_STRING(node.tag) ? node.data.str.ptr : null;
}


const(char)* cvReadStringByName( const CvFileStorage* fs, const CvFileNode* map,
                                 const(char)* name, const(char)* default_value = null )
{
	return cvReadString( cvGetFileNodeByName( fs, map, name ), default_value );
}


/* decodes standard or user-defined object and returns it */
void* cvRead( CvFileStorage* fs, CvFileNode* node,
              CvAttrList* attributes = null);

/* decodes standard or user-defined object and returns it */
void* cvReadByName( CvFileStorage* fs, const CvFileNode* map,
                    const char* name, CvAttrList* attributes = null )
{
	return cvRead( fs, cvGetFileNodeByName( fs, map, name ), attributes );
}


/* starts reading data from sequence or scalar numeric node */
void cvStartReadRawData( const CvFileStorage* fs, const CvFileNode* src,
                         CvSeqReader* reader );

/* reads multiple numbers and stores them to array */
void cvReadRawDataSlice( const CvFileStorage* fs, CvSeqReader* reader,
                         int count, void* dst, const char* dt );

/* combination of two previous functions for easier reading of whole sequences */
void cvReadRawData( const CvFileStorage* fs, const CvFileNode* src,
                    void* dst, const char* dt );

/* writes a copy of file node to file storage */
void cvWriteFileNode( CvFileStorage* fs, const char* new_node_name,
                      const CvFileNode* node, int embed );

/* returns name of file node */
const(char)* cvGetFileNodeName( const CvFileNode* node );

/*********************************** Adding own types ***********************************/

void cvRegisterType( const CvTypeInfo* info );
void cvUnregisterType( const char* type_name );
CvTypeInfo* cvFirstType();
CvTypeInfo* cvFindType( const char* type_name );
CvTypeInfo* cvTypeOf( const void* struct_ptr );

/* universal functions */
void cvRelease( void** struct_ptr );
void* cvClone( const void* struct_ptr );

/* simple API for reading/writing data */
void cvSave( const char* filename, const void* struct_ptr,
             const char* name = null,
             const char* comment = null,
             CvAttrList attributes = cvAttrList());
void* cvLoad( const char* filename,
              CvMemStorage* memstorage = null,
              const char* name = null,
              const char** real_name = null );

/*********************************** Measuring Execution Time ***************************/

/* helper functions for RNG initialization and accurate time measurement:
   uses internal clock counter on x86 */
long cvGetTickCount();
double cvGetTickFrequency();

/*********************************** CPU capabilities ***********************************/

enum
{
	CV_CPU_NONE    = 0,
	CV_CPU_MMX     = 1,
	CV_CPU_SSE     = 2,
	CV_CPU_SSE2    = 3,
	CV_CPU_SSE3    = 4,
	CV_CPU_SSSE3   = 5,
	CV_CPU_SSE4_1  = 6,
	CV_CPU_SSE4_2  = 7,
	CV_CPU_AVX     = 10,
	CV_HARDWARE_MAX_FEATURE = 255,
}

int cvCheckHardwareSupport(int feature);

/*********************************** Multi-Threading ************************************/

/* retrieve/set the number of threads used in OpenMP implementations */
int cvGetNumThreads();
void cvSetNumThreads( int threads = 0 );
/* get index of the thread being executed */
int cvGetThreadNum();


/********************************** Error Handling **************************************/

/* Get current OpenCV error status */
int cvGetErrStatus();

/* Sets error status silently */
void cvSetErrStatus( int status );

enum
{
	CV_ErrModeLeaf     = 0,   /* Print error and exit program */
	CV_ErrModeParent   = 1,   /* Print error and continue */
	CV_ErrModeSilent   = 2,   /* Don't print and continue */
}

/* Retrives current error processing mode */
int cvGetErrMode();

/* Sets error processing mode, returns previously used mode */
int cvSetErrMode( int mode );

/* Sets error status and performs some additonal actions (displaying message box,
 writing message to stderr, terminating application etc.)
 depending on the current error mode */
void cvError( int status, const char* func_name,
              const char* err_msg, const char* file_name, int line );

/* Retrieves textual description of the error given its code */
const(char)* cvErrorStr( int status );

/* Retrieves detailed information about the last error occured */
int cvGetErrInfo( const char** errcode_desc, const char** description,
                  const char** filename, int* line );

/* Maps IPP error codes to the counterparts from OpenCV */
int cvErrorFromIppStatus( int ipp_status );

alias int function( int status, const char* func_name,
                    const char* err_msg, const char* file_name, int line, void* userdata ) CvErrorCallback;

/* Assigns a new error-handling function */
CvErrorCallback cvRedirectError( CvErrorCallback error_handler,
                                 void* userdata = null,
                                 void** prev_userdata = null );

/*
 Output to:
 cvNulDevReport - nothing
 cvStdErrReport - console(fprintf(stderr,...))
 cvGuiBoxReport - MessageBox(WIN32)
 */
int cvNulDevReport( int status, const char* func_name, const char* err_msg,
                    const char* file_name, int line, void* userdata );

int cvStdErrReport( int status, const char* func_name, const char* err_msg,
                    const char* file_name, int line, void* userdata );

int cvGuiBoxReport( int status, const char* func_name, const char* err_msg,
                    const char* file_name, int line, void* userdata );    


void OPENCV_ERROR(int status, const char* func, const char* context, string file=__FILE__, uint line = __LINE__)
{
	cvError(status,func,context,file.ptr,line);
}

void OPENCV_ERRCHK(const char* func, const char* context, string file=__FILE__, uint line = __LINE__)
{
	if (cvGetErrStatus() >= 0)
	{
		OPENCV_ERROR(CV_StsBackTrace,func,context, file, line);
	}
}

void OPENCV_ASSERT(bool expr, const char* func, const char* context, string file=__FILE__, uint line = __LINE__)
{
	if (! expr)
	{
		OPENCV_ERROR(CV_StsInternal,func,context,file,line);
	}
}

void OPENCV_RSTERR()
{
	cvSetErrStatus(CV_StsOk);
}

void OPENCV_CALL(alias FNC)()
{
	Func();
}

/*
 CV_ERROR macro unconditionally raises error with passed code and message.
 After raising error, control will be transferred to the exit label.
 */
void CV_ERROR( int code,  const char* msg, string file=__FILE__, uint line = __LINE__)
{
	cvError( code, "?????", msg, file.ptr, line );
}

/* Simplified form of CV_ERROR */
void CV_ERROR_FROM_CODE( int code )
{
	CV_ERROR( code, "" );
}

/*
 CV_CHECK macro checks error status after CV (or IPL)
 function call. If error detected, control will be transferred to the exit
 label.
 */
void CV_CHECK()
{
	if( cvGetErrStatus() < 0 )
		CV_ERROR( CV_StsBackTrace, "Inner function failed." );
}


/*
 CV_CALL macro calls CV (or IPL) function, checks error status and
 signals a error if the function failed. Useful in "parent node"
 error procesing mode
 */
void CV_CALL( alias Func )()
{
	Func();
	CV_CHECK();
}


/* Runtime assertion macro */
void CV_ASSERT( bool condition )
{
	if( !condition )
		CV_ERROR( CV_StsInternal, "Assertion: failed" );
}
