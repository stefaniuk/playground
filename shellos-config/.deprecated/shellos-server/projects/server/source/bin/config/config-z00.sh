#!/bin/bash

# set up github, SEE: http://help.github.com/win-set-up-git/

GITHUB_KEY_PASS="ThisIsATestOnly"
rm ~/.ssh/keys/github*
ssh-keygen -N $GITHUB_KEY_PASS -f ~/.ssh/keys/github -t rsa -b 4096 -C $ADMIN_MAIL
chmod 400 ~/.ssh/keys/github*
cat <<EOF > ~/github
#!/usr/bin/expect -f
spawn ssh -T git@github.com
expect {
    -re ".*Are.*.*yes.*no.*" {
        send "yes\r"
        exp_continue
    }
}
EOF
chmod 500 ~/github; ~/github; rm ~/github
#ssh-add ~/.ssh/keys/github

#git config --global github.user stefaniuk
#git config --global github.token 0123456789

exit 0
