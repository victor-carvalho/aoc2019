module day9;

import intcode;
import std.array;

long puzzle(long value) {
    import day5: runProgram;
    auto program = parseProgram("input/day9.txt");
    auto extendedMemory = new long[program.length * 10];
    extendedMemory[0..program.length] = program;
    auto testResult = runProgram(extendedMemory, value);
    assert(testResult.length == 1);
    return testResult.front;
}

version(day9) {
    void main() {
        import std.stdio;
        writeln("AOC2019 day9 puzzle1: ", puzzle(1));
        writeln("AOC2019 day9 puzzle2: ", puzzle(2));
    }
}