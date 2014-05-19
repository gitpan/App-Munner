package App::Munner;
$App::Munner::VERSION = '0.1';
=head1 NAME

Munner - Multi-Apps Runner

=head1 DESCRIPTION

This script "munner" run multiple apps in one commands.

=head1 Why we need this?

Some project may involves different APIs running at the background in order
to exchange information. But what if we just use munner to start these apis
in one call. It is a very handy tools to start multiple applications.

=head1 How to install it?

=head2 System perl

 cpan -i App::Munner

=head2 Perlbrew

 echo App::Munner >> ~/cpanmfile
 perlbrew install-cpanm
 cat ~/cpanmfile | cpanm

=head2 Carton

 cd <to your main project>
 echo 'requires "App::Munner";' >> cpanfile
 carton install

=head1 How to use it?

=head2 System perl

 after install, just call munner <options>

=head2 Perlbrew

 perlbrew exec --with <PERL_VERSION> munner <options>

=head2 carton

 carton exec munner <options>

=head1 Options

 munner [-Aacdh] [long options...]
        -c --config       App runner config file ( default ./munner.yml )
        -d --base-dir     Global base directory ( default ../ )
        -a --app          App to run
        -A --all          Start All
        -h --cmd_help     Help
        -p --perldoc      Perldoc App::Munner

=head1 What else?

=head2 Config file

To run munner, you will need a YAML format of config file.

The config file name is munner.yml

It looks like this:
 ---------------------------
 base_dir: "... base directory to find the app ..."
 apps:
    web-frontend:
        dir: "... either full path or the tail part after base_dir ..."
        run: "... command ..."
    foobar-api:
        dir: "... path cound find the command to run ..."
        run: "... start up command ..."

=head2 Where to save the config file?

By default munner will find the config file at the current directory. If you have
the config some where else, you will need to tell munner like below:

 pwd --> /home/micvu/websrc/website
 munner -c /home/micvu/munner.yml <options> ...

If the config is in the current directory.

 pwd --> /home/micvu/websrc/website
 ls munner.yml --> munner.yml
 munner <options> --> without telling the config file location

=head2 Command examples:

start web-frontend only

 munner -a web-frontend

start foobar-api only

 munner -a foobar-api

start everything in the config

 munner -A

show a simple help page

 munner -h

show this perldoc

 perldoc App::Munner

=cut

1;
