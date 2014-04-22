package Dist::Zilla::Plugin::PPPort;

use 5.008;
use Moose;
with qw/Dist::Zilla::Role::FileGatherer/;
use Moose::Util::TypeConstraints 'enum';
use MooseX::Types::Perl qw(StrictVersionStr);
use MooseX::Types::Stringlike 'Stringlike';
use Devel::PPPort;
use File::Spec::Functions 'catdir';

my $content;
{
	local *PPPORT_FILE;
	open PPPORT_FILE, '>', \$content or confess "Couldn't open scalar filehandle";
	Devel::PPPort::WriteFile("&=Dist::Zilla::Plugin::PPPort::PPPORT_FILE");
	close PPPORT_FILE;
}

has style => (
	is  => 'ro',
	isa => enum(['MakeMaker', 'ModuleBuild']),
	default => 'MakeMaker',
);

has filename => (
	is      => 'ro',
	isa     => Stringlike,
	lazy    => 1,
	coerce  => 1,
	default => sub {
		my $self = shift;
		if ($self->style eq 'MakeMaker') {
			return 'ppport.h';
		}
		elsif ($self->style eq 'ModuleBuild') {
			my @module_parts = split /-/, $self->zilla->name;
			return catdir('lib', @module_parts[0 .. $#module_parts - 1], 'ppport.h');
		}
		else {
			confess 'Invalid style for XS file generation';
		}
	}
);

has version => (
	is      => 'ro',
	isa     => StrictVersionStr,
	default => 0,
);

sub gather_files {
	my $self = shift;
	Devel::PPPort->VERSION($self->version) if $self->version;
	$self->add_file(Dist::Zilla::File::InMemory->new(name => $self->filename, content => $content, encoding => 'ascii'));
	return;
}

__PACKAGE__->meta->make_immutable;

no Moose;

1;

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
