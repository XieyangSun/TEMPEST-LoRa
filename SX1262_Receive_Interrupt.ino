/*
   RadioLib SX1276 Transmit Example

   This example transmits packets using SX1276 LoRa radio module.
   Each packet contains up to 256 bytes of data, in the form of:
    - Arduino String
    - null-terminated char array (C-string)   c
    - arbitrary binary data (byte array)

   Other modules from SX127x/RFM9x family can also be used.

   For default module settings, see the wiki page
   https://github.com/jgromes/RadioLib/wiki/Default-configuration#sx127xrfm9x---lora-modem

   For full API reference, see the GitHub Pages
   https://jgromes.github.io/RadioLib/
*/

#include <RadioLib.h>
#include "boards.h"

SX1262 radio = new Module(RADIO_CS_PIN, RADIO_DIO1_PIN, RADIO_RST_PIN, RADIO_BUSY_PIN);

// flag to indicate that a packet was received
volatile bool receivedFlag = false;

// disable interrupt when it's not needed
volatile bool enableInterrupt = true;

// this function is called when a complete packet
// is received by the module
// IMPORTANT: this function MUST be 'void' type
//            and MUST NOT have any arguments!
void setFlag(void)
{
    // check if the interrupt is enabled
    if (!enableInterrupt)
    {
        return;
    }

    // we got a packet, set the flag
    receivedFlag = true;
}

void setup()
{
    initBoard();
    // When the power is turned on, a delay is required.
    delay(10);
    // initialize SX1262 with default settings
    Serial.print(F("[SX1262] Initializing ... "));
    int state = radio.begin(LoRa_frequency);
    radio.setFrequency(915);
    radio.setBandwidth(500);
    radio.setSpreadingFactor(7); 
    //radio.setCRC(1);
    radio.setCodingRate(5);
    radio.setPreambleLength(4);
    //radio.forceLDRO(true);



    
    

    if (state == RADIOLIB_ERR_NONE)
    {
        Serial.println(F("success!"));
    }
    else
    {
        Serial.print(F("failed, code "));
        Serial.println(state);
        while (true);
    }

    // set the function that will be called
    // when new packet is received
    radio.setDio1Action(setFlag);

    // start listening for LoRa packets
    Serial.print(F("[SX1262] Starting to listen ... "));
    state = radio.startReceive();
#ifdef HAS_DISPLAY
    if (u8g2) {
        if (state != RADIOLIB_ERR_NONE) {
            u8g2->clearBuffer();
            u8g2->drawStr(0, 12, "Initializing: FAIL!");
            u8g2->sendBuffer();
        }
    }
#endif
#ifdef EDP_DISPLAY
    if (state != RADIOLIB_ERR_NONE)
    {
        display.setRotation(1);
        display.fillScreen(GxEPD_WHITE);
        display.setTextColor(GxEPD_BLACK);
        display.setFont(&FreeMonoBold9pt7b);
        display.setCursor(0, 15);
        display.println("Initializing: FAIL!");
        display.update();
    }
#endif   
    if (state == RADIOLIB_ERR_NONE)
    {
        Serial.println(F("success!"));
    }
    else
    {
        Serial.print(F("failed, code "));
        Serial.println(state);
        while (true);
    }

    // if needed, 'listen' mode can be disabled by calling
    // any of the following methods:
    //
    // radio.standby()
    // radio.sleep()
    // radio.transmit();
    // radio.receive();
    // radio.readData();
    // radio.scanChannel();
}

void loop()
{

    // check if the flag is set
    if (receivedFlag)
    {
        // disable the interrupt service routine while
        // processing the data
        enableInterrupt = false;

        // reset flag
        receivedFlag = false;

        // you can read received data as an Arduino String
        String str;
        int state = radio.readData(str);

        // you can also read received data as byte array
        /*
          byte byteArr[8];
          int state = radio.readData(byteArr, 8);
        */

        if (state == RADIOLIB_ERR_NONE)
        {
            // packet was successfully received
            Serial.println(F("[SX1262] Received packet!"));

            // print data of the packet
            Serial.print(F("[SX1262] Data:\t\t"));
            Serial.println(str);

            // print RSSI (Received Signal Strength Indicator)
            Serial.print(F("[SX1262] RSSI:\t\t"));
            Serial.print(radio.getRSSI());
            Serial.println(F(" dBm"));

            // print SNR (Signal-to-Noise Ratio)
            Serial.print(F("[SX1262] SNR:\t\t"));
            Serial.print(radio.getSNR());
            Serial.println(F(" dB"));

#ifdef HAS_DISPLAY
            if (u8g2)
            {
                u8g2->clearBuffer();
                char buf[256];
                u8g2->drawStr(0, 12, "Received OK!");
                snprintf(buf, sizeof(buf), "RX:%s", str);
                u8g2->drawStr(0, 26, buf);
                snprintf(buf, sizeof(buf), "RSSI:%.2f", radio.getRSSI());
                u8g2->drawStr(0, 40, buf);
                snprintf(buf, sizeof(buf), "SNR:%.2f", radio.getSNR());
                u8g2->drawStr(0, 54, buf);
                u8g2->sendBuffer();
            }
#endif
#ifdef EDP_DISPLAY
            display.setRotation(3);
            display.fillScreen(GxEPD_WHITE);
            display.setTextColor(GxEPD_BLACK);
            display.setFont(&FreeMonoBold9pt7b);
            display.setCursor(0, 15);
            display.println("[SX1262] Received:");
            display.setCursor(0, 35);
            display.println("DATA:"); 
            display.setCursor(55, 35);
            display.println(str); 
            display.setCursor(0, 55);
            display.println("RSSI:"); 
            display.setCursor(55, 55);
            display.println(radio.getRSSI());
            display.setCursor(0, 75);
            display.println("SNR :"); 
            display.setCursor(55, 75);
            display.println(radio.getSNR());  
            display.update();
#endif
        }
//        else if (state == RADIOLIB_ERR_CRC_MISMATCH)
//        {
            // packet was received, but is malformed
//            Serial.println(F("CRC error!"));
//        }
        else
        {
            // some other error occurred
            Serial.print(F("failed, code "));
            Serial.println(state);
        }

        // put module back to listen mode
        radio.startReceive();

        // we're ready to receive more packets,
        // enable interrupt service routine
        enableInterrupt = true;
    }
}
