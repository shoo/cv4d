module cv4d.opencv.highgui;

//##############################################################################
//##### opencv2/highgui/highgui_c.h
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
//                        Intel License Agreement
//                For Open Source Computer Vision Library
//
// Copyright (C) 2000, Intel Corporation, all rights reserved.
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
//   * The name of Intel Corporation may not be used to endorse or promote products
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

/****************************************************************************************\
*                                  Basic GUI functions                                   *
\****************************************************************************************/
//YV
//-----------New for Qt
/* For font */
enum {	CV_FONT_LIGHT 			= 25,//QFont::Light,
		CV_FONT_NORMAL 			= 50,//QFont::Normal,
		CV_FONT_DEMIBOLD 		= 63,//QFont::DemiBold,
		CV_FONT_BOLD 			= 75,//QFont::Bold,
		CV_FONT_BLACK 			= 87 //QFont::Black
};

enum {	CV_STYLE_NORMAL			= 0,//QFont::StyleNormal,
		CV_STYLE_ITALIC 		= 1,//QFont::StyleItalic,
		CV_STYLE_OBLIQUE 		= 2 //QFont::StyleOblique
};
/* ---------*/

//for color cvScalar(blue_component, green_component, red\_component[, alpha_component])
//and alpha= 0 <-> 0xFF (not transparent <-> transparent)
CvFont cvFontQt(const char* nameFont, int pointSize = -1, CvScalar color = cvScalarAll(0), int weight = CV_FONT_NORMAL ,  int style = CV_STYLE_NORMAL , int spacing = 0);

void cvAddText(const CvArr* img, const char* text, CvPoint org, CvFont *arg2);

void cvDisplayOverlay(const char* name, const char* text, int delayms = 0);
void cvDisplayStatusBar(const char* name, const char* text, int delayms = 0);

void cvSaveWindowParameters(const char* name);
void cvLoadWindowParameters(const char* name);
int cvStartLoop(int function(int argc, const char*[] argv) pt2Func, int argc, const char*[] argv);
void cvStopLoop();

alias void function(int state, void* userdata) CvButtonCallback;
enum {CV_PUSH_BUTTON = 0, CV_CHECKBOX = 1, CV_RADIOBOX = 2};
int cvCreateButton( const char* button_name = null,CvButtonCallback on_change = null, void* userdata = null , int button_type = CV_PUSH_BUTTON, int initial_button_state = 0);
//----------------------


/* this function is used to set some external parameters in case of X Window */
int cvInitSystem( int argc, char** argv );

int cvStartWindowThread();

// ---------  YV ---------
enum
{
	//These 3 flags are used by cvSet/GetWindowProperty
	CV_WND_PROP_FULLSCREEN = 0,//to change/get window's fullscreen property
	CV_WND_PROP_AUTOSIZE   = 1,//to change/get window's autosize property
	CV_WND_PROP_ASPECTRATIO= 2,//to change/get window's aspectratio property
    CV_WND_PROP_OPENGL     = 3, //to change/get window's opengl support
    
	//These 2 flags are used by cvNamedWindow and cvSet/GetWindowProperty
	CV_WINDOW_NORMAL       = 0x00000000,//the user can resize the window (no constraint)  / also use to switch a fullscreen window to a normal size
	CV_WINDOW_AUTOSIZE 	   = 0x00000001,//the user cannot resize the window, the size is constrainted by the image displayed
    CV_WINDOW_OPENGL       = 0x00001000, //window with opengl support
    
	//Those flags are only for Qt
	CV_GUI_EXPANDED 		= 0x00000000,//status bar and tool bar
	CV_GUI_NORMAL 			= 0x00000010,//old fashious way
    
	//These 3 flags are used by cvNamedWindow and cvSet/GetWindowProperty
	CV_WINDOW_FULLSCREEN   = 1,//change the window to fullscreen
	CV_WINDOW_FREERATIO	   = 0x00000100,//the image expends as much as it can (no ratio constraint)
	CV_WINDOW_KEEPRATIO    = 0x00000000//the ration image is respected.
};

/* create window */
int cvNamedWindow( const char* name, int flags = CV_WINDOW_AUTOSIZE );

