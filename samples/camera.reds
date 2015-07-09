Red/System [
	Title:		"OpenCV Camera Test"
	Author:		"Franois Jouen"
	Rights:		"Copyright (c) 2012-2013 Franois Jouen. All rights reserved."
	License:     "BSD-3 - https://github.com/dockimbel/Red/blob/master/BSD-3-License.txt"
]

#include %../opencv.reds
; use  default camera 
cvStartWindowThread ; separate window thread

capture: cvCreateFileCapture "http://192.168.2.1/?action=stream.mjpeg" ; create a cature using default webcam (iSight) ; change to n for other cam
print [capture lf]
if capture = null [print "error!" lf]

;cvSetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH 1280.0
;cvSetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT 720.0

width: cvGetCaptureProperty capture CV_CAP_PROP_FRAME_WIDTH
height: cvGetCaptureProperty capture CV_CAP_PROP_FRAME_HEIGHT
;probe CV_FOURCC(#"B" #"G" #"R" #"3")
;cvSetCaptureProperty capture CV_CAP_PROP_FOURCC 861030210.0
?? width
?? height 
fourcc: cvGetCaptureProperty capture CV_CAP_PROP_FOURCC
fps: cvGetCaptureProperty capture CV_CAP_PROP_FPS
vformat: cvGetCaptureProperty capture CV_CAP_PROP_FORMAT
mode: cvGetCaptureProperty capture CV_CAP_PROP_MODE

;set our movie properties
?? fourcc
?? fps
?? vformat
?? mode
camW: 1280
camH: 720
rec: true ; no automatic movie recording 

;; creates a writer to record video
;movie: "camera.mov"
;writer: cvCreateVideoWriter movie 844715353 fps 640 480 1 ; 1: CV_DEFAULT (1)
;&writer: as byte-ptr! writer ; get the pointer address
;if &writer = null [print "error"]
;&&writer: declare double-byte-ptr!
;&&writer/ptr: &writer


cvNamedWindow "Test Window" CV_WINDOW_AUTOSIZE ; create window to show movie
handle: cvGetWindowHandle "Test Window" ; not used  when using mac OSX without X 
image: cvRetrieveFrame capture ; get the first image 
&image: as byte-ptr! image ; pointer address
&&image: declare double-byte-ptr!
&&image/ptr: &image; double pointeur 

assert &image <> null ; test image status

key:  27
foo: 0

; repeat until q keypress
while [foo <> key] [
        image: cvRetrieveFrame capture      ; get the frame
       	cvShowImage "Test Window" &image    ; show frame
        ;if rec [cvWriteFrame writer image]  ; write frame on disk if we want to record movie (set rec to true for testing)
        foo: cvWaitKey 1
]


print ["Done. Any key to quit" lf]
cvWaitKey 0

; releases structures and windows
cvDestroyAllWindows
cvReleaseImage &&image 
caphandle: as-integer capture
cvReleaseCapture as double-byte-ptr! :caphandle ; a pb with MacOSX due to the 32 bit framework
;cvReleaseVideoWriter &&writer


