package App::Munner;
$App::Munner::VERSION = '0.41';
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
 perlbrew use <5.x.x>
 cat ~/cpanmfile | cpanm

=head2 Carton

 cd <to your main project>
 echo 'requires "App::Munner";' >> cpanfile
 carton install

=head1 How to use it?

=head2 System perl

after install, just call

 munner <options>

=head2 Perlbrew

 perlbrew exec --with <PERL_VERSION> munner <options>

=head2 carton

 carton exec munner <options>

=head1 Options

 munner [-Aacdh] [long options...]
        -c --config       App runner config file ( default ./munner.yml )
        -d --base-dir     Global base directory ( default ../ )
        -a --app          run App
        -g --group        run Group
        -A --all          run All
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
        carton: 1 or 0
        non-stop: sleep N or pause
    db-api:
        dir: "... path cound find the command to run ..."
        env:
            - foo: 1
            - bar: 2
        run: "... start up command ..."
    event-api:
        dir: "websrc/event-api"
        run: bin/app.pl
        carton: 1
    login-server:
        dir: websrc/login-server
        run: bin/app.pl
        carton: 1
 groups:
    database:
        ## only start these apps
        apps:
            - login-server
            - db-api
    events:
        apps:
            - login-server
            - event-api
    website:
        ## start apps and above groups
        apps:
            - web-frontend
        groups:
            - database
            - events

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

start event-api only

 munner -a event-api

start everything website (db, event and login)

 munner -g website

start all apps in the config

 munner -A

start all groups in the config?

 do we need one? and why? munner -G

show a simple help page

 munner -h

show this perldoc

 perldoc App::Munner

=head1 AUTHOR

Michael Vu <micvu@cpan.org>

=head1 SUPPORT

Please submit bugs to the Bitbucket Issue Tracker: L<http://goo.gl/gHJQii>
or via email <micvu@cpan.org>

=head1 COPYRIGHT AND LICENSE

This software is Copyright (c) 2014 by Michael Vu.

This is free software, licensed under:

The Artistic License 2.0 (GPL Compatible)

=cut

1;
