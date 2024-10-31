# hack to install any additional certificates 


docker exec -it kind-control-plane /usr/bin/bash -c \
"
echo 'Installing certificates inside kind' \
&& curl -ks 'http://my.crl/Certificates/cert0.cer' -o '/usr/local/share/ca-certificates/cert0.crt' \
&& curl -ks 'http://my.crl/Certificates/cert1.cer' -o '/usr/local/share/ca-certificates/cert1.crt' \
&& /usr/sbin/update-ca-certificates \
&& systemctl restart containerd && systemctl status containerd
"

