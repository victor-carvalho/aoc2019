#!/usr/bin/env rund

module day4;

import misc;
import std.stdio;

bool isValid(int pass) {
    auto hasDuplicates = false;
    auto last = int.max;
    foreach(digit; pass.digits) {
        if (digit > last) return false;
        if (digit == last)
            hasDuplicates = true;
        last = digit;
    }
    return hasDuplicates;
}

bool isValidStrict(int pass) {
    auto hasDouble = false;
    auto duplicateLen = 0;
    auto last = int.max;
    foreach(digit; pass.digits) {
        if (digit > last) return false;
        if (digit == last) {
            duplicateLen += 1;
        } else {
            hasDouble = hasDouble || duplicateLen == 2;
            duplicateLen = 1;
        }
        last = digit;
    }
    hasDouble = hasDouble || duplicateLen == 2;
    return hasDouble;
}

int puzzle(bool function(int) validator) {
    auto count = 0;
    foreach(pass; 231_832..767_346) {
        if (validator(pass))
            count += 1;
    }
    return count;
}

void main() {
    writeln("AOC2019 Day4 puzzle1: ", puzzle(&isValid));
    writeln("AOC2019 Day4 puzzle2: ", puzzle(&isValidStrict));
}
