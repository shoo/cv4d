module cv4d.opencv.imgproc;

//##############################################################################
//##### opencv2/imgproc/type_c.h
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

import cv4d.opencv.core;
extern (C):

/* Connected component structure */
struct CvConnectedComp
{
	double area;    /* area of the connected component  */
	CvScalar value; /* average color of the connected component */
	CvRect rect;    /* ROI of the component  */
	CvSeq* contour; /* optional component boundary
	                  (the contour might have child contours corresponding to the holes)*/
}

/* Image smooth methods */
enum
{
	CV_BLUR_NO_SCALE =0,
	CV_BLUR  =1,
	CV_GAUSSIAN  =2,
	CV_MEDIAN =3,
	CV_BILATERAL =4
}

/* Filters used in pyramid decomposition */
enum
{
	CV_GAUSSIAN_5x5 = 7
}

/* Special filters */
enum
{
	CV_SCHARR =-1,
	CV_MAX_SOBEL_KSIZE =7
}

/* Constants for color conversion */
enum
{
	CV_BGR2BGRA    =0,
	CV_RGB2RGBA    =CV_BGR2BGRA,

	CV_BGRA2BGR    =1,
	CV_RGBA2RGB    =CV_BGRA2BGR,

	CV_BGR2RGBA    =2,
	CV_RGB2BGRA    =CV_BGR2RGBA,

	CV_RGBA2BGR    =3,
	CV_BGRA2RGB    =CV_RGBA2BGR,

	CV_BGR2RGB     =4,
	CV_RGB2BGR     =CV_BGR2RGB,

	CV_BGRA2RGBA   =5,
	CV_RGBA2BGRA   =CV_BGRA2RGBA,

	CV_BGR2GRAY    =6,
	CV_RGB2GRAY    =7,
	CV_GRAY2BGR    =8,
	CV_GRAY2RGB    =CV_GRAY2BGR,
	CV_GRAY2BGRA   =9,
	CV_GRAY2RGBA   =CV_GRAY2BGRA,
	CV_BGRA2GRAY   =10,
	CV_RGBA2GRAY   =11,

	CV_BGR2BGR565  =12,
	CV_RGB2BGR565  =13,
	CV_BGR5652BGR  =14,
	CV_BGR5652RGB  =15,
	CV_BGRA2BGR565 =16,
	CV_RGBA2BGR565 =17,
	CV_BGR5652BGRA =18,
	CV_BGR5652RGBA =19,

	CV_GRAY2BGR565 =20,
	CV_BGR5652GRAY =21,

	CV_BGR2BGR555  =22,
	CV_RGB2BGR555  =23,
	CV_BGR5552BGR  =24,
	CV_BGR5552RGB  =25,
	CV_BGRA2BGR555 =26,
	CV_RGBA2BGR555 =27,
	CV_BGR5552BGRA =28,
	CV_BGR5552RGBA =29,

	CV_GRAY2BGR555 =30,
	CV_BGR5552GRAY =31,

	CV_BGR2XYZ     =32,
	CV_RGB2XYZ     =33,
	CV_XYZ2BGR     =34,
	CV_XYZ2RGB     =35,

	CV_BGR2YCrCb   =36,
	CV_RGB2YCrCb   =37,
	CV_YCrCb2BGR   =38,
	CV_YCrCb2RGB   =39,

	CV_BGR2HSV     =40,
	CV_RGB2HSV     =41,

	CV_BGR2Lab     =44,
	CV_RGB2Lab     =45,

	CV_BayerBG2BGR =46,
	CV_BayerGB2BGR =47,
	CV_BayerRG2BGR =48,
	CV_BayerGR2BGR =49,

	CV_BayerBG2RGB =CV_BayerRG2BGR,
	CV_BayerGB2RGB =CV_BayerGR2BGR,
	CV_BayerRG2RGB =CV_BayerBG2BGR,
	CV_BayerGR2RGB =CV_BayerGB2BGR,

	CV_BGR2Luv     =50,
	CV_RGB2Luv     =51,
	CV_BGR2HLS     =52,
	CV_RGB2HLS     =53,

	CV_HSV2BGR     =54,
	CV_HSV2RGB     =55,

	CV_Lab2BGR     =56,
	CV_Lab2RGB     =57,
	CV_Luv2BGR     =58,
	CV_Luv2RGB     =59,
	CV_HLS2BGR     =60,
	CV_HLS2RGB     =61,

	CV_BayerBG2BGR_VNG =62,
	CV_BayerGB2BGR_VNG =63,
	CV_BayerRG2BGR_VNG =64,
	CV_BayerGR2BGR_VNG =65,
	
	CV_BayerBG2RGB_VNG =CV_BayerRG2BGR_VNG,
	CV_BayerGB2RGB_VNG =CV_BayerGR2BGR_VNG,
	CV_BayerRG2RGB_VNG =CV_BayerBG2BGR_VNG,
	CV_BayerGR2RGB_VNG =CV_BayerGB2BGR_VNG,
	
	CV_BGR2HSV_FULL = 66,
	CV_RGB2HSV_FULL = 67,
	CV_BGR2HLS_FULL = 68,
	CV_RGB2HLS_FULL = 69,
	
	CV_HSV2BGR_FULL = 70,
	CV_HSV2RGB_FULL = 71,
	CV_HLS2BGR_FULL = 72,
	CV_HLS2RGB_FULL = 73,
	
	CV_LBGR2Lab     = 74,
	CV_LRGB2Lab     = 75,
	CV_LBGR2Luv     = 76,
	CV_LRGB2Luv     = 77,
	
	CV_Lab2LBGR     = 78,
	CV_Lab2LRGB     = 79,
	CV_Luv2LBGR     = 80,
	CV_Luv2LRGB     = 81,
	
	CV_BGR2YUV      = 82,
	CV_RGB2YUV      = 83,
	CV_YUV2BGR      = 84,
	CV_YUV2RGB      = 85,
	
	CV_BayerBG2GRAY = 86,
	CV_BayerGB2GRAY = 87,
	CV_BayerRG2GRAY = 88,
	CV_BayerGR2GRAY = 89,

	//YUV 4:2:0 formats family
	CV_YUV2RGB_NV12 = 90,
	CV_YUV2BGR_NV12 = 91,    
	CV_YUV2RGB_NV21 = 92,
	CV_YUV2BGR_NV21 = 93,
	CV_YUV420sp2RGB = CV_YUV2RGB_NV21,
	CV_YUV420sp2BGR = CV_YUV2BGR_NV21,

	CV_YUV2RGBA_NV12 = 94,
	CV_YUV2BGRA_NV12 = 95,
	CV_YUV2RGBA_NV21 = 96,
	CV_YUV2BGRA_NV21 = 97,
	CV_YUV420sp2RGBA = CV_YUV2RGBA_NV21,
	CV_YUV420sp2BGRA = CV_YUV2BGRA_NV21,
	
	CV_YUV2RGB_YV12 = 98,
	CV_YUV2BGR_YV12 = 99,
	CV_YUV2RGB_IYUV = 100,
	CV_YUV2BGR_IYUV = 101,
	CV_YUV2RGB_I420 = CV_YUV2RGB_IYUV,
	CV_YUV2BGR_I420 = CV_YUV2BGR_IYUV,
	CV_YUV420p2RGB = CV_YUV2RGB_YV12,
	CV_YUV420p2BGR = CV_YUV2BGR_YV12,
	
	CV_YUV2RGBA_YV12 = 102,
	CV_YUV2BGRA_YV12 = 103,
	CV_YUV2RGBA_IYUV = 104,
	CV_YUV2BGRA_IYUV = 105,
	CV_YUV2RGBA_I420 = CV_YUV2RGBA_IYUV,
	CV_YUV2BGRA_I420 = CV_YUV2BGRA_IYUV,
	CV_YUV420p2RGBA = CV_YUV2RGBA_YV12,
	CV_YUV420p2BGRA = CV_YUV2BGRA_YV12,
	
	CV_YUV2GRAY_420 = 106,
	CV_YUV2GRAY_NV21 = CV_YUV2GRAY_420,
	CV_YUV2GRAY_NV12 = CV_YUV2GRAY_420,
	CV_YUV2GRAY_YV12 = CV_YUV2GRAY_420,
	CV_YUV2GRAY_IYUV = CV_YUV2GRAY_420,
	CV_YUV2GRAY_I420 = CV_YUV2GRAY_420,
	CV_YUV420sp2GRAY = CV_YUV2GRAY_420,
	CV_YUV420p2GRAY = CV_YUV2GRAY_420,
	
	//YUV 4:2:2 formats family
	CV_YUV2RGB_UYVY = 107,
	CV_YUV2BGR_UYVY = 108,
	//CV_YUV2RGB_VYUY = 109,
	//CV_YUV2BGR_VYUY = 110,
	CV_YUV2RGB_Y422 = CV_YUV2RGB_UYVY,
	CV_YUV2BGR_Y422 = CV_YUV2BGR_UYVY,
	CV_YUV2RGB_UYNV = CV_YUV2RGB_UYVY,
	CV_YUV2BGR_UYNV = CV_YUV2BGR_UYVY,
	
	CV_YUV2RGBA_UYVY = 111,
	CV_YUV2BGRA_UYVY = 112,
	//CV_YUV2RGBA_VYUY = 113,
	//CV_YUV2BGRA_VYUY = 114,
	CV_YUV2RGBA_Y422 = CV_YUV2RGBA_UYVY,
	CV_YUV2BGRA_Y422 = CV_YUV2BGRA_UYVY,
	CV_YUV2RGBA_UYNV = CV_YUV2RGBA_UYVY,
	CV_YUV2BGRA_UYNV = CV_YUV2BGRA_UYVY,
	
	CV_YUV2RGB_YUY2 = 115,
	CV_YUV2BGR_YUY2 = 116,
	CV_YUV2RGB_YVYU = 117,
	CV_YUV2BGR_YVYU = 118,
	CV_YUV2RGB_YUYV = CV_YUV2RGB_YUY2,
	CV_YUV2BGR_YUYV = CV_YUV2BGR_YUY2,
	CV_YUV2RGB_YUNV = CV_YUV2RGB_YUY2,
	CV_YUV2BGR_YUNV = CV_YUV2BGR_YUY2,
	
	CV_YUV2RGBA_YUY2 = 119,
	CV_YUV2BGRA_YUY2 = 120,
	CV_YUV2RGBA_YVYU = 121,
	CV_YUV2BGRA_YVYU = 122,
	CV_YUV2RGBA_YUYV = CV_YUV2RGBA_YUY2,
	CV_YUV2BGRA_YUYV = CV_YUV2BGRA_YUY2,
	CV_YUV2RGBA_YUNV = CV_YUV2RGBA_YUY2,
	CV_YUV2BGRA_YUNV = CV_YUV2BGRA_YUY2,
	
