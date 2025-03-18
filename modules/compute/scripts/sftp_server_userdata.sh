#!/bin/bash
#yum update -y
#yum install -y openssh-server
systemctl enable sshd
systemctl start sshd
mkdir /home/sftpuser
useradd -d /home/sftpuser -m sftpuser
echo "sftpuser:toor" | chpasswd
mkdir /home/sftpuser/upload
echo "Hello, this is a test file from Emmanuel" > /home/sftpuser/upload/TestFile.txt
chown sftpuser:sftpuser /home/sftpuser/upload
chmod 755 /home/sftpuser/upload
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl restart sshd