/* Set and Get Property of the window */
void cvSetWindowProperty(const char* name, int prop_id, double prop_value);
double cvGetWindowProperty(const char* name, int prop_id);

/* display image within window (highgui windows remember their content) */
void cvShowImage( const char* name, const CvArr* image );

/* resize/move window */
void cvResizeWindow( const char* name, int width, int height );
void cvMoveWindow( const char* name, int x, int y );


/* destroy window and all the trackers associated with it */
void cvDestroyWindow( const char* name );

void cvDestroyAllWindows();

/* get native window handle (HWND in case of Win32 and Widget in case of X Window) */
void* cvGetWindowHandle( const char* name );

/* get name of highgui window given its native handle */
const(char)* cvGetWindowName( void* window_handle );


alias void function(int pos) CvTrackbarCallback;

/* create trackbar and display it on top of given window, set callback */
int cvCreateTrackbar( const char* trackbar_name, const char* window_name,
                      int* value, int count, CvTrackbarCallback on_change = null);

alias void function(int pos, void* userdata) CvTrackbarCallback2;

int cvCreateTrackbar2( const char* trackbar_name, const char* window_name,
                       int* value, int count, CvTrackbarCallback2 on_change,
                       void* userdata = null);

/* retrieve or set trackbar position */
int cvGetTrackbarPos( const char* trackbar_name, const char* window_name );
void cvSetTrackbarPos( const char* trackbar_name, const char* window_name, int pos );

enum
{
	CV_EVENT_MOUSEMOVE      =0,
	CV_EVENT_LBUTTONDOWN    =1,
	CV_EVENT_RBUTTONDOWN    =2,
	CV_EVENT_MBUTTONDOWN    =3,
	CV_EVENT_LBUTTONUP      =4,
	CV_EVENT_RBUTTONUP      =5,
	CV_EVENT_MBUTTONUP      =6,
	CV_EVENT_LBUTTONDBLCLK  =7,
	CV_EVENT_RBUTTONDBLCLK  =8,
	CV_EVENT_MBUTTONDBLCLK  =9
};

enum
{
	CV_EVENT_FLAG_LBUTTON   =1,
	CV_EVENT_FLAG_RBUTTON   =2,
	CV_EVENT_FLAG_MBUTTON   =4,
	CV_EVENT_FLAG_CTRLKEY   =8,
	CV_EVENT_FLAG_SHIFTKEY  =16,
	CV_EVENT_FLAG_ALTKEY    =32
};

alias void function(int event, int x, int y, int flags, void* param) CvMouseCallback;

/* assign callback for mouse events */
void cvSetMouseCallback( const char* window_name, CvMouseCallback on_mouse,
                         void* param = null);

enum
{
	/* 8bit, color or not */
	CV_LOAD_IMAGE_UNCHANGED  =-1,
	/* 8bit, gray */
	CV_LOAD_IMAGE_GRAYSCALE  =0,
	/* ?, color */
	CV_LOAD_IMAGE_COLOR      =1,
	/* any depth, ? */
	CV_LOAD_IMAGE_ANYDEPTH   =2,
	/* ?, any color */
	CV_LOAD_IMAGE_ANYCOLOR   =4
};

/* load image from file
  iscolor can be a combination of above flags where CV_LOAD_IMAGE_UNCHANGED
  overrides the other flags
  using CV_LOAD_IMAGE_ANYCOLOR alone is equivalent to CV_LOAD_IMAGE_UNCHANGED
  unless CV_LOAD_IMAGE_ANYDEPTH is specified images are converted to 8bit
*/
IplImage* cvLoadImage( const char* filename, int iscolor = CV_LOAD_IMAGE_COLOR);
CvMat* cvLoadImageM( const char* filename, int iscolor = CV_LOAD_IMAGE_COLOR);

enum
{
	CV_IMWRITE_JPEG_QUALITY =1,
	CV_IMWRITE_PNG_COMPRESSION =16,
    CV_IMWRITE_PNG_STRATEGY =17,
    CV_IMWRITE_PNG_STRATEGY_DEFAULT =0,
    CV_IMWRITE_PNG_STRATEGY_FILTERED =1,
    CV_IMWRITE_PNG_STRATEGY_HUFFMAN_ONLY =2,
    CV_IMWRITE_PNG_STRATEGY_RLE =3,
    CV_IMWRITE_PNG_STRATEGY_FIXED =4,
	CV_IMWRITE_PXM_BINARY =32
};

