import requests
from bs4 import BeautifulSoup
from requests.auth import HTTPProxyAuth

proxyDict = { 
          'http'  : '10.49.98.4:8080', 
          'https' : '10.49.98.4:8080'
        }
auth = HTTPProxyAuth('e103448', 'pass')

result = requests.get("http://cdn.redhat.com", proxies=proxyDict, auth=auth)
#result = requests.get("http://www.google.com")

print(result.status_code)