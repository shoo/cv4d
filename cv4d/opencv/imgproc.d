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

#ifndef __OPENCV_IMGPROC_TYPES_C_H__
#define __OPENCV_IMGPROC_TYPES_C_H__

#include "opencv2/core/core_c.h"
#include "opencv2/imgproc/types_c.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Connected component structure */
typedef struct CvConnectedComp
{
    double area;    /* area of the connected component  */
    CvScalar value; /* average color of the connected component */
    CvRect rect;    /* ROI of the component  */
    CvSeq* contour; /* optional component boundary
                      (the contour might have child contours corresponding to the holes)*/
}
CvConnectedComp;

/* Image smooth methods */
enum
{
    CV_BLUR_NO_SCALE =0,
    CV_BLUR  =1,
    CV_GAUSSIAN  =2,
    CV_MEDIAN =3,
    CV_BILATERAL =4
};

/* Filters used in pyramid decomposition */
enum
{
    CV_GAUSSIAN_5x5 = 7
};

/* Inpainting algorithms */
enum
{
    CV_INPAINT_NS      =0,
    CV_INPAINT_TELEA   =1
};

/* Special filters */
enum
{
    CV_SCHARR =-1,
    CV_MAX_SOBEL_KSIZE =7
};

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
    
    CV_COLORCVT_MAX  =100
};


/* Sub-pixel interpolation methods */
enum
{
    CV_INTER_NN        =0,
    CV_INTER_LINEAR    =1,
    CV_INTER_CUBIC     =2,
    CV_INTER_AREA      =3,
    CV_INTER_LANCZOS4  =4
};

/* ... and other image warping flags */
enum
{
    CV_WARP_FILL_OUTLIERS =8,
    CV_WARP_INVERSE_MAP  =16
};

/* Shapes of a structuring element for morphological operations */
enum
{
    CV_SHAPE_RECT      =0,
    CV_SHAPE_CROSS     =1,
    CV_SHAPE_ELLIPSE   =2,
    CV_SHAPE_CUSTOM    =100
};

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
};

/* Spatial and central moments */
typedef struct CvMoments
{
    double  m00, m10, m01, m20, m11, m02, m30, m21, m12, m03; /* spatial moments */
    double  mu20, mu11, mu02, mu30, mu21, mu12, mu03; /* central moments */
    double  inv_sqrt_m00; /* m00 != 0 ? 1/sqrt(m00) : 0 */
}
CvMoments;

/* Hu invariants */
typedef struct CvHuMoments
{
    double hu1, hu2, hu3, hu4, hu5, hu6, hu7; /* Hu invariants */
}
CvHuMoments;

/* Template matching methods */
enum
{
    CV_TM_SQDIFF        =0,
    CV_TM_SQDIFF_NORMED =1,
    CV_TM_CCORR         =2,
    CV_TM_CCORR_NORMED  =3,
    CV_TM_CCOEFF        =4,
    CV_TM_CCOEFF_NORMED =5
};

typedef float (CV_CDECL * CvDistanceFunction)( const float* a, const float* b, void* user_param );

/* Contour retrieval modes */
enum
{
    CV_RETR_EXTERNAL=0,
    CV_RETR_LIST=1,
    CV_RETR_CCOMP=2,
    CV_RETR_TREE=3
};

/* Contour approximation methods */
enum
{
    CV_CHAIN_CODE=0,
    CV_CHAIN_APPROX_NONE=1,
    CV_CHAIN_APPROX_SIMPLE=2,
    CV_CHAIN_APPROX_TC89_L1=3,
    CV_CHAIN_APPROX_TC89_KCOS=4,
    CV_LINK_RUNS=5
};

/*
Internal structure that is used for sequental retrieving contours from the image.
It supports both hierarchical and plane variants of Suzuki algorithm.
*/
typedef struct _CvContourScanner* CvContourScanner;

/* Freeman chain reader state */
typedef struct CvChainPtReader
{
    CV_SEQ_READER_FIELDS()
    char      code;
    CvPoint   pt;
    schar     deltas[8][2];
}
CvChainPtReader;

/* initializes 8-element array for fast access to 3x3 neighborhood of a pixel */
#define  CV_INIT_3X3_DELTAS( deltas, step, nch )            \
    ((deltas)[0] =  (nch),  (deltas)[1] = -(step) + (nch),  \
     (deltas)[2] = -(step), (deltas)[3] = -(step) - (nch),  \
     (deltas)[4] = -(nch),  (deltas)[5] =  (step) - (nch),  \
     (deltas)[6] =  (step), (deltas)[7] =  (step) + (nch))


/****************************************************************************************\
*                              Planar subdivisions                                       *
\****************************************************************************************/

typedef size_t CvSubdiv2DEdge;

#define CV_QUADEDGE2D_FIELDS()     \
    int flags;                     \
    struct CvSubdiv2DPoint* pt[4]; \
    CvSubdiv2DEdge  next[4];

#define CV_SUBDIV2D_POINT_FIELDS()\
    int            flags;      \
    CvSubdiv2DEdge first;      \
    CvPoint2D32f   pt;         \
    int id;

#define CV_SUBDIV2D_VIRTUAL_POINT_FLAG (1 << 30)

typedef struct CvQuadEdge2D
{
    CV_QUADEDGE2D_FIELDS()
}
CvQuadEdge2D;

typedef struct CvSubdiv2DPoint
{
    CV_SUBDIV2D_POINT_FIELDS()
}
CvSubdiv2DPoint;

