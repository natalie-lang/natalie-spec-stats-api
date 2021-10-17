# Natalie Spec Stats API

This little app has one job: accept stats POSTed from our nightly spec runner.

## Local Development

```sh
bundle install
echo super-duper-secret > secret.txt
ruby app.rb
```

The corresponding code in the spec runner is [here](https://github.com/seven1m/natalie/blob/3b2efde2ccd1100b5aabbb79b2c48baee246ae84/spec/support/ruby_spec_runner.rb#L73-L82).
