import subprocess
import re
import sys
import os
from packaging.version import Version
from slither.slither import Slither

def switch_solidity_version(version):
    try:
        subprocess.run(
            ['solc-select', 'use', version],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL
        )
    except subprocess.CalledProcessError:
        print(f"Failed to switch to Solidity version {version}. Please make sure the version is installed.")
        sys.exit(1)

def get_installed_versions():
    try:
        result = subprocess.run(['solc-select', 'versions'], capture_output=True, text=True, check=True)
        versions = result.stdout.splitlines()

        for i in range(len(versions)):
            versions[i] = versions[i].split('(')[0].strip()
        return versions
    except subprocess.CalledProcessError:
        print("Failed to retrieve installed Solidity versions.")
        sys.exit(1)

def process_solidity_files(file_path):
    installed_versions = get_installed_versions()
    
    for version in installed_versions:
        switch_solidity_version(version)
        try:
            slither = Slither(file_path)
            if str(slither.contracts[0].source_mapping) != '':
                return slither
            else:
                continue
        except:
            continue
    return False


def switch_solc_version(input_path):
    return process_solidity_files(input_path)
