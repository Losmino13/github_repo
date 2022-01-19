# Import libs
import boto3
import logging
import os
import subprocess
import sys
import requests
import pprint
import argparse
import datetime

# Logger Configuration
logging.basicConfig(format='%(asctime)s - %(levelname)s - %(message)s', datefmt='%m/%d/%Y %I:%M:%S %p',
                    level=logging.INFO)
pp = pprint.PrettyPrinter(indent=2)

#credentials
access_key_id = os.environ.get('AWS_ACCESS_KEY_ID')
secret_access_key = os.environ.get('AWS_SECRET_ACCESS_KEY')
session_token = os.environ.get('AWS_SESSION_TOKEN')

env='DEV_IRL1_VA6'
regions = ['us-east-1', 'eu-west-1', 'ap-northeast-1']

now = datetime.datetime.now()
time_sufix = now.strftime("%H:%M:%S")

for region in regions:
        with open("/Users/milosmilisavljevic/dev/issues/SimpleDB_sunset/sdb_"+env+"__"+region+".txt", "w") as out:
            conn = boto3.client('sdb', region_name=region,
                                aws_access_key_id=access_key_id,
                                aws_secret_access_key=secret_access_key,
                                aws_session_token=session_token)

            simple_db_data = conn.list_domains()
            
            for key,value in simple_db_data.items():
                if key == 'DomainNames':
                    for v in value:
                        header = "SimpleDB DomainNames: "+ env + " - " + region
                        domain_metadata = conn.domain_metadata(DomainName=v)
                        now = datetime.datetime.now()
                        out.write(str(now)+"\n")
                        out.write(pprint.pformat(header)+"\n")
                        out.write(v+"\n")
                        out.write(pprint.pformat(domain_metadata)+"\n")