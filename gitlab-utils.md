VM instead of CT.

Config behind reverse proxy :

`/etc/gitlab/gitlab.rb`

```rb
external_url 'https://my.real.domain'

nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['proxy_protocol'] = false

letsencrypt['enable'] = false
gitlab_rails['gitlab_shell_ssh_port'] = 10022
```

`/etc/ssh/sshd_config`

```
Port 10022
```