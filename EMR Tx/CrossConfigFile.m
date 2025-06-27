classdef CrossConfigFile < matlab.mixin.Copyable
    methods (Static = true)
        function val = getInstance()
            persistent value;
            if isempty(value)
                value = CrossConfigFile.makeParameters();
            end
            val = value;
        end
    end
    
    methods (Static = true, Access = private)
        function ConfigFile = makeParameters()
            if nargin == 0
            end
            
disp("Note that this open-source version only supports the 1080*1920@60Hz setting")

            %% Monitor/Cable parameter config
            ConfigFile.FrameRate = 60;
            ConfigFile.Height = 1080;
            ConfigFile.Width = 1920;
            ConfigFile.HeightTotal = 1125;
            ConfigFile.WidthTotal = 2200;
            ConfigFile.PC = ConfigFile.HeightTotal * ConfigFile.WidthTotal * ConfigFile.FrameRate;

            %% EM Packet Info
            ConfigFile.Preamble = 4;                              % The length of Preamble, ranges from 4 to 65535
            ConfigFile.SF = 7;                                    % The LoRa comment SF range is 6-12.
            ConfigFile.ChipNum = 2 ^ ConfigFile.SF;               % One chirp signal is divided into 2^SF chips (within bandwidth range).
            ConfigFile.BandWidth = 0.5e6;                         % The LoRa comment bandwidth is 125kHz, 250kHz, 500kHz.
            ConfigFile.LoRaRxSampleRate = ConfigFile.BandWidth;   % LoRa Tx/Rx's sample rate is consistent with the bandwidth setting.
            
            %% EMR chirp setting (Control the transmission frequency of the video cable)
            ConfigFile.LeakageOffset = 0;                         % If the center frequency emitted by the video cable deviates from the expected frequency, LeakageOffset is used for manual alignment.
            ConfigFile.CenterFreq = 915e6 + ConfigFile.LeakageOffset;
            ConfigFile.LowFreq = ConfigFile.CenterFreq - ConfigFile.BandWidth / 2;
            ConfigFile.HighFreq = ConfigFile.CenterFreq + ConfigFile.BandWidth / 2;

            %% Time calculation
            ConfigFile.ChirpTime = ConfigFile.ChipNum / ConfigFile.LoRaRxSampleRate;
            ConfigFile.PixelTime = 1 / ConfigFile.PC;
            ConfigFile.EMPointOffset = 0;
            ConfigFile.EMChirpPointLength = round((ConfigFile.ChirpTime / ConfigFile.PixelTime)) + ConfigFile.EMPointOffset;
            
            %% Attack Video Config
            ConfigFile.VideoRate = 60;

            %% USRP/SDR settings for reverse analysis of LoRa packets
            ConfigFile.USRPCenterFreq = ConfigFile.CenterFreq;
            ConfigFile.USRPSampleRate = 1e6;                      
            % When collecting standard LoRa packets, the USRP/SDR sampling
            % rate is set to 1MHz, and then the captured signal is
            % downsampled according to the LoRa bandwidth setting during
            % reverse analysys (in the ReverseLoRaPacket.m).



            %% Old-version SDR-based TEMPEST-LoRa.
%             %% basic-UpStepchirp
%             t = 0;
%             f_low = ConfigFile.PC - ConfigFile.BW/2;
%             f_high = ConfigFile.PC + ConfigFile.BW/2;
%             f_step = ConfigFile.BW / ConfigFile.Height;
% 
%             UpStepChirp = zeros(1, ConfigFile.PC / ConfigFile.FrameRate);
%             for x = 1 : ConfigFile.Height
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1))) + 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 UpStepChirp((x-1) * ConfigFile.WidthTotal + 1: x *ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%             end
%             ConfigFile.UpStepChirp = resample(UpStepChirp, ConfigFile.SampleRate, ConfigFile.PC);
% 
%             %% Basic-DownStepChirp
%             t = 0;
%             f_low = ConfigFile.PC - ConfigFile.BW/2;
%             f_high = ConfigFile.PC + ConfigFile.BW/2;
%             f_step = ConfigFile.BW / ConfigFile.Height;
% 
%             DownStepChirp = zeros(1, ConfigFile.PC / ConfigFile.FrameRate);
%             for x = 1 : ConfigFile.Height
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (x - 1))) + 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (x - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 DownStepChirp((x-1) * ConfigFile.WidthTotal + 1: x *ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%             end
%             ConfigFile.DownStepChirp = resample(DownStepChirp, ConfigFile.SampleRate, ConfigFile.PC);
% 
%             %% PayloadSignal
%             t = 0;
%             f_low = ConfigFile.PC - ConfigFile.BW/2;
%             f_high = ConfigFile.PC + ConfigFile.BW/2;
%             f_step = ConfigFile.BW / ConfigFile.Height;
% 
%             PayloadSignal = zeros(1, ConfigFile.PC / ConfigFile.FrameRate);
%             for x = 1 : 1024
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1)))+ 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 PayloadSignal((x - 1) * ConfigFile.WidthTotal + 1 : x * ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%             end
% 
%             k = 1;
%             for x = 1025 : ConfigFile.Height
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (k - 1))) + 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (k - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 PayloadSignal((1024 + k - 1) * ConfigFile.WidthTotal + 1 : (1024 + k) * ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%                 k = k + 1;
%             end
% 
%             ConfigFile.PayloadSignal = resample(PayloadSignal, ConfigFile.SampleRate, ConfigFile.PC);
% 
%             %% DownChip
%             t = 0;
%             DownChip = zeros(1, 1024 * ConfigFile.PC / ConfigFile.FrameRate / ConfigFile.HeightTotal);
%             for x = 1 : 1024
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (x - 1))) + 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_high - f_step * (x - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 DownChip((x - 1) * ConfigFile.WidthTotal + 1 : x * ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%             end
%             ConfigFile.DownChip = resample(DownChip, ConfigFile.SampleRate, ConfigFile.PC);
% 
%             %% UpChip
%             t = 0;
% 
%             UpChip = zeros(1, (ConfigFile.Height - 1024) * ConfigFile.PC / ConfigFile.FrameRate / ConfigFile.HeightTotal);
%             for x = 1 : ConfigFile.Height - 1024
%                 Sig = sin(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1))) + 1j * cos(2 * pi * (1 : ConfigFile.Width) * (1 / ConfigFile.PC) * (f_low + f_step * (x - 1)));
%                 Padding = zeros(1, ConfigFile.WidthTotal - ConfigFile.Width);
%                 UpChip((x - 1) * ConfigFile.WidthTotal + 1 : x * ConfigFile.WidthTotal) = [Sig, Padding];
%                 t = t + ConfigFile.WidthTotal;
%             end
%             ConfigFile.UpChip = resample(UpChip, ConfigFile.SampleRate, ConfigFile.PC);
% 
% 
% 
% %             ConfigFile.dc = ConfigFile.dc(1 : end - 1);
% %            ConfigFile.uc = chirp(0 : 1/ConfigFile.SampleRate : ConfigFile.TChirp, 0, ConfigFile.TChirp, ConfigFile.BW);
% %             ConfigFile.uc = ConfigFile.uc(1 : end - 1);
%             %% Base-DownStep
% 
% 
% 
% 
% %              for i = ConfigFile.Height : -1 : 1
% %                  temp = sin(2 * pi * (ConfigFile.StopFreq - ConfigFile.StartFreq) / ConfigFile.Height * i * t);
% %                  s = [s temp];
% %              end
% %              PaddingTime = (ConfigFile.Height)
% %              ConfigFile.DownStep = s;
% % 
         end
     end
 end 

