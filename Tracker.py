import cv

class Tracker:
	def __init__(self):
		self.valid_template='no'
		while self.valid_template !='yes':
			self.template=self.getTemplate(400,400,100,100)
			cv.ShowImage("template",self.template)
			self.valid_template=raw_input("Is the template acceptable?")
			cv.DestroyWindow("template")
			print self.valid_template

		self.matching(self.template,90)

	def getTemplate(self,x,y,w,h):
		capture=cv.CaptureFromCAM(0)
		# writer=cv.CreateVideoWriter("output.avi", 0, 15, (400,600), 1)
		count=0
		while count<50:
			image=cv.QueryFrame(capture)
			cv.Rectangle(image,(int(x),int(y)),(int(x)+w,int(y)+h),(255,255,255),1,0)
			# cv.WriteFrame(writer, image)
			cv.ShowImage('Image_Window',image)
			print count
			count+=1

		image=cv.QueryFrame(capture)

		cv.SetImageROI(image, (x,y,w,h))

		template=cv.CloneImage(image)
		cv.DestroyWindow('Image_Window')
		return template

	def matching(self,template,time):
		capture=cv.CaptureFromCAM(0)
		image=cv.QueryFrame(capture)
		# writer=cv.CreateVideoWriter("output.avi", 0, 15, cv.GetSize(image), 1)
		count=0
		w,h = cv.GetSize(template)
		W,H = cv.GetSize(image)
		width = W-w+1
		height = H-h+1
		while count<time:
			image=cv.QueryFrame(capture)
			result = cv.CreateImage((width, height), 32, cv.CV_TM_SQDIFF)
			cv.MatchTemplate(template, image, result, cv.CV_TM_SQDIFF)
			print result
			(min_x,max_y,minloc,maxloc)=cv.MinMaxLoc(result)
			(x,y)=minloc
			cv.Rectangle(image,(int(x),int(y)),(int(x)+w,int(y)+h),(255,255,255),1,0)
			print minloc
			# cv.WriteFrame(writer, image)
			cv.WaitKey(1)
			cv.ShowImage('Image_Window',image)
			count+=1
		cv.DestroyWindow('Image_Window')





tracker=Tracker()
