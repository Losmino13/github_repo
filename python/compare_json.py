# Comparing chef server environment attributes with policyfile attributes
# get environment attributes 
# knife environment show env_name -F json > ~/env_name.json
# push policy with simple run_list like this:
#
# output="#{Chef::JSONCompat.to_json_pretty(node.to_hash)}"
# file '/tmp/policy_env_name.json' do
#   content output
# end
# 
# Run script against those two json files


import json
import pprint
import collections
import argparse
import warnings
warnings.filterwarnings("ignore")

def update_it(orig_dict, new_dict):
    for key, val in new_dict.items():
        if isinstance(val, collections.Mapping):
            tmp = update_it(orig_dict.get(key, { }), val)
            orig_dict[key] = tmp
        elif isinstance(val, list):
            orig_dict[key] = (orig_dict.get(key, []) + val)
        else:
            orig_dict[key] = new_dict[key]
    return orig_dict

def parse_env_json(json_file, attr):
    env_map = {}
    for k, v in json_file.items():
        if k in lookup_keys:
            for kk, vv in v.items():
                if kk in env_dict:
                    update_it(env_dict[kk],vv)
                    #env_dict[kk].update(vv)
                else:
                    env_dict[kk] = vv

def compare():
    for k,v in env_dict.items():
        if not k in policy_data:
            print("------------------------------------------------")
            print("This attribute(key) is not in policy file attributes")
            print(k,v)
            print("------------------------------------------------") 
        for kk in policy_data:
            if kk == k:
                if env_dict[k] != policy_data[kk]:
                    print("-----------DIFFS-----------")
                    print("environment attributes\n") 
                    print(k,env_dict[k])
                    print("\n")
                    print("policy environment attributes\n")
                    print(kk,policy_data[kk])
    print("NO DIFFS")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Comparing environment and policyfile attributes')
    parser.add_argument('--json_file1',
                        help='First json to compare')
    parser.add_argument('--json_file2',
                        help='Second json to compare')
    args = parser.parse_args()

    json_file1 = args.json_file1
    json_file2 = args.json_file2

    with open(json_file1, 'r') as json_file:
        environment_data = json.load(json_file)  

    with open(json_file2, 'r') as json_file:
        policy_data = json.load(json_file)  


    lookup_keys = ["default_attributes", "override_attributes"]
    env_dict = dict()

    parse_env_json(environment_data, lookup_keys)
    compare()
