#!/usr/bin/env rund

module day1;

import std.algorithm;
import std.conv: to;
import std.stdio;
import std.string;

long puzzle1() {
    auto file = File("input/day1.txt");
    return file.byLine
        .map!strip
        .map!(to!long)
        .map!(m => m / 3 - 2)
        .sum;
}

long calculateFuel(long mass) {
    auto fuel = mass / 3 - 2;
    auto total = 0; 
    while(fuel > 0) {
        total += fuel;
        fuel = fuel / 3 - 2;
    }
    return total;
}

long puzzle2() {
    auto file = File("input/day1.txt");
    return file.byLine
        .map!strip
        .map!(to!long)
        .map!calculateFuel
        .sum;
}

void main() {
    writeln("AOC2019 Day1 puzzle1: ", puzzle1());
    writeln("AOC2019 Day1 puzzle2: ", puzzle2());
}