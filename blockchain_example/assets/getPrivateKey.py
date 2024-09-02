from eth_account import Account
from eth_account.signers.local import LocalAccount
from web3 import Web3, EthereumTesterProvider
import os


w3 = Web3(EthereumTesterProvider())
with open('./keystore/mykeyfile') as keyfile:
    encrypted_key = keyfile.read()
    bin_private_key = w3.eth.account.decrypt(encrypted_key, '123')
    private_key = w3.to_hex(bin_private_key)

print(f"Private key from geth: {private_key}")
##end Of First Block##