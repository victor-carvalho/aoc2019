module day7;

import intcode;
import misc;
import std.array;
import std.algorithm;
import std.conv;
import std.file;
import std.range;
import std.stdio;
import std.string;

long runSequence(R)(long[] tape, R signals) if (isInputRange!R && is(ElementType!R : long)) {
    import day5: runProgram;
    auto lastOutput = 0L;
    foreach(signal; signals) {
        auto outputs = runProgram(tape.dup, signal, lastOutput);
        lastOutput = outputs[$-1];
    }
    return lastOutput;
}

long puzzle1() {
    auto tape = parseProgram("input/day7.txt");
    return iota(5).permutations.map!(inputs => runSequence(tape, inputs)).maxElement;
}

Computer startProgramWithPhase(long[] tape, long phase) {
    auto computer = Computer(tape);
    
    enforce(computer.run.hasAskedForInput, "computer should first ask for input");
    enforce(computer.run(phase).hasAskedForInput, "after input is given it should ask for input again");
    
    return computer;
}

long runFeedbackLoop(R)(long[] tape, R phases) if (isInputRange!R && is(ElementType!R : long)) {
    auto amplifiers = phases.map!(phase => startProgramWithPhase(tape.dup, phase)).array;
    auto lastOutput = 0L;
    while(true) {
        auto haltedCount = 0;
        foreach(ref amplifier; amplifiers) {
            if (amplifier.isHalted) {
                haltedCount += 1;
                continue;
            }
            enforce(amplifier.isWaitingInput, "amplifier should be waiting input");
            
            auto result = amplifier.run(lastOutput);
            enforce(!amplifier.isWaitingInput, "amplifier should output or halt");
            if (result.hasGivenOutput) {
                lastOutput = result.value;
                amplifier.run();
            } else if (result.hasHalted) {
                return lastOutput;
            }
        }
        if (haltedCount == 5)
            break;
    }
    return lastOutput;
}

long puzzle2() {
    auto tape = parseProgram("input/day7.txt");
    return iota(5,10).permutations.map!(inputs => runFeedbackLoop(tape, inputs)).maxElement;
}

version(day7) {
    void main() {
        writeln("AOC2019 day7 puzzle1: ", puzzle1());
        writeln("AOC2019 day7 puzzle2: ", puzzle2());
    }
}
