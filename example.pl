#!/usr/bin/perl
use strict;
use BloomFilter;

# Create a new filter
my $bloomFilter = new BloomFilter();

#Create a list of even numbers from 10 to 20
my @evens = map {$_*2} 5..10;

#Add them to the filter
map { $bloomFilter->insert($_) } @evens;

#Check if all numbers from 0 to 20 are in the filter
print join "", map {
	$bloomFilter->exists($_)
		? "$_ exists in filter\n"
		: "$_ does not exist in filter\n"
} @evens;
