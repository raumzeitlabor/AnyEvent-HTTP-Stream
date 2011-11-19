AnyEvent::HTTP::Stream
======================

An unfinished library for streaming HTTP with AnyEvent.

Building a Debian package
-------------------------
The preferred way to deploy code on the Blackbox (where this library
runs on) is by installing a Debian package. This has many advantages:

1. When we need to re-install for some reason, the package has the correct
   dependencies, so installation is easy.

2. If Debian ships a new version of perl, the script will survive that easily.

3. A simple `dpkg -l | grep -i raumzeit` is enough to find all
   RaumZeitLabor-related packages **and their version**. The precise location
   of initscripts, configuration and source code can be displayed by `dpkg -L
   libanyevent-http-stream-perl`

To create a Debian package, ensure you have `dpkg-dev` installed, then run:
<pre>
dpkg-buildpackage
</pre>

Now you have a package called `libanyevent-http-stream-perl_1.0-1_all.deb`
which you can deploy on the Blackbox.

Updating the Debian packaging
-----------------------------

If you introduce new dependencies, bump the version or change the description,
you have to update the Debian packaging. First, install the packaging tools we
are going to use:
<pre>
apt-get install dh-make-perl
</pre>

Then, run the following commands:
<pre>
perl Makefile.PL
rm -rf debian
dh-make-perl -p libanyevent-http-stream-perl --source-format 1
</pre>

See also
--------

For more information about Debian packaging, see:

* http://wiki.ubuntu.com/PackagingGuide/Complete

For online documentation about the Perl modules which are used:

* http://search.cpan.org/perldoc?AnyEvent::HTTP
* http://search.cpan.org/perldoc?Moose
