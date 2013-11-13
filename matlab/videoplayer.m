videoFReader = vision.VideoFileReader('markertest.mp4')
EOF=0;
framecounter=0
[initialframe, EOF] = step(videoFReader);
background=ones(size(rgb2gray(initialframe)));
mu=0.1

videoFWriter = vision.VideoFileWriter('ouput.mp4','FrameRate',videoFReader.info.VideoFrameRate);

while EOF==0 
    [frame, EOF] = step(videoFReader);
    framecounter=framecounter+1
    grayframe=rgb2gray(frame);
    background = (1-mu) * background + mu * grayframe;
    background=mat2gray(retinexfunc(255.0*background));
    imshow(background);
    pause(0.01);
    step(videoFWriter, background);

    
end

release(videoFReader);
release(videoFWriter);