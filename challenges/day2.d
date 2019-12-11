#!/usr/bin/env rund

module day2;

import intcode;
import std.algorithm;
import std.array;
import std.conv: text, to;
import std.file: readText;
import std.stdio;
import std.string;
import std.typecons;

long runProgram(long[] program, long noun, long verb) {
    program[1] = noun;
    program[2] = verb;
    auto computer = Computer(program);
    while (!computer.run.hasHalted) {}
    return program[0];
}


long puzzle1() {
    auto tape = parseProgram("input/day2.txt");
    return runProgram(tape, 12, 2);
}

auto puzzle2() {
    auto tape = parseProgram("input/day2.txt");
    auto aux = tape.dup;
    foreach(noun; 1..100) {
        foreach(verb; 1..100) {
            aux[] = tape;
            auto result = runProgram(aux, noun, verb);
            if (result == 19690720)
                return tuple(noun, verb);
        }
    }
    assert(false, "Should not be reached");
}

version(day2) {
    void main() {
        writeln("AOC2019 Day2 puzzle1: ", puzzle1());
        writeln("AOC2019 Day2 puzzle2: ", puzzle2());
    }
}