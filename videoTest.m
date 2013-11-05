if ~exist('vidmat','var')
    vObj = VideoReader('testvid.mp4');
    vidmat = read(vObj);
end
alpha=0.1
vidmatsize = size(vidmat)
mu = zeros(vidmatsize(1), vidmatsize(2), vidmatsize(4));
for k=1:size(vidmat,4)
    k
    temp = rgb2gray(vidmat(:,:,:,k));
    temp
    if k == 1
        mu(:,:,k) = temp;
    else
        mu(:,:,k+1) = (1-alpha)*mu(:,:,k-1) + alpha* temp;
    end
end

figure
implay(mu);
