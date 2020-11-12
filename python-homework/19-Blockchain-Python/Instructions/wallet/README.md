## 18 - Blockchain - Python
---
#### Sending blockchain transactions using python code only

1. Instead of using **MyCrypto** to generate wallet keystore file, I'm using **Ganache** to connect to my private ETH blockchain through the pre-generated mnemonic phrase.\
    * url: http://127.0.0.1:7545
    * network ID: 5777
    * coin: ETH
    !['ganache'](.\Screenshots\ganache.png)
---

2. The [wallet.py](wallet.py) file supports the following coins:
    | Coin | Symbol | Global Variable |
    | --- | --- | --- |
    | Ethereum | `eth` | `ETH` |
    | Bitcoin Testnet | `btc-test` | `BTCTEST` |
---

3. To send a transaction