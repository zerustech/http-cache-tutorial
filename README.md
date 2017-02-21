# HTTP Cache Tutorial #
This project is a tutorial for HTTP/1.1 caching mechanism and Varnish cache
server. It covers some common topics, best practices, issues, and tricks about HTTP/1.1 caching and Varnish by test cases—each test case consists of a `vcl` file, one or more php files, a `test.sh` file for running the test case, and other related files.

Each test case addresses and resolves a specific problem and it has been created to be as
simple as possible, so that you can concentrate on the most important part of
the solution.

::: info-box note

This tutorial is based on HTTP/1.1 and Varnish 5.0, both are the latest release at the time
of documentation.

The `netcat` or `nc` is needed to run the test cases. You also need update
file `/etc/hosts` (please refer to the test cases for details).

:::

## How to Use This Tutorial ##

### Change Configuration ###

Edit `<base>/bootstrap.sh` and configure the following variables according to your
enviornment:

```bash
#!/bin/bash
...
php_home=<path_to_php_base_directory>
varnish_home=<path_to_varnish_base_directory>

```

### Test Cases ###

This project organizes test cases into the following first-level directories: 

* `<base>/test-cases/default` - default test case
* `<base>/test-cases/http/rfc7232-conditional-requests` - RFC7332 test cases
* `<base>/test-cases/http/rfc7233-range-requests` - RFC7233 test cases
* `<base>/test-cases/http/rfc7234-caching` - RFC7234 test cases
* `<base>/test-cases/varnish` - varnish test cases

### Test Case Directory Structure ###

All test cases share the same directory structure. Take varnish debug test case as an example:

```bash
debug                    # the directory name of the debug test case is "debug"
 \_ bin/test.sh          # the test case script
 |_ etc/config.vcl       # the varnish configuration file
 |_ service
 |   \_ varnish.start    # script for starting varnish
 |   |_ varnish.stop     # script for stopping varnish
 |   |_ php.start        # script for starting php builtin server
 |   |_ php.stop         # script for stopping php builtin server
 |
 |_ web                  # php document root
     \_ index.php        # default php script
     |_ *.php            # other test scripts
     ...                 # ...

```

### Run Multiple Test Cases ###

```bash
$ cd <base>
$
$ # run all test cases interactively in silent mode.
$ bin/app/run.sh test-cases
$
$ # run all test cases interactively in verbose mode.
$ bin/app/run.sh -v test-cases 
$
$ # run all test cases automatically in silent mode.
$ bin/app/run.sh -a test-cases
$
$ # run all test cases automatically in verbose mode.
$ bin/app/run.sh -a -v test-cases
$
$ # Usage of run.sh:
$ # run.sh [-iasv] [-l log_file] <test_case_dir>
$ # The options are as follows:
$ #     -i Request confirming before running each test case.
$ #     -a Run all test cases automatically.
$ #     -s Do not display any output from the test cases (default).
$ #     -v Display output from test cases.
```

### Run Single Test Case ###

Take the varnish debug test cases for example:
```bash
$ cd <base>
$ cd test-cases/varnish/debug
$ bin/test.sh
```

::: info-box note

NOTE: when running test cases with `run.sh` or `test.sh`, the varnish cache
server and php builtin web servers will be started and stopped automatically.

:::

### Start and Stop Servers ###
Sometimes, you may want to manually start and stop the varnish and php servers.
Take the varnish debug test cases for example:
```bash
$ cd <base>
$ cd test-cases/varnish/debug
$ service/varnish.start
$ service/varnish.stop
$ service/php.start
$ service/php.stop
```

# References #
* [Varnish 5.0 Tutorial][2]
* [Varnish 5.0 Users Guide][3]
* [Varnish 5.0 Reference Manual][4]
* [HTTP/1.1 Conditional Requests][5]
* [HTTP/1.1 Range Requests][6]
* [HTTP/1.1 Caching][7]
* [Varnish Configuration for FOS Http Cache][8]

[1]: https://opensource.org/licenses/MIT "The MIT License (MIT)"
[2]: https://www.varnish-cache.org/docs/trunk/tutorial/index.html "Varnish 5.0 Tutorial"
[3]: https://www.varnish-cache.org/docs/trunk/users-guide/ "Varnish 5.0 Users Guide"
[4]: https://www.varnish-cache.org/docs/trunk/reference/index.html "Varnish 5.0 Reference Manual"
[5]: https://tools.ietf.org/html/rfc7232 "HTTP/1.1 Conditional Requests"
[6]: https://tools.ietf.org/html/rfc7233 "HTTP/1.1 Range Requests"
[7]: https://tools.ietf.org/html/rfc7234 "HTTP/1.1 Caching"
[8]: http://foshttpcache.readthedocs.io/en/stable/proxy-configuration.html#proxy-configuration "Varnish Configuration for FOS Http Cache"

# License #
This tutorial is published under the [MIT License][1].
