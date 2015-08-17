#!/usr/bin/python
import sys, os, shutil
import urllib3
http = urllib3.PoolManager()
filename = sys.argv[1] + ".tar.gz"
aururl = 'https://aur.archlinux.org/cgit/aur.git/snapshot/' + filename
print('=> Downloading ' + filename)
urllib3.disable_warnings()
with http.request('GET', aururl, preload_content=False) as r, open(filename, 'wb') as out:
    print('==> Trying ' + aururl)
    if not r.status == 404:
        shutil.copyfileobj(r, out)
    else:
        print('===> Not found')
