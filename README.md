## TEMPEST-LoRa code for Artifact Evaluation

This repository contains the source code and instructions for reproducing the results of "TEMPEST-LoRa: Cross-Technology Covert Communication", accepted to ACM CCS 2025.

### Overview

This work demonstrates how to craft a malicious image or video that, when played in full-screen mode on a monitor/projector/TV, causes the connected VGA or HDMI cable to emit electromagnetic radiation (EMR)  LoRa-compatible packets.

### Hardwave Requirements

TEMPEST-LoRa requires the following hardware:

- Transmitter side (Tx): Video Cable, VGA or HDMI.
    - A computer and a monitor/projector/TV via VGA or HDMI cable.
    - Display setting is 1080x1920@60Hz.
- Receiver side (Rx): Any Comercial Off-The-Shelf (COTS) LoRa devices for reception.
    
    In our paper, we use:
    
    - SX1262 LoRa node, made by Lilygo.
    - SX1302 LoRa gateway, made by Waveshare.

### EMR Transmitter Setup (in MATLAB)

All transmitter scripts are located under the ‘/EMR Tx’ folder.

— **CrossConfigFile.m**

Used to set the global parameters for the attack video. 

Default settings:

- Attack video’s resolution and refresh rate: 1080x1920@60Hz.
- EMR center frequency: 915 MHz.
- LoRa Spread Factor (SF): 7
- LoRa Bandwidth (BW): 500 kHz
- LoRa Preamble length: 4

Run: `Config = CrossConfigFile.getInstance`

— **GetLoRaPacketInfo.m**

Used to set the symbol sequence representing the payload to be encoded as EMR. 

Default parameter is:

- Payload (Under SF=6): “Hello, TEMPEST-LoRa”

To generate other Payloads, we have provided some samples of physical-layer symbol encoding sequence under SF6 to SF12 settings, which are saved in the ‘/EMR Tx/PayloadSymbols’ folder. 

- Load the desired symbol sequence from /PayloadSymbols/. The variable name in All PayloadSymbols files is ‘Index’.
- Replace **PacketInfo.Payload** in **GetLoRaPacketInfo.m**

Run: `PacketInfo = GetLoRaPacketInfo`

— **GenerateAttackVideo.m**

Used to generate a video named ‘Attack-Video.avi’ at the current directory. Each frame of the attack image that constitutes the attack video is saved under the path of ‘/EMR Tx/pics’ (from 1.png to x.png).

Run: `GenerateAttackVideo(PacketInfo, Config)`

Some internal utility scripts:

—  **CalculateChirpPoints.p** and **CalculateSFD.p**

Used to calculate the pixel stream corresponding to each EMR chirp signal.  They are used by **GenerateAttackVideo.m** and the output results are combined into a 1-D pixel stream. (coressponding an EMR LoRa packet). Then, follow the parameters in **CrossConfigFile.m** (ConfigFile.Height, ConfigFile.Width, ConfigFile.HeightTotal and ConfigFile.WidthTotal), the 1-D attack pixel stream is reshaped into a 2-D attack image.

—**BlackPic.m**

Generates a black image for the first and last frame to mark video boundaries.

— **ReverseLoRaPacket.m**

Analyzes chirps from captured physical-layer samples to extract encoded LoRa symbols (reverse-engineering aid).

Our usage method is to control a COTS LoRa device (for example, a SX1262 LoRa node) to transmit data packets, and at the same time use USRP or SDR to capture the physical-layer samples of this standard LoRa packet. Subsequently, the internal chirp encoding was analyzed using **ReverseLoRaPacket.m**, and the result was manually saved in ‘/EMR Tx/PayloadSymbols’.

— **ShowSpectrum.m**

Used to draw and observe the time-frequency graph of the physical-layer signals (for debugging or calibration).

### LoRa Receiver Setup (COTS Devices)

In our paper, the models we use are SX1262 node and SX1302 gateway.

### For SX1262 LoRa node:

- Install the Arduino IDE on Windows 10/11.
- Install RadioLib on Arduino IDE. Reference: https://www.ardu-badge.com/RadioLib.
- Connect the SX1262 node to the computer via USB.
- Load ‘SX1262_Receive_Interrupt.ino’ from RadioLib, and upload this program to the SX262 node.
- Open the Tools→Serial Monitor. When LoRa packets are received, the Data, RSSI and SNR of each packet will be displayed.

If you use the LoRa SX1262 made by Lilygo, you can refer to the official tutorial: https://github.com/Xinyuan-LilyGO/LilyGo-LoRa-Series. 

### For SX1302 LoRa gateway:

We operated the SX1302 on a Raspberry PI (the model we use is https://www.waveshare.com/wiki/SX1302_LoRaWAN_Gateway_HAT). 

First, configure SX1302_hal, an open-source LoRa gateway library. Please refer to the readme of SX1302_hal: https://github.com/Lora-net/sx1302_hal.

- There are two reception methods:
    
    (1) Under the /libloragw folder,
    
    run: `./test_loragw_hal_rx -a 915 -b 915 -m 1250`
    
    Here, the parameters after -a and -b are used to specify the received center ferquency. The parameters following -m are used to specify the internal chip model, and there are 3 possible models: 1250, 1255 and 1257 (It depends on the gateway model you purchase).
    
    (2) Under the /packet_forwarder folder,
    
    run: `./lora_pkt_fwd -c global_conf.json.sx1250.US915`
    
    Here, the parameters after -c are used to specify the file for setting the received parameters. Detailed received parameters can be modified in the corresponding global_conf.json.
    

Note:

(1) This project is developed solely for academic research and educational purposes. It aims to explore the potential of cross-technology covert communication, and to reveal the potential security risks. Please respect applicable laws, regulations, and ethical standards when working with side-channel signals or wireless technologies.

(2) Make sure the display settings are set to exactly 1080x1920@60Hz. On some monitors, the actual refresh rates under this setting may be very close to (such as 59.91 Hz, 59.94 Hz), but not equal to 60.00 Hz. The actual refresh rate needs to be confirmed in the display Settings of the operating system. For example, under the Windows 10/11 system, the actual refresh rate need to be confirmed in Display Settings -> Advanced Display Settings.

(3) When playing attack images/videos, make sure they are displayed in full screen. Any built-in or third-party player (such as PotPlayer) can be used.

(4) In practice, we noticed that the actual EMR frequency emitted by the video cable may deviate from the set attack frequency by several kHz to several hundred kHz. The precise calibration method should be to observe the frequency offset on the spectrum using USRP/SDR, and then modify ConfigFile.LeakageOffset in CrossConfigFile.m to calibrate the transmission frequency. 

To facilitate anyone interested in quickly reproducing TEMPEST-LoRa, we offer a portion of the generated attack images and videos in the AttackDemo folder. The corresponding settings are reflected in the naming (SF_BW_Payload_CenterFrequency_FrequencyOffset). For each setting, we offer multiple versions with frequency offsets. /TEMPEST-LoRa/SX1262_Receive_Interrupt.ino is used for the receiving program example on the SX1262 node. The defulat parameters can decode the corresponding EM packet in the AtttackDemo folder. The important parameters are as follows:

`radio.setFrequency(915); // set the center frequency`

`radio.setBandwidth(500); // set the LoRa badnwidth (kHz)`

`radio.setSpreadingFactor(7); // set SF (6-12)`

`radio.setCodingRate(5) // set the coding rate. The samples in AttackDemo were created when CodingRate = 5`

`radio.setPreambleLength(4); // set the length of Preamble. The samples in AttackDemo were created when PreambleLength = 4`

(5) Some core MATLAB functions are provided in `.p` format to protect ongoing patent applications. Reviewers can run the code end-to-end as described in the instructions.