module day7;

import day5: Program;
import std.array;
import std.algorithm;
import std.conv;
import std.file;
import std.range;
import std.stdio;
import std.string;

int runSequence(R)(int[] tape, R signals) if (isInputRange!R && is(ElementType!R == int)) {
    import day5: runProgram;
    auto lastOutput = 0;
    foreach(signal; signals) {
        auto outputs = runProgram(tape.dup, signal, lastOutput);
        lastOutput = outputs[$-1];
    }
    return lastOutput;
}

int puzzle1() {
    auto text = readText("input/day7.txt");
    auto tape = text.strip.splitter(",").map!(to!int).array;
    return iota(5).permutations.map!(inputs => runSequence(tape, inputs)).maxElement;
}

Program startProgramWithPhase(int[] tape, int phase) {
    auto program = Program(tape);
    
    assert(program.run.hasAskedForInput);
    assert(program.run(phase).hasAskedForInput);
    
    return program;
}

int runFeedbackLoop(R)(int[] tape, R phases) if (isInputRange!R && is(ElementType!R == int)) {
    auto amplifiers = phases.map!(phase => startProgramWithPhase(tape.dup, phase)).array;
    auto lastOutput = 0;
    while(true) {
        auto haltedCount = 0;
        foreach(ref amplifier; amplifiers) {
            if (amplifier.isHalted) {
                haltedCount += 1;
                continue;
            }
            assert(amplifier.isWaitingInput, "amplifier should be waiting input");
            auto result = amplifier.run(lastOutput);
            if (result.hasGivenOutput) {
                lastOutput = result.value;
                amplifier.run();
            } else if (result.hasHalted) {
                return lastOutput;
            } else {
                assert(false, "amplifier should output or halt");
            }
        }
        if (haltedCount == 5)
            break;
    }
    return lastOutput;
}

int puzzle2() {
    auto text = readText("input/day7.txt");
    auto tape = text.strip.splitter(",").map!(to!int).array;
    return iota(5,10).permutations.map!(inputs => runFeedbackLoop(tape, inputs)).maxElement;
}

version(day7) {
    void main() {
        writeln(puzzle1());
        writeln(puzzle2());
    }
}
