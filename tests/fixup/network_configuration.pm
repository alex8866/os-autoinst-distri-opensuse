# SUSE's openQA tests
#
# Copyright © 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

use base "x11test";
use strict;
use testapi;

sub run() {
    my $self = shift;

    # openSUSE 13.2's (and earlier) systemd has broken rules for virtio-net, not applying predictable names (despite being configured)
    # A maintenance update breaking networking names sounds worse than just accepting that 13.2 -> TW breaks with virtio-net
    # At this point, the system has been updated, but our network interface changed name (thus we lost network connection)
    my $command = "cp /etc/sysconfig/network/ifcfg-eth0 /etc/sysconfig/network/ifcfg-ens4; /usr/sbin/ifup ens4";

    if (get_var("DESKTOP") =~ /kde|gnome/) {
        x11_start_program("xterm");
        assert_script_sudo($command);
        send_key "alt-f4";
    }
    else {
        select_console 'root-console';
        assert_script_run($command);
    }
}

sub test_flags() {
    return {milestone => 1};
}

1;
# vim: set sw=4 et:
