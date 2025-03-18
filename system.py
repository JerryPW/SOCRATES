import os
from Openai.call import call_gpt, call_template_gpt
from Openai.prompt import *
from Openai.output_template import *
from utils import *
from slither.analyses.data_dependency.data_dependency import is_tainted, is_dependent

import json
import pygraphviz as pgv
from collections import deque

total_token = 0
        
def analyze_function_security(slither_function, smart_contract_code, conclusion, indent=0):
    global total_token
    conclusion = report(f"Function Security Analysis for {slither_function.canonical_name}", indent+0, conclusion)
    if slither_function.is_constructor:
        conclusion = report("This is a constructor.", indent+4, conclusion)
        return True

    modifiers = slither_function.modifiers

    if modifiers == []:
        conclusion = report(f'There are no modifiers should be examined in function {slither_function.name}.', indent+4, conclusion)
    else:
        conclusion = report(f"The modifier of function {slither_function.name} are {[m.name for m in modifiers]}", indent+4, conclusion)
        conclusion = report("The result of checking modifiers: ", indent+4, conclusion)

        for m in modifiers:
            modifier_code_pos = str(m.source_mapping).split('#')[1]
            if '-' in modifier_code_pos:
                modifier_code_start, modifier_code_end = modifier_code_pos.split('-')
            else:
                modifier_code_start = modifier_code_pos
                modifier_code_end = modifier_code_pos
            modifier_code_list = smart_contract_code[(int(modifier_code_start)-1) : (int(modifier_code_end))]
            modifier_code = ''.join(modifier_code_list)

            messages=[
                {"role": "system", "content": modifier_1},
                {"role": "user", "content": modifier_code},
            ]
            result, token = call_template_gpt(messages, Explaination)
            total_token += token

            if 'Yes' in result.judge:
                messages=[
                    {"role": "system", "content": modifier_1},
                    {"role": "user", "content": modifier_code},
                    {"role": "assistant", "content": "Judge: " + result.judge + " Reason: " + result.Reason},
                    {"role": "user", "content": modifier_2},
                ]
                result, token = call_template_gpt(messages, Explaination)
                total_token += token


            if 'Yes' in result.judge:
                conclusion = report(f'- modifier {m.name} is controlled by owner, the function would not cause REE problem.', indent+8, conclusion)
                conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)
                return True
            elif 'No' in result.judge:
                conclusion = report(f'- modifier {m.name} has no relation with controlled by owner.', indent+8, conclusion)
                conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)
    
    conclusion = report("Check direct function security", indent+4, conclusion)
    fun_code_pos = str(slither_function.source_mapping).split('#')[1]
    if '-' in fun_code_pos:
        fun_code_start, fun_code_end = fun_code_pos.split('-')
    else:
        fun_code_start = fun_code_pos
        fun_code_end = fun_code_pos
    fun_code_list = smart_contract_code[(int(fun_code_start)-1) : (int(fun_code_end))]
    fun_code = ''.join(fun_code_list)

    messages=[
        {"role": "system", "content": security_require_1},
        {"role": "user", "content": fun_code},
    ]
    result, token = call_template_gpt(messages, Explaination)
    total_token += token

    if 'Yes' in result.judge:
        messages=[
            {"role": "system", "content": security_require_1},
            {"role": "user", "content": fun_code},
            {"role": "assistant", "content": "Judge: " + result.judge + " Reason: " + result.Reason},
            {"role": "user", "content": security_require_2},
        ]
        result, token = call_template_gpt(messages, Explaination)
        total_token += token

    if 'Yes' in result.judge:
        conclusion = report(f'- function {slither_function.canonical_name} has security assurance protected by checking the authority of msg.sender, the function would not cause REE problem.', indent+8, conclusion)
        conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)
        return True
    elif 'No' in result.judge:
        conclusion = report(f'- function {slither_function.canonical_name} has no security assurance protected by checking the authority of msg.sender', indent+8, conclusion)
        conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)
    

    messages=[
        {"role": "system", "content": security_lock_1},
        {"role": "user", "content": fun_code},
    ]
    result, token = call_template_gpt(messages, Explaination)
    total_token += token

    if 'Yes' in result.judge:
        messages=[
            {"role": "system", "content": security_lock_1},
            {"role": "user", "content": fun_code},
            {"role": "assistant", "content": "Judge: " + result.judge + " Reason: " + result.Reason},
            {"role": "user", "content": security_lock_2},
        ]
        result, token = call_template_gpt(messages, Explaination)
        total_token += token
    
    if 'Yes' in result.judge:
        messages=[
            {"role": "system", "content": security_lock_1},
            {"role": "user", "content": fun_code},
            {"role": "assistant", "content": "Judge: " + result.judge + " Reason: " + result.Reason},
            {"role": "user", "content": security_lock_2},
            {"role": "assistant", "content": "Judge: " + result.judge + " Reason: " + result.Reason},
            {"role": "user", "content": security_lock_3 + "Code: " + fun_code},
        ]
        result, token = call_template_gpt(messages, Explaination)
        total_token += token

    if 'Yes' in result.judge:
        conclusion = report(f'- function {slither_function.canonical_name} has security assurance by utilizing a lock machinism, the function would not cause REE problem.', indent+8, conclusion)
        conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)
        return True
    elif 'No' in result.judge:
        conclusion = report(f'- function {slither_function.canonical_name} has no apparent security assurance by utilizing a lock machinism.', indent+8, conclusion)
        conclusion = report(f'Reason: {result.Reason}', indent+10, conclusion)

    if slither_function.visibility in ['internal', 'private']:
        conclusion = report(f"Since the function can only be called by functions, we start to analyze indirect function security.", indent+4, conclusion)
        reachable_function = slither_function.all_reachable_from_functions
        if len(reachable_function) == 0:
            conclusion = report(f"There are no reachable function for internal/private function, please manually check its successor contracts.", indent+4, conclusion)
            return True
        conclusion = report(f"The reachable functions are {[fun.name for fun in reachable_function]}", indent+4, conclusion)
        for func in reachable_function:
            if func.canonical_name == slither_function.canonical_name:
                continue
            result = analyze_function_security(func, smart_contract_code, conclusion, indent+8)
            if result == False:
                return False
        return True

    return False

