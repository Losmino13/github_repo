#!/usr/bin/env python

import urllib.request
from bs4 import BeautifulSoup 
from array import *

#req=urllib.request.urlopen('https://www.b92.net/sport/vesti.php?start=40')
#print(req.status)



proxy_handler = urllib.request.ProxyHandler({'http': 'http://10.49.98.4:8080'})
#proxy_auth_handler = urllib.request.ProxyBasicAuthHandler()
#proxy_auth_handler.add_password('realm', 'host', 'username', 'password')

opener = urllib.request.build_opener(proxy_handler)
# This time, rather than install the OpenerDirector, we use it directly:
page_array = array('i', [20,40,60,80,100,120])
page_content = ''
page_content_all = ''
for i in page_array:
    url = f"https://www.b92.net/sport/vesti.php?start={i}"
    req = opener.open(url)
#print(req.status)

    page_content = req.read()
    page_content_all = page_content_all + str(page_content, 'utf-8', errors="replace")

#print(page_content_all)
soup = BeautifulSoup(page_content_all, features="html.parser")
#var = ''
#print(soup.prettify())


for i in soup.find_all('section', class_="blog"):
    var = i.findChildren('h2', recursive=True)
    for k in var:
        print (k.text)



#moze i ovako jer je samo h2 na tom nivou
#for i in soup.find_all('h2'):
    #print(i.text)
    #print (var)
    #print ("Found the URL:", i['href'], i.get_text())


#################################################################################
# # import urllib3
# # import requests
# # from bs4 import BeautifulSoup
# # from requests.auth import HTTPProxyAuth

# # proxyDict = { 
# #           'http'  : '10.49.98.4:8080', 
# #           'https' : '10.49.98.4:8080'
# #         }
# # auth = HTTPProxyAuth('e1083448', 'pass')

# # headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36'}


# # result = requests.get("https://google.com", headers=headers, proxies=proxyDict, auth=auth)
# # #result = requests.get("http://cdn.redhat.com", proxies=proxyDict, auth=auth)
# # #result = requests.get("http://www.google.com")

# # print(result.status_code)


# import urllib.request, socket

# socket.setdefaulttimeout(180)

# # read the list of proxy IPs in proxyList
# proxyList = ['10.49.98.44:8080'] # there are two sample proxy ip    