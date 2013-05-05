package BloomFilter;

use strict;
use Digest::JHash qw(jhash);

use fields qw(
	filter
);

sub new
{
	my $self = fields::new( shift );

	return $self;
}

########################################################################
#	Static Methods
########################################################################

sub rehash
{
	my $class		= shift;
	my $input  		= shift;
	my $hasher		= shift;
	my $iterations	= shift;

	my $hash		= &$hasher($input);
	my $output		= [$hash];

	if(--$iterations > 0)
	{
		push @{$output}, BloomFilter->rehash($hash, $hasher, $iterations);
	}

	return @{ $output };
}

sub reduceHash
{
	my $class		= shift;
	my $input		= shift;

	my $trunc		= 6;

	my $hashMax			= hex('F' x length($input));
	my $maxReturn		= hex('F' x $trunc);
	my $reductionRatio	= $maxReturn/$hashMax;

	return int((hex($_) * $reductionRatio)+0.5);
}

sub jHasher{
	my $class		= shift;
	my $input		= shift;

	return uc(sprintf("%08x", jhash($input)));
};

sub hashList
{
	my $class		= shift;
	my $input		= shift;

	my $hashAmt		= 3;

	my @h = map{ BloomFilter->reduceHash($_) } BloomFilter->rehash(
		$input
		, sub{BloomFilter->jHasher(shift)}
		, $hashAmt
	);
}

########################################################################
#	Instance Methods
########################################################################

sub insert
{
	my $self		= shift;

	foreach my $word (@_)
	{
		foreach my $bit (BloomFilter->hashList($word))
		{
			$self->{filter}->[$bit] = 1;
		}
	}
}

sub exists
{
	my $self		= shift;
	my $word		= shift;

	foreach my $bit (BloomFilter->hashList($word))
	{
		if(not exists $self->{filter}->[$bit])
		{
			return 0;
		}
	}

	return 1;
}

1;
