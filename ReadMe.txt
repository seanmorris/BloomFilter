BloomFilter is a Perl implementation of a Bloom Filter. The purpose of a bloom
filter is to provide a fast lookup to test if data has been added to a list or
not.

The method works in such a way that data may be added but not removed or
extracted, it stores an array representing true values for the hashes that have
been added to it.

The filter may sometimes return false positives. But never false negetives. This
is the tradeoff for its speed and small size. You may end up looking for a value
in the list that is not there, but if the value is not in the list, you'll know
for sure.
