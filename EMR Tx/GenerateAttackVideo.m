function GenerateAttackVideo(PacketInfo, ConfigFile)
PixelStream = [];
%% Generating the attack pixel stream
% 1. Preamble part
PreamblePart = [];
for i = 1 : ConfigFile.Preamble
    temp = CalculateChirpPoints(ConfigFile, 1);
    PreamblePart = [PreamblePart temp];
end
PixelStream = [PixelStream PreamblePart];

% 2. SyncWord part
SyncWordPart = [];
for i = 1 : 2
    temp = CalculateChirpPoints(ConfigFile, PacketInfo.SyncWord(i));
    SyncWordPart = [SyncWordPart temp];
end
PixelStream = [PixelStream SyncWordPart];

% 3. SFD part
SFDPart = CalculateSFD(ConfigFile);
PixelStream = [PixelStream SFDPart];

% 4. Payload (and possible CRC) part
PayloadPart = [];
for i = 1 : length(PacketInfo.Payload)
    temp = CalculateChirpPoints(ConfigFile, PacketInfo.Payload(i));
    PayloadPart = [PayloadPart temp];
end
PixelStream = [PixelStream PayloadPart];

%% Add padding at the beginning of the pixel stream. 
% This release version is only available for 1080*1920 resolution.
% Add H Front Porch + H Sync (132 pixels), and V Front Porch + V Sync (9 line pixels).
PixelStream = [zeros(1, 132 + 9 * 2200) PixelStream]; 

%% Convert to a 2-D pixel stream matrix by the resolution
% Note that end of the PixelStream need to be completed into a complete frame.
EndPixelNum = mod(length(PixelStream), 2200);
FillRowNum = floor(length(PixelStream) / 2200);
image = zeros(FillRowNum + 1200, 2200);

for i = 1 : FillRowNum
    image(i, :) = PixelStream((i - 1) * 2200 + 1 : i * 2200);
end
% Complete the last line.
image(i + 1, 1 : EndPixelNum) = PixelStream(end - EndPixelNum + 1 :end);
image(i + 1, EndPixelNum + 1 : 2200) = 0;
% Complete the last frame.
image(i + 2 : i + 1125 + 2, 1 : 2200) = 0;

%% Take out the display area, frame by frame.
OneImagePixelNum = ConfigFile.HeightTotal * ConfigFile.WidthTotal;
ImageNum = ceil(length(PixelStream) / OneImagePixelNum);
SaveNum = 1;
for i = 1 : ImageNum
    TempImage = image(10 + (i - 1) * 1125 : 10 + (i - 1) * 1125 + 1080 - 1, 133 : 133 + 1920 - 1);
    PicIndex = [num2str(SaveNum), '.png'];

    str = fullfile('pics', PicIndex);
    imwrite(TempImage,str);
    img = imread(str);
    img1 = imcrop(img,[0, 0, 1920, 1080]);
    imwrite(img1,str);
    SaveNum = SaveNum + 1;
end

%% Generate attack video
VideoRate = ConfigFile.VideoRate;
V = VideoWriter('Attack-Video.avi', 'Uncompressed AVI');
V.FrameRate = VideoRate;
open(V);

% Loop play N times (or set loop play in the video player)
for N = 1 : 4
    % For the convenience of testing, the first and last frames of the attack video are black frames.
    % The default black-frame is 0.png in the pics folder.
    BlackPic(ConfigFile);
     
    % Combine the first black-frame and attack images.
    for i = 0 : SaveNum - 1
        PicIndex = [num2str(i) '.png'];
        str = fullfile('pics', PicIndex);
        img = imread(str);
        writeVideo(V, img);
    end
    
    % add the last black-frame.
    str = fullfile('pics','0.png');
    img = imread(str);
    writeVideo(V, img);
end

close(V);