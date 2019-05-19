#!/bin/bash -ex
PATH=$PATH:/opt/local/bin
pkgin -y install \
	gcc8-8.2.0 \
	git-2.19.1 \
	gmake-4.2.1nb1 \
	libmicrohttpd-0.9.57nb4
echo 'PATH=$PATH:/opt/local/gcc8/bin' >> ~/.profile

git init --bare /root/doordown.git
cat <<EOF > /root/doordown.git/hooks/post-receive
#!/bin/bash -e
PATH=/usr/local/sbin:/usr/local/bin:/opt/local/sbin:/opt/local/bin:/usr/sbin:/usr/bin:/sbin:/opt/local/gcc8/bin

build() {
        read branch
        echo -e "\\e[31m# \$branch\\e[0m"
	rm -rf /tmp/\$branch
        mkdir -p /tmp/\$branch
        git worktree add /tmp/\$branch \$branch
        cd /tmp/\$branch
        make build
}

awk '{ print \$3 }' | build
EOF
chmod +x /root/doordown.git/hooks/post-receive
