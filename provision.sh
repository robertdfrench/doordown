#!/bin/bash -ex
pkgin -y install \
	gcc8-8.2.0 \
	git-2.19.1 \
	gmake-4.2.1nb1 \
	libmicrohttpd-0.9.57nb4

git init --bare doordown.git
cat <<EOF > doordown.git/hooks/post-receive
#!/bin/bash -e
PATH=/usr/local/sbin:/usr/local/bin:/opt/local/sbin:/opt/local/bin:/usr/sbin:/usr/bin:/sbin:/opt/local/gcc8/bin

build() {
        read branch
        echo -e "\e[31m# $$branch\e[0m"
	rm -rf /tmp/$$branch
        mkdir /tmp/$$branch
        git worktree add /tmp/$$branch $$branch
        cd /tmp/$$branch
        make build
}

awk '{ print $3 }' | build
EOF
chmod +x doordown.git/hooks/post-receive