def analyze_transfer(direct_external_call, slither_contract, slither_function, smart_contract_code, conclusion):
    global total_token
    conclusion = report("Analyze Transfer", 4, conclusion)
    messages=[
            {"role": "system", "content": transfer_1},
            {"role": "user", "content": str(direct_external_call)},
        ]
    result, token = call_template_gpt(messages, Transfer)
    result = result.Judge
    total_token += token

    need_for_further_analyze = []
    for external_call, judge in zip(direct_external_call, result):
        if judge.judge is True and (count_parameters(external_call) <= 1):
            conclusion = report(f"- {external_call} is subjected to gas limits. Therefore, it has no potential REE problem. Here is the reason: {judge.explaination}. Parameter in 'transfer'/'send': {count_parameters(external_call)}.", 8, conclusion)
        elif judge.judge is True and (count_parameters(external_call) > 1):
            conclusion = report(f"- {external_call} ISN'T subjected to gas limits. Parameter in 'transfer'/'send': {count_parameters(external_call)}.", 8, conclusion)
            need_for_further_analyze.append(external_call)
        else:
            # conclusion = report(f"- {external_call} ISN'T subjected to gas limits. Here is the reason: {judge.explaination}", 8, conclusion)
            need_for_further_analyze.append(external_call)
    
    conclusion = report("Analyze Gas", 4, conclusion)
    messages=[
        {"role": "system", "content": transfer_2},
        {"role": "user", "content": str(need_for_further_analyze)},
    ]
    result, token = call_template_gpt(messages, Gas)
    result = result.Judge
    total_token += token

    need_for_analyze_address = []
    for external_call, judge in zip(need_for_further_analyze, result):
        if judge.judge and judge.is_Number:
            if float(judge.gas_value) > 3000:
                conclusion = report(f"- The gas limit in {external_call} is {judge.gas_value}, which is too high. Therefore, it will not prevent REE problem.", 8, conclusion)
                need_for_analyze_address.append(external_call)
            else:
                conclusion = report(f"- {external_call} is subjected to gas limits {judge.gas_value}. Therefore, it has no potential REE problem.", 8, conclusion)
        elif judge.judge and not judge.is_Number:
            initialize_code = []
            for fun in slither_contract.functions:
                fun_variables_write = [var.name for var in fun.variables_written]
                if judge.gas_value in fun_variables_write:
                    fun_code_pos = str(fun.source_mapping).split('#')[1]
                    if '-' in fun_code_pos:
                        fun_code_start, fun_code_end = fun_code_pos.split('-')
                    else:
                        fun_code_start = fun_code_pos
                        fun_code_end = fun_code_pos
                    fun_code_list = smart_contract_code[(int(fun_code_start)-1) : (int(fun_code_end))]
                    fun_code = ''.join(fun_code_list)
                    initialize_code.append(fun_code)
            
            messages=[
                {"role": "system", "content": transfer_3},
                {"role": "user", "content": "provided variable: " + judge.gas_value +  " Code: " + str(initialize_code)},
            ]
            result, token = call_template_gpt(messages, Reason)
            total_token += token
            if result.judge:
                conclusion = report(f"- {external_call} is subjected to gas limits {judge.gas_value} <= 3000. Therefore, it has no potential REE problem. Here is the reason: {result.explaination}", 8, conclusion)
            else:
                conclusion = report(f"- {external_call} ISN'T subjected to gas limits. Here is the reason: {result.explaination}", 8, conclusion)
                need_for_analyze_address.append(external_call)
        else:
            conclusion = report(f"- {external_call} ISN'T subjected to gas limits.", 8, conclusion)
            need_for_analyze_address.append(external_call)

    return need_for_analyze_address