	CV_YUV2GRAY_UYVY = 123,
	CV_YUV2GRAY_YUY2 = 124,
	//CV_YUV2GRAY_VYUY = CV_YUV2GRAY_UYVY,
	CV_YUV2GRAY_Y422 = CV_YUV2GRAY_UYVY,
	CV_YUV2GRAY_UYNV = CV_YUV2GRAY_UYVY,
	CV_YUV2GRAY_YVYU = CV_YUV2GRAY_YUY2,
	CV_YUV2GRAY_YUYV = CV_YUV2GRAY_YUY2,
	CV_YUV2GRAY_YUNV = CV_YUV2GRAY_YUY2,
	
	CV_COLORCVT_MAX  = 125
}


/* Sub-pixel interpolation methods */
enum
{
	CV_INTER_NN        =0,
	CV_INTER_LINEAR    =1,
	CV_INTER_CUBIC     =2,
	CV_INTER_AREA      =3,
	CV_INTER_LANCZOS4  =4
}

/* ... and other image warping flags */
enum
{
	CV_WARP_FILL_OUTLIERS =8,
	CV_WARP_INVERSE_MAP  =16
}

/* Shapes of a structuring element for morphological operations */
enum
{
	CV_SHAPE_RECT      =0,
	CV_SHAPE_CROSS     =1,
	CV_SHAPE_ELLIPSE   =2,
	CV_SHAPE_CUSTOM    =100
}

/* Morphological operations */
enum
{
	CV_MOP_ERODE        =0,
	CV_MOP_DILATE       =1,
	CV_MOP_OPEN         =2,
	CV_MOP_CLOSE        =3,
	CV_MOP_GRADIENT     =4,
	CV_MOP_TOPHAT       =5,
	CV_MOP_BLACKHAT     =6
}

/* Spatial and central moments */
struct CvMoments
{
	double  m00, m10, m01, m20, m11, m02, m30, m21, m12, m03; /* spatial moments */
	double  mu20, mu11, mu02, mu30, mu21, mu12, mu03; /* central moments */
	double  inv_sqrt_m00; /* m00 != 0 ? 1/sqrt(m00) : 0 */
}

/* Hu invariants */
struct CvHuMoments
{
	double hu1, hu2, hu3, hu4, hu5, hu6, hu7; /* Hu invariants */
}

/* Template matching methods */
enum
{
	CV_TM_SQDIFF        =0,
	CV_TM_SQDIFF_NORMED =1,
	CV_TM_CCORR         =2,
	CV_TM_CCORR_NORMED  =3,
	CV_TM_CCOEFF        =4,
	CV_TM_CCOEFF_NORMED =5
}

alias float function( const float* a, const float* b, void* user_param ) CvDistanceFunction;

/* Contour retrieval modes */
enum
{
	CV_RETR_EXTERNAL=0,
	CV_RETR_LIST=1,
	CV_RETR_CCOMP=2,
    CV_RETR_TREE=3,
    CV_RETR_FLOODFILL=4
}

/* Contour approximation methods */
enum
{
	CV_CHAIN_CODE=0,
	CV_CHAIN_APPROX_NONE=1,
	CV_CHAIN_APPROX_SIMPLE=2,
	CV_CHAIN_APPROX_TC89_L1=3,
	CV_CHAIN_APPROX_TC89_KCOS=4,
	CV_LINK_RUNS=5
}

/*
Internal structure that is used for sequental retrieving contours from the image.
It supports both hierarchical and plane variants of Suzuki algorithm.
*/
alias void* CvContourScanner;

/* Freeman chain reader state */
struct CvChainPtReader
{
	mixin CV_SEQ_READER_FIELDS!();
	char       code;
	CvPoint    pt;
	byte[2][8] deltas;
}

/* initializes 8-element array for fast access to 3x3 neighborhood of a pixel */
void CV_INIT_3X3_DELTAS(ref byte[8] deltas, byte step, byte nch )
{
	deltas[0] = cast(byte)( nch);
	deltas[1] = cast(byte)(-step + nch);
	deltas[2] = cast(byte)(-step);
	deltas[3] = cast(byte)(-step - nch);
	deltas[4] = cast(byte)(-nch);
	deltas[5] = cast(byte)( step - nch);
	deltas[6] = cast(byte)( step);
	deltas[7] = cast(byte)( step + nch);
}

/****************************************************************************************\
*                              Planar subdivisions                                       *
\****************************************************************************************/

alias size_t CvSubdiv2DEdge;

mixin template CV_QUADEDGE2D_FIELDS()
{
	int flags;
	CvSubdiv2DPoint*[4] pt;
	CvSubdiv2DEdge[4]  next;
}

mixin template CV_SUBDIV2D_POINT_FIELDS()
{
	int            flags;
	CvSubdiv2DEdge first;
	CvPoint2D32f   pt;
	int id;
}

enum CV_SUBDIV2D_VIRTUAL_POINT_FLAG = 1 << 30;

struct CvQuadEdge2D
{
	mixin CV_QUADEDGE2D_FIELDS!();
}

struct CvSubdiv2DPoint
{
	mixin CV_SUBDIV2D_POINT_FIELDS!();
}

mixin template CV_SUBDIV2D_FIELDS()
{
	mixin CV_GRAPH_FIELDS!();
	int quad_edges;
	int is_geometry_valid;
	CvSubdiv2DEdge recent_edge;
	CvPoint2D32f topleft;
	CvPoint2D32f bottomright;
}

struct CvSubdiv2D
{
	mixin CV_SUBDIV2D_FIELDS!();
}


enum CvSubdiv2DPointLocation
{
	CV_PTLOC_ERROR = -2,
	CV_PTLOC_OUTSIDE_RECT = -1,
	CV_PTLOC_INSIDE = 0,
	CV_PTLOC_VERTEX = 1,
	CV_PTLOC_ON_EDGE = 2
}

enum CvNextEdgeType
{
	CV_NEXT_AROUND_ORG   = 0x00,
	CV_NEXT_AROUND_DST   = 0x22,
	CV_PREV_AROUND_ORG   = 0x11,
	CV_PREV_AROUND_DST   = 0x33,
	CV_NEXT_AROUND_LEFT  = 0x13,
	CV_NEXT_AROUND_RIGHT = 0x31,
	CV_PREV_AROUND_LEFT  = 0x20,
	CV_PREV_AROUND_RIGHT = 0x02
}

/* get the next edge with the same origin point (counterwise) */
CvSubdiv2DEdge CV_SUBDIV2D_NEXT_EDGE(EDGE)(EDGE edge)
{
	return (cast(CvQuadEdge2D*)(edge & ~3)).next[edge&3];
}

/* Contour approximation algorithms */
enum
{
	CV_POLY_APPROX_DP = 0
}

/* Shape matching methods */
enum
{
	CV_CONTOURS_MATCH_I1  =1,
	CV_CONTOURS_MATCH_I2  =2,
	CV_CONTOURS_MATCH_I3  =3
}

/* Shape orientation */
enum
{
	CV_CLOCKWISE         =1,
	CV_COUNTER_CLOCKWISE =2
}


/* Convexity defect */
struct CvConvexityDefect
{
	CvPoint* start; /* point of the contour where the defect begins */
	CvPoint* end; /* point of the contour where the defect ends */
	CvPoint* depth_point; /* the farthest from the convex hull point within the defect */
	float depth; /* distance between the farthest point and the convex hull */
}


/* Histogram comparison methods */
enum
{
	CV_COMP_CORREL        =0,
	CV_COMP_CHISQR        =1,
	CV_COMP_INTERSECT     =2,
	CV_COMP_BHATTACHARYYA =3
}

/* Mask size for distance transform */
enum
{
	CV_DIST_MASK_3   =3,
	CV_DIST_MASK_5   =5,
	CV_DIST_MASK_PRECISE =0
}

/* Content of output label array: connected components or pixels */
enum
{
	CV_DIST_LABEL_CCOMP = 0,
	CV_DIST_LABEL_PIXEL = 1
};

/* Distance types for Distance Transform and M-estimators */
enum
{
	CV_DIST_USER    =-1,  /* User defined distance */
	CV_DIST_L1      =1,   /* distance = |x1-x2| + |y1-y2| */
	CV_DIST_L2      =2,   /* the simple euclidean distance */
	CV_DIST_C       =3,   /* distance = max(|x1-x2|,|y1-y2|) */
	CV_DIST_L12     =4,   /* L1-L2 metric: distance = 2(sqrt(1+x*x/2) - 1)) */
	CV_DIST_FAIR    =5,   /* distance = c^2(|x|/c-log(1+|x|/c)), c = 1.3998 */
	CV_DIST_WELSCH  =6,   /* distance = c^2/2(1-exp(-(x/c)^2)), c = 2.9846 */
	CV_DIST_HUBER   =7    /* distance = |x|<c ? x^2/2 : c(|x|-c/2), c=1.345 */
}


/* Threshold types */
enum
{
	CV_THRESH_BINARY      =0,  /* value = value > threshold ? max_value : 0       */
	CV_THRESH_BINARY_INV  =1,  /* value = value > threshold ? 0 : max_value       */
	CV_THRESH_TRUNC       =2,  /* value = value > threshold ? threshold : value   */
	CV_THRESH_TOZERO      =3,  /* value = value > threshold ? value : 0           */
	CV_THRESH_TOZERO_INV  =4,  /* value = value > threshold ? 0 : value           */
	CV_THRESH_MASK        =7,
	CV_THRESH_OTSU        =8  /* use Otsu algorithm to choose the optimal threshold value;
	                             combine the flag with one of the above CV_THRESH_* values */
}

/* Adaptive threshold methods */
enum
{
	CV_ADAPTIVE_THRESH_MEAN_C  =0,
	CV_ADAPTIVE_THRESH_GAUSSIAN_C  =1
}

/* FloodFill flags */
enum
{
	CV_FLOODFILL_FIXED_RANGE =(1 << 16),
	CV_FLOODFILL_MASK_ONLY   =(1 << 17)
}


/* Canny edge detector flags */
enum
{
	CV_CANNY_L2_GRADIENT  =(1 << 31)
}

/* Variants of a Hough transform */
enum
{
	CV_HOUGH_STANDARD =0,
	CV_HOUGH_PROBABILISTIC =1,
	CV_HOUGH_MULTI_SCALE =2,
	CV_HOUGH_GRADIENT =3
}


/* Fast search data structures  */
struct CvFeatureTree {}
struct CvLSH {}
struct CvLSHOperations {}



//##############################################################################
//##### opencv2/imgproc/imgproc_c.h
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

import cv4d.opencv.core;

/*********************** Background statistics accumulation *****************************/

/* Adds image to accumulator */
void cvAcc( const CvArr* image, CvArr* sum,
            const CvArr* mask = null );

/* Adds squared image to accumulator */
void cvSquareAcc( const CvArr* image, CvArr* sqsum,
                  const CvArr* mask = null );

