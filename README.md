# HTTP Cache Tutorial #
This project is a tutorial for HTTP/1.1 caching mechanism and Varnish cache
server. It describes the common topics, best practices, issues, and tricks in
terms of test cases—each test case consists of a `vcl` file, one or more php files,
a `test.sh` file for running the test case, and other related files.

Each test case addresses and resolves a specific problem and it has been created
to be as simple as possible to only present the principle or algorithm, but
nothing else, to the readers. You may find long and detailed code
comments in the source code of some test cases, make sure to read them carefully,
because that is the way we document things in this tutorial.

Bascially, test cases are organized into two big categories: HTTP and Varnish
test cases.

The HTTP test cases are intended for implementing and explaining
scenarios/algorithms in RFC specifications of caching machanism, including
[RFC7232][5], [RFC7233][6], and [RFC7234][7].

Varnish is used as the cache implementation for all test cases, because it is
widely used by other professionals and is also our first choice for caching
solution in our web projects. Unfortunately, it does not conform to all RFC
specifications, such as it ignores all request `Cache-Control` directives as
well as the `Pragma: no-cache` header field by default; it does not support
multiple byte ranges in range request; it does not conform to the algorithm,
recommended by RFC, when generating a heuristic freshness lifetime. In order to
present those scenarios that are not supported by Varnish, custom `vcl` files
have been developed.

The Varnish test cases are intended for presenting common best practices of
Varnish, such as banning objects by tags, restarting a request, content
negotiation with `Vary` header field, cookie manipulation, and user context
hash.

We will add more test cases in the future, when new scenarios or best practices
are available.

::: info-box note

This tutorial is based on HTTP/1.1 and Varnish 5.0, both are the latest releases
at the time of documentation.

The `netcat` or `nc` is needed to run the test cases. You also need update
file `/etc/hosts` (please refer to the test cases for details).

:::

## Directory Structure ##

The directory structure of this project is as follows:

```bash
<base>             # project base directory
  \_ bin
  |   \_ task      # scripts for starting/stopping test cases
  |   |_ varnish   # varnish management scripts (e.g., starting varnish server).
  |
  |_ docs          # documents
  |_ etc           # varnish builtin vcl file and secret key file
  |
  |_ test-cases
  |   \_ default   # default test cases
  |   |
  |   |_ http
  |   |   \_ rfc7232-conditional-requests   # rfc7232 test cases
  |   |   |_ rfc7233-range-requests         # rfc7233 test cases
  |   |   |_ rfc7234-caching                # rfc7234 test cases
  |   |   |_ ...                            # ...
  |   |
  |   |_ varnish
  |       \_ ban-by-tags   # varnish test cases for banning contents by tags
  |       |_ ban-by-url    # varnish test cases for banning contents by url
  |       |_ debug         # varnish test cases for debugging cache
  |       |_ ...           # ...
  |
  |_ var                   # log and pid files

```

## How to Use This Tutorial ##

### Install Composer Dependencies ###

```bash
$ cd <base>
$ composer install
```

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
     |_ ...              # ...

```

### Run Multiple Test Cases ###

```bash
$ cd <base>
$
$ # run all test cases interactively in verbose mode.
$ bin/tasks/task.all.run
$
$ # run all test cases in http folder interactively in verbose mode.
$ bin/tasks/task.all.run test-cases/http
$
$ # run all test cases automatically.
$ bin/tasks/task.all.run -a
$
$ # run all test cases in scilent mode.
$ bin/tasks/task.all.run -s
$
$ # run all test cases in verbose mode.
$ bin/tasks/task.all.run -v
$
$ # Usage of task.all.run:
$ # task.all.run: usage: task.all.run [-avs] [-l log_file] [-e task_exec]
$ # [-p path_pattern] [-n name_pattern] [-d depth|min+|min-max] path
$ # [task_arguments ...]
$ #
$ # The options are as follows:
$ # -a Run all tasks automatically.
$ # -v Run all tasks in verbose mode: display output from tasks to stdout.
$ # -s Run all tasks in scilent mode: hide output from tasks.
```

### Run Single Test Case ###

Take the varnish debug test case for example:
```bash
$ cd <base>
$ cd test-cases/varnish/debug
$ bin/test.sh
```

::: info-box note

NOTE: when running test cases with `task.all.run` or `test.sh`, both the varnish
cache server and the php builtin web server are started and stopped automatically.

:::

### Start and Stop Servers ###
Sometimes, you may want to manually start and stop the varnish and php servers.
Take the varnish debug test case for example:
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
* [The zerustech/cli project][9]

[1]: https://opensource.org/licenses/MIT "The MIT License (MIT)"
[2]: https://www.varnish-cache.org/docs/trunk/tutorial/index.html "Varnish 5.0 Tutorial"
[3]: https://www.varnish-cache.org/docs/trunk/users-guide/ "Varnish 5.0 Users Guide"
[4]: https://www.varnish-cache.org/docs/trunk/reference/index.html "Varnish 5.0 Reference Manual"
[5]: https://tools.ietf.org/html/rfc7232 "HTTP/1.1 Conditional Requests"
[6]: https://tools.ietf.org/html/rfc7233 "HTTP/1.1 Range Requests"
[7]: https://tools.ietf.org/html/rfc7234 "HTTP/1.1 Caching"
[8]: http://foshttpcache.readthedocs.io/en/stable/proxy-configuration.html#proxy-configuration "Varnish Configuration for FOS Http Cache"
[9]: https://github.com/zerustech/cli "zerustech/cli"

# License #
This tutorial is published under the [MIT License][1].
