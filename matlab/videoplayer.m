videoFReader = vision.VideoFileReader('4lettertest.mp4')
EOF=0;
framecounter=0
[initialframe, EOF] = step(videoFReader);

figure;
imshow(initialframe);
[x,y]=ginput(4)
border_mask=poly2mask(x,y,size(initialframe,1),size(initialframe,2));

background=ones(size(rgb2gray(initialframe)));
output=ones(size(rgb2gray(initialframe)));
mu=0.05
mu2=0.5

videoFWriter = vision.VideoFileWriter('reconstruction.avi','FrameRate',videoFReader.info.VideoFrameRate);
figure;
while EOF==0 
    [frame, EOF] = step(videoFReader);

    %compute convex hull of hand
    [out bin] = generate_skinmap(255.*frame);
    [Xout,rp]=getLargestCc(logical(bin.*border_mask));
    CH=bwconvhull(Xout,'objects').*border_mask;
    mask=1.-CH;
    
    %accumulate
    framecounter=framecounter+1
    grayframe=rgb2gray(frame);
    grayframe=mat2gray(retinexfunc(255.0*grayframe));
    background = (1-mu) * mask.*background + mu * mask.*grayframe+CH.*background;
    background=mat2gray(retinexfunc(255.0*background));
    
     temp=background;
     temp(temp>.35)=1;
     temp(temp<=.35)=0;
     temp=temp.*border_mask;
%     output = (1-mu2) * output + mu2 * temp;
%     output(output>.5)=1;
%     output(output<=.5)=0;
    rgb_temp(:,:,1)=(temp+(1.-border_mask));
    rgb_temp(:,:,2)=rgb_temp(:,:,1);
    rgb_temp(:,:,3)=rgb_temp(:,:,1);
    reconstruction=initialframe.*rgb_temp;
     imshow(reconstruction);
%     pause(0.01);
    %imshow(mask.*grayframe);
    

    pause(0.01);
    step(videoFWriter,reconstruction);
    
end

release(videoFReader);
release(videoFWriter);