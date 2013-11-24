function [] = videoplayer(inputFile, frameFreq)
if ~exist('frameFreq', 'var')
    frameFreq = 1;
end

videoFReader = vision.VideoFileReader(inputFile)
EOF=0;
framecounter=0
[initialframe, EOF] = step(videoFReader);

figure;
imshow(initialframe);
[x,y]=ginput(4);
close;
border_mask=poly2mask(x,y,size(initialframe,1),size(initialframe,2));

background=ones(size(rgb2gray(initialframe)));

mu=0.05
mu2=0.5

videoFWriter = vision.VideoFileWriter('pi.avi','FrameRate',videoFReader.info.VideoFrameRate);
figure;
while EOF==0
    for i=1:frameFreq
        [frame, EOF] = step(videoFReader);
        if EOF == 1
            break
        end
    end
    try
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
        background = mat2gray(retinexfunc(255.0*background));
    %     
    %     rgb_temp(:,:,1)=(output+(1.-border_mask));
    %     rgb_temp(:,:,2)=rgb_temp(:,:,1);
    %     rgb_temp(:,:,3)=rgb_temp(:,:,1);
    %     reconstruction=initialframe.*rgb_temp;
         imshow(background);
    %     pause(0.01);
        %imshow(mask.*grayframe);


        pause(0.01);
        step(videoFWriter,background);
    catch
    end
    
end

release(videoFReader);
release(videoFWriter);