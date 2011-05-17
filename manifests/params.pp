# Class: grok::params
#
#
class grok::params {
	$version = $grok_version ? {
		''      => '1.20110429.1',
		default => $grok_version,
	}
	
	$unpack_root = $grok_unpack_root ? {
		''      => '/usr/src',
		default => $grok_unpack_root,
	}
}
