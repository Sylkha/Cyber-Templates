#!/usr/bin/python3

import sys, signal, requests

def def_handler(sig, frame):
    print("\n\n[!] Saliendo...\n")
    sys.exit(1)

#Ctrl + C
signal.signal(signal.SIGINT, def_handler)

main_url = "http://127.0.0.1"
squid_proxy = {'http': 'http://192.168.111.39:3128'}

def portDiscovery():
    common_tcp_ports = {20, 21, 22, 23, 25, 53, 67, 68, 69, 80, 88, 110, 119, 123, 135, 137, 138, 139, 143, 161, 162, 179, 389, 443, 445, 514, 515, 587,636, 993, 995, 1080, 1433, 1434, 1723, 3306, 3389, 5060, 5222, 5223, 5900, 5901, 5984, 6379, 8080, 8443, 8888, 9200, 9300, 11211, 27017}
    
    for tcp_port in common_tcp_ports:
        r = requests.get(main_url + ':' + str(tcp_port), proxies=squid_proxy)

        if r.status_code != 503:
            print("\n[+] Port " + str(tcp_port) + " - OPEN")

if __name__ == '__main__':

    portDiscovery()
