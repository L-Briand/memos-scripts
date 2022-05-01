Config behind reverse proxy

```
external_url 'https://my.real.domain'

nginx['listen_port'] = 80
nginx['listen_https'] = false
nginx['proxy_protocol'] = false

letsencrypt['enable'] = false
```

