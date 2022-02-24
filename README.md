# Born2beroot with Debian OS

## Sudo

1. Login as root
```sh
$ su
```
2. Install sudo
```sh
$ apt-get update -y
$ apt-get upgrade -y
$ apt-get install sudo
```
3. Add user in sudo group
```sh
$ su -
$ usermod -aG sudo YOUR_USERNAME
```
4. Verify if user is in sudo group
```sh
$ genet group sudo
```


