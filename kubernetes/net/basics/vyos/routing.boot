interfaces {
    ethernet eth1 {
        address 10.1.5.1/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 10.1.8.1/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
nat {
    source {
        rule 100 {
            outbound-interface eth0
            source {
                address 10.1.0.0/16
            }
            translation {
                address masquerade
            }
        }
    }
}
service {
    ntp {
        allow-client {
            address 0.0.0.0/0
            address ::/0
        }
        server time1.vyos.net {
        }
        server time2.vyos.net {
        }
        server time3.vyos.net {
        }
    }
}
system {
    config-management {
        commit-revisions 100
    }
    conntrack {
        modules {
            ftp
            h323
            nfs
            pptp
            sip
            sqlnet
            tftp
        }
    }
    console {
        device ttyS0 {
            speed 115200
        }
    }
    host-name gw0
    login {
        user vyos {
            authentication {
                encrypted-password $6$6MDHkow/GQ0RuguS$ba7PNU6xuG.TlpxOmKtpA5cM7/AZtnPtJzLwjlsmAPYVEVb.PZc98u8bhpGSu/HL/ICHFxEgdbcNEPS9ru9Po/
                plaintext-password ""
            }
            level admin
        }
    }
    syslog {
        global {
            facility all {
                level info
            }
            facility local7 {
                level debug
            }
        }
    }
}