#define CV_SUBDIV2D_FIELDS()    \
    CV_GRAPH_FIELDS()           \
    int  quad_edges;            \
    int  is_geometry_valid;     \
    CvSubdiv2DEdge recent_edge; \
    CvPoint2D32f  topleft;      \
    CvPoint2D32f  bottomright;

typedef struct CvSubdiv2D
{
    CV_SUBDIV2D_FIELDS()
}
CvSubdiv2D;


typedef enum CvSubdiv2DPointLocation
{
    CV_PTLOC_ERROR = -2,
    CV_PTLOC_OUTSIDE_RECT = -1,
    CV_PTLOC_INSIDE = 0,
    CV_PTLOC_VERTEX = 1,
    CV_PTLOC_ON_EDGE = 2
}
CvSubdiv2DPointLocation;

typedef enum CvNextEdgeType
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
CvNextEdgeType;

/* get the next edge with the same origin point (counterwise) */
#define  CV_SUBDIV2D_NEXT_EDGE( edge )  (((CvQuadEdge2D*)((edge) & ~3))->next[(edge)&3])


/* Contour approximation algorithms */
enum
{
    CV_POLY_APPROX_DP = 0
};

/* Shape matching methods */
enum
{
    CV_CONTOURS_MATCH_I1  =1,
    CV_CONTOURS_MATCH_I2  =2,
    CV_CONTOURS_MATCH_I3  =3
};

/* Shape orientation */
enum
{
    CV_CLOCKWISE         =1,
    CV_COUNTER_CLOCKWISE =2
};


/* Convexity defect */
typedef struct CvConvexityDefect
{
    CvPoint* start; /* point of the contour where the defect begins */
    CvPoint* end; /* point of the contour where the defect ends */
    CvPoint* depth_point; /* the farthest from the convex hull point within the defect */
    float depth; /* distance between the farthest point and the convex hull */
} CvConvexityDefect;


/* Histogram comparison methods */
enum
{
    CV_COMP_CORREL        =0,
    CV_COMP_CHISQR        =1,
    CV_COMP_INTERSECT     =2,
    CV_COMP_BHATTACHARYYA =3
};

/* Mask size for distance transform */
enum
{
    CV_DIST_MASK_3   =3,
    CV_DIST_MASK_5   =5,
    CV_DIST_MASK_PRECISE =0
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
};


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
};

/* Adaptive threshold methods */
enum
{
    CV_ADAPTIVE_THRESH_MEAN_C  =0,
    CV_ADAPTIVE_THRESH_GAUSSIAN_C  =1
};

/* FloodFill flags */
enum
{
    CV_FLOODFILL_FIXED_RANGE =(1 << 16),
    CV_FLOODFILL_MASK_ONLY   =(1 << 17)
};


/* Canny edge detector flags */
enum
{
    CV_CANNY_L2_GRADIENT  =(1 << 31)
};

/* Variants of a Hough transform */
enum
{
    CV_HOUGH_STANDARD =0,
    CV_HOUGH_PROBABILISTIC =1,
    CV_HOUGH_MULTI_SCALE =2,
    CV_HOUGH_GRADIENT =3
};


/* Fast search data structures  */
struct CvFeatureTree;
struct CvLSH;
struct CvLSHOperations;

#ifdef __cplusplus
}
#endif

#endif


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

#ifndef __OPENCV_IMGPROC_IMGPROC_C_H__
#define __OPENCV_IMGPROC_IMGPROC_C_H__

#include "opencv2/core/core_c.h"
#include "opencv2/imgproc/types_c.h"