/* Adds a product of two images to accumulator */
void cvMultiplyAcc( const CvArr* image1, const CvArr* image2, CvArr* acc,
                    const CvArr* mask = null );

/* Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha */
void cvRunningAvg( const CvArr* image, CvArr* acc, double alpha,
                   const CvArr* mask = null );
	
/****************************************************************************************\
*                                    Image Processing                                    *
\****************************************************************************************/

/* Copies source 2D array inside of the larger destination array and
   makes a border of the specified type (IPL_BORDER_*) around the copied area. */
void cvCopyMakeBorder( const CvArr* src, CvArr* dst, CvPoint offset,
                       int bordertype, CvScalar value = cvScalarAll(0));

/* Smoothes array (removes noise) */
void cvSmooth( const CvArr* src, CvArr* dst,
               int smoothtype = CV_GAUSSIAN,
               int size1 = 3,
               int size2 = 0,
               double sigma1 = 0,
               double sigma2 = 0);

/* Convolves the image with the kernel */
void cvFilter2D( const CvArr* src, CvArr* dst, const CvMat* kernel,
                 CvPoint anchor = cvPoint(-1,-1));

/* Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y) */
void cvIntegral( const CvArr* image, CvArr* sum,
                 CvArr* sqsum = null,
                 CvArr* tilted_sum = null);

/*
   Smoothes the input image with gaussian kernel and then down-samples it.
   dst_width = floor(src_width/2)[+1],
   dst_height = floor(src_height/2)[+1]
*/
void cvPyrDown( const CvArr* src, CvArr* dst,
                int filter = CV_GAUSSIAN_5x5 );

/*
   Up-samples image and smoothes the result with gaussian kernel.
   dst_width = src_width*2,
   dst_height = src_height*2
*/
void cvPyrUp( const CvArr* src, CvArr* dst,
              int filter = CV_GAUSSIAN_5x5 );

/* Builds pyramid for an image */
CvMat** cvCreatePyramid( const CvArr* img, int extra_layers, double rate,
                         const CvSize* layer_sizes = null,
                         CvArr* bufarr = null,
                         int calc = 1,
                         int filter = CV_GAUSSIAN_5x5 );

/* Releases pyramid */
void cvReleasePyramid( CvMat*** pyramid, int extra_layers );


/* Filters image using meanshift algorithm */
void cvPyrMeanShiftFiltering( const CvArr* src, CvArr* dst,
                              double sp, double sr, int max_level = 1,
                              CvTermCriteria termcrit = cvTermCriteria(
                                  CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,5,1));

/* Segments image using seed "markers" */
void cvWatershed( const CvArr* image, CvArr* markers );

/* Calculates an image derivative using generalized Sobel
   (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
   Scharr can be used only for the first dx or dy derivative */
void cvSobel( const CvArr* src, CvArr* dst,
              int xorder, int yorder,
              int aperture_size = 3);

/* Calculates the image Laplacian: (d2/dx + d2/dy)I */
void cvLaplace( const CvArr* src, CvArr* dst,
                int aperture_size = 3 );

/* Converts input array pixels from one color space to another */
void cvCvtColor( const CvArr* src, CvArr* dst, int code );


/* Resizes image (input array is resized to fit the destination array) */
void cvResize( const CvArr* src, CvArr* dst,
               int interpolation = CV_INTER_LINEAR);

/* Warps image with affine transform */
void cvWarpAffine( const CvArr* src, CvArr* dst, const CvMat* map_matrix,
                   int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS,
                   CvScalar fillval = cvScalarAll(0) );

/* Computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) */
CvMat* cvGetAffineTransform( const CvPoint2D32f* src,
                             const CvPoint2D32f* dst,
                             CvMat* map_matrix );

/* Computes rotation_matrix matrix */
CvMat* cv2DRotationMatrix( CvPoint2D32f center, double angle,
                           double scale, CvMat* map_matrix );

/* Warps image with perspective (projective) transform */
void cvWarpPerspective( const CvArr* src, CvArr* dst, const CvMat* map_matrix,
                        int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS,
                        CvScalar fillval = cvScalarAll(0) );

/* Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3) */
CvMat* cvGetPerspectiveTransform( const CvPoint2D32f* src,
                                  const CvPoint2D32f* dst,
                                  CvMat* map_matrix );

/* Performs generic geometric transformation using the specified coordinate maps */
void cvRemap( const CvArr* src, CvArr* dst,
              const CvArr* mapx, const CvArr* mapy,
              int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS,
              CvScalar fillval = cvScalarAll(0) );

/* Converts mapx & mapy from floating-point to integer formats for cvRemap */
void cvConvertMaps( const CvArr* mapx, const CvArr* mapy,
                    CvArr* mapxy, CvArr* mapalpha );

/* Performs forward or inverse log-polar image transform */
void cvLogPolar( const CvArr* src, CvArr* dst,
                 CvPoint2D32f center, double M,
                 int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS);

/* Performs forward or inverse linear-polar image transform */
void cvLinearPolar( const CvArr* src, CvArr* dst,
                    CvPoint2D32f center, double maxRadius,
                    int flags = CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS);

/* Transforms the input image to compensate lens distortion */
void cvUndistort2( const CvArr* src, CvArr* dst,
                   const CvMat* camera_matrix,
                   const CvMat* distortion_coeffs,
                   const CvMat* new_camera_matrix = null );

/* Computes transformation map from intrinsic camera parameters
   that can used by cvRemap */