/* save image to file */
int cvSaveImage( const char* filename, const CvArr* image,
                 const int* params = null );

/* decode image stored in the buffer */
IplImage* cvDecodeImage( const CvMat* buf, int iscolor = CV_LOAD_IMAGE_COLOR);
CvMat* cvDecodeImageM( const CvMat* buf, int iscolor = CV_LOAD_IMAGE_COLOR);

/* encode image and store the result as a byte vector (single-row 8uC1 matrix) */
CvMat* cvEncodeImage( const char* ext, const CvArr* image,
                      const int* params = null );

enum
{
	CV_CVTIMG_FLIP      =1,
	CV_CVTIMG_SWAP_RB   =2
};

/* utility function: convert one image to another with optional vertical flip */
void cvConvertImage( const CvArr* src, CvArr* dst, int flags = 0);

/* wait for key event infinitely (delay<=0) or for "delay" milliseconds */
int cvWaitKey(int delay = 0);

// OpenGL support

alias void function(void* userdata) CvOpenGlDrawCallback;
void cvSetOpenGlDrawCallback(const char* window_name, CvOpenGlDrawCallback callback, void* userdata = null);

void cvSetOpenGlContext(const char* window_name);
void cvUpdateWindow(const char* window_name);


/****************************************************************************************\
*                         Working with Video Files and Cameras                           *
\****************************************************************************************/

/* "black box" capture structure */
alias void* CvCapture;

/* start capturing frames from video file */
CvCapture* cvCreateFileCapture( const char* filename );

enum
{
	CV_CAP_ANY      =0,     // autodetect
	
	CV_CAP_MIL      =100,   // MIL proprietary drivers
	
	CV_CAP_VFW      =200,   // platform native
	CV_CAP_V4L      =200,
	CV_CAP_V4L2     =200,
	
	CV_CAP_FIREWARE =300,   // IEEE 1394 drivers
	CV_CAP_FIREWIRE =300,
	CV_CAP_IEEE1394 =300,
	CV_CAP_DC1394   =300,
	CV_CAP_CMU1394  =300,
	
	CV_CAP_STEREO   =400,   // TYZX proprietary drivers
	CV_CAP_TYZX     =400,
	CV_TYZX_LEFT    =400,
	CV_TYZX_RIGHT   =401,
	CV_TYZX_COLOR   =402,
	CV_TYZX_Z       =403,
	
	CV_CAP_QT       =500,   // QuickTime
	
	CV_CAP_UNICAP   =600,   // Unicap drivers
	
	CV_CAP_DSHOW    =700,   // DirectShow (via videoInput)
	
	CV_CAP_PVAPI    =800,   // PvAPI, Prosilica GigE SDK
	
	CV_CAP_OPENNI   =900,   // OpenNI (for Kinect)
	CV_CAP_OPENNI_ASUS =910,   // OpenNI (for Asus Xtion)
	
	CV_CAP_ANDROID  =1000,  // Android
	
	CV_CAP_XIAPI    =1100,   // XIMEA Camera API
	
	CV_CAP_AVFOUNDATION = 1200	// AVFoundation framework for iOS (OS X Lion will have the same API)
};

/* start capturing frames from camera: index = camera_index + domain_offset (CV_CAP_*) */
CvCapture* cvCreateCameraCapture( int index );

/* grab a frame, return 1 on success, 0 on fail.
  this function is thought to be fast               */
int cvGrabFrame( CvCapture* capture );

/* get the frame grabbed with cvGrabFrame(..)
  This function may apply some frame processing like
  frame decompression, flipping etc.
  !!!DO NOT RELEASE or MODIFY the retrieved frame!!! */
IplImage* cvRetrieveFrame( CvCapture* capture, int streamIdx = 0 );

/* Just a combination of cvGrabFrame and cvRetrieveFrame
   !!!DO NOT RELEASE or MODIFY the retrieved frame!!!      */
IplImage* cvQueryFrame( CvCapture* capture );

/* stop capturing/reading and free resources */
void cvReleaseCapture( CvCapture** capture );

