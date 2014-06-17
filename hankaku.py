#!/usr/bin/env python

import re
import sys
import struct

def main():
    print("unsigned char hankaku[0x100][16] = {")
    
    while True:
        l = sys.stdin.readline()
        if not l: break
        if re.search(r'^char (0x..)', l):
            print('{')
            while True:
                l = sys.stdin.readline()
                if not l: break
                if re.search(r'^\s*$', l): break
                print('0x%x,' % int(l[:-1].replace('.','0').replace('*', '1'), 2))
            print('},')
    print('};')

if __name__ == '__main__':
    main()
    
