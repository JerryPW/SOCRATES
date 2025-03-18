from system import analysis
from switch_solc_version import switch_solc_version
from utils import log
from tqdm import trange

import pandas as pd
import random
import time
import os


if __name__ == "__main__":
    label = pd.read_csv('toy_examples.csv')
    for i in trange(label.shape[0]):
        smart_contract_address = label.loc[i, 'Smart Contract']
        root = f'toy_examples/{smart_contract_address}.sol'
        input = label.loc[i, 'Function Name']
        slither = switch_solc_version(root)
        if slither:
            start_analyze_time = time.time()
            conclusion, total_token = analysis(root, input, slither)
            end_analyze_time = time.time()
        else:
            conclusion = ["Unsuccessful to get slither contract."]
        os.makedirs('./logs', exist_ok=True)
        log(conclusion, f'./logs/{smart_contract_address}_{input}_GPT.txt')

        print('Analyzed Time:', end_analyze_time - start_analyze_time)
        print('Token Consumptions: ', total_token)
