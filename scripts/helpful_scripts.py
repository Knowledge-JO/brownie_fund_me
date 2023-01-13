from brownie import accounts, network,config, MockV3Aggregator

FORKED_LOCAL_BLOCKCHAIN = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ['development', 'ganache-local']

DECIMALS = 8
START_PRICE = 200000000000

def get_account():
    if network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS or network.show_active() in FORKED_LOCAL_BLOCKCHAIN:
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def deploy_mocks():
    # deploy mock 
    print(f"The active network is:{network.show_active()}")
    print("deploying Mocks....")
    if len(MockV3Aggregator) <= 0:
        MockV3Aggregator.deploy(DECIMALS, START_PRICE, {'from':get_account()})
    print("mocks deployed")