package Dist::Zilla::Plugin::PPPort;

use 5.008;
use Moose;
with qw/Dist::Zilla::Role::FileGatherer/;
use Devel::PPPort;
use Symbol;

my $content;
open PPPORT_FILE, '>', \$content or confess "Couldn't open scalar filehandle";
Devel::PPPort::WriteFile("&=".__PACKAGE__."::PPPORT_FILE");
close PPPORT_FILE;

sub gather_files {
	my $self = shift;
	my $file = Dist::Zilla::File::InMemory->new(name => 'ppport.h', content => $content);
	$self->add_file($file);
	return;
}

1;

__END__

#ABSTRACT: PPPort for Dist::Zilla

=head1 SYNOPSIS

In your dist.ini

 [PPPort]

=for Pod::Coverage
gather_files
=end