def analyze_external_address(need_for_analyze_address, slither_contract, slither_function, smart_contract_code, conclusion, indent=0):
    global total_token
    if need_for_analyze_address == []:
        conclusion = report("No more external call should be analyzed.", indent+4, conclusion)
        return True
    conclusion = report("Analyze External Address", indent+4, conclusion)
    slither_function_variable_read = [var.name for var in slither_function.variables_read if var is not None]
    for external_call in need_for_analyze_address:
        initialize_code = []
        slither_initialize_function = []
        messages=[
                {"role": "system", "content": "Please find the variable among the following variables that appear in this call. If there is none, return []."},
                {"role": "user", "content": f"public variable: {str(slither_function_variable_read)}   call: {external_call.split('.')[0] if '[' not in external_call.split('.')[0] else external_call.split('.')[0].split('[')[0]}"},
            ]
        result, token = call_template_gpt(messages, StateRead)
        total_token += token

        if result.variable == []:
            if 'address(this)' in external_call.split('.')[0]:
                conclusion = report(f"External call {external_call} calls contract address, which consider no REE problem.", indent+8, conclusion)
                continue
            elif 'msgSender' in external_call.split('.')[0]:
                conclusion = report(f"External call {external_call} calls msg.sender, which consider potential REE problem.", indent+8, conclusion)
                conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
                return False
            elif 'msg.sender' in external_call:
                conclusion = report(f"External call {external_call} calls msg.sender, which consider potential REE problem.", indent+8, conclusion)
                conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
                return False
            conclusion = report(f"ERROR!! External call {external_call} has no variable matched.", indent+8, conclusion)
            return False

        if 'msg.sender' in result.variable:
            conclusion = report(f"External call {external_call} calls msg.sender, which consider potential REE problem.", indent+8, conclusion)
            conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
            return False
        if 'this' in result.variable:
            conclusion = report(f"External call {external_call} calls contract address, which consider no REE problem.", indent+8, conclusion)
            continue

        for var in result.variable:
            if (slither_function.get_local_variable_from_name(var) is None) and (slither_contract.get_state_variable_from_name(var) is None):
                continue
            result_variable = var
        try:
            slither_function.get_local_variable_from_name(result_variable)
        except:
            conclusion = report(f"Error! No variable has been found.", indent+8, conclusion)
            conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
            return False

        # result_variable = result.variable[0]
        need_for_check = []

        var = slither_function.get_local_variable_from_name(result_variable)
        flag = False
        if var is None:
            flag = True
            var = slither_contract.get_state_variable_from_name(result_variable)
        for s_var in slither_contract.state_variables:
            if is_dependent(var, s_var, slither_function) and (var.name != s_var.name):
                need_for_check.append(s_var.name)
        if flag and len(need_for_check) == 0:
            need_for_check.append(var.name)

        if need_for_check != []:
            conclusion = report(f"There are {str(need_for_check)} should be checked in variable {result_variable}", indent+8, conclusion)
            for check_var in need_for_check:
                conclusion = report(f"Checked variables: {check_var}", indent+8, conclusion)
                state_variable = check_var
                for fun in slither_contract.functions:
                    fun_state_variables_written = [var.name for var in fun.state_variables_written]
                    if state_variable in fun_state_variables_written:
                        if fun.name == 'slitherConstructorVariables' or fun.name == 'slitherConstructorConstantVariables':
                            initialize_code.append(fun.name)
                            break
                        fun_code_pos = str(fun.source_mapping).split('#')[1]
                        if '-' in fun_code_pos:
                            fun_code_start, fun_code_end = fun_code_pos.split('-')
                        else:
                            fun_code_start = fun_code_pos
                            fun_code_end = fun_code_pos
                        fun_code_list = smart_contract_code[(int(fun_code_start)-1) : (int(fun_code_end))]
                        fun_code = ''.join(fun_code_list)
                        initialize_code.append(fun_code)
                        slither_initialize_function.append(fun)

                if initialize_code == []:
                    conclusion = report("There are no function that assign and initialize this variable. Please further manually check on successor contracts or modifiers.", indent+8, conclusion)
                    continue
                elif 'slitherConstructorVariables' in initialize_code or 'slitherConstructorConstantVariables' in initialize_code:
                    conclusion = report(f"State variable {state_variable} has initialized in public area after declaration.", indent+12, conclusion)
                    continue
                    
                messages=[
                        {"role": "system", "content": address_1},
                        {"role": "user", "content": "Contract name: " + slither_contract.name + " State variable: " + state_variable + " Code: " + str(initialize_code)},
                    ]
                result, token = call_template_gpt(messages, Explaination)
                total_token += token
                conclusion = report(result.judge + ' ' + result.Reason, indent+12, conclusion)
                
                if result.judge == "Yes":
                    continue
                else:
                    for slither_fun in slither_initialize_function:
                        result = analyze_function_security(slither_fun, smart_contract_code, conclusion, 12)
                        if result == False:
                            conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
                            return False
        else:
            flag = False
            if result_variable in [str(x) for x in slither_function.parameters] and slither_function.visibility in ['internal', 'private']:
                conclusion = report(f"The variable '{result_variable}' in external call '{external_call}' has no state variable assigned in {slither_function.canonical_name}. Considering that it is an internal/private function, we analyze the function inputs.", indent+8, conclusion)
                function_parameters = [str(x) for x in slither_function.parameters]
                reachable_function = [x for x in slither_function.reachable_from_functions]
                for func in reachable_function:
                    expression_call_slither_function = [str(x) for x in func.expressions 
                        if re.search(rf'(?<![a-zA-Z]){re.escape(slither_function.name)}(?![a-zA-Z])', str(x))]
                    second_grade_call = []
                    for expression in expression_call_slither_function:
                        messages=[
                            {"role": "system", "content": f"Here are two lists you will receive: the first list contains the parameters of the function {slither_function.canonical_name}, and the second list contains the arguments passed when other functions call this function. Please match the parameter names from the first list with the corresponding arguments from the second list, and return a list. Each element in the list should be a key-value pair, where the key is the parameter from the first list and the value is the argument from the second list."},
                            {"role": "user", "content": str(function_parameters) + str(expression)},
                        ]
                        result, token = call_template_gpt(messages, Match)
                        result = result.result
                        total_token += token
                        for k_v in result:
                            if k_v.key == result_variable:
                                second_grade_call.append(k_v.value)
                                break
                    result = analyze_external_address(second_grade_call, slither_contract, func, smart_contract_code, conclusion, indent+4)
                    
                    if result == False:
                        return False
                flag = True
            if flag == False:
                conclusion = report(f"The variable '{result_variable}' in external call '{external_call}' has no state variable assigned in {slither_function.canonical_name}. Therefore we check whether it has been hardcoded in the function.", indent+8, conclusion)
                fun_code_pos = str(slither_function.source_mapping).split('#')[1]
                if '-' in fun_code_pos:
                    fun_code_start, fun_code_end = fun_code_pos.split('-')
                else:
                    fun_code_start = fun_code_pos
                    fun_code_end = fun_code_pos
                fun_code_list = smart_contract_code[(int(fun_code_start)-1) : (int(fun_code_end))]
                fun_code = ''.join(fun_code_list)
                messages=[
                            {"role": "system", "content": "Please check the provided function whether hardcode the provided variable. If the variable is hardcoded, then output 'Yes', else 'No'."},
                            {"role": "user", "content": "Variable: " + result_variable + " Code: " + fun_code},
                        ]
                result, token = call_template_gpt(messages, Explaination)
                total_token += token
                conclusion = report(result.judge + ' ' + result.Reason, indent+12, conclusion)

                if "Yes" in result.judge:
                        continue
                else:
                    conclusion = report("Conclusion: This function will cause REE Problem.", 0, conclusion)
                    return False
    return True

