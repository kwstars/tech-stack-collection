interfaces {
    ethernet eth1 {
        address 10.1.8.1/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 172.12.1.11/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
protocols {
    static {
        route 10.1.5.0/24{
            next-hop 172.12.1.10{
            }
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    console {
        device ttyS0 {
            speed 9600
        }
    }
    host-name vyos
    login {
        user vyos {
            authentication {
                encrypted-password $6$QxPS.uk6mfo$9QBSo8u1FkH16gMyAvhus6fu3LOzvLR929.82m3tiHFAxTtIkhaZSwssSgzt4v4dGAL8rhvQxTg0oAG9/q11h/
                plaintext-password ""
            }
            level admin
        }
    }
    ntp {
        server 0.pool.ntp.org {
        }
        server 1.pool.ntp.org {
        }
        server 2.pool.ntp.org {
        }
    }
    syslog {
        global{
            facility all {
                level info
            }
            facility protocols {
                level debug
            }
        }
    }
    time-zone UTC
}
