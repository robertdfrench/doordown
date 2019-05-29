# Doordown
This is a prototype for a web application that uses [illumos doors][1] for
communication, as an alternative to both CGI and socket-based communication
patterns.

### Motivation
With CGI-style applications, we do not necessarily need to plan ahead to support
multiple concurrent requests: the operating system can handle this for us. The
downside of course is the paying for the cost of `fork()`ing from the webserver.

With applications that run in an appserver and communicate over an internal http
socket (Rails, Django, Express, etc), we can do some expensive work at startup
(such as connecting to a database), thus lowering the amount of work needed to
handle each request. The downside of this is that we must handle concurrency
ourselves, either by writing asynchronous code or using some control mechanism
to anticipate the number of appservers which should run simultaneously.

I would like to know if it is possible to have my cake and eat it too. The goal
of this work is to ascertain the viability of writing synchronous code to handle
web requests, and leaving concurrency management to the operating system. My
hypothesis is that if the operating system is allowed to handle requests as
independent threads, it will perform better than attempting to have an
application runtime accomplish the same thing, and the synchronous-looking code
will be easier to reason about.

### Implementation
The code in this repo is running [here][2]. There is no https or dynamic content
to speak of; [libmicrohttpd][3] handles each request in a separate thread, and
each of those threads issues a [door_call][4] to the application, which responds
"Well, hello to you too!".

### Future work
1. Measure the difference between this approach, [Proxy Pass][6], and [FastCGI][5], with regard to memory consumption and requests/s.
1. Implement something akin to [mod_fcgid][5] but with doors, so that administrators can launch a single application and allow the operating system to handle thread management.
1. Demonstrate how PostgreSQL connections can be maintained as thread-local variables, and re-used by future door invocations, without needing to be explicitly managed as a pool.

[1]: https://github.com/robertdfrench/revolving-door
[2]: http://doordown.inst.c7a4437d-3835-44cd-d115-c3dd99dd176b.us-west-1.triton.zone/
[3]: https://www.gnu.org/software/libmicrohttpd/
[4]: https://www.illumos.org/man/3C/door_call
[5]: https://httpd.apache.org/mod_fcgid/mod/mod_fcgid.html
[6]: https://httpd.apache.org/docs/current/mod/mod_proxy.html