void cvInitUndistortMap( const CvMat* camera_matrix,
                         const CvMat* distortion_coeffs,
                         CvArr* mapx, CvArr* mapy );

/* Computes undistortion+rectification map for a head of stereo camera */
void cvInitUndistortRectifyMap( const CvMat* camera_matrix,
                                const CvMat* dist_coeffs,
                                const CvMat *R, const CvMat* new_camera_matrix,
                                CvArr* mapx, CvArr* mapy );

/* Computes the original (undistorted) feature coordinates
   from the observed (distorted) coordinates */
void cvUndistortPoints( const CvMat* src, CvMat* dst,
                        const CvMat* camera_matrix,
                        const CvMat* dist_coeffs,
                        const CvMat* R = null,
                        const CvMat* P = null);

/* creates structuring element used for morphological operations */
IplConvKernel* cvCreateStructuringElementEx(
        int cols, int  rows, int  anchor_x, int  anchor_y,
        int shape, int* values = null );

/* releases structuring element */
void cvReleaseStructuringElement( IplConvKernel** element );

/* erodes input image (applies minimum filter) one or more times.
   If element pointer is NULL, 3x3 rectangular element is used */
void cvErode( const CvArr* src, CvArr* dst,
              IplConvKernel* element = null,
              int iterations = 1 );

/* dilates input image (applies maximum filter) one or more times.
   If element pointer is NULL, 3x3 rectangular element is used */
void cvDilate( const CvArr* src, CvArr* dst,
               IplConvKernel* element = null,
               int iterations = 1 );

/* Performs complex morphological transformation */
void cvMorphologyEx( const CvArr* src, CvArr* dst,
                     CvArr* temp, IplConvKernel* element,
                     int operation, int iterations = 1 );

/* Calculates all spatial and central moments up to the 3rd order */
void cvMoments( const CvArr* arr, CvMoments* moments, int binary = 0);

/* Retrieve particular spatial, central or normalized central moments */
double cvGetSpatialMoment( CvMoments* moments, int x_order, int y_order );
double cvGetCentralMoment( CvMoments* moments, int x_order, int y_order );
double cvGetNormalizedCentralMoment( CvMoments* moments,
                                     int x_order, int y_order );

/* Calculates 7 Hu's invariants from precalculated spatial and central moments */
void cvGetHuMoments( CvMoments*  moments, CvHuMoments*  hu_moments );

/*********************************** data sampling **************************************/

/* Fetches pixels that belong to the specified line segment and stores them to the buffer.
   Returns the number of retrieved points. */
int cvSampleLine( const CvArr* image, CvPoint pt1, CvPoint pt2, void* buffer,
                  int connectivity = 8);

/* Retrieves the rectangular image region with specified center from the input array.
 dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
 Values of pixels with fractional coordinates are retrieved using bilinear interpolation*/
void cvGetRectSubPix( const CvArr* src, CvArr* dst, CvPoint2D32f center );


/* Retrieves quadrangle from the input array.
	matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
	            ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels
	                                 with fractional coordinates)
*/
void cvGetQuadrangleSubPix( const CvArr* src, CvArr* dst,
                            const CvMat* map_matrix );

/* Measures similarity between template and overlapped windows in the source image
   and fills the resultant image with the measurements */
void cvMatchTemplate( const CvArr* image, const CvArr* templ,
                      CvArr* result, int method );

/* Computes earth mover distance between
   two weighted point sets (called signatures) */
float cvCalcEMD2( const CvArr* signature1,
                  const CvArr* signature2,
                  int distance_type,
                  CvDistanceFunction distance_func = null,
                  const CvArr* cost_matrix = null,
                  CvArr* flow = null,
                  float* lower_bound = null,
                  void* userdata = null);

/****************************************************************************************\
*                              Contours retrieving                                       *
\****************************************************************************************/

/* Retrieves outer and optionally inner boundaries of white (non-zero) connected
   components in the black (zero) background */
int cvFindContours( CvArr* image, CvMemStorage* storage, CvSeq** first_contour,
                    int header_size = CvContour.sizeof,
                    int mode = CV_RETR_LIST,
                    int method = CV_CHAIN_APPROX_SIMPLE,
                    CvPoint offset = cvPoint(0,0));

/* Initalizes contour retrieving process.
   Calls cvStartFindContours.
   Calls cvFindNextContour until null pointer is returned
   or some other condition becomes true.
   Calls cvEndFindContours at the end. */
CvContourScanner cvStartFindContours( CvArr* image, CvMemStorage* storage,
                                      int header_size = CvContour.sizeof,
                                      int mode = CV_RETR_LIST,
                                      int method = CV_CHAIN_APPROX_SIMPLE,
                                      CvPoint offset = cvPoint(0,0));

/* Retrieves next contour */
CvSeq* cvFindNextContour( CvContourScanner scanner );


/* Substitutes the last retrieved contour with the new one
   (if the substitutor is null, the last retrieved contour is removed from the tree) */
void cvSubstituteContour( CvContourScanner scanner, CvSeq* new_contour );


/* Releases contour scanner and returns pointer to the first outer contour */
CvSeq* cvEndFindContours( CvContourScanner* scanner );

/* Approximates a single Freeman chain or a tree of chains to polygonal curves */
CvSeq* cvApproxChains( CvSeq* src_seq, CvMemStorage* storage,
                       int method = CV_CHAIN_APPROX_SIMPLE,
                       double parameter = 0,
                       int  minimal_perimeter = 0,
                       int  recursive = 0);