def analyze_external_call(slither_function, slither_contract, function_call, smart_contract_code, conclusion):
    conclusion = report("External Call Analysis", 0, conclusion)
    direct_external_call = set()
    slither_function_external_call = sorted([str(call).replace(' ', '') for call in slither_function.external_calls_as_expressions], key=len, reverse=True)
    for call in function_call:
        call = call.replace(' ', '')
        for ex_call in slither_function_external_call:
            if ex_call in call:
                direct_external_call.add(ex_call)
                call = call.replace(ex_call, '')
    direct_external_call = list(direct_external_call)
    conclusion = report(f"Direct external call: {str(direct_external_call)}", 4, conclusion)
    need_for_analyze_address = analyze_transfer(direct_external_call, slither_contract, slither_function, smart_contract_code, conclusion)
    conclusion = report(f"Remaining external call: {str(need_for_analyze_address)}", 4, conclusion)

    result = analyze_external_address(need_for_analyze_address, slither_contract, slither_function, smart_contract_code, conclusion)
    if result:
        conclusion = report("Conclusion: This function will not cause REE Problem.", 0, conclusion)
        return True
    else:
        return False

     
def analysis(root, input, slither):
    conclusion = []
    global total_token
    total_token = 0

    # get reentrancy report of each function from slither txt
    Reentrancy_report = get_reentrancy_report(root)

    slither_contract = slither.get_contract_from_name(input.split('.')[0])[0]

    for fun in slither_contract.functions:
        if fun.name == input.split('.')[1]:
            slither_function = fun

    if slither_function.canonical_name not in Reentrancy_report.keys():
        conclusion = report("This function has not been reported by Slither", 0, conclusion)
        conclusion = report("Conclusion: This function will not cause REE Problem.", 0, conclusion)
        return conclusion, 0

    smart_contract_code = get_smart_contract_code(root)
    external_call_in_needed_function = get_all_external_calls(Reentrancy_report, slither_contract, slither_function, conclusion, dict(), set())
    call_graph = build_call_graph(external_call_in_needed_function.keys(), slither_contract)
    visited = set()
    queue = deque([list(external_call_in_needed_function.keys())[0]])
    safe_func = []
    while queue:
        current_node = queue.popleft()
        if current_node not in visited:
            predecessors = list(call_graph.predecessors(current_node))
            if predecessors != [] and all(condition(pred, safe_func) for pred in predecessors):
                safe_func.append(current_node)
                safe_func = add_safe_func(call_graph, current_node, safe_func)
                continue
            visited.add(current_node)

            for neighbor in call_graph.successors(current_node):
                if neighbor not in visited:
                    queue.append(neighbor)
            
            fun_name = current_node
            fun_call = external_call_in_needed_function[current_node]

            slither_function = slither_contract.get_function_from_canonical_name(fun_name)
            if slither_function is None:
                slither_function = slither_contract.get_modifier_from_canonical_name(fun_name)
            conclusion = report('\n', 0, conclusion)
            conclusion = report(f'Start analyze function: {slither_function.canonical_name}', 0, conclusion)
            result = analyze_function_security(slither_function, smart_contract_code, conclusion)
            if result:
                safe_func.append(current_node)
                safe_func = add_safe_func(call_graph, current_node, safe_func)
                conclusion = report("Conclusion: This function will not cause REE Problem.", 0, conclusion)
            else:
                external_call_result = analyze_external_call(slither_function, slither_contract, fun_call, smart_contract_code, conclusion)
                if external_call_result == False:
                    break
        
    return conclusion, total_token
    