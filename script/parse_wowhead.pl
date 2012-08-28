#!/usr/bin/perl
use strict;
my @SIDE = ( "ERROR!", "Alliance", "Horde" );

# Script to parse wowhead dumps, only work for a certain type.

my $dumpInfo = 0;
my $guessMode = 0;
my $doBoss = 0;
my $debug = 0;
my $file = '';

foreach my $item ( @ARGV ) {
	if( $item =~ /-{1,2}dump(=(\d+))?/ ) {
		$dumpInfo = ( defined($2) ? $2 : 1 );
	} elsif( $item =~ /-{1,2}guess(=(\d+))?/ ) {
		$guessMode = ( defined($2) ? $2 : 1 );
	} elsif( $item =~ /-{1,2}boss(=(\d+))?/ ) {
		$doBoss = ( defined($2) ? $2 : 1 );
	} elsif( $item =~ /-{1,2}debug(=(\d+))?/ ) {
		$debug = ( defined($2) ? $2 : 1 );
	} else {
		$file .= "$item ";
	}
}
die "filename duh!" if( $file eq '' );

die "Can't open '$file' for reading: $!" unless (open(FIL, $file));
my $line;
my (%out) = ();
while( defined($line = <FIL>) ) {
	if ($line =~ /template:\s+?'achievement'(.+?)data:\s+?\[(.+)\]}\);$/) {
		$line = $2;
		chomp($line);
		#print "line $.:\n----------\n$line\n----------\n";
		while ($line =~ s/{(.+?)}(,|$)//) {
			my $atom = $1;
			my %temp = ();
			
			my $i = 0;

			while ($atom =~ s/^"([^"]+)"://) {
				my $var = $1;
				if ($atom =~ s/^([\d\-]+)(,|$)//) {
					$temp{$var} = $1;
				} elsif ($atom =~ s/^"([^\"]+)"(,|$)//) {
					$temp{$var} = $1;
				} elsif ($atom =~ s/^\[\[(.+?)\]\](,|$)//) {
					$temp{$var} = "unparsed: $1";
				} else {
					print "unparsable atom: $atom\n";
					exit;
				}
			}
			print "post-atom: $atom\n" if( $atom ne '' );

			if( $guessMode ) {
				my $txt = $temp{'description'};

				my $boss = '';
				my $zone = '';

				if( $txt =~ /^Defeat the (.+) bosses/i ) {
					$zone = $1;
				} elsif( $txt =~ /^(Defeat|Engage) (.+?) in (.+?)( on |\.|$)/i ) {
					$boss = $2;
					$zone = $3;
				} else {
					$zone = '<unknown>';
					print "Unmatched: $txt\n" if( $debug );
				}
				$zone =~ s/^the //g;
				print "zone=[$zone] [$txt]\n" if( $debug );

				# Various hacks.
				$zone = 'The Nexus' if( $zone eq 'Nexus' );
				$zone = 'The Violet Hold' if( $zone =~ /^The Violet Hold/ );
				$zone = 'Trial of the Champion' if( $zone =~ /^Trial of the Champion/ );

				push @{ $out{$zone} }, {
					boss => $boss,
					line => $temp{'description'},
					side => $temp{'side'},
					id => $temp{'id'},
				};
			} elsif( $dumpInfo ) {
				printf("%d%s: %s - %s\n", $temp{'id'}, ($temp{'side'} == 3 ? '' : sprintf(" [side=%d!]", $temp{'side'})), $temp{'description'}, $temp{'name'});
			} else {
				if ($temp{'side'} == 3) {
					push @{ $out{'shared'} }, $temp{'id'};
				} else {
					my $key = $SIDE[$temp{'side'}];
					push @{ $out{$key} }, $temp{'id'};
				}
			}
		}
		print "post-line='$line'\n" if( $line ne '' );
	}
}
close(FIL);

&dumpGuess() if( $guessMode );

exit if( $dumpInfo || $guessMode );

if( defined($out{$SIDE[2]}) || defined($out{$SIDE[1]}) ) {
	print "ids = {\n";
	foreach my $item ( 'shared', $SIDE[2], $SIDE[1] ) {
		next if( !defined($out{$item}) );
		printf("\t[\"%s\"] = { %s },\n", $item, join(", ", @{ $out{$item}}));
	}
	print "});\n";
} elsif( defined($out{'shared'}) ) {
	printf("ids = { %s });\n", join(", ", @{ $out{'shared'}}));
} else {
	print "uhuh. Nothing found.\n";
}

###
#############################################################################

sub dumpGuess
{
	foreach my $z ( keys %out ) {
		if( $z eq '<unknown>' ) {
			printf("-- Unknown:\n");
			foreach my $item ( @{ $out{$z} } ) {
				printf("-- %d: %s\n", $item->{'id'}, $item->{'line'});
			}
			next;
		}

		print <<EOF;
	RAQ_AddAchievement({
		category = pve,
		expansion = exp,
		name = "$z",
EOF
		my $diffSides = 0;
		foreach my $item ( @{ $out{$z} } ) {
			$diffSides = 1 if( $item->{'side'} != 3 );
		}
		die "doBoss" if( $doBoss );
		if( $diffSides ) {
			my (%temp) = ();
			foreach my $item ( @{ $out{$z} } ) {
				my $side = ($item->{'side'} == 3 ? 'shared' : $SIDE[$item->{'side'}]);
				push @{ $temp{$side} }, $item->{'id'};
			}

			printf("\t\tids = {\n");
			foreach my $item ( 'shared', $SIDE[2], $SIDE[1] ) {
				printf("\t\t\t[\"%s\"] = { %s },\n", $item, join(", ", @{ $temp{$item} }));
			}
			printf("\t\t}\n");
		} else {
			my (@temp) = ();
			foreach my $item ( @{ $out{$z} } ) {
				push @temp, $item->{'id'};
			}
			printf("\t\tids = { %s },\n", join(", ", @temp));
		}

		print <<EOF;
	})

EOF
	}
}

