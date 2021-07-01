#!/usr/bin/env python3

import json

if __name__ == '__main__':
    import sys

    args = sys.argv[1:]
    if len(args) < 2:
        print('usage: collect-hashes.py hashtrace.txt hashes.json')
        sys.exit(1)

    result = {}

    for row in open(args[0]).readlines():
        jdata = json.loads(row)
        if jdata['hash'] not in result:
            result[jdata['hash']] = jdata['inputs']

    with open(args[1],'w') as f:
        f.write(json.dumps({'hashes':result}, indent=4))