#ifdef __cplusplus
extern "C" {
#endif

/*********************** Background statistics accumulation *****************************/

/* Adds image to accumulator */
CVAPI(void)  cvAcc( const CvArr* image, CvArr* sum,
                   const CvArr* mask CV_DEFAULT(NULL) );

/* Adds squared image to accumulator */
CVAPI(void)  cvSquareAcc( const CvArr* image, CvArr* sqsum,
                         const CvArr* mask CV_DEFAULT(NULL) );

/* Adds a product of two images to accumulator */
CVAPI(void)  cvMultiplyAcc( const CvArr* image1, const CvArr* image2, CvArr* acc,
                           const CvArr* mask CV_DEFAULT(NULL) );

/* Adds image to accumulator with weights: acc = acc*(1-alpha) + image*alpha */
CVAPI(void)  cvRunningAvg( const CvArr* image, CvArr* acc, double alpha,
                          const CvArr* mask CV_DEFAULT(NULL) );
    
/****************************************************************************************\
*                                    Image Processing                                    *
\****************************************************************************************/

/* Copies source 2D array inside of the larger destination array and
   makes a border of the specified type (IPL_BORDER_*) around the copied area. */
CVAPI(void) cvCopyMakeBorder( const CvArr* src, CvArr* dst, CvPoint offset,
                              int bordertype, CvScalar value CV_DEFAULT(cvScalarAll(0)));

/* Smoothes array (removes noise) */
CVAPI(void) cvSmooth( const CvArr* src, CvArr* dst,
                      int smoothtype CV_DEFAULT(CV_GAUSSIAN),
                      int size1 CV_DEFAULT(3),
                      int size2 CV_DEFAULT(0),
                      double sigma1 CV_DEFAULT(0),
                      double sigma2 CV_DEFAULT(0));

/* Convolves the image with the kernel */
CVAPI(void) cvFilter2D( const CvArr* src, CvArr* dst, const CvMat* kernel,
                        CvPoint anchor CV_DEFAULT(cvPoint(-1,-1)));

/* Finds integral image: SUM(X,Y) = sum(x<X,y<Y)I(x,y) */
CVAPI(void) cvIntegral( const CvArr* image, CvArr* sum,
                       CvArr* sqsum CV_DEFAULT(NULL),
                       CvArr* tilted_sum CV_DEFAULT(NULL));

/*
   Smoothes the input image with gaussian kernel and then down-samples it.
   dst_width = floor(src_width/2)[+1],
   dst_height = floor(src_height/2)[+1]
*/
CVAPI(void)  cvPyrDown( const CvArr* src, CvArr* dst,
                        int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );

/*
   Up-samples image and smoothes the result with gaussian kernel.
   dst_width = src_width*2,
   dst_height = src_height*2
*/
CVAPI(void)  cvPyrUp( const CvArr* src, CvArr* dst,
                      int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );

/* Builds pyramid for an image */
CVAPI(CvMat**) cvCreatePyramid( const CvArr* img, int extra_layers, double rate,
                                const CvSize* layer_sizes CV_DEFAULT(0),
                                CvArr* bufarr CV_DEFAULT(0),
                                int calc CV_DEFAULT(1),
                                int filter CV_DEFAULT(CV_GAUSSIAN_5x5) );

/* Releases pyramid */
CVAPI(void)  cvReleasePyramid( CvMat*** pyramid, int extra_layers );


/* Splits color or grayscale image into multiple connected components
   of nearly the same color/brightness using modification of Burt algorithm.
   comp with contain a pointer to sequence (CvSeq)
   of connected components (CvConnectedComp) */
CVAPI(void) cvPyrSegmentation( IplImage* src, IplImage* dst,
                              CvMemStorage* storage, CvSeq** comp,
                              int level, double threshold1,
                              double threshold2 );

/* Filters image using meanshift algorithm */
CVAPI(void) cvPyrMeanShiftFiltering( const CvArr* src, CvArr* dst,
    double sp, double sr, int max_level CV_DEFAULT(1),
    CvTermCriteria termcrit CV_DEFAULT(cvTermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,5,1)));

/* Segments image using seed "markers" */
CVAPI(void) cvWatershed( const CvArr* image, CvArr* markers );

/* Inpaints the selected region in the image */
CVAPI(void) cvInpaint( const CvArr* src, const CvArr* inpaint_mask,
                       CvArr* dst, double inpaintRange, int flags );

/* Calculates an image derivative using generalized Sobel
   (aperture_size = 1,3,5,7) or Scharr (aperture_size = -1) operator.
   Scharr can be used only for the first dx or dy derivative */
CVAPI(void) cvSobel( const CvArr* src, CvArr* dst,
                    int xorder, int yorder,
                    int aperture_size CV_DEFAULT(3));

/* Calculates the image Laplacian: (d2/dx + d2/dy)I */
CVAPI(void) cvLaplace( const CvArr* src, CvArr* dst,
                      int aperture_size CV_DEFAULT(3) );

/* Converts input array pixels from one color space to another */
CVAPI(void)  cvCvtColor( const CvArr* src, CvArr* dst, int code );


/* Resizes image (input array is resized to fit the destination array) */
CVAPI(void)  cvResize( const CvArr* src, CvArr* dst,
                       int interpolation CV_DEFAULT( CV_INTER_LINEAR ));

/* Warps image with affine transform */
CVAPI(void)  cvWarpAffine( const CvArr* src, CvArr* dst, const CvMat* map_matrix,
                           int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS),
                           CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );

/* Computes affine transform matrix for mapping src[i] to dst[i] (i=0,1,2) */
CVAPI(CvMat*) cvGetAffineTransform( const CvPoint2D32f * src,
                                    const CvPoint2D32f * dst,
                                    CvMat * map_matrix );

/* Computes rotation_matrix matrix */
CVAPI(CvMat*)  cv2DRotationMatrix( CvPoint2D32f center, double angle,
                                   double scale, CvMat* map_matrix );

/* Warps image with perspective (projective) transform */
CVAPI(void)  cvWarpPerspective( const CvArr* src, CvArr* dst, const CvMat* map_matrix,
                                int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS),
                                CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );

/* Computes perspective transform matrix for mapping src[i] to dst[i] (i=0,1,2,3) */
CVAPI(CvMat*) cvGetPerspectiveTransform( const CvPoint2D32f* src,
                                         const CvPoint2D32f* dst,
                                         CvMat* map_matrix );

/* Performs generic geometric transformation using the specified coordinate maps */
CVAPI(void)  cvRemap( const CvArr* src, CvArr* dst,
                      const CvArr* mapx, const CvArr* mapy,
                      int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS),
                      CvScalar fillval CV_DEFAULT(cvScalarAll(0)) );

/* Converts mapx & mapy from floating-point to integer formats for cvRemap */
CVAPI(void)  cvConvertMaps( const CvArr* mapx, const CvArr* mapy,
                            CvArr* mapxy, CvArr* mapalpha );

/* Performs forward or inverse log-polar image transform */
CVAPI(void)  cvLogPolar( const CvArr* src, CvArr* dst,
                         CvPoint2D32f center, double M,
                         int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS));

/* Performs forward or inverse linear-polar image transform */
CVAPI(void)  cvLinearPolar( const CvArr* src, CvArr* dst,
                         CvPoint2D32f center, double maxRadius,
                         int flags CV_DEFAULT(CV_INTER_LINEAR+CV_WARP_FILL_OUTLIERS));

