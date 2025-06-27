function [S F T P] = showSpectrum(soundVector)

[S,F,T,P] = spectrogram(soundVector,64,32,64,1e6, 'centered');

figure; 
imagesc(F,T,db(P'));
colormap(jet);
view(-90,90);