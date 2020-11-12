import subprocess
import json
import os
from bit import PrivateKeyTestnet
import web3
from web3 import Web3
from web3.middleware import geth_poa_middleware
from eth_account import Account
from dotenv import load_dotenv
load_dotenv()

from constants import *
w3 = Web3(Web3.HTTPProvider("http://127.0.0.1:8545"))
w3.middleware_onion.inject(geth_poa_middleware, layer=0)

def derive_wallets(coin):
    mnemonic = os.getenv('MNEMONIC')

    #ln does not work for me, replaced with actual php instead
    command = f'php hd-wallet-derive\hd-wallet-derive.php -g --mnemonic="{mnemonic}" --cols=path,address,privkey,pubkey --format=json --coin={coin}'

    p = subprocess.Popen(command, stdout=subprocess.PIPE, shell=True)
    output, err = p.communicate()
    p_status = p.wait()

    keys = json.loads(output)
    return keys

def priv_key_to_account(coin, priv_key):
    if (coin == 'eth'):
        return w3.eth.Account.privateKeyToAccount(priv_key)
    elif (coin == 'btc-test'):
        return PrivateKeyTestnet(priv_key)
    else:
        return None

def create_tx(coin , account, to, amount):
    if (coin == 'eth'):
        return {
            'to': to,
            'from': account,
            'value': amount,
            'gas': w3.eth.estimateGas({
                "from": account.address,
                "to": to,
                "value": amount
            }),
            'gasPrice': w3.eth.gasPrice,
            'nonce': w3.eth.getTransactionCount(account.address),
            'chainID': coins[coin][0]['path'].split("'/")[1]
        }
    elif (coin == 'btc-test'):
        return PrivateKeyTestnet.prepare_transaction(account.address, [(to, amount, BTC)])
    else:
        return None

coin_list = [BTC, ETH, BTCTEST]
coins = {}
for coin in coin_list:
    coins[coin] = derive_wallets(coin)

print(coins)