/* Initalizes Freeman chain reader.
   The reader is used to iteratively get coordinates of all the chain points.
   If the Freeman codes should be read as is, a simple sequence reader should be used */
void cvStartReadChainPoints( CvChain* chain, CvChainPtReader* reader );

/* Retrieves the next chain point */
CvPoint cvReadChainPoint( CvChainPtReader* reader );


/****************************************************************************************\
*                            Contour Processing and Shape Analysis                       *
\****************************************************************************************/

/* Approximates a single polygonal curve (contour) or
   a tree of polygonal curves (contours) */
CvSeq* cvApproxPoly( const void* src_seq,
                     int header_size, CvMemStorage* storage,
                     int method, double parameter,
                     int parameter2 = 0);

/* Calculates perimeter of a contour or length of a part of contour */
double cvArcLength( const void* curve,
                    CvSlice slice = CV_WHOLE_SEQ,
                    int is_closed = -1);

double cvContourPerimeter( const void* contour )
{
	return cvArcLength( contour, CV_WHOLE_SEQ, 1 );
}


/* Calculates contour boundning rectangle (update=1) or
   just retrieves pre-calculated rectangle (update=0) */
CvRect cvBoundingRect( CvArr* points, int update = 0 );

/* Calculates area of a contour or contour segment */
double cvContourArea( const CvArr* contour,
                      CvSlice slice = CV_WHOLE_SEQ,
                      int oriented = 0);

/* Finds minimum area rotated rectangle bounding a set of points */
CvBox2D cvMinAreaRect2( const CvArr* points,
                        CvMemStorage* storage = null);

/* Finds minimum enclosing circle for a set of points */
int cvMinEnclosingCircle( const CvArr* points,
                          CvPoint2D32f* center, float* radius );

/* Compares two contours by matching their moments */
double cvMatchShapes( const void* object1, const void* object2,
                      int method, double parameter = 0);

/* Calculates exact convex hull of 2d point set */
CvSeq* cvConvexHull2( const CvArr* input,
                      void* hull_storage = null,
                      int orientation = CV_CLOCKWISE,
                      int return_points = 0);

/* Checks whether the contour is convex or not (returns 1 if convex, 0 if not) */
int cvCheckContourConvexity( const CvArr* contour );


/* Finds convexity defects for the contour */
CvSeq* cvConvexityDefects( const CvArr* contour, const CvArr* convexhull,
                           CvMemStorage* storage = null);

/* Fits ellipse into a set of 2d points */
CvBox2D cvFitEllipse2( const CvArr* points );

/* Finds minimum rectangle containing two given rectangles */
CvRect cvMaxRect( const CvRect* rect1, const CvRect* rect2 );

/* Finds coordinates of the box vertices */
void cvBoxPoints( CvBox2D box, CvPoint2D32f[4] pt );

/* Initializes sequence header for a matrix (column or row vector) of points -
   a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!) */
CvSeq* cvPointSeqFromMat( int seq_kind, const CvArr* mat,
                          CvContour* contour_header,
                          CvSeqBlock* block );

/* Checks whether the point is inside polygon, outside, on an edge (at a vertex).
   Returns positive, negative or zero value, correspondingly.
   Optionally, measures a signed distance between
   the point and the nearest polygon edge (measure_dist=1) */
double cvPointPolygonTest( const CvArr* contour,
                           CvPoint2D32f pt, int measure_dist );

/****************************************************************************************\
*                                  Histogram functions                                   *
\****************************************************************************************/

/* Creates new histogram */
CvHistogram* cvCreateHist( int dims, int* sizes, int type,
                           float** ranges = null,
                           int uniform = 1);

/* Assignes histogram bin ranges */
void cvSetHistBinRanges( CvHistogram* hist, float** ranges,
                         int uniform = 1);

/* Creates histogram header for array */
CvHistogram* cvMakeHistHeaderForArray(
                        int  dims, int* sizes, CvHistogram* hist,
                        float* data, float** ranges = null,
                        int uniform = 1);

/* Releases histogram */
void cvReleaseHist( CvHistogram** hist );

/* Clears all the histogram bins */
void cvClearHist( CvHistogram* hist );

/* Finds indices and values of minimum and maximum histogram bins */
void cvGetMinMaxHistValue( const CvHistogram* hist,
                           float* min_value, float* max_value,
                           int* min_idx = null,
                           int* max_idx = null);


/* Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>.
   After that sum of histogram bins is equal to <factor> */
void cvNormalizeHist( CvHistogram* hist, double factor );


/* Clear all histogram bins that are below the threshold */
void cvThreshHist( CvHistogram* hist, double threshold );


/* Compares two histogram */
double cvCompareHist( const CvHistogram* hist1,
                      const CvHistogram* hist2,
                      int method);

/* Copies one histogram to another. Destination histogram is created if
   the destination pointer is NULL */
void cvCopyHist( const CvHistogram* src, CvHistogram** dst );


/* Calculates bayesian probabilistic histograms
   (each or src and dst is an array of <number> histograms */
void cvCalcBayesianProb( CvHistogram** src, int number,
                         CvHistogram** dst);

/* Calculates array histogram */
void cvCalcArrHist( CvArr** arr, CvHistogram* hist,
                    int accumulate = 0,
                    const CvArr* mask = null );

void  cvCalcHist( IplImage** image, CvHistogram* hist,
                  int accumulate = 0,
                  const CvArr* mask = null )
{
	cvCalcArrHist( cast(CvArr**)image, hist, accumulate, mask );
}

