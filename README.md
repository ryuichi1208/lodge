# lodge
CI/CD pipeline

#### localでの検証

``` bash
# リポジトリのルートで実行
$ docker run -it -v `pwd`:/home/circleci --workdir=/home/circleci circleci/python:3.6.5 /bin/bash

# 以下コンテナ内
circleci@fe6492b1eaa9:~$ cat /etc/debian_version
9.4

circleci@fe6492b1eaa9:~$ uname -a
Linux fe6492b1eaa9 3.10.0-957.10.1.el7.x86_64 #1 SMP Mon Mar 18 15:06:45 UTC 2019 x86_64 GNU/Linux

circleci@fe6492b1eaa9:~$ which python ; python --version
/usr/local/bin/python
Python 3.6.5
```