enum
{
    // modes of the controlling registers (can be: auto, manual, auto single push, absolute Latter allowed with any other mode)
    // every feature can have only one mode turned on at a time
    CV_CAP_PROP_DC1394_OFF         = -4,  //turn the feature off (not controlled manually nor automatically)
    CV_CAP_PROP_DC1394_MODE_MANUAL = -3, //set automatically when a value of the feature is set by the user
    CV_CAP_PROP_DC1394_MODE_AUTO = -2,
    CV_CAP_PROP_DC1394_MODE_ONE_PUSH_AUTO = -1,
	CV_CAP_PROP_POS_MSEC       =0,
	CV_CAP_PROP_POS_FRAMES     =1,
	CV_CAP_PROP_POS_AVI_RATIO  =2,
	CV_CAP_PROP_FRAME_WIDTH    =3,
	CV_CAP_PROP_FRAME_HEIGHT   =4,
	CV_CAP_PROP_FPS            =5,
	CV_CAP_PROP_FOURCC         =6,
	CV_CAP_PROP_FRAME_COUNT    =7,
	CV_CAP_PROP_FORMAT         =8,
	CV_CAP_PROP_MODE           =9,
	CV_CAP_PROP_BRIGHTNESS    =10,
	CV_CAP_PROP_CONTRAST      =11,
	CV_CAP_PROP_SATURATION    =12,
	CV_CAP_PROP_HUE           =13,
	CV_CAP_PROP_GAIN          =14,
	CV_CAP_PROP_EXPOSURE      =15,
	CV_CAP_PROP_CONVERT_RGB   =16,
	CV_CAP_PROP_WHITE_BALANCE_BLUE_U =17,
	CV_CAP_PROP_RECTIFICATION =18,
	CV_CAP_PROP_MONOCROME     =19,
	CV_CAP_PROP_SHARPNESS     =20,
	CV_CAP_PROP_AUTO_EXPOSURE =21, // exposure control done by camera,
	                               // user can adjust refernce level
	                               // using this feature
	CV_CAP_PROP_GAMMA         =22,
	CV_CAP_PROP_TEMPERATURE   =23,
	CV_CAP_PROP_TRIGGER       =24,
	CV_CAP_PROP_TRIGGER_DELAY =25,
	CV_CAP_PROP_WHITE_BALANCE_RED_V =26,
	CV_CAP_PROP_ZOOM          =27,
	CV_CAP_PROP_FOCUS         =28,	
	CV_CAP_PROP_GUID          =29,	
	CV_CAP_PROP_ISO_SPEED     =30,	
	CV_CAP_PROP_MAX_DC1394    =31,
	CV_CAP_PROP_BACKLIGHT     =32,
	CV_CAP_PROP_PAN           =33,
	CV_CAP_PROP_TILT          =34,
	CV_CAP_PROP_ROLL          =35,
	CV_CAP_PROP_IRIS          =36,
	CV_CAP_PROP_SETTINGS      =37,
	
	CV_CAP_PROP_AUTOGRAB      =1024, // property for highgui class CvCapture_Android only
	CV_CAP_PROP_SUPPORTED_PREVIEW_SIZES_STRING=1025, // readonly, tricky property, returns cpnst char* indeed
	CV_CAP_PROP_PREVIEW_FORMAT=1026, // readonly, tricky property, returns cpnst char* indeed
	
	// OpenNI map generators
	CV_CAP_OPENNI_DEPTH_GENERATOR = 1 << 31,
	CV_CAP_OPENNI_IMAGE_GENERATOR = 1 << 30,
	CV_CAP_OPENNI_GENERATORS_MASK = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_OPENNI_IMAGE_GENERATOR,
	
