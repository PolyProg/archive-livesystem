#!/bin/sh

base_url="http://http.kali.org/pool/main/l/live-build/"
package=`curl ${base_url} 2>/dev/null | grep ".deb" | tr \" "\n" | grep ".deb" | grep -v ">" | grep "kali"  | grep -v "cgi"`

echo "Install live-build with UEFI support*"

curl -L -o "/tmp/${package}" "${base_url}${package}" 2>/dev/null

dpkg -i "/tmp/${package}"
rm "/tmp/${package}"

