import numpy as np
import cv2
import cv2.cv as cv
import utils

vidFile = cv2.VideoCapture( './testvid.mp4' )

nFrames = int(vidFile.get(cv.CV_CAP_PROP_FRAME_COUNT) )
fps = vidFile.get(cv.CV_CAP_PROP_FPS )
waitPerFrameInMillisec = int( 1/fps * 1000/1 )

print 'Num. Frames = ', nFrames
print 'Frame Rate = ', fps, ' frames per sec'
s,background=vidFile.read()
# background = utils.rotateImg(background)
# background *= 1./255 
print background.shape
background=cv2.cvtColor(background,cv2.COLOR_RGB2GRAY)
background = background/255.0
print background.shape
print np.amax(background)

mu = 0.01

for f in xrange( nFrames ):
  s,frameImg = vidFile.read()
  gray = cv2.cvtColor(frameImg,cv2.COLOR_RGB2GRAY)
  gray = gray / 255.0
  background = (1-mu) * background + mu * gray
  # print background
  # background=cv2.cvtColor(background,cv2.CV_8U)
  cv2.imshow( "Original Frame",  utils.rotateImg(frameImg))	
  cv2.imshow( "My Video Window",  utils.rotateImg(background))
  cv2.waitKey( waitPerFrameInMillisec  )


# # When playing is done, delete the window
# #  NOTE: this step is not strictly necessary, 
# #         when the script terminates it will close all windows it owns anyways
# cv2.DestroyWindow( "My Video Window" )