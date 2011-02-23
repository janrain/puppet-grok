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
	if !$grok_version { $grok_version = "1.20101117.3112" }
	if !$grok_unpack_root { $grok_unpack_root = "/usr/src" }
	
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
					
					common::archive { "grok-${grok_version}":
						ensure   => present,
						checksum => false,
						url      => "http://semicomplete.googlecode.com/files/grok-${grok_version}.tar.gz",
						timeout  => 600,
						target   => "${grok_unpack_root}",
						notify	 => Exec["make-grok"]
					}

					exec { "make-grok":
						command     => "/usr/bin/make grok",
						cwd         => "${grok_unpack_root}/grok-${grok_version}",
						creates     => "${grok_unpack_root}/grok-${grok_version}/grok",
						refreshonly => true,
						notify		=> Exec["make-install-grok"],
						require     => [ Common::Archive["grok-${grok_version}"], Class["buildenv::c"], Class["buildenv::packages::ctags"],
										 Class["buildenv::packages::flex"], Class["buildenv::packages::gperf"], Class["buildenv::packages::libevent"],
										 Class["buildenv::packages::libpcre3"], Class["buildenv::packages::tokyocabinet"] ]
					}

					exec { "make-install-grok":
						command     => "/usr/bin/make install",
						cwd         => "${grok_unpack_root}/grok-${grok_version}",
						creates     => "/usr/bin/grok",
						refreshonly => true,
						require     => Exec["make-grok"]
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