	// Properties of cameras available through OpenNI interfaces
	CV_CAP_PROP_OPENNI_OUTPUT_MODE     = 100,
	CV_CAP_PROP_OPENNI_FRAME_MAX_DEPTH = 101, // in mm
	CV_CAP_PROP_OPENNI_BASELINE        = 102, // in mm
	CV_CAP_PROP_OPENNI_FOCAL_LENGTH    = 103, // in pixels
	CV_CAP_PROP_OPENNI_REGISTRATION    = 104, // flag
	CV_CAP_PROP_OPENNI_REGISTRATION_ON = CV_CAP_PROP_OPENNI_REGISTRATION, // flag that synchronizes the remapping depth map to image map
	                                                                      // by changing depth generator's view point (if the flag is "on") or
	                                                                      // sets this view point to its normal one (if the flag is "off").
	CV_CAP_PROP_OPENNI_APPROX_FRAME_SYNC = 105,
	CV_CAP_PROP_OPENNI_MAX_BUFFER_SIZE   = 106,
	CV_CAP_PROP_OPENNI_CIRCLE_BUFFER     = 107,
	CV_CAP_PROP_OPENNI_MAX_TIME_DURATION = 108,

	CV_CAP_PROP_OPENNI_GENERATOR_PRESENT = 109,

	CV_CAP_OPENNI_IMAGE_GENERATOR_PRESENT         = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_GENERATOR_PRESENT,
	CV_CAP_OPENNI_IMAGE_GENERATOR_OUTPUT_MODE     = CV_CAP_OPENNI_IMAGE_GENERATOR + CV_CAP_PROP_OPENNI_OUTPUT_MODE,
	CV_CAP_OPENNI_DEPTH_GENERATOR_BASELINE        = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_BASELINE,
	CV_CAP_OPENNI_DEPTH_GENERATOR_FOCAL_LENGTH    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_FOCAL_LENGTH,
	CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION    = CV_CAP_OPENNI_DEPTH_GENERATOR + CV_CAP_PROP_OPENNI_REGISTRATION,
	CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION_ON = CV_CAP_OPENNI_DEPTH_GENERATOR_REGISTRATION,
	
	// Properties of cameras available through GStreamer interface
	CV_CAP_GSTREAMER_QUEUE_LENGTH   = 200, // default is 1
	CV_CAP_PROP_PVAPI_MULTICASTIP   = 300, // ip for anable multicast master mode. 0 for disable multicast
	
	// Properties of cameras available through XIMEA SDK interface
	CV_CAP_PROP_XI_DOWNSAMPLING  = 400,      // Change image resolution by binning or skipping.  
	CV_CAP_PROP_XI_DATA_FORMAT   = 401,       // Output data format.
	CV_CAP_PROP_XI_OFFSET_X      = 402,      // Horizontal offset from the origin to the area of interest (in pixels).
	CV_CAP_PROP_XI_OFFSET_Y      = 403,      // Vertical offset from the origin to the area of interest (in pixels).
	CV_CAP_PROP_XI_TRG_SOURCE    = 404,      // Defines source of trigger.
	CV_CAP_PROP_XI_TRG_SOFTWARE  = 405,      // Generates an internal trigger. PRM_TRG_SOURCE must be set to TRG_SOFTWARE.
	CV_CAP_PROP_XI_GPI_SELECTOR  = 406,      // Selects general purpose input 
	CV_CAP_PROP_XI_GPI_MODE      = 407,      // Set general purpose input mode
	CV_CAP_PROP_XI_GPI_LEVEL     = 408,      // Get general purpose level
	CV_CAP_PROP_XI_GPO_SELECTOR  = 409,      // Selects general purpose output 
	CV_CAP_PROP_XI_GPO_MODE      = 410,      // Set general purpose output mode
	CV_CAP_PROP_XI_LED_SELECTOR  = 411,      // Selects camera signalling LED 
	CV_CAP_PROP_XI_LED_MODE      = 412,      // Define camera signalling LED functionality
	CV_CAP_PROP_XI_MANUAL_WB     = 413,      // Calculates White Balance(must be called during acquisition)
	CV_CAP_PROP_XI_AUTO_WB       = 414,      // Automatic white balance
	CV_CAP_PROP_XI_AEAG          = 415,      // Automatic exposure/gain
	CV_CAP_PROP_XI_EXP_PRIORITY  = 416,      // Exposure priority (0.5 - exposure 50%, gain 50%).
	CV_CAP_PROP_XI_AE_MAX_LIMIT  = 417,      // Maximum limit of exposure in AEAG procedure
	CV_CAP_PROP_XI_AG_MAX_LIMIT  = 418,      // Maximum limit of gain in AEAG procedure
	CV_CAP_PROP_XI_AEAG_LEVEL    = 419,       // Average intensity of output signal AEAG should achieve(in %)
	CV_CAP_PROP_XI_TIMEOUT       = 420,       // Image capture timeout in milliseconds
	
