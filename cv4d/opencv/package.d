/*******************************************************************************
 * 全てのopencvパッケージのモジュールの集約
 * 
 * See_Also:
 * $(UL
 *     $(LI $(LINK2 cv4d.html, cv4d)
 *     $(UL
 *         $(LI $(LINK2 cv4d._opencv.html, opencv))
 *         $(UL
 *             $(LI $(LINK2 cv4d._opencv.core.html, core))
 *             $(LI $(LINK2 cv4d._opencv.imgproc.html, imgproc))
 *             $(LI $(LINK2 cv4d._opencv.highgui.html, highgui))
 *             $(LI $(LINK2 cv4d._opencv.calib3d.html, calib3d))
 *         )
 *     ))
 * )
 */
module cv4d.opencv;

public:
import cv4d.opencv.core;
import cv4d.opencv.imgproc;
import cv4d.opencv.highgui;
import cv4d.opencv.calib3d;

