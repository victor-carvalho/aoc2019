#!/usr/bin/env rund

module day5;

import intcode;
import std.array;
import std.algorithm;
import std.conv;
import std.file;
import std.stdio;
import std.string;

long[] runProgram(long[] tape, long[] input ...) {
    auto computer = Computer(tape);
    auto output = appender!(long[]);
    auto result = computer.run();
    auto index = 0;
    while(!result.hasHalted) {
        if (result.hasAskedForInput) {
            result = computer.run(input[index]);
            index += 1;
        } else {
            output.put(result.value);
            result = computer.run();
        }
    }
    return output.data;

}

long puzzle(long input) {
    auto tape = parseProgram("input/day5.txt");
    auto result = runProgram(tape, input);
    return result[$-1];
}

version(day5) {
    void main() {
        writeln("AOC2019 day5 puzzle1: ", puzzle(1));
        writeln("AOC2019 day5 puzzle2: ", puzzle(5));
    }
}