	// Properties for Android cameras
	CV_CAP_PROP_ANDROID_FLASH_MODE = 8001,
	CV_CAP_PROP_ANDROID_FOCUS_MODE = 8002,
	CV_CAP_PROP_ANDROID_WHITE_BALANCE = 8003,
	CV_CAP_PROP_ANDROID_ANTIBANDING = 8004,
	CV_CAP_PROP_ANDROID_FOCAL_LENGTH = 8005,
	CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_NEAR = 8006,
	CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_OPTIMAL = 8007,
	CV_CAP_PROP_ANDROID_FOCUS_DISTANCE_FAR = 8008,

	// Properties of cameras available through AVFOUNDATION interface
	CV_CAP_PROP_IOS_DEVICE_FOCUS = 9001,
	CV_CAP_PROP_IOS_DEVICE_EXPOSURE = 9002,
	CV_CAP_PROP_IOS_DEVICE_FLASH = 9003,
	CV_CAP_PROP_IOS_DEVICE_WHITEBALANCE = 9004,
	CV_CAP_PROP_IOS_DEVICE_TORCH = 9005
}

enum
{
	// Data given from depth generator.
	CV_CAP_OPENNI_DEPTH_MAP                 = 0, // Depth values in mm (CV_16UC1)
	CV_CAP_OPENNI_POINT_CLOUD_MAP           = 1, // XYZ in meters (CV_32FC3)
	CV_CAP_OPENNI_DISPARITY_MAP             = 2, // Disparity in pixels (CV_8UC1)
	CV_CAP_OPENNI_DISPARITY_MAP_32F         = 3, // Disparity in pixels (CV_32FC1)
	CV_CAP_OPENNI_VALID_DEPTH_MASK          = 4, // CV_8UC1

	// Data given from RGB image generator.
	CV_CAP_OPENNI_BGR_IMAGE                 = 5,
	CV_CAP_OPENNI_GRAY_IMAGE                = 6
}

// Supported output modes of OpenNI image generator
enum
{
	CV_CAP_OPENNI_VGA_30HZ     = 0,
	CV_CAP_OPENNI_SXGA_15HZ    = 1,
	CV_CAP_OPENNI_SXGA_30HZ    = 2
}

//supported by Android camera output formats
enum
{
	CV_CAP_ANDROID_COLOR_FRAME_BGR = 0, //BGR
	CV_CAP_ANDROID_COLOR_FRAME = CV_CAP_ANDROID_COLOR_FRAME_BGR,
	CV_CAP_ANDROID_GREY_FRAME  = 1,  //Y
	CV_CAP_ANDROID_COLOR_FRAME_RGB = 2,
	CV_CAP_ANDROID_COLOR_FRAME_BGRA = 3,
	CV_CAP_ANDROID_COLOR_FRAME_RGBA = 4
}

// supported Android camera flash modes
enum
{
	CV_CAP_ANDROID_FLASH_MODE_AUTO = 0,
	CV_CAP_ANDROID_FLASH_MODE_OFF,
	CV_CAP_ANDROID_FLASH_MODE_ON,
	CV_CAP_ANDROID_FLASH_MODE_RED_EYE,
	CV_CAP_ANDROID_FLASH_MODE_TORCH
}

// supported Android camera focus modes
enum
{
	CV_CAP_ANDROID_FOCUS_MODE_AUTO = 0,
	CV_CAP_ANDROID_FOCUS_MODE_CONTINUOUS_VIDEO,
	CV_CAP_ANDROID_FOCUS_MODE_EDOF,
	CV_CAP_ANDROID_FOCUS_MODE_FIXED,
	CV_CAP_ANDROID_FOCUS_MODE_INFINITY,
	CV_CAP_ANDROID_FOCUS_MODE_MACRO
}

