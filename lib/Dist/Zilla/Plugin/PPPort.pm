package Dist::Zilla::Plugin::PPPort;

use 5.008;
use Moose;
with qw/Dist::Zilla::Role::FileGatherer/;
use MooseX::Types::Perl qw(VersionObject);
use MooseX::Types::Stringlike 'Stringlike';
use Devel::PPPort;

my $content;
{
	local *PPPORT_FILE;
	open PPPORT_FILE, '>', \$content or confess "Couldn't open scalar filehandle";
	Devel::PPPort::WriteFile("&=Dist::Zilla::Plugin::PPPort::PPPORT_FILE");
	close PPPORT_FILE;
}

has filename => (
	is      => 'ro',
	isa     => Stringlike,
	coerce  => 1,
	default => 'ppport.h',
);

has version => (
	is      => 'ro',
	isa     => VersionObject,
	default => 0,
	coerce  => 1,
);

sub gather_files {
	my $self = shift;
	Devel::PPPort->VERSION($self->version) if $self->version;
	$self->add_file(Dist::Zilla::File::InMemory->new(name => $self->filename, content => $content));
	return;
}

__PACKAGE__->meta->make_immutable;

no Moose;

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