/* Transforms the input image to compensate lens distortion */
CVAPI(void) cvUndistort2( const CvArr* src, CvArr* dst,
                          const CvMat* camera_matrix,
                          const CvMat* distortion_coeffs,
                          const CvMat* new_camera_matrix CV_DEFAULT(0) );

/* Computes transformation map from intrinsic camera parameters
   that can used by cvRemap */
CVAPI(void) cvInitUndistortMap( const CvMat* camera_matrix,
                                const CvMat* distortion_coeffs,
                                CvArr* mapx, CvArr* mapy );

/* Computes undistortion+rectification map for a head of stereo camera */
CVAPI(void) cvInitUndistortRectifyMap( const CvMat* camera_matrix,
                                       const CvMat* dist_coeffs,
                                       const CvMat *R, const CvMat* new_camera_matrix,
                                       CvArr* mapx, CvArr* mapy );

/* Computes the original (undistorted) feature coordinates
   from the observed (distorted) coordinates */
CVAPI(void) cvUndistortPoints( const CvMat* src, CvMat* dst,
                               const CvMat* camera_matrix,
                               const CvMat* dist_coeffs,
                               const CvMat* R CV_DEFAULT(0),
                               const CvMat* P CV_DEFAULT(0));

/* creates structuring element used for morphological operations */
CVAPI(IplConvKernel*)  cvCreateStructuringElementEx(
            int cols, int  rows, int  anchor_x, int  anchor_y,
            int shape, int* values CV_DEFAULT(NULL) );

/* releases structuring element */
CVAPI(void)  cvReleaseStructuringElement( IplConvKernel** element );

/* erodes input image (applies minimum filter) one or more times.
   If element pointer is NULL, 3x3 rectangular element is used */
CVAPI(void)  cvErode( const CvArr* src, CvArr* dst,
                      IplConvKernel* element CV_DEFAULT(NULL),
                      int iterations CV_DEFAULT(1) );

/* dilates input image (applies maximum filter) one or more times.
   If element pointer is NULL, 3x3 rectangular element is used */
CVAPI(void)  cvDilate( const CvArr* src, CvArr* dst,
                       IplConvKernel* element CV_DEFAULT(NULL),
                       int iterations CV_DEFAULT(1) );

/* Performs complex morphological transformation */
CVAPI(void)  cvMorphologyEx( const CvArr* src, CvArr* dst,
                             CvArr* temp, IplConvKernel* element,
                             int operation, int iterations CV_DEFAULT(1) );

/* Calculates all spatial and central moments up to the 3rd order */
CVAPI(void) cvMoments( const CvArr* arr, CvMoments* moments, int binary CV_DEFAULT(0));

/* Retrieve particular spatial, central or normalized central moments */
CVAPI(double)  cvGetSpatialMoment( CvMoments* moments, int x_order, int y_order );
CVAPI(double)  cvGetCentralMoment( CvMoments* moments, int x_order, int y_order );
CVAPI(double)  cvGetNormalizedCentralMoment( CvMoments* moments,
                                             int x_order, int y_order );

/* Calculates 7 Hu's invariants from precalculated spatial and central moments */
CVAPI(void) cvGetHuMoments( CvMoments*  moments, CvHuMoments*  hu_moments );

/*********************************** data sampling **************************************/

/* Fetches pixels that belong to the specified line segment and stores them to the buffer.
   Returns the number of retrieved points. */
CVAPI(int)  cvSampleLine( const CvArr* image, CvPoint pt1, CvPoint pt2, void* buffer,
                          int connectivity CV_DEFAULT(8));

/* Retrieves the rectangular image region with specified center from the input array.
 dst(x,y) <- src(x + center.x - dst_width/2, y + center.y - dst_height/2).
 Values of pixels with fractional coordinates are retrieved using bilinear interpolation*/
CVAPI(void)  cvGetRectSubPix( const CvArr* src, CvArr* dst, CvPoint2D32f center );


/* Retrieves quadrangle from the input array.
    matrixarr = ( a11  a12 | b1 )   dst(x,y) <- src(A[x y]' + b)
                ( a21  a22 | b2 )   (bilinear interpolation is used to retrieve pixels
                                     with fractional coordinates)
*/
CVAPI(void)  cvGetQuadrangleSubPix( const CvArr* src, CvArr* dst,
                                    const CvMat* map_matrix );

/* Measures similarity between template and overlapped windows in the source image
   and fills the resultant image with the measurements */
CVAPI(void)  cvMatchTemplate( const CvArr* image, const CvArr* templ,
                              CvArr* result, int method );

/* Computes earth mover distance between
   two weighted point sets (called signatures) */
CVAPI(float)  cvCalcEMD2( const CvArr* signature1,
                          const CvArr* signature2,
                          int distance_type,
                          CvDistanceFunction distance_func CV_DEFAULT(NULL),
                          const CvArr* cost_matrix CV_DEFAULT(NULL),
                          CvArr* flow CV_DEFAULT(NULL),
                          float* lower_bound CV_DEFAULT(NULL),
                          void* userdata CV_DEFAULT(NULL));

/****************************************************************************************\
*                              Contours retrieving                                       *
\****************************************************************************************/

/* Retrieves outer and optionally inner boundaries of white (non-zero) connected
   components in the black (zero) background */
CVAPI(int)  cvFindContours( CvArr* image, CvMemStorage* storage, CvSeq** first_contour,
                            int header_size CV_DEFAULT(sizeof(CvContour)),
                            int mode CV_DEFAULT(CV_RETR_LIST),
                            int method CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE),
                            CvPoint offset CV_DEFAULT(cvPoint(0,0)));

/* Initalizes contour retrieving process.
   Calls cvStartFindContours.
   Calls cvFindNextContour until null pointer is returned
   or some other condition becomes true.
   Calls cvEndFindContours at the end. */
CVAPI(CvContourScanner)  cvStartFindContours( CvArr* image, CvMemStorage* storage,
                            int header_size CV_DEFAULT(sizeof(CvContour)),
                            int mode CV_DEFAULT(CV_RETR_LIST),
                            int method CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE),
                            CvPoint offset CV_DEFAULT(cvPoint(0,0)));

/* Retrieves next contour */
CVAPI(CvSeq*)  cvFindNextContour( CvContourScanner scanner );


/* Substitutes the last retrieved contour with the new one
   (if the substitutor is null, the last retrieved contour is removed from the tree) */
CVAPI(void)   cvSubstituteContour( CvContourScanner scanner, CvSeq* new_contour );


/* Releases contour scanner and returns pointer to the first outer contour */
CVAPI(CvSeq*)  cvEndFindContours( CvContourScanner* scanner );

/* Approximates a single Freeman chain or a tree of chains to polygonal curves */
CVAPI(CvSeq*) cvApproxChains( CvSeq* src_seq, CvMemStorage* storage,
                            int method CV_DEFAULT(CV_CHAIN_APPROX_SIMPLE),
                            double parameter CV_DEFAULT(0),
                            int  minimal_perimeter CV_DEFAULT(0),
                            int  recursive CV_DEFAULT(0));

/* Initalizes Freeman chain reader.
   The reader is used to iteratively get coordinates of all the chain points.
   If the Freeman codes should be read as is, a simple sequence reader should be used */
CVAPI(void) cvStartReadChainPoints( CvChain* chain, CvChainPtReader* reader );

/* Retrieves the next chain point */
CVAPI(CvPoint) cvReadChainPoint( CvChainPtReader* reader );

/****************************************************************************************\
*                              Planar subdivisions                                       *
\****************************************************************************************/

/* Initializes Delaunay triangulation */
CVAPI(void)  cvInitSubdivDelaunay2D( CvSubdiv2D* subdiv, CvRect rect );

/* Creates new subdivision */
CVAPI(CvSubdiv2D*)  cvCreateSubdiv2D( int subdiv_type, int header_size,
                                      int vtx_size, int quadedge_size,
                                      CvMemStorage* storage );

/************************* high-level subdivision functions ***************************/

/* Simplified Delaunay diagram creation */
CV_INLINE  CvSubdiv2D* cvCreateSubdivDelaunay2D( CvRect rect, CvMemStorage* storage )
{
    CvSubdiv2D* subdiv = cvCreateSubdiv2D( CV_SEQ_KIND_SUBDIV2D, sizeof(*subdiv),
                         sizeof(CvSubdiv2DPoint), sizeof(CvQuadEdge2D), storage );

    cvInitSubdivDelaunay2D( subdiv, rect );
    return subdiv;
}


/* Inserts new point to the Delaunay triangulation */
CVAPI(CvSubdiv2DPoint*)  cvSubdivDelaunay2DInsert( CvSubdiv2D* subdiv, CvPoint2D32f pt);

/* Locates a point within the Delaunay triangulation (finds the edge
   the point is left to or belongs to, or the triangulation point the given
   point coinsides with */
CVAPI(CvSubdiv2DPointLocation)  cvSubdiv2DLocate(
                               CvSubdiv2D* subdiv, CvPoint2D32f pt,
                               CvSubdiv2DEdge* edge,
                               CvSubdiv2DPoint** vertex CV_DEFAULT(NULL) );

/* Calculates Voronoi tesselation (i.e. coordinates of Voronoi points) */
CVAPI(void)  cvCalcSubdivVoronoi2D( CvSubdiv2D* subdiv );


/* Removes all Voronoi points from the tesselation */
CVAPI(void)  cvClearSubdivVoronoi2D( CvSubdiv2D* subdiv );


/* Finds the nearest to the given point vertex in subdivision. */
CVAPI(CvSubdiv2DPoint*) cvFindNearestPoint2D( CvSubdiv2D* subdiv, CvPoint2D32f pt );


/************ Basic quad-edge navigation and operations ************/

CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DNextEdge( CvSubdiv2DEdge edge )
{
    return  CV_SUBDIV2D_NEXT_EDGE(edge);
}


CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DRotateEdge( CvSubdiv2DEdge edge, int rotate )
{
    return  (edge & ~3) + ((edge + rotate) & 3);
}

CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DSymEdge( CvSubdiv2DEdge edge )
{
    return edge ^ 2;
}

CV_INLINE  CvSubdiv2DEdge  cvSubdiv2DGetEdge( CvSubdiv2DEdge edge, CvNextEdgeType type )
{
    CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
    edge = e->next[(edge + (int)type) & 3];
    return  (edge & ~3) + ((edge + ((int)type >> 4)) & 3);
}


CV_INLINE  CvSubdiv2DPoint*  cvSubdiv2DEdgeOrg( CvSubdiv2DEdge edge )
{
    CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
    return (CvSubdiv2DPoint*)e->pt[edge & 3];
}


CV_INLINE  CvSubdiv2DPoint*  cvSubdiv2DEdgeDst( CvSubdiv2DEdge edge )
{
    CvQuadEdge2D* e = (CvQuadEdge2D*)(edge & ~3);
    return (CvSubdiv2DPoint*)e->pt[(edge + 2) & 3];
}


CV_INLINE  double  cvTriangleArea( CvPoint2D32f a, CvPoint2D32f b, CvPoint2D32f c )
{
    return ((double)b.x - a.x) * ((double)c.y - a.y) - ((double)b.y - a.y) * ((double)c.x - a.x);
}


/****************************************************************************************\
*                            Contour Processing and Shape Analysis                       *
\****************************************************************************************/

/* Approximates a single polygonal curve (contour) or
   a tree of polygonal curves (contours) */
CVAPI(CvSeq*)  cvApproxPoly( const void* src_seq,
                             int header_size, CvMemStorage* storage,
                             int method, double parameter,
                             int parameter2 CV_DEFAULT(0));

/* Calculates perimeter of a contour or length of a part of contour */
CVAPI(double)  cvArcLength( const void* curve,
                            CvSlice slice CV_DEFAULT(CV_WHOLE_SEQ),
                            int is_closed CV_DEFAULT(-1));

CV_INLINE double cvContourPerimeter( const void* contour )
{
    return cvArcLength( contour, CV_WHOLE_SEQ, 1 );
}


/* Calculates contour boundning rectangle (update=1) or
   just retrieves pre-calculated rectangle (update=0) */
CVAPI(CvRect)  cvBoundingRect( CvArr* points, int update CV_DEFAULT(0) );

/* Calculates area of a contour or contour segment */
CVAPI(double)  cvContourArea( const CvArr* contour,
                              CvSlice slice CV_DEFAULT(CV_WHOLE_SEQ),
                              int oriented CV_DEFAULT(0));

/* Finds minimum area rotated rectangle bounding a set of points */
CVAPI(CvBox2D)  cvMinAreaRect2( const CvArr* points,
                                CvMemStorage* storage CV_DEFAULT(NULL));

/* Finds minimum enclosing circle for a set of points */
CVAPI(int)  cvMinEnclosingCircle( const CvArr* points,
                                  CvPoint2D32f* center, float* radius );

/* Compares two contours by matching their moments */
CVAPI(double)  cvMatchShapes( const void* object1, const void* object2,
                              int method, double parameter CV_DEFAULT(0));

/* Calculates exact convex hull of 2d point set */
CVAPI(CvSeq*) cvConvexHull2( const CvArr* input,
                             void* hull_storage CV_DEFAULT(NULL),
                             int orientation CV_DEFAULT(CV_CLOCKWISE),
                             int return_points CV_DEFAULT(0));

/* Checks whether the contour is convex or not (returns 1 if convex, 0 if not) */
CVAPI(int)  cvCheckContourConvexity( const CvArr* contour );


/* Finds convexity defects for the contour */
CVAPI(CvSeq*)  cvConvexityDefects( const CvArr* contour, const CvArr* convexhull,
                                   CvMemStorage* storage CV_DEFAULT(NULL));

/* Fits ellipse into a set of 2d points */
CVAPI(CvBox2D) cvFitEllipse2( const CvArr* points );

/* Finds minimum rectangle containing two given rectangles */
CVAPI(CvRect)  cvMaxRect( const CvRect* rect1, const CvRect* rect2 );

/* Finds coordinates of the box vertices */
CVAPI(void) cvBoxPoints( CvBox2D box, CvPoint2D32f pt[4] );

/* Initializes sequence header for a matrix (column or row vector) of points -
   a wrapper for cvMakeSeqHeaderForArray (it does not initialize bounding rectangle!!!) */
CVAPI(CvSeq*) cvPointSeqFromMat( int seq_kind, const CvArr* mat,
                                 CvContour* contour_header,
                                 CvSeqBlock* block );

/* Checks whether the point is inside polygon, outside, on an edge (at a vertex).
   Returns positive, negative or zero value, correspondingly.
   Optionally, measures a signed distance between
   the point and the nearest polygon edge (measure_dist=1) */
CVAPI(double) cvPointPolygonTest( const CvArr* contour,
                                  CvPoint2D32f pt, int measure_dist );

/****************************************************************************************\
*                                  Histogram functions                                   *
\****************************************************************************************/

/* Creates new histogram */
CVAPI(CvHistogram*)  cvCreateHist( int dims, int* sizes, int type,
                                   float** ranges CV_DEFAULT(NULL),
                                   int uniform CV_DEFAULT(1));

/* Assignes histogram bin ranges */
CVAPI(void)  cvSetHistBinRanges( CvHistogram* hist, float** ranges,
                                int uniform CV_DEFAULT(1));

/* Creates histogram header for array */
CVAPI(CvHistogram*)  cvMakeHistHeaderForArray(
                            int  dims, int* sizes, CvHistogram* hist,
                            float* data, float** ranges CV_DEFAULT(NULL),
                            int uniform CV_DEFAULT(1));

/* Releases histogram */
CVAPI(void)  cvReleaseHist( CvHistogram** hist );

/* Clears all the histogram bins */
CVAPI(void)  cvClearHist( CvHistogram* hist );

/* Finds indices and values of minimum and maximum histogram bins */
CVAPI(void)  cvGetMinMaxHistValue( const CvHistogram* hist,
                                   float* min_value, float* max_value,
                                   int* min_idx CV_DEFAULT(NULL),
                                   int* max_idx CV_DEFAULT(NULL));


/* Normalizes histogram by dividing all bins by sum of the bins, multiplied by <factor>.
   After that sum of histogram bins is equal to <factor> */
CVAPI(void)  cvNormalizeHist( CvHistogram* hist, double factor );


/* Clear all histogram bins that are below the threshold */
CVAPI(void)  cvThreshHist( CvHistogram* hist, double threshold );


/* Compares two histogram */
CVAPI(double)  cvCompareHist( const CvHistogram* hist1,
                              const CvHistogram* hist2,
                              int method);

/* Copies one histogram to another. Destination histogram is created if
   the destination pointer is NULL */
CVAPI(void)  cvCopyHist( const CvHistogram* src, CvHistogram** dst );


/* Calculates bayesian probabilistic histograms
   (each or src and dst is an array of <number> histograms */
CVAPI(void)  cvCalcBayesianProb( CvHistogram** src, int number,
                                CvHistogram** dst);

/* Calculates array histogram */
CVAPI(void)  cvCalcArrHist( CvArr** arr, CvHistogram* hist,
                            int accumulate CV_DEFAULT(0),
                            const CvArr* mask CV_DEFAULT(NULL) );

CV_INLINE  void  cvCalcHist( IplImage** image, CvHistogram* hist,
                             int accumulate CV_DEFAULT(0),
                             const CvArr* mask CV_DEFAULT(NULL) )
{
    cvCalcArrHist( (CvArr**)image, hist, accumulate, mask );
}

/* Calculates back project */
CVAPI(void)  cvCalcArrBackProject( CvArr** image, CvArr* dst,
                                   const CvHistogram* hist );
#define  cvCalcBackProject(image, dst, hist) cvCalcArrBackProject((CvArr**)image, dst, hist)


/* Does some sort of template matching but compares histograms of
   template and each window location */
CVAPI(void)  cvCalcArrBackProjectPatch( CvArr** image, CvArr* dst, CvSize range,
                                        CvHistogram* hist, int method,
                                        double factor );
#define  cvCalcBackProjectPatch( image, dst, range, hist, method, factor ) \
     cvCalcArrBackProjectPatch( (CvArr**)image, dst, range, hist, method, factor )


/* calculates probabilistic density (divides one histogram by another) */
CVAPI(void)  cvCalcProbDensity( const CvHistogram* hist1, const CvHistogram* hist2,
                                CvHistogram* dst_hist, double scale CV_DEFAULT(255) );

/* equalizes histogram of 8-bit single-channel image */
CVAPI(void)  cvEqualizeHist( const CvArr* src, CvArr* dst );


/* Applies distance transform to binary image */
CVAPI(void)  cvDistTransform( const CvArr* src, CvArr* dst,
                              int distance_type CV_DEFAULT(CV_DIST_L2),
                              int mask_size CV_DEFAULT(3),
                              const float* mask CV_DEFAULT(NULL),
                              CvArr* labels CV_DEFAULT(NULL));


/* Applies fixed-level threshold to grayscale image.
   This is a basic operation applied before retrieving contours */
CVAPI(double)  cvThreshold( const CvArr*  src, CvArr*  dst,
                            double  threshold, double  max_value,
                            int threshold_type );

/* Applies adaptive threshold to grayscale image.
   The two parameters for methods CV_ADAPTIVE_THRESH_MEAN_C and
   CV_ADAPTIVE_THRESH_GAUSSIAN_C are:
   neighborhood size (3, 5, 7 etc.),
   and a constant subtracted from mean (...,-3,-2,-1,0,1,2,3,...) */
CVAPI(void)  cvAdaptiveThreshold( const CvArr* src, CvArr* dst, double max_value,
                                  int adaptive_method CV_DEFAULT(CV_ADAPTIVE_THRESH_MEAN_C),
                                  int threshold_type CV_DEFAULT(CV_THRESH_BINARY),
                                  int block_size CV_DEFAULT(3),
                                  double param1 CV_DEFAULT(5));

/* Fills the connected component until the color difference gets large enough */
CVAPI(void)  cvFloodFill( CvArr* image, CvPoint seed_point,
                          CvScalar new_val, CvScalar lo_diff CV_DEFAULT(cvScalarAll(0)),
                          CvScalar up_diff CV_DEFAULT(cvScalarAll(0)),
                          CvConnectedComp* comp CV_DEFAULT(NULL),
                          int flags CV_DEFAULT(4),
                          CvArr* mask CV_DEFAULT(NULL));

/****************************************************************************************\
*                                  Feature detection                                     *
\****************************************************************************************/

/* Runs canny edge detector */
CVAPI(void)  cvCanny( const CvArr* image, CvArr* edges, double threshold1,
                      double threshold2, int  aperture_size CV_DEFAULT(3) );

/* Calculates constraint image for corner detection
   Dx^2 * Dyy + Dxx * Dy^2 - 2 * Dx * Dy * Dxy.
   Applying threshold to the result gives coordinates of corners */
CVAPI(void) cvPreCornerDetect( const CvArr* image, CvArr* corners,
                               int aperture_size CV_DEFAULT(3) );

/* Calculates eigen values and vectors of 2x2
   gradient covariation matrix at every image pixel */
CVAPI(void)  cvCornerEigenValsAndVecs( const CvArr* image, CvArr* eigenvv,
                                       int block_size, int aperture_size CV_DEFAULT(3) );

/* Calculates minimal eigenvalue for 2x2 gradient covariation matrix at
   every image pixel */
