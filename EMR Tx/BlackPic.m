function BlackPic(ConfigFile)
% Generate a black image,
% place it in the first and last frame of the attack video.
image = zeros(ConfigFile.Height, ConfigFile.Width);

if ~isfolder('pics')
    mkdir('pics');
end

str = fullfile('pics','0.png');
imwrite(image,str);
img = imread(str);
img1 = imcrop(img,[0,0,ConfigFile.Width,ConfigFile.Height]);
imwrite(img1,str);
