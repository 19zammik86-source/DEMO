apt-get update && apt-get install -y openssl-gost-engine

control openssl-gost enabled

openssl req -new -x509 -md_gost12_256 -days 30 -newkey gost2012_256 -pkeyopt paramset:A -keyout ca.key -out ca.cer -nodes -subj "/C=RU/O=au-team.irpo/CN=hq-srv.au-team.irpo"

openssl req -new -md_gost12_256 -newkey gost2012_256 -pkeyopt paramset:A -nodes -keyout web.au-team.irpo.key -out web.au-team.irpo.csr -subj "/C=RU/O=au-team.irpo/CN=web.au-team.irpo"

openssl x509 -req -md_gost12_256 -days 30 -in web.au-team.irpo.csr -CA ca.cer -CAkey ca.key -CAcreateserial -out web.au-team.irpo.cer

openssl req -new -md_gost12_256 -newkey gost2012_256 -pkeyopt paramset:A -nodes -keyout docker.au-team.irpo.key -out docker.au-team.irpo.csr -subj "/C=RU/O=au-team.irpo/CN=docker.au-team.irpo"

openssl x509 -req -md_gost12_256 -days 30 -in docker.au-team.irpo.csr -CA ca.cer -CAkey ca.key -CAcreateserial -out docker.au-team.irpo.cer

scp web.au-team.irpo.key root@172.16.1.1:~/
scp web.au-team.irpo.cer root@172.16.1.1:~/
scp docker.au-team.irpo.key root@172.16.1.1:~/
scp docker.au-team.irpo.cer root@172.16.1.1:~/
