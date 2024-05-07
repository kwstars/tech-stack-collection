interfaces {
    ethernet eth1 {
        address 10.1.5.1/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    ethernet eth2 {
        address 172.12.1.10/24
        duplex auto
        smp-affinity auto
        speed auto
    }
    loopback lo {
    }
}
protocols {
    static {
        route 10.1.8.0/24{
            next-hop 172.12.1.11{
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
                encrypted-password $6$6MDHkow/GQ0RuguS$ba7PNU6xuG.TlpxOmKtpA5cM7/AZtnPtJzLwjlsmAPYVEVb.PZc98u8bhpGSu/HL/ICHFxEgdbcNEPS9ru9Po/
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
