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

testnet_rpc_url = "https://rpc.main.siberium.net"
proxy = "http://nexus:8082"

web3 = Web3(
    Web3.HTTPProvider(
        testnet_rpc_url,
        request_kwargs={"proxies":{'https' : proxy }}
    )
)


web3.middleware_onion.inject(geth_poa_middleware, layer=0)
print(f"Is connected: {web3.is_connected()}\n")

# Основная информация о сети:
# * Идентификатор блокчейна (1 - Ethereum, 111111 - Siberium)
# * Текущая цена газа 
# * Номер последнего блока

print(f"Chain ID: {web3.eth.chain_id}")
print(f"Gas price: {web3.eth.gas_price:_} Wei")
print(f"Current block number: {web3.eth.block_number}\n")


# Проверим баланс какого-нибудь кошелька в Siberium:

wallet_address = "0xeFeAee14D7E590B7CC3Ac31Ebdc4D7168e6Dd929" 
balance = web3.eth.get_balance(wallet_address)/10**18
print(f"Balance of {wallet_address} = {balance} ETH\n")


#Квитанцтия тразакции (trasaction receipt) содержит поля, описывающие базовые сведения от выполненной транзакции.

transaction_hash = "0x5dae165343ba1dc8992f5014f66d6de6eeb39525af6a95fd1b5e1ce32c1abb22"
transaction = web3.eth.get_transaction(transaction_hash)
transaction_receipt = web3.eth.get_transaction_receipt(transaction_hash)

receipt = dict(transaction_receipt)

for key, value in receipt.items():
    printk(key)
    printh(value)

#Например, можно узнать, сколько газа заплатил инициатор данной транзакции:

gasUsed = receipt.get('gasUsed')
print (f"\nCummulative gas used for transaction: {gasUsed}\n")

#Можно получить данные обо всем блоке, в который была включена данная транзакция:
block_number = receipt.get('blockNumber')
block = web3.eth.get_block(block_number)
#print (block)
for key, value in block.items():
    printk(key)
    printh(value)

#Например, узнать время, когда был посчитан блок:
    
timestamp = block.get('timestamp')
block_datetime = datetime.fromtimestamp(timestamp)

print(f"\nBlock timestamp is: {block_datetime}\n")


#Блокчейн: блоки связаны между собой при помощи Parent Hash. Это поле в заголовке нового блока указывает на хеш предыдущего блока в цепочке. Благодаря этому невозможо заменить один блок блокчейна другим.

number_of_blocks = 4
block_count = 0

current_block_number = block_number
while block_count < number_of_blocks:
    
    current_block = web3.eth.get_block(current_block_number)

    print(f"Block Number: {current_block.number}")
    print(f"Block Hash: {web3.to_hex(current_block.hash)}")
    print(f"Parent Hash: {web3.to_hex(current_block.parentHash)}")
    print("-" * 50)
    
    previous_block = web3.eth.get_block(current_block.parentHash)
    current_block_number = previous_block.number
    block_count += 1

#Валидирование транзакций. "Сверху" должно быть достаточное количество блоков, чтобы транзакцию можно было бы считать валидной (она "надежно" включена в блокчейн).  
    

confirmation_blocks = 6
block_count = 0

transaction = web3.eth.get_transaction(transaction_hash)
block_number = transaction.blockNumber

current_block_number = block_number + 1

while block_count < confirmation_blocks:
    if web3.eth.block_number >= current_block_number:
        current_block = web3.eth.get_block(current_block_number)

        print(f"\nBlock Number: {current_block.number}")
        print(f"Block Hash:   {web3.to_hex(current_block.hash)}")
        print(f"Parent Hash:  {web3.to_hex(current_block.parentHash)}")
        print("-" * 50)

        current_block_number += 1
        block_count += 1
    else:
        print("Transaction has not been validated yet. Not enough blocks have been mined.")
        break

if block_count == confirmation_blocks:
    print(f"Transaction is validated with {confirmation_blocks} confirmations.\n")

log = receipt.get('logs', [])[0]

for key, value in log.items():
     printk(key)
     printh(value)


#Зная хеш события, мы можем искать все аналогичные события в блокчейне. Найдем все переводы токенов на этот контракт: 
     
event_topic_hash = "0x5a0ebf9442637ca6e817894481a6de0c29715a73efc9e02bb7ef4ed52843362d"

event_filter = web3.eth.filter({
    "fromBlock": "earliest", 
    "toBlock": "latest",      
    "topics": [event_topic_hash]
})

logs = event_filter.get_all_entries()

for log in logs:
    print(f"\nBlock Number: {log['blockNumber']}")
    print(f"Transaction Hash: {log['transactionHash'].hex()}")
    print(f"Log Index: {log['logIndex']}")
    print(f"Topics: {log['topics']}")
    print(f"Data: {log['data']}\n")

#Теперь в нашем dapp мы, например, можем посчитать всю сумму токенов, переведенных на этот смарт:
    
token_sum = 0
for log in logs:
    token_sum += int(log['data'].hex(), 16)
print(f"{token_sum} Wei")
print(f"{web3.from_wei(token_sum, unit='ether')} Ether")