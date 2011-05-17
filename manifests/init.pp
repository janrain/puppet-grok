# Class: grok
#
# This module manages grok
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
class grok {
	require grok::params
	include buildenv::c
	
	case $operatingsystem {
		/(?i)(Ubuntu)/: {
			case $lsbdistcodename {
        		/(?i)(hardy|lucid)/: {
					include buildenv::packages::ctags
					include buildenv::packages::flex
					include buildenv::packages::gperf
					include buildenv::packages::libevent
					include buildenv::packages::libpcre3
					include buildenv::packages::tokyocabinet
					
					common::archive { "grok-${grok::params::version}":
						ensure   => present,
						checksum => false,
						url      => "http://semicomplete.googlecode.com/files/grok-${grok::params::version}.tar.gz",
						timeout  => 600,
						target   => "${grok::params::unpack_root}",
						notify	 => Exec['make-grok'],
					}

					exec { 'make-grok':
						command     => '/usr/bin/make grok',
						cwd         => "${grok::params::unpack_root}/grok-${grok::params::version}",
						creates     => "${grok::params::unpack_root}/grok-${grok::params::version}/grok",
						refreshonly => true,
						notify		  => Exec['make-install-grok'],
						require     => [ Common::Archive["grok-${grok::params::version}"],
														 Class['buildenv::c'],
														 Class['buildenv::packages::ctags'],
														 Class['buildenv::packages::flex'],
														 Class['buildenv::packages::gperf'],
														 Class['buildenv::packages::libevent'],
														 Class['buildenv::packages::libpcre3'],
														 Class['buildenv::packages::tokyocabinet'] ],
					}

					exec { 'make-install-grok':
						command     => '/usr/bin/make install',
						cwd         => "${grok::params::unpack_root}/grok-${grok::params::version}",
						creates     => '/usr/bin/grok',
						refreshonly => true,
						require     => Exec['make-grok'],
					}
				}
				default: {
					fail "Unsupported Ubuntu version ${lsbdistcodename} in 'grok' module"
				}
			}
		}
		default: {
			fail "Unsupported OS ${operatingsystem} in 'grok' module"
		}
	}
}
