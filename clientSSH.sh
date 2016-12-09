ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
chmod 700 ~/.ssh && chmod 600 ~/.ssh/*
cat ~/.ssh/id_rsa.pub | ssh root@10.2.0.253
