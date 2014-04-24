package Dist::Zilla::Plugin::PPPort;

use Moose;
with qw/Dist::Zilla::Role::FileGatherer/;
use Moose::Util::TypeConstraints 'enum';
use MooseX::Types::Perl qw(StrictVersionStr);
use MooseX::Types::Stringlike 'Stringlike';
use Devel::PPPort 3.23;
use File::Spec::Functions 'catdir';

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
	default => '3.23',
);

sub gather_files {
	my $self = shift;
	Devel::PPPort->VERSION($self->version);
	$self->add_file(Dist::Zilla::File::InMemory->new(
		name => $self->filename,
		content => Devel::PPPort::GetFileContents($self->filename),
		encoding => 'ascii',
	));
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
