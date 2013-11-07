import cv2
import numpy as np
def rotateImg(img):
	if len(img.shape) == 2:
		trans = img.transpose()
		return cv2.flip(trans,1)
	elif len(img.shape) == 3:
		trans = img.transpose(1,0,2)
		return cv2.flip(trans,1)
	else:
		print 'sorry bro'
		return None
