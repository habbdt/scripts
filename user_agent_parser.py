#!/usr/bin/env python3.9

# import libraries

import sys
import httpagentparser
import json

input_file = sys.argv[1]

with open(input_file, 'r') as file:
    for line in file:
        json_str = json.loads(line)
        for key in json_str:
            agent_version= json_str[key]
            print(httpagentparser.simple_detect(agent_version))