/* Calculates back project */
void cvCalcArrBackProject( CvArr** image, CvArr* dst,
                           const CvHistogram* hist );
void cvCalcBackProject(IMG)(IMG image, CvArr* dst, const CvHistogram* hist)
{
	cvCalcArrBackProject(cast(CvArr**)image, dst, hist);
}


/* Does some sort of template matching but compares histograms of
   template and each window location */
void cvCalcArrBackProjectPatch( CvArr** image, CvArr* dst, CvSize range,
                                CvHistogram* hist, int method, double factor );
void cvCalcBackProjectPatch(IMG)( IMG image, CvArr* dst, CvSize range,
                                  CvHistogram* hist, int method, double factor)
{
	return cvCalcArrBackProjectPatch( cast(CvArr**)image,
		dst, range, hist, method, factor);
}


/* calculates probabilistic density (divides one histogram by another) */
void cvCalcProbDensity( const CvHistogram* hist1, const CvHistogram* hist2,
                        CvHistogram* dst_hist, double scale = 255 );

/* equalizes histogram of 8-bit single-channel image */
void cvEqualizeHist( const CvArr* src, CvArr* dst );


/* Applies distance transform to binary image */
void cvDistTransform( const CvArr* src, CvArr* dst,
                      int distance_type = CV_DIST_L2,
                      int mask_size = 3,
                      const float* mask = null,
                      CvArr* labels = null,
                      int labelType = CV_DIST_LABEL_CCOMP);


/* Applies fixed-level threshold to grayscale image.
   This is a basic operation applied before retrieving contours */
double cvThreshold( const CvArr*  src, CvArr*  dst,
                    double  threshold, double  max_value,
                    int threshold_type );

/* Applies adaptive threshold to grayscale image.
   The two parameters for methods CV_ADAPTIVE_THRESH_MEAN_C and
   CV_ADAPTIVE_THRESH_GAUSSIAN_C are:
   neighborhood size (3, 5, 7 etc.),
   and a constant subtracted from mean (...,-3,-2,-1,0,1,2,3,...) */
void cvAdaptiveThreshold( const CvArr* src, CvArr* dst, double max_value,
                          int adaptive_method = CV_ADAPTIVE_THRESH_MEAN_C,
                          int threshold_type = CV_THRESH_BINARY,
                          int block_size = 3,
                          double param1 = 5);

/* Fills the connected component until the color difference gets large enough */
void cvFloodFill( CvArr* image, CvPoint seed_point,
                  CvScalar new_val, CvScalar lo_diff = cvScalarAll(0),
                  CvScalar up_diff = cvScalarAll(0),
                  CvConnectedComp* comp = null,
                  int flags = 4,
                  CvArr* mask = null);

/****************************************************************************************\
*                                  Feature detection                                     *
\****************************************************************************************/

/* Runs canny edge detector */
void cvCanny( const CvArr* image, CvArr* edges, double threshold1,
              double threshold2, int  aperture_size = 3 );

/* Calculates constraint image for corner detection
   Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy.
   Applying threshold to the result gives coordinates of corners */
void cvPreCornerDetect( const CvArr* image, CvArr* corners,
                        int aperture_size = 3 );

/* Calculates eigen values and vectors of 2x2
   gradient covariation matrix at every image pixel */
void cvCornerEigenValsAndVecs( const CvArr* image, CvArr* eigenvv,
                               int block_size, int aperture_size = 3 );

/* Calculates minimal eigenvalue for 2x2 gradient covariation matrix at
   every image pixel */
void cvCornerMinEigenVal( const CvArr* image, CvArr* eigenval,
                          int block_size, int aperture_size = 3 );

/* Harris corner detector:
   Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel */
void cvCornerHarris( const CvArr* image, CvArr* harris_responce,
                     int block_size, int aperture_size = 3,
                     double k = 0.04 );

/* Adjust corner position using some sort of gradient search */
void cvFindCornerSubPix( const CvArr* image, CvPoint2D32f* corners,
                         int count, CvSize win, CvSize zero_zone,
                         CvTermCriteria  criteria );

/* Finds a sparse set of points within the selected region
   that seem to be easy to track */
void cvGoodFeaturesToTrack( const CvArr* image, CvArr* eig_image,
                            CvArr* temp_image, CvPoint2D32f* corners,
                            int* corner_count, double  quality_level,
                            double  min_distance,
                            const CvArr* mask = null,
                            int block_size = 3,
                            int use_harris = 0,
                            double k = 0.04 );

/* Finds lines on binary image using one of several methods.
   line_storage is either memory storage or 1 x <max number of lines> CvMat, its
   number of columns is changed by the function.
   method is one of CV_HOUGH_*;
   rho, theta and threshold are used for each of those methods;
   param1 ~ line length, param2 ~ line gap - for probabilistic,
   param1 ~ srn, param2 ~ stn - for multi-scale */
CvSeq* cvHoughLines2( CvArr* image, void* line_storage, int method,
                      double rho, double theta, int threshold,
                      double param1 = 0, double param2 = 0);

/* Finds circles in the image */
CvSeq* cvHoughCircles( CvArr* image, void* circle_storage,
                       int method, double dp, double min_dist,
                       double param1 = 100,
                       double param2 = 100,
                       int min_radius = 0,
                       int max_radius = 0);

/* Fits a line into set of 2d or 3d points in a robust way (M-estimator technique) */
void cvFitLine( const CvArr* points, int dist_type, double param,
                double reps, double aeps, float* line );

