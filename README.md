# gather-metrics
## About
This is a small coding challenge, meant to be a toy.

It's meant to be run, say, via `cron`.
It will gather metrics and submit them to Datadog, or more likely, to a mock server.
It currently gathers:
* is `aes` available on this cpu?
* how much of the root volume is in use?

## Set up
Let's use [Vagrant!](https://www.vagrantup.com/)
Run `vagrant up` to download images and set up the environment.

## Running
We'll want two terminals. 

### Start the server
Once the environment is set up, in one terminal, run `vagrant ssh`, then `/vagrant_data/mock-httpd.sh`.
This is a mock server: every request gets a 200 response, and the request is fully printed to the terminal.

### Gather metrics
In the other terminal, run:
```
vagrant ssh
# wait for connection
cd /vagrant_data/
./gather-metrics.rb
```

It should read `config.yml` and make the request of the mock server above, which should show some JSON.

## Adding more checks
Add executable files in `shared_data/herd`, and a reference in `config.yml`.
The executable files should emit `key=value` on completion.
Examples to add: SMART data and ECC corrected errors, but my usual Linux box is out of order.

## Older version
See `shared_data/check-metric-shell.sh` for the first quick-and-dirty version.
The configuration is part of the script.
Timeouts aren't handled.

## Misc notes
### Environment
I tested this on Ubuntu 14.04, but it should work on other Linuxes.
There's a `Vagrantfile` if you'd like to spin up a disposable environment for testing.

### Choices made
I considered httparty for http requests, but it wasn't available with the given version of Ruby.

I considered the dogapi gem, but getting debug output seemed too complicated for the time constraints.

I could have rewritten the json generation, using Ruby hashes, but I already had something that worked.
I considered erb to generate the json, but I didn't realize at the time that it was installed.

If a check times out, we could submit an error, but in this case, we don't submit anything, and we can have Datadog alert upon the absense of metrics.


