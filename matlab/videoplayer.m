videoFReader = vision.VideoFileReader('boxtest.mp4')
EOF=0;
framecounter=0
[initialframe, EOF] = step(videoFReader);
background=ones(size(rgb2gray(initialframe)));
output=ones(size(rgb2gray(initialframe)));
mu=0.05
mu2=0.5

videoFWriter = vision.VideoFileWriter('skinmap.avi','FrameRate',videoFReader.info.VideoFrameRate);
figure;
while EOF==0 
    [frame, EOF] = step(videoFReader);
    size(frame)
    framecounter=framecounter+1
%     grayframe=rgb2gray(frame);
%     %grayframe=mat2gray(retinexfunc(255.0*grayframe));
%     background = (1-mu) * background + mu * grayframe;
%     background=mat2gray(retinexfunc(255.0*background));
%     
%     temp=background;
%     temp(temp>.35)=1;
%     temp(temp<=.35)=0;
%     output = (1-mu2) * output + mu2 * temp;
%     %output(output>.5)=1;
%     %output(output<=.5)=0;
%     %imshow(output);
%     pause(0.01);
    [out bin] = generate_skinmap(255.*frame);
    imshow(bin);
    pause(0.01);
    step(videoFWriter, out);
    
end

release(videoFReader);
release(videoFWriter);