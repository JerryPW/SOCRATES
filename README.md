# Socrates
This is the official repository for Socrates in paper "How To Ask Questions The Smart Way: On the Role of LLM in Smart Contract Auditing"

![Structure](Overall_Structure.pdf)

## Usage
### Create a python environment
```
    python3 -m venv venv  
    pip install -r requirements.txt 
```


### Paste your openai-key
Socrates uses GPT-4o as our base LLM, please acquire your own openai key from [here](https://platform.openai.com/docs/overview), and paste your key into ```line 3``` in ```Openai/call.py```

### Start your first trial on Socrates
We provide some toy examples in dir ```toy_examples```, which includes 10 smart contracts from dataset [SCRUBD](https://github.com/sujeetc/SCRUBD). Among all these examples, 8 of them are classified as w/o REE and the rest of 2 are w/ REE. Detailed labels are presented in the file ```toy_examples.csv``` with simple reasons for each example.

Different solidity file needs different solidity version based on their implementation.(Based on the ```pragma solidity xxx``` in each sol file) Therefore, several solidity versions need to installed before actually run Socrates.
```
    solc-select install xxx // xxx represents the version that you want to install
    solc-select use xxx // switch solidity version
```
We recommend that install all solidity versions by this following command.
```
solc-select install all
```
After finishing all preparation, run
```
python main.py
```

## More Examples?
If you want to try more examples, you could refer to these three datasets:

- [Smartbugs-curated](https://github.com/smartbugs/smartbugs-curated): including 31 labeled as REE smart contracts
- [Rudder](https://github.com/InPlusLab/ReentrancyStudy-Data): including 46 labeled as REE smart contracts
- [SCRUBD](https://github.com/sujeetc/SCRUBD): large datasets focusing on REE vulnerability
