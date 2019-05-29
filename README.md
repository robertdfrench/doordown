# Doordown
This is a prototype for a web application that uses [illumos doors][1] for
communication, as an alternative to both CGI and socket-based communication
patterns. My hypothesis is that the operating system will provide a better
framework for concurrency management than a

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

[1]: https://github.com/robertdfrench/revolving-door
