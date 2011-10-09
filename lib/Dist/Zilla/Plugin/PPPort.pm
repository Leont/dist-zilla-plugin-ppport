package Dist::Zilla::Plugin::PPPort;

use 5.008;
use Moose;
with qw/Dist::Zilla::Role::FileGatherer/;
use Devel::PPPort;

my $content;
{
	local *PPPORT_FILE;
	open PPPORT_FILE, '>', \$content or confess "Couldn't open scalar filehandle";
	Devel::PPPort::WriteFile("&=".__PACKAGE__."::PPPORT_FILE");
	close PPPORT_FILE;
}

has filename => (
	is => 'ro',
	isa => 'Str',
	default => 'ppport.h'
);

sub gather_files {
	my $self = shift;
	$self->add_file(Dist::Zilla::File::InMemory->new(name => $self->filename, content => $content));
	return;
}

1;

__END__

#ABSTRACT: PPPort for Dist::Zilla

=head1 SYNOPSIS

In your dist.ini

 [PPPort]
 filename = ppport.h ;default

=head1 DESCRIPTION

This module adds a PPPort file to your distribution. By default it's called C<ppport.h>, but you can name differently.

=for Pod::Coverage
gather_files
=end
