# Import libs
import boto3
import logging
import os
import subprocess
import sys
import requests
import pprint
import argparse

# Logger Configuration
logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p',
                    level=logging.INFO)
pp = pprint.PrettyPrinter(indent=2)

#credentials
access_key_id = os.environ.get('AWS_ACCESS_KEY_ID')
secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY')
session_token = os.environ.get('AWS_SESSION_TOKEN')
ß
env='DEV'

regions = ['us-east-1', 'eu-west-1', 'ap-northeast-1']

for region in regions:
    conn = boto3.client('sdb', region_name=region,
                        aws_access_key_id=access_key_id,
                        aws_secret_access_key=secret_access_key,
                        aws_session_token=session_token)


    simple_db_data = conn.list_domains()
    #simple_db_data = conn.domain_metadata(DomainName='deployr-timing')
    #pp.pprint(simple_db_data)

    for key in simple_db_data:
        if key == 'DomainNames':
            print("SimpleDB DomainNames: "+ env + " - " + region)
            #print("\n")
            pp.pprint(simple_db_data[key])
        
