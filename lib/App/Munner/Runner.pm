package
    App::Munner::Runner;

use Daemon::Control;
use Mo qw( builder );

has name => (
    is       => "ro",
    isa      => "Str",
    required => 1,
);

has base_dir => (
    is      => "ro",
    isa     => "Str",
    default => '.',
);

has user => (
    is      => "ro",
    isa     => "Str",
    builder => "_build_user",
);

sub _build_user {
    return $ENV{USER};
}

has group => (
    is      => "ro",
    isa     => "Int",
    builder => "_build_group",
);

sub _build_group {
    return $ENV{USER};
}

has pid_file => (
    is      => "ro",
    isa     => "Str",
    builder => "_build_pid_file",
);

sub _build_pid_file {
    my $self     = shift;
    my $base_dir = $self->base_dir || q{};
    my $app      = $self->name;
    return "$base_dir/$app.pid";
}

has error_log => (
    is      => "ro",
    isa     => "Str",
    builder => "_build_error_log",
);

sub _build_error_log {
    my $self     = shift;
    my $base_dir = $self->base_dir || q{};
    my $app      = $self->name;
    my $file     = "$base_dir/$app.error.log";
    system "touch $file";
    return $file;
}

has access_log => (
    is      => "ro",
    isa     => "Str",
    builder => "_build_access_log",
);

sub _build_access_log {
    my $self     = shift;
    my $base_dir = $self->base_dir || q{};
    my $app      = $self->name;
    my $file     = "$base_dir/$app.access.log";
    system "touch $file";
    return $file;
}

has command => (
    is       => "ro",
    isa      => "Str",
    required => 1,
);

has _daemon => (
    is      => "ro",
    isa     => "Daemon::Control",
    builder => "_build_daemon",
);

sub _build_daemon {
    my $self   = shift;
    my $config = $self->config_file;
    my $app    = $self->name;
    my $daemon = Daemon::Control->new(
        {
            name        => $app,
            lsb_start   => q{$syslog $remote_fs},
            lsb_stop    => q{$syslog},
            lsb_sdesc   => $app,
            lsb_desc    => $app,

            group       => $self->group,
            directory   => $self->base_dir,
            program     => $self->command,
            pid_file    => $self->pid_file,
            stderr_file => $self->error_log,
            stdout_file => $self->access_log,
            fork        => 1,
        }
    );
    return $daemon;
}

sub run {
    my $self = shift;
    $self->_daemon->do_foreground;
}

sub run_at_bg {
    my $self   = shift;
    my $daemon = $self->_daemon;
    $daemon->do_start;
    $daemon->write_pid;
}

sub stop {
    my $self = shift;
    $self->_daemon->do_stop;
}

sub restart {
    my $self = shift;
    $self->_daemon->do_restart;
}

sub graceful {
    my $self = shift;
    $self->_daemon->do_reload;
}

has config_file => (
    is       => "ro",
    isa      => "Str",
    required => 1,
);

sub status {
    my $self = shift;
    $self->_daemon->do_status;
}

1;
