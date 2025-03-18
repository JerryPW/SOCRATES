# For checking the modifier
modifier_1 = '''If the function satisfies at least one of the following characteristics, you can output 'Yes', else output 'No': 
                1. Check whether the code in the modifier enforces that only the owner or specific addresses can execute the function.
                   Such code structure can be like:
                    - require(msg.sender == xxxOwner/xxxAddress/Leader/CEO); / require(... || msg.sender == xxxOwner/xxxAddress/Leader/CEO || ...);
                    - if (msg.sender != xxxOwner/xxxAddress/Leader/CEO) {...} / if (... || msg.sender != xxxOwner/xxxAddress/Leader/CEO || ... ) {...}
                    - if (msg.sender != xxxOwner/xxxAddress/Leader/CEO) throw; / if (... || msg.sender != xxxOwner/xxxAddress/Leader/CEO || ... ) throw;
                    - assert(msg.sender == xxxOwner/xxxAddress/Leader/CEO); / assert(... || msg.sender == xxxOwner/xxxAddress/Leader/CEO || ...);
                2. Check whether the code has used the lock operation (usually set a flag to true before the function runs and resets it to false afterward) to ensure the function enters only once.
                3. If the information provided in the modifier's code is limited, you can infer the answer of instruction one and two based on the modifier's function name, like Onlyxxx or nonReentrant.
                I need your answer to strictly match the structure I have provided, without additional semantic reasoning or extensions.
                Please explain in the Reason section which rule your judgment is based on. '''
modifier_2 = '''Please double-check the answer to the previous question, and locate the corresponding part in the code to recheck whether there are any structural omissions, such as finding only one matching statement and making a judgment blindly. Please note that for structures 2, both lock and unlock operation in the structure must be matched to be considered correct.'''

security_require_1 = '''If the function satisfies at least one of the following characteristics, you can output 'Yes', else output 'No': 
                        I need your answer to strictly match the structure I have provided, without additional semantic reasoning or extensions.
                        Check whether the code has one of the following structure:
                        1. require(msg.sender == xxxOwner/xxxAddress/Leader/CEO); / require(... || msg.sender == xxxOwner/xxxAddress/Leader/CEO || ...);
                        2. if (msg.sender != xxxOwner/xxxAddress/Leader/CEO) {...} / if (... || msg.sender != xxxOwner/xxxAddress/Leader/CEO || ... ) {...}
                        3. if (msg.sender != xxxOwner/xxxAddress/Leader/CEO) throw; / if (... || msg.sender != xxxOwner/xxxAddress/Leader/CEO || ... ) throw;
                        4. assert(msg.sender == xxxOwner/xxxAddress/Leader/CEO); / assert(... || msg.sender == xxxOwner/xxxAddress/Leader/CEO || ...);'''

security_require_2 = '''Please double-check the answer to the previous question. 
                        Please note that for structures 1, 2, 3 and 4, the xxx.owner guided by the local variable xxx does not count as part of the above structure.'''

security_lock_1 = '''If the function satisfies at least one of the following characteristics, you can output 'Yes', else output 'No': 
                I need your answer to strictly match the structure I have provided, without additional semantic reasoning or extensions.
                Check whether the code has one of the following structure:
                1. {require(xxx == True);
                    xxx = False;
                    (xxx represents the same variable, and the structure must contain both of these statements)
                    ...
                    xxx = True; (This is optional)}
                2. {require(xxx == False);
                    xxx = True; 
                    (xxx represents the same variable, and the structure must contain both of these statements)
                    ...
                    xxx = False; (This is optional)}
                3. {require(!xxx);
                    xxx = True;
                    (xxx represents the same variable, and the structure must contain both of these statements)
                    ...
                    xxx = False; (This is optional)}
                4. {if(!xxx) throw;
                    xxx = true;
                    (xxx represents the same variable, and the structure must contain both of these statements)
                    ...
                    xxx = False; (This is optional)}'''

security_lock_2 = '''Please double-check the answer to the previous question, and locate the corresponding part in the code to recheck whether there are any structural omissions, such as finding only one matching statement and making a judgment blindly. 
                Please note that for structures 1, 2, 3 and 4, both first two statements (except the optional statement) in the structure must be matched to be considered correct.'''

security_lock_3 = '''If the code satisfies Structure 1, 2, 3 or 4, please further check whether the first two lines of code that meet the structural requirements immediately perform a state negation operation on xxx after checking the state of xxx using 'require' or 'if',
                and ensure that this negation operation is completed before the main logic of the function executes, even if some non-critical code exists in between.
                If the structure satisfy the requirements, then output 'Yes', else output 'No'.
             '''

transfer_1 = '''Please check the following external calls and determine whether the external call satisfy at least one following characteristic. Please explain your reason.
                To determine each external call respectively, you can follow these two instructions.
                1. The external call contains '.transfer(' keyword. Please notice that 'TransferFrom' and 'SafeTransferFrom' don't contain '.transfer(' keyword.
                2. The external call contains '.send(' keyword. 
                Please strictly follow the above rules and do not make any excessive associations or inferences.
                Please ensure that the output judgments correspond one-to-one with the input calls.'''

transfer_2 = '''Please check the following external calls and determine whether the external call satisfy the following characteristic.
                To determine each external call respectively, you can follow this instruction.
                1. The external call contains 'gas' keyword. 
                Please strictly follow the above rules and do not make any excessive associations or inferences.
                In your response, you need to include three parts. The first part is a judgment, which checks whether the given external call meets the condition in part 1. If the gas keyword is present, return True; otherwise, return False. The second part is the gas value. If the result from the first part is 'No', this section should return an empty string "". Otherwise, this part should provide the specific gas value set in the external call. The value can either be a number or a variable holding a number. The third part is is_Number, which checks whether the gas limit provided in the second part is given in the form of a number. If it is, return True; otherwise, return False.
                Please ensure that the output judgments correspond one-to-one with the input calls.'''

transfer_3 = '''For the following series of functions provided, is the assignment to the provided variable always less than or equal to 3000? If yes, return True; if not, return False.'''

# For checking the external address
address_1 = '''You will be given a list of external call functions and a piece of smart contract code. Please determine whether the external call satisfy at least one following characteristic. Please explain your reason.
                If the function satisfies at least one of the following characteristics, you can output 'Yes': 
                1. You should check whether the provided code is a constructor. Typically, you can determine this by checking whether the function name matches the contract name or is explicitly named 'constructor'.
                2. You should check whether the function has hardcoded the provided state variable. 
                Please strictly follow the above rules and do not make any excessive associations or inferences.'''