// supported Android camera white balance modes
enum
{
	CV_CAP_ANDROID_WHITE_BALANCE_AUTO = 0,
	CV_CAP_ANDROID_WHITE_BALANCE_CLOUDY_DAYLIGHT,
	CV_CAP_ANDROID_WHITE_BALANCE_DAYLIGHT,
	CV_CAP_ANDROID_WHITE_BALANCE_FLUORESCENT,
	CV_CAP_ANDROID_WHITE_BALANCE_INCANDESCENT,
	CV_CAP_ANDROID_WHITE_BALANCE_SHADE,
	CV_CAP_ANDROID_WHITE_BALANCE_TWILIGHT,
	CV_CAP_ANDROID_WHITE_BALANCE_WARM_FLUORESCENT
}

// supported Android camera antibanding modes
enum
{
	CV_CAP_ANDROID_ANTIBANDING_50HZ = 0,
	CV_CAP_ANDROID_ANTIBANDING_60HZ,
	CV_CAP_ANDROID_ANTIBANDING_AUTO,
	CV_CAP_ANDROID_ANTIBANDING_OFF
}

/* retrieve or set capture properties */
double cvGetCaptureProperty( CvCapture* capture, int property_id );
int    cvSetCaptureProperty( CvCapture* capture, int property_id, double value );

// Return the type of the capturer (eg, CV_CAP_V4W, CV_CAP_UNICAP), which is unknown if created with CV_CAP_ANY
int    cvGetCaptureDomain( CvCapture* capture);  

/* "black box" video file writer structure */
alias void* CvVideoWriter;

int CV_FOURCC(char c1, char c2, char c3, char c4)
{
	return (c1 & 255) + ((c2 & 255) << 8) + ((c3 &255) << 16) + ((c4 & 255) << 24);
}

enum CV_FOURCC_PROMPT = -1;  /* Open Codec Selection Dialog (Windows only) */
enum CV_FOURCC_DEFAULT = CV_FOURCC('I', 'Y', 'U', 'V'); /* Use default codec for specified filename (Linux only) */

/* initialize video file writer */
CvVideoWriter* cvCreateVideoWriter( const char* filename, int fourcc,
                                    double fps, CvSize frame_size,
                                    int is_color = 1);

//CVAPI(CvVideoWriter*) cvCreateImageSequenceWriter( const char* filename,
//                                                   int is_color = 1);

/* write frame to video file */
int cvWriteFrame( CvVideoWriter* writer, const IplImage* image );

/* close video file writer */
void cvReleaseVideoWriter( CvVideoWriter** writer );

/****************************************************************************************\
*                              Obsolete functions/synonyms                               *
\****************************************************************************************/

alias cvCreateFileCapture cvCaptureFromFile;
alias cvCreateCameraCapture cvCaptureFromCAM;
alias cvCaptureFromFile cvCaptureFromAVI;
alias cvCreateVideoWriter cvCreateAVIWriter;
alias cvWriteFrame cvWriteToAVI;
void cvAddSearchPath(T)(T path){}
alias cvInitSystem cvvInitSystem;
alias cvNamedWindow cvvNamedWindow;
alias cvShowImage cvvShowImage;
alias cvResizeWindow cvvResizeWindow;
alias cvDestroyWindow cvvDestroyWindow;
alias cvCreateTrackbar cvvCreateTrackbar;
IplImage* cvvLoadImage(const char* name) { return cvLoadImage(name,1); }
alias cvSaveImage cvvSaveImage;
alias cvAddSearchPath cvvAddSearchPath;
int cvvWaitKey(const char* name) { return cvWaitKey(0); }
int cvvWaitKeyEx(const char* name, int delay) { return cvWaitKey(delay); }
alias cvConvertImage cvvConvertImage;
alias CV_WINDOW_AUTOSIZE HG_AUTOSIZE;
version (Windows)
{
	alias cvSetPreprocessFuncWin32 set_preprocess_func;
	alias cvSetPostprocessFuncWin32 set_postprocess_func;

	private import core.sys.windows.windows: HWND, UINT, WPARAM, LPARAM;
	alias int function(HWND, UINT, WPARAM, LPARAM, int*) CvWin32WindowCallback;
	void cvSetPreprocessFuncWin32( CvWin32WindowCallback on_preprocess );
	void cvSetPostprocessFuncWin32( CvWin32WindowCallback on_postprocess );
}
