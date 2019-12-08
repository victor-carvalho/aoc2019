#!/usr/bin/env rund

module day2;

import std.algorithm;
import std.array;
import std.conv: text, to;
import std.stdio;
import std.string;
import std.typecons;

struct Program {
    this(string filename) {
        orig = parseProgram(filename);
        tmp = new long[](orig.length);
    }

    long run(long noun, long verb) {
        tmp[0..$] = orig[0..$];
        tmp[1] = noun;
        tmp[2] = verb;
        auto ip = 0;
        loop: while (true) {
            auto left = tmp[ip + 1];
            auto right = tmp[ip + 2];
            auto result = tmp[ip + 3];
            switch(tmp[ip]) {
                case 1:
                    tmp[result] = tmp[left] + tmp[right];
                    break;
                case 2:
                    tmp[result] = tmp[left] * tmp[right];
                    break;
                case 99:
                    break loop;
                default:
                    assert(false, text("invalid input ", tmp[ip]));
            }
            ip += 4;
        }
        return tmp[0];
    }

    private long[] parseProgram(string filename) {
        auto file = File(filename);
        auto program = appender!(long[]);
        foreach(line; file.byLine) {
            program.put(line.splitter(",").map!(to!long));
        }
        return program.data;
    }

    private long[] orig;
    private long[] tmp;
}

void runProgram(long[] program) {
    auto ip = 0;
    loop: while (true) {
        auto left = program[ip + 1];
        auto right = program[ip + 2];
        auto result = program[ip + 3];
        switch(program[ip]) {
            case 1:
                program[result] = program[left] + program[right];
                break;
            case 2:
                program[result] = program[left] * program[right];
                break;
            case 99:
                break loop;
            default:
                assert(false, text("invalid input ", program[ip]));
        }
        ip += 4;
    }
}

long[] parseProgram() {
    auto file = File("input/day2.txt");
    auto program = appender!(long[]);
    foreach(line; file.byLine) {
        program.put(line.splitter(",").map!(to!long));
    }
    return program.data;
}


long puzzle1() {
    auto program = Program("input/day2.txt");
    return program.run(12, 2);
}

auto puzzle2() {
    auto program = Program("input/day2.txt");
    foreach(noun; 1..100) {
        foreach(verb; 1..100) {
            auto result = program.run(noun, verb);
            if (result == 19690720)
                return tuple(noun, verb);
        }
    }
    assert(false, "Should not be reached");
}

void main() {
    writeln("AOC2019 Day2 puzzle1: ", puzzle1());
    writeln("AOC2019 Day2 puzzle2: ", puzzle2());
}