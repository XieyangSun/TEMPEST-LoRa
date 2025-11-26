<h1 align="center">TEMPEST-LoRa: Cross-Technology Covert Communication</h1>

<div align="center">

**[Xieyang Sun](https://github.com/XieyangSun)<sup>1</sup>** · **Yuanqing Zheng<sup>2</sup>** · **Wei Xi<sup>1</sup>** · **Zuhao Chen<sup>1</sup>** · **Zhizhen Chen<sup>1</sup>** · **Han Hao<sup>1</sup>** · **Zhiping Jiang<sup>3</sup>** · **Sheng Zhong<sup>4</sup>**

<sup>1</sup>Xi'an Jiaotong University · <sup>2</sup>The Hong Kong Polytechnic University · <sup>3</sup>Xidian University · <sup>4</sup>Nanjing University

**ACM CCS 2025**

</div>

<div align="center">

[![Paper](https://img.shields.io/badge/Paper-PDF-blue)](https://dl.acm.org/doi/10.1145/3719027.3744817)
[![arXiv](https://img.shields.io/badge/arXiv-2506.21069-b31b1b.svg)](https://arxiv.org/abs/2506.21069)
[![GitHub](https://img.shields.io/badge/GitHub-Code-black?logo=github)](https://github.com/XieyangSun/TEMPEST-LoRa)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

</div>


This repository contains the source code and instructions for reproducing the results of **"TEMPEST-LoRa: Cross-Technology Covert Communication"**, accepted to **ACM CCS 2025**.

---

## 📺 Demo Video

Watch our demonstration of TEMPEST-LoRa in action:

[![TEMPEST-LoRa Demo](https://img.shields.io/badge/▶️_Watch_on-Bilibili-00A1D6?style=for-the-badge&logo=bilibili)](https://www.bilibili.com/video/BV1PLKiz6Eao)
[![TEMPEST-LoRa Demo](https://img.shields.io/badge/▶️_Watch_on-YouTube-FF0000?style=for-the-badge&logo=youtube)](https://www.youtube.com/watch?v=HDbdAZd6cLw)


## 📋 Table of Contents

- [Overview](#-overview)
- [Media Coverage](#-media-coverage)
- [Key Features](#-key-features)
- [Hardware Requirements](#-hardware-requirements)
- [Quick Start](#-quick-start)
- [EMR Transmitter Setup](#-emr-transmitter-setup-matlab)
- [LoRa Receiver Setup](#-lora-receiver-setup-cots-devices)
- [Attack Samples](#-attack-samples)
- [Important Notes](#-important-notes)
- [Citation](#-citation)
- [Errata](#-errata)
- [Acknowledgments](#-acknowledgments)
- [License](#-license)

---

## 🔬 Overview

TEMPEST-LoRa demonstrates a novel cross-technology covert communication technique that exploits electromagnetic radiation (EMR) from video cables. By crafting malicious images or videos displayed on a monitor/projector/TV, we can cause the connected **VGA or HDMI cable** to emit electromagnetic radiation that encodes **LoRa-compatible packets**.

### How It Works

1. **Transmitter**: A specially crafted video is displayed in full-screen mode on a monitor
2. **Medium**: The VGA/HDMI cable acts as an unintentional antenna, emitting EMR
3. **Receiver**: Commercial Off-The-Shelf (COTS) LoRa devices receive and decode the packets

### Research Paper

📄 **Published**: [ACM CCS 2025](https://dl.acm.org/doi/10.1145/3719027.3744817)  
📄 **Preprint**: [arXiv:2506.21069](https://arxiv.org/abs/2506.21069)

---

## 📰 Media Coverage

Our research has been featured in several technology and security publications:

- 🔗 [**Hackaday**](https://hackaday.com/2025/07/04/video-cable-becomes-transmitter-with-tempest-lora/) - "Video Cable Becomes Transmitter With TEMPEST-LoRa"
- 🔗 [**RTL-SDR Blog**](https://www.rtl-sdr.com/tempest-lora-emitting-lora-packets-from-vga-or-hdmi-cables/) - "TEMPEST-LoRa: Emitting LoRa Packets from VGA or HDMI Cables"
- 🔗 [**Hackster.io**](https://www.hackster.io/news/tempest-lora-breaches-air-gapped-systems-with-video-cables-582771e6ea21) - "TEMPEST-LoRa Breaches Air-Gapped Systems with Video Cables"
- 🔗 [**Treadstone71**](https://www.treadstone71.com/tempest-lora) - "TEMPEST-LoRa Capabilities, Threats, and Strategic Implications in Modern Electronic Warfare"

---

## ✨ Key Features

- ✅ **Cross-Technology Communication**: Bridge display technology and LoRa wireless protocol
- ✅ **COTS Hardware**: Works with commercial LoRa devices (no custom hardware needed)
- ✅ **Flexible Configuration**: Supports multiple LoRa parameters (SF, BW, frequency)
- ✅ **Ready-to-Use Samples**: Pre-generated attack images and videos included
- ✅ **Academic Research**: Demonstrates novel side-channel communication technique

---

## 🛠️ Hardware Requirements

### Transmitter Side (Tx)

- **Computer** with VGA or HDMI output
- **Monitor/Projector/TV** connected via VGA or HDMI cable
- **Display Settings**: Must be set to **1080×1920 @ 60Hz**

### Receiver Side (Rx)

Any **Commercial Off-The-Shelf (COTS) LoRa device**, in our paper, we used:

| Device | Manufacturer | Type |
|--------|--------------|------|
| SX1262 | Lilygo | LoRa Node |
| SX1302 | Waveshare | LoRa Gateway |

---

## 🚀 Quick Start

### Prerequisites

- MATLAB (for generating attack videos)
- Arduino IDE (for SX1262 node setup)
- LoRa receiver hardware

### Basic Workflow

1. **Configure parameters** in `CrossConfigFile.m`
2. **Generate attack video** using `GenerateAttackVideo.m`
3. **Display video** in full-screen mode on target monitor
4. **Receive packets** using configured LoRa device

For detailed instructions, see the sections below.

---

## 📡 EMR Transmitter Setup (MATLAB)

All transmitter scripts are located in the `/EMR Tx` folder.

### 1. Configure Global Parameters

**File**: `CrossConfigFile.m`

Sets the global parameters for the attack video.

**Default Settings**:
- Video resolution: **1080×1920 @ 60Hz**
- EMR center frequency: **915 MHz**
- LoRa Spread Factor (SF): **7**
- LoRa Bandwidth (BW): **500 kHz**
- LoRa Preamble length: **4**

**Usage**:
```matlab
Config = CrossConfigFile.getInstance;
```

### 2. Set Payload Symbols

**File**: `GetLoRaPacketInfo.m`

Defines the symbol sequence representing the payload to be encoded as EMR.

**Default Payload** (SF=6): `"Hello, TEMPEST-LoRa"`

**Custom Payloads**:
Sample physical-layer symbol encoding sequences (SF6-SF12) are provided in `/EMR Tx/PayloadSymbols`.

To use a custom payload:
1. Load the desired symbol sequence from `/PayloadSymbols/`
2. Replace `PacketInfo.Payload` in `GetLoRaPacketInfo.m` with the loaded `Index` variable

**Usage**:
```matlab
PacketInfo = GetLoRaPacketInfo;
```

### 3. Generate Attack Video

**File**: `GenerateAttackVideo.m`

Generates an attack video file named `Attack-Video.avi` in the current directory. Individual frames are saved in `/EMR Tx/pics` (1.png, 2.png, ..., x.png).

**Usage**:
```matlab
GenerateAttackVideo(PacketInfo, Config);
```

### Utility Scripts

#### `CalculateChirpPoints.p` and `CalculateSFD.p`

Calculate the pixel stream corresponding to each EMR chirp signal. These are used internally by `GenerateAttackVideo.m` to create the 1-D pixel stream, which is then reshaped into a 2-D attack image based on the configured resolution.

#### `BlackPic.m`

Generates black images for the first and last frames to mark video boundaries.

#### `ReverseLoRaPacket.m`

Analyzes chirps from captured physical-layer samples to extract encoded LoRa symbols (reverse-engineering aid).

**Workflow**:
1. Use a COTS LoRa device (e.g., SX1262) to transmit data packets
2. Capture physical-layer samples using USRP or SDR
3. Analyze chirp encoding with `ReverseLoRaPacket.m`
4. Manually save results to `/EMR Tx/PayloadSymbols`

#### `ShowSpectrum.m`

Visualizes the time-frequency graph of physical-layer signals (for debugging or calibration).

---

## 📻 LoRa Receiver Setup (COTS Devices)

### Option 1: SX1262 LoRa Node

#### Setup Steps

1. **Install Arduino IDE** on Windows 10/11
2. **Install RadioLib** library ([Documentation](https://www.ardu-badge.com/RadioLib))
3. **Connect SX1262 node** to computer via USB
4. **Upload program**: Load `SX1262_Receive_Interrupt.ino` from RadioLib examples
5. **Monitor reception**: Open Tools → Serial Monitor to view received packets (Data, RSSI, SNR)

#### Configuration Parameters

The default parameters in `SX1262_Receive_Interrupt.ino` are configured to decode the samples in the `AttackSamples` folder:

```cpp
radio.setFrequency(915);        // Center frequency (MHz)
radio.setBandwidth(500);        // LoRa bandwidth (kHz)
radio.setSpreadingFactor(7);    // Spreading factor (6-12)
radio.setCodingRate(5);         // Coding rate
radio.setPreambleLength(4);     // Preamble length
```

**Reference**: For Lilygo SX1262 devices, see the [official tutorial](https://github.com/Xinyuan-LilyGO/LilyGo-LoRa-Series).

### Option 2: SX1302 LoRa Gateway

#### Hardware Setup

We tested with the [Waveshare SX1302 LoRaWAN Gateway HAT](https://www.waveshare.com/wiki/SX1302_LoRaWAN_Gateway_HAT) on Raspberry Pi.

#### Software Setup

1. **Configure SX1302_hal**: Follow the [SX1302_hal README](https://github.com/Lora-net/sx1302_hal)

2. **Reception Method 1** (Direct HAL):

   Navigate to `/libloragw` folder and run:
   ```bash
   ./test_loragw_hal_rx -a 915 -b 915 -m 1250
   ```
   
   **Parameters**:
   - `-a`, `-b`: Center frequency (MHz)
   - `-m`: Chip model (1250, 1255, or 1257, depending on your gateway)

3. **Reception Method 2** (Packet Forwarder):

   Navigate to `/packet_forwarder` folder and run:
   ```bash
   ./lora_pkt_fwd -c global_conf.json.sx1250.US915
   ```
   
   **Parameters**:
   - `-c`: Configuration file (modify `global_conf.json` for custom settings)

---

## 🎯 Attack Samples

Pre-generated attack images and videos are provided in the `/AttackSamples` folder for quick reproduction.

### Naming Convention

Files are named according to their configuration:

```
SF[SpreadFactor]_[Bandwidth]kHz_[Payload]_[CenterFreq]MHz_[FreqOffset]Offset.png
```

**Example**: `SF6_500kHz_ABC_915MHz_+50kHzOffset.png`
- Spread Factor: 6
- Bandwidth: 500 kHz
- Payload: "ABC"
- Center Frequency: 915 MHz
- Frequency Offset: +50 kHz

### Available Configurations

Multiple frequency offset versions are provided for each configuration to account for hardware variations.

---

## ⚠️ Important Notes

### 1. Academic and Educational Use Only

> [!CAUTION]
> This project is developed **solely for academic research and educational purposes**. It aims to explore cross-technology covert communication and reveal potential security risks. Please respect applicable laws, regulations, and ethical standards when working with side-channel signals or wireless technologies.

### 2. Display Settings

> [!IMPORTANT]
> Ensure display settings are **exactly 1080×1920 @ 60Hz**. Some monitors may show "60Hz" but actually run at 59.91Hz or 59.94Hz. Verify the **actual refresh rate** in your OS display settings:
> - **Windows 10/11**: Settings → Display → Advanced Display Settings

### 3. Full-Screen Display

> [!NOTE]
> Attack images/videos **must be displayed in full-screen mode**. Any media player (built-in or third-party like PotPlayer) can be used.

### 4. Frequency Calibration

> [!TIP]
> In practice, the actual EMR frequency may deviate from the configured frequency by several kHz to hundreds of kHz. 
> 
> **Calibration Method**:
> 1. Observe the frequency offset using USRP/SDR spectrum analyzer
> 2. Modify `ConfigFile.LeakageOffset` in `CrossConfigFile.m` to compensate

### 5. Protected Code

> [!NOTE]
> Some core MATLAB functions are provided in `.p` format to protect ongoing patent applications. Reviewers can run the code end-to-end as described in the instructions.

---

## 📚 Citation

If you find this work useful in your research, please cite:

```bibtex
@inproceedings{TEMPEST-LoRa,
  title={TEMPEST-LoRa: Cross-Technology Covert Communication},
  author={Xieyang Sun and Yuanqing Zheng and Wei Xi and Zuhao Chen and Zhizhen Chen and Han Hao and Zhiping Jiang and Sheng Zhong},
  booktitle={Proceedings of the ACM Conference on Computer and Communications Security (CCS)},
  year={2025}
}
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```

### 2. Set Payload Symbols

**File**: `GetLoRaPacketInfo.m`

Defines the symbol sequence representing the payload to be encoded as EMR.

**Default Payload** (SF=6): `"Hello, TEMPEST-LoRa"`

**Custom Payloads**:
Sample physical-layer symbol encoding sequences (SF6-SF12) are provided in `/EMR Tx/PayloadSymbols`.

To use a custom payload:
1. Load the desired symbol sequence from `/PayloadSymbols/`
2. Replace `PacketInfo.Payload` in `GetLoRaPacketInfo.m` with the loaded `Index` variable

**Usage**:
```matlab
PacketInfo = GetLoRaPacketInfo;
```

### 3. Generate Attack Video

**File**: `GenerateAttackVideo.m`

Generates an attack video file named `Attack-Video.avi` in the current directory. Individual frames are saved in `/EMR Tx/pics` (1.png, 2.png, ..., x.png).

**Usage**:
```matlab
GenerateAttackVideo(PacketInfo, Config);
```

### Utility Scripts

#### `CalculateChirpPoints.p` and `CalculateSFD.p`

Calculate the pixel stream corresponding to each EMR chirp signal. These are used internally by `GenerateAttackVideo.m` to create the 1-D pixel stream, which is then reshaped into a 2-D attack image based on the configured resolution.

#### `BlackPic.m`

Generates black images for the first and last frames to mark video boundaries.

#### `ReverseLoRaPacket.m`

Analyzes chirps from captured physical-layer samples to extract encoded LoRa symbols (reverse-engineering aid).

**Workflow**:
1. Use a COTS LoRa device (e.g., SX1262) to transmit data packets
2. Capture physical-layer samples using USRP or SDR
3. Analyze chirp encoding with `ReverseLoRaPacket.m`
4. Manually save results to `/EMR Tx/PayloadSymbols`

#### `ShowSpectrum.m`

Visualizes the time-frequency graph of physical-layer signals (for debugging or calibration).

---

## 📻 LoRa Receiver Setup (COTS Devices)

### Option 1: SX1262 LoRa Node

#### Setup Steps

1. **Install Arduino IDE** on Windows 10/11
2. **Install RadioLib** library ([Documentation](https://www.ardu-badge.com/RadioLib))
3. **Connect SX1262 node** to computer via USB
4. **Upload program**: Load `SX1262_Receive_Interrupt.ino` from RadioLib examples
5. **Monitor reception**: Open Tools → Serial Monitor to view received packets (Data, RSSI, SNR)

#### Configuration Parameters

The default parameters in `SX1262_Receive_Interrupt.ino` are configured to decode the samples in the `AttackSamples` folder:

```cpp
radio.setFrequency(915);        // Center frequency (MHz)
radio.setBandwidth(500);        // LoRa bandwidth (kHz)
radio.setSpreadingFactor(7);    // Spreading factor (6-12)
radio.setCodingRate(5);         // Coding rate
radio.setPreambleLength(4);     // Preamble length
```

**Reference**: For Lilygo SX1262 devices, see the [official tutorial](https://github.com/Xinyuan-LilyGO/LilyGo-LoRa-Series).

### Option 2: SX1302 LoRa Gateway

#### Hardware Setup

We tested with the [Waveshare SX1302 LoRaWAN Gateway HAT](https://www.waveshare.com/wiki/SX1302_LoRaWAN_Gateway_HAT) on Raspberry Pi.

#### Software Setup

1. **Configure SX1302_hal**: Follow the [SX1302_hal README](https://github.com/Lora-net/sx1302_hal)

2. **Reception Method 1** (Direct HAL):

   Navigate to `/libloragw` folder and run:
   ```bash
   ./test_loragw_hal_rx -a 915 -b 915 -m 1250
   ```
   
   **Parameters**:
   - `-a`, `-b`: Center frequency (MHz)
   - `-m`: Chip model (1250, 1255, or 1257, depending on your gateway)

3. **Reception Method 2** (Packet Forwarder):

   Navigate to `/packet_forwarder` folder and run:
   ```bash
   ./lora_pkt_fwd -c global_conf.json.sx1250.US915
   ```
   
   **Parameters**:
   - `-c`: Configuration file (modify `global_conf.json` for custom settings)

---

## 🎯 Attack Samples

Pre-generated attack images and videos are provided in the `/AttackSamples` folder for quick reproduction.

### Naming Convention

Files are named according to their configuration:

```
SF[SpreadFactor]_[Bandwidth]kHz_[Payload]_[CenterFreq]MHz_[FreqOffset]Offset.png
```

**Example**: `SF6_500kHz_ABC_915MHz_+50kHzOffset.png`
- Spread Factor: 6
- Bandwidth: 500 kHz
- Payload: "ABC"
- Center Frequency: 915 MHz
- Frequency Offset: +50 kHz

### Available Configurations

Multiple frequency offset versions are provided for each configuration to account for hardware variations.

---

## ⚠️ Important Notes

### 1. Academic and Educational Use Only

> [!CAUTION]
> This project is developed **solely for academic research and educational purposes**. It aims to explore cross-technology covert communication and reveal potential security risks. Please respect applicable laws, regulations, and ethical standards when working with side-channel signals or wireless technologies.

### 2. Display Settings

> [!IMPORTANT]
> Ensure display settings are **exactly 1080×1920 @ 60Hz**. Some monitors may show "60Hz" but actually run at 59.91Hz or 59.94Hz. Verify the **actual refresh rate** in your OS display settings:
> - **Windows 10/11**: Settings → Display → Advanced Display Settings

### 3. Full-Screen Display

> [!NOTE]
> Attack images/videos **must be displayed in full-screen mode**. Any media player (built-in or third-party like PotPlayer) can be used.

### 4. Frequency Calibration

> [!TIP]
> In practice, the actual EMR frequency may deviate from the configured frequency by several kHz to hundreds of kHz. 
> 
> **Calibration Method**:
> 1. Observe the frequency offset using USRP/SDR spectrum analyzer
> 2. Modify `ConfigFile.LeakageOffset` in `CrossConfigFile.m` to compensate

### 5. Protected Code

> [!NOTE]
> Some core MATLAB functions are provided in `.p` format to protect ongoing patent applications. Reviewers can run the code end-to-end as described in the instructions.

---

## 📚 Citation

If you find this work useful in your research, please cite:

```bibtex
@inproceedings{TEMPEST-LoRa,
  title={TEMPEST-LoRa: Cross-Technology Covert Communication},
  author={Xieyang Sun and Yuanqing Zheng and Wei Xi and Zuhao Chen and Zhizhen Chen and Han Hao and Zhiping Jiang and Sheng Zhong},
  booktitle={Proceedings of the ACM Conference on Computer and Communications Security (CCS)},
  year={2025}
}
```

---

## 📝 Errata

We have identified the following typographical errors in the published paper (both arXiv and ACM versions):

> [!NOTE]
> **Page 2, Introduction (Third Contribution)**
> - **Error**: "21.6 bps"
> - **Correction**: "21.6 kbps"
> - The data rate should be in kilobits per second (kbps), not bits per second (bps).

> [!NOTE]
> **Page 5, Figure 4 Caption**
> - **Error**: "Hsync and Ysync"
> - **Correction**: "Hsync and Vsync"
> - The vertical synchronization signal should be referred to as Vsync, not Ysync.

We apologize for any confusion these errors may have caused.

---

## ❤️ Acknowledgments

We thank the anonymous reviewers of ACM CCS and the research community for their valuable feedback and support. We are grateful for the collaborative efforts of all authors. We also acknowledge the pioneering research in wireless communications and side-channel analysis that has laid the foundation for this work.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
