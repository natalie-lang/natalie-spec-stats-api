# Natalie Spec Stats API

This little app has one job: accept stats POSTed from [Natalie's](https://github.com/seven1m/natalie) nightly spec runner.

## Local Development

```sh
bundle install
echo super-duper-secret > secret.txt
ruby app.rb
```

The corresponding code in the spec runner is [here](https://github.com/natalie-lang/natalie/blob/99df60fd6a25d9b77dcdbb4b08f0ccfccd746afe/spec/support/nightly_ruby_spec_runner.rb#L120-L130).

## Dokku Config

For my (Tim's) benefit, here is the Dokku config which hosts this app:

```sh
$ dokku config:show stats.natalie-lang.org | egrep -v "GIT_REV|SECRET"
=====> stats.natalie-lang.org env vars
DOKKU_APP_RESTORE:     1
DOKKU_APP_TYPE:        herokuish
DOKKU_PROXY_PORT:      80
DOKKU_PROXY_PORT_MAP:  http:80:5000 https:443:5000
DOKKU_PROXY_SSL_PORT:  443

$ dokku storage:list stats.natalie-lang.org
stats.natalie-lang.org volume bind-mounts:
     /var/lib/dokku/data/storage/natalie-lang-stats:/app/storage
     
$ dokku docker-options:report stats.natalie-lang.org
=====> stats.natalie-lang.org docker options information
       Docker options build:                                   
       Docker options deploy:         --restart=on-failure:10 -v /var/lib/dokku/data/storage/natalie-lang-stats:/app/storage 
       Docker options run:            -v /var/lib/dokku/data/storage/natalie-lang-stats:/app/storage 
       
$ dokku proxy:ports stats.natalie-lang.org
-----> Port mappings for stats.natalie-lang.org
    -----> scheme  host port  container port
    http           80         5000
    https          443        5000
```
