from web3 import Web3
from web3.middleware import geth_poa_middleware
from hexbytes import HexBytes
from datetime import datetime

bold_start = "\033[1m"
bold_end = "\033[0m"

def printh(arg):
    if isinstance(arg, HexBytes): print(arg.hex())
    else: print(arg)

def printk(arg):
    print(f"{bold_start}{arg}:".ljust(25) + bold_end, end='')    

rpc_node_url = "https://eth-sepolia.g.alchemy.com/v2/bSK_LKDOkhI7j880V2GPDSiqvbUHoM1r"
proxy = "http://nexus:8082"

w3 = Web3(
    Web3.HTTPProvider(
        rpc_node_url,
        request_kwargs={"proxies":{'https' : proxy }}
    )
)


w3.middleware_onion.inject(geth_poa_middleware, layer=0)
print(f"Is connected: {w3.is_connected()}\n")

MY_ADDRESS = "0x2842fc9008eD72b976d540EAFB4ED046280fA5F3"
# так как все адреса и хэши внутри блокчейна имеют определенный порядок больших и маленьких букв
# мы всегда будем оборачивать адреса с помощью дополнительной функции
MY_ADDRESS = w3.to_checksum_address("0x2842fc9008eD72b976d540EAFB4ED046280fA5F3")

w3.eth.get_balance(MY_ADDRESS)

w3.from_wei(
    number=w3.eth.get_balance(MY_ADDRESS), ## какое число в wei
    unit='Ether' ## в какую единицу измерения переводим
)