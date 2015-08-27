# anstrap #

aspnet bootstrap for developing projects with vagrant

## Running ##

Make sure you've got vagrant installed, then:

    $ vagrant up

This will download and install dnvm and its dependencies, upgrade itself to
install dnx, clone the aspnet Home repo, and fetch the dependencies for the
HelloWeb app under /vagrant/Home/samples/HelloWeb.

## Home Samples ##

The aspnet/Home project has some samples you can use, the HelloWeb sample
for beta6 should be ready to go via the provision.sh script.

Use:

    $ vagrant up
    $ vagrant ssh

Confirm your version of DNX matches the correct beta (beta6 for this example):

    $ dnx --version

    $ cd /vagrant/Home/samples/1.0.0-beta6/HelloWeb
    $ MONO_THREADS_PER_CPU=2000 dnu restore # should be done already
    $ dnx . kestrel

You should be able to access the server from the host system at:

http://localhost:5004/

Happy coding!

## License ##

MIT