CVAPI(void)  cvCornerMinEigenVal( const CvArr* image, CvArr* eigenval,
                                  int block_size, int aperture_size CV_DEFAULT(3) );

/* Harris corner detector:
   Calculates det(M) - k*(trace(M)^2), where M is 2x2 gradient covariation matrix for each pixel */
CVAPI(void)  cvCornerHarris( const CvArr* image, CvArr* harris_responce,
                             int block_size, int aperture_size CV_DEFAULT(3),
                             double k CV_DEFAULT(0.04) );

/* Adjust corner position using some sort of gradient search */
CVAPI(void)  cvFindCornerSubPix( const CvArr* image, CvPoint2D32f* corners,
                                 int count, CvSize win, CvSize zero_zone,
                                 CvTermCriteria  criteria );

/* Finds a sparse set of points within the selected region
   that seem to be easy to track */
CVAPI(void)  cvGoodFeaturesToTrack( const CvArr* image, CvArr* eig_image,
                                    CvArr* temp_image, CvPoint2D32f* corners,
                                    int* corner_count, double  quality_level,
                                    double  min_distance,
                                    const CvArr* mask CV_DEFAULT(NULL),
                                    int block_size CV_DEFAULT(3),
                                    int use_harris CV_DEFAULT(0),
                                    double k CV_DEFAULT(0.04) );

/* Finds lines on binary image using one of several methods.
   line_storage is either memory storage or 1 x <max number of lines> CvMat, its
   number of columns is changed by the function.
   method is one of CV_HOUGH_*;
   rho, theta and threshold are used for each of those methods;
   param1 ~ line length, param2 ~ line gap - for probabilistic,
   param1 ~ srn, param2 ~ stn - for multi-scale */
CVAPI(CvSeq*)  cvHoughLines2( CvArr* image, void* line_storage, int method,
                              double rho, double theta, int threshold,
                              double param1 CV_DEFAULT(0), double param2 CV_DEFAULT(0));

/* Finds circles in the image */
CVAPI(CvSeq*) cvHoughCircles( CvArr* image, void* circle_storage,
                              int method, double dp, double min_dist,
                              double param1 CV_DEFAULT(100),
                              double param2 CV_DEFAULT(100),
                              int min_radius CV_DEFAULT(0),
                              int max_radius CV_DEFAULT(0));

/* Fits a line into set of 2d or 3d points in a robust way (M-estimator technique) */
CVAPI(void)  cvFitLine( const CvArr* points, int dist_type, double param,
                        double reps, double aeps, float* line );


/* Constructs kd-tree from set of feature descriptors */
CVAPI(struct CvFeatureTree*) cvCreateKDTree(CvMat* desc);

/* Constructs spill-tree from set of feature descriptors */
CVAPI(struct CvFeatureTree*) cvCreateSpillTree( const CvMat* raw_data,
                                    const int naive CV_DEFAULT(50),
                                    const double rho CV_DEFAULT(.7),
                                    const double tau CV_DEFAULT(.1) );

/* Release feature tree */
CVAPI(void) cvReleaseFeatureTree(struct CvFeatureTree* tr);

/* Searches feature tree for k nearest neighbors of given reference points,
   searching (in case of kd-tree/bbf) at most emax leaves. */
CVAPI(void) cvFindFeatures(struct CvFeatureTree* tr, const CvMat* query_points,
                           CvMat* indices, CvMat* dist, int k, int emax CV_DEFAULT(20));

/* Search feature tree for all points that are inlier to given rect region.
   Only implemented for kd trees */
CVAPI(int) cvFindFeaturesBoxed(struct CvFeatureTree* tr,
                               CvMat* bounds_min, CvMat* bounds_max,
                               CvMat* out_indices);


/* Construct a Locality Sensitive Hash (LSH) table, for indexing d-dimensional vectors of
   given type. Vectors will be hashed L times with k-dimensional p-stable (p=2) functions. */
CVAPI(struct CvLSH*) cvCreateLSH(struct CvLSHOperations* ops, int d,
                                 int L CV_DEFAULT(10), int k CV_DEFAULT(10),
                                 int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
                                 int64 seed CV_DEFAULT(-1));

/* Construct in-memory LSH table, with n bins. */
CVAPI(struct CvLSH*) cvCreateMemoryLSH(int d, int n, int L CV_DEFAULT(10), int k CV_DEFAULT(10),
                                       int type CV_DEFAULT(CV_64FC1), double r CV_DEFAULT(4),
                                       int64 seed CV_DEFAULT(-1));

/* Free the given LSH structure. */
CVAPI(void) cvReleaseLSH(struct CvLSH** lsh);

/* Return the number of vectors in the LSH. */
CVAPI(unsigned int) LSHSize(struct CvLSH* lsh);

/* Add vectors to the LSH structure, optionally returning indices. */
CVAPI(void) cvLSHAdd(struct CvLSH* lsh, const CvMat* data, CvMat* indices CV_DEFAULT(0));

/* Remove vectors from LSH, as addressed by given indices. */
CVAPI(void) cvLSHRemove(struct CvLSH* lsh, const CvMat* indices);

/* Query the LSH n times for at most k nearest points; data is n x d,
   indices and dist are n x k. At most emax stored points will be accessed. */
CVAPI(void) cvLSHQuery(struct CvLSH* lsh, const CvMat* query_points,
                       CvMat* indices, CvMat* dist, int k, int emax);


#ifdef __cplusplus
}
#endif

#endif
