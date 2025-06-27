function PacketInfo = GetLoRaPacketInfo()

%% LoRa packet key info, consistent with the COTS LoRa receiver
PacketInfo.SyncWord = [9 17];
PacketInfo.Payload = [2	2 48 21	56 5 55	58 24 55 28	64 17 46 31	51 4 12	32 61 47 23	12 37 6	41 28 56 15	37 5	44	28	48	27	20	7	47	34	37	45	23	46	15	54	46 38 6 44 42 26 50 55 42	37 5 40	8 6	6 6];