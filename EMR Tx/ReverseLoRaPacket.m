function  Index = ReverseLoRaPacket(LoRaSignals, ConfigFile)
%% Geneate a down-chirp for dechirp calculation
Fs = ConfigFile.BandWidth; 
N = 2 ^ ConfigFile.SF;
T = N / Fs;
t = (0 : N - 1) * T / N;
f0 = -ConfigFile.BandWidth / 2;
f1 = ConfigFile.BandWidth / 2;
DownChirp = chirp(t, f1, T, f0);

%% Point by point for dechirp calculation
DechirpSeq = [];
for i = 1 : length(LoRaSignals) - N + 1
    temp = LoRaSignals(i : i + N - 1);
    dechirp = abs(fft(temp .* DownChirp'));
    [value index] = max(dechirp);
    if value > 0
        DechirpSeq(i) = index;
    else
        DechirpSeq(i) = -1;
    end
    %Signal(i) = index;
end

plot(DechirpSeq); 

StartIndex =  1;
StartIndex + (ConfigFile.Preamble + 2.25) * N
k = 1;
Index = [];
for i = 1 : (length(LoRaSignals) - StartIndex) / N - 1
    temp = LoRaSignals(StartIndex : StartIndex + N - 1);
    dechirp = abs(fft(temp .* DownChirp'));
    [value index] = max(dechirp);
    if value > 10
        Index(k) = index;
        k = k + 1;
    end
    StartIndex = StartIndex + N;
end


figure;
plot(Index);
