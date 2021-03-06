# SUSE's openQA tests
#
# Copyright © 2016 SUSE LLC
#
# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.

# Case 1560070  - FIPS: systemd journald FSS

use base "consoletest";
use strict;
use testapi;

sub run() {

    select_console "root-console";

    # Enable FSS (Forward Secure Sealing)
    assert_script_run("sed -i -e 's/^Storage/#Storage/g' -e 's/^Seal/#Seal/g' /etc/systemd/journald.conf");
    assert_script_run('echo -e "Storage=persistence\nSeal=yes" >> /etc/systemd/journald.conf');
    assert_script_run("mkdir -p /var/log/journal");
    assert_script_run("systemctl restart systemd-journald.service");

    # Setup keys
    assert_script_run("journalctl --interval=30s --setup-keys | tee /tmp/key");

    # Verify the journal with valid verification key
    assert_script_run('key=$(cat /tmp/key); echo "Verify with key: $key"; journalctl --verify --verify-key=$key');

    # Wait some time for the secret key being changed, and verify again
    assert_script_run('sleep 40; key=$(cat /tmp/key); echo "Verify with key: $key"; journalctl --verify --verify-key=$key', 60);

    assert_script_run("rm -f /tmp/key");
}

sub test_flags() {
    return {important => 1};
}

1;
# vim: set sw=4 et:
