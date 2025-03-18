import os
import re
import subprocess
import textwrap
import networkx as nx
import matplotlib.pyplot as plt
from collections import deque

def report(text, indent, conclusion):
    str_indent = ''
    for i in range(indent):
        str_indent += ' '
    formatted_text = textwrap.fill(text, width=170, subsequent_indent=str_indent, initial_indent=str_indent)
    conclusion.append(formatted_text)
    print(formatted_text)
    return conclusion

def condition(ele, arr):
    if ele in arr:
        return True
    else:
        return False

def log(conclusion, address):
    with open(address, 'w') as file:
        for line in conclusion:
            file.write(line + '\n')

def get_reentrancy_report(root):
    result = subprocess.run(f'slither {root}', shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
    lines = result.stderr.split('\n')
    Reentrancy_report = dict()
    flag = False
    external_calls_start = False
    for line in lines:
        if len(line) == 0:
            continue
        if line.startswith('Reentrancy in'):
            function_name = line.split(' ')[2]#.split('.')[1].split('(')[0]
            if function_name not in Reentrancy_report.keys():
                flag = True
                Reentrancy_report[function_name] = line + '\n'
            else:
                flag = True
                Reentrancy_report[function_name] += line + '\n'
        elif flag:
            if 'External calls:' in line or 'External calls sending eth' in line: 
                external_calls_start = True 
                Reentrancy_report[function_name] += line + '\n'
            elif external_calls_start and '-' not in line:
                external_calls_start = False 
            elif external_calls_start:
                Reentrancy_report[function_name] += line + '\n'
            else:
                continue
        elif line[0] != '\t' and flag:
            flag = False
            external_calls_start = False
        elif flag == False:
            continue
    return Reentrancy_report

def get_smart_contract_code(root):
    with open(os.path.join(root), 'r') as file:
        lines = file.readlines()
    return lines

def get_function_from_position(slither_contract, line_num):
    for function in slither_contract.functions:
        if function.name == 'slitherConstructorVariables' or function.name == 'slitherConstructorConstantVariables':
            continue
        fun_code_pos = str(function.source_mapping).split('#')[1]
        if '-' in fun_code_pos:
            fun_code_start, fun_code_end = fun_code_pos.split('-')
        else:
            fun_code_start = fun_code_pos
            fun_code_end = fun_code_pos
        if int(line_num) >= int(fun_code_start) and int(line_num) <= int(fun_code_end):
            return function
    for modifier in slither_contract.modifiers:
        fun_code_pos = str(modifier.source_mapping).split('#')[1]
        if '-' in fun_code_pos:
            fun_code_start, fun_code_end = fun_code_pos.split('-')
        else:
            fun_code_start = fun_code_pos
            fun_code_end = fun_code_pos
        if int(line_num) >= int(fun_code_start) and int(line_num) <= int(fun_code_end):
            return modifier
    return False

def get_all_external_calls(Reentrancy_report, slither_contract, slither_function, conclusion, external_call_dict, visited):
    if slither_function.canonical_name not in external_call_dict.keys():
        external_call_dict[slither_function.canonical_name] = []
    if slither_function.canonical_name not in Reentrancy_report.keys():
        return external_call_dict
    if slither_function.canonical_name in visited:
        return external_call_dict
    else:
        visited.add(slither_function.canonical_name)
    function_slither_report = Reentrancy_report[slither_function.canonical_name]
    function_slither_report_list = function_slither_report.split('\n')
    unknow_external_call = []
    unfinished_internal_call = []
    i = 0
    while i < len(function_slither_report_list):
        if slither_function.canonical_name not in external_call_dict.keys():
            external_call_dict[slither_function.canonical_name] = []
        line = function_slither_report_list[i]
        
        if line.startswith('\t- ') and i != len(function_slither_report_list)-1 and function_slither_report_list[i+1].startswith('\t\t'):
            unfinished_internal_call.append(line[2:].strip())
        elif line.startswith('\t\t'):
            unknow_external_call.append(function_slither_report_list[i][3:].strip())
        elif line.startswith('\t- '):
            external_call_dict[slither_function.canonical_name].append(line[2:].strip())
        i += 1

    pattern = re.compile(r'\([^\)]*\)(?!.*\()')
    for call in list(set(unknow_external_call)):
        match = pattern.search(call)
        position = match.group(0)
        line = position.split('#')[-1][:-1]
        if '-' in line:
            line = line.split('-')[0]
        function = get_function_from_position(slither_contract, line)
        if function == False:
            continue
        if function.canonical_name not in external_call_dict.keys():
            external_call_dict[function.canonical_name] = []
        external_call_dict[function.canonical_name].append(call)
    for call in list(set(unfinished_internal_call)):
        slither_function_internal_call = slither_function.internal_calls
        for s_call in slither_function_internal_call:
            if ('require' in s_call.name) or ('assert' in s_call.name) or ('balanceOf' in s_call.name) or ('msgSender' in s_call.name) or ('abi.' in s_call.name):
                continue
            if s_call.name in call:
                get_all_external_calls(Reentrancy_report, slither_contract, s_call, conclusion, external_call_dict, visited)
                call = call.replace(s_call.name, '')
    return external_call_dict

def build_call_graph(function_list, slither_contract):
    call_graph = nx.DiGraph()
    for func in function_list:
        call_graph.add_node(func)
    for func in function_list:
        slither_func = slither_contract.get_function_from_canonical_name(func)
        if slither_func is None:
            continue
        reachable_functions = slither_func.reachable_from_functions
        reachable_functions = [f.canonical_name for f in reachable_functions if f.canonical_name in function_list]
        for caller in reachable_functions:
            call_graph.add_edge(caller, func)

        called_modifiers = [m.canonical_name for m in slither_func.modifiers if m.canonical_name in function_list]
        for callee in called_modifiers:
            call_graph.add_edge(func, callee)
    
    start_node = list(function_list)[0]
    level_dict = {} 
    visited = set()
    queue = deque([start_node])
    level_dict[start_node] = 0
    visited.add(start_node)

    while queue:
        current_node = queue.popleft()
        if current_node not in visited:
            visited.add(current_node)
            for neighbor in call_graph.successors(current_node):
                if neighbor not in visited:
                    level_dict[neighbor] = level_dict[current_node] + 1
                    queue.append(neighbor)
    
    nodes_with_zero_in_degree = [node for node, in_degree in call_graph.in_degree() if (in_degree == 0 and node != start_node)]
    for node in nodes_with_zero_in_degree:
        slither_func = slither_contract.get_function_from_canonical_name(node)
        if slither_func is None:
            continue
        all_reachable_functions = [[f.canonical_name, level_dict[f.canonical_name]] for f in slither_func.all_reachable_from_functions if (f.canonical_name in function_list and f.canonical_name in level_dict.keys())]
        if all_reachable_functions == []:
            continue
        lowest_node = sorted(all_reachable_functions, key=lambda x: x[1], reverse=True)[0][0]
        call_graph.add_edge(lowest_node, node)

    # save_call_graph(call_graph, filename="call_graph.png")
    # exit()
    return call_graph

def save_call_graph(call_graph, filename="call_graph.png"):
    pos = nx.spring_layout(call_graph)

    nx.draw_networkx_nodes(call_graph, pos, node_size=200, node_color='lightblue')

    nx.draw_networkx_edges(call_graph, pos, arrowstyle='->', arrowsize=10, edge_color='gray')

    labels = {node: node for node in call_graph.nodes}
    nx.draw_networkx_labels(call_graph, pos, labels, font_size=6)

    plt.title("Call Graph")
    plt.axis('off') 
    plt.savefig(filename, format="png", bbox_inches="tight")
    plt.close() 
    print(f"Call graph saved to {filename}")

def count_parameters(code):
    stake = deque()
    pattern = re.compile(r'.transfer\s*\(')
    match = pattern.search(code)
    if match:
        transfer_code = code[match.start()+9:]
    else:
        pattern = re.compile(r'.send\s*\(')
        match = pattern.search(code)
        if match:
            transfer_code = code[match.start()+5:]
        else:
            return 2
    if transfer_code == "();":
        return 0
    stake.append(transfer_code[0])
    i = 1
    param_count = 1
    while len(stake) != 0:
        char = transfer_code[i]
        if char == '(':
            stake.append(char)
        if char == ')':
            stake.pop()
        if char == ',' and len(stake) == 1:
            param_count += 1
        i += 1
    return param_count

def add_safe_func(call_graph, current_node, safe_func):
    successors = list(call_graph.successors(current_node))
    for nei in successors:
        if call_graph.in_degree(nei) == 1 and nei not in safe_func:
            safe_func.append(nei)
            add_safe_func(call_graph, nei, safe_func)
    return safe_func