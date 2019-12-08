#!/usr/bin/env rund

module day5;

import std.array;
import std.algorithm;
import std.conv;
import std.file;
import std.stdio;
import std.string;

struct ProgramResult {
    private enum ProgramResultTag {
        Halted,
        AskedInput,
        Output,
    }

    static ProgramResult halted() {
        return ProgramResult(0, ProgramResultTag.Halted);
    }

    static ProgramResult output(int payload) {
        return ProgramResult(payload, ProgramResultTag.Output);
    }

    static ProgramResult waitingInput() {
        return ProgramResult(0, ProgramResultTag.AskedInput);
    }

    @property bool hasHalted() {
        return tag == ProgramResultTag.Halted;
    }

    @property bool hasAskedForInput() {
        return tag == ProgramResultTag.AskedInput;
    }

    @property bool hasGivenOutput() {
        return tag == ProgramResultTag.Output;
    }

    @property int value() {
        assert(hasGivenOutput);
        return payload;
    }

    private int payload = 0;
    private ProgramResultTag tag;
}

enum ProgramState {
    NotStarted,
    Halted,
    WaitingInput,
    PausedForOutput,
}

struct Program {
    this(int[] program) {
        tape = program;
        state = ProgramState.NotStarted;
        paramModes = [0,0,0,0];
        ip = 0;
    }

    ProgramResult run() {
        assert(state == ProgramState.NotStarted || state == ProgramState.PausedForOutput);
        return execute();
    }

    ProgramResult run(int value) {
        assert(state == ProgramState.WaitingInput);
        writeValue(1, value);
        ip += 2;
        return execute();
    }

    @property bool isHalted() {
        return state == ProgramState.Halted;
    }

    @property bool isWaitingInput() {
        return state == ProgramState.WaitingInput;
    }

private:
    ProgramResult execute() {
        while(true) {
            auto instruction = nextInstruction();
            switch(instruction) {
                case 1:
                    writeValue(3, getOperand(1) + getOperand(2));
                    ip += 4;
                    break;
                case 2:
                    writeValue(3, getOperand(1) * getOperand(2));
                    ip += 4;
                    break;
                case 3:
                    state = ProgramState.WaitingInput;
                    return ProgramResult.waitingInput();
                case 4:
                    auto value = getOperand(1);
                    ip += 2;
                    state = ProgramState.PausedForOutput;
                    return ProgramResult.output(value);
                case 5:
                    if(getOperand(1) != 0)
                        ip = getOperand(2);
                    else
                        ip += 3;
                    break;
                case 6:
                    if(getOperand(1) == 0)
                        ip = getOperand(2);
                    else
                        ip += 3;
                    break;
                case 7:
                    writeValue(3, getOperand(1) < getOperand(2));
                    ip += 4;
                    break;
                case 8:
                    writeValue(3, getOperand(1) == getOperand(2));
                    ip += 4;
                    break;
                case 99:
                    state = ProgramState.Halted;
                    return ProgramResult.halted();
                default:
                    assert(false, text("invalid instruction ", instruction));
            }
        }
    }

    int nextInstruction() {
        auto code = tape[ip];
        auto instruction = code % 100;
        paramModes[] = 0;
        for (auto i = 0, num = code / 100; i < paramModes.length && num > 0; i++, num /= 10)
            paramModes[i] = cast(ubyte) num % 10;
        return instruction;
    }

    int getOperand(size_t index) {
        assert(index > 0, "index has to be bigger than zero");
        auto mode = paramModes[index - 1];
        auto operand = tape[ip + index];
        if (mode == 0)
            return tape[operand];
        return operand;
    }

    void writeValue(size_t index, int value) {
        assert(index > 0, "index has to be bigger than zero");
        tape[tape[ip + index]] = value;
    }

    size_t ip = 0;
    int[] tape;
    ubyte[4] paramModes;
    ProgramState state;
}

int[] runProgram(int[] tape, int[] input ...) {
    auto program = Program(tape);
    auto output = appender!(int[]);
    auto result = program.run();
    auto index = 0;
    while(!result.hasHalted) {
        if (result.hasAskedForInput) {
            result = program.run(input[index]);
            index += 1;
        } else {
            output.put(result.value);
            result = program.run();
        }
    }
    return output.data;

}

int puzzle(int input) {
    auto text = readText("input/day5.txt");
    auto tape = text.strip.splitter(",").map!(to!int).array;
    auto result = runProgram(tape, input);
    return result[$-1];
}

version(day5) {
    void main() {
        writeln("Running puzzle1:");
        writeln(puzzle(1));
        writeln("----------");
        writeln("Running puzzle2:");
        writeln(puzzle(5));
    }
}
