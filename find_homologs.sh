#!/usr/bin/env bash
# Usage: find_homologs.sh <query file> <subject file> <output file>
#
# Searches a protein query against a nucleotide subject with tblastn,
# keeps hits with >30% identity whose alignment length is >90% of the
# query length, writes them to the output file, and prints the count.

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <query file> <subject file> <output file>" >&2
    exit 1
fi

query="$1"
subject="$2"
output="$3"

# "6 std qlen" = the 12 standard tabular columns plus query length as $13,
# so each hit is compared against the length of its own query sequence.
tblastn -query "$query" -subject "$subject" -outfmt "6 std qlen" \
    | awk '$3 > 30 && $4 > 0.9 * $13' > "$output"

wc -l < "$output"
