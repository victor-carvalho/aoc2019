#!/usr/bin/env rund

import std.array;
import std.algorithm;
import std.conv;
import std.file;
import std.stdio;
import std.string;

struct Program(alias inputHandler, alias outputHandler) {
    this(int[] program) {
        tape = program;
        done = false;
        paramModes = [0,0,0,0];
        ip = 0;
    }

    void run() {
        assert(!done, "trying to start program that already halted");
        execute();
    }

private:
    void execute() {
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
                    writeValue(1, inputHandler());
                    ip += 2;
                    break;
                case 4:
                    outputHandler(getOperand(1));
                    ip += 2;
                    break;
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
                    done = true;
                    return;
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
    bool done;
}

void puzzle(int input) {
    auto text = readText("input/day5.txt");
    auto tape = text.strip.splitter(",").map!(to!int).array;
    auto program = Program!(() => input, writeln)(tape);
    program.run();
}

void main() {
    writeln("Running puzzle1:");
    puzzle(1);
    writeln("----------");
    writeln("Running puzzle2:");
    puzzle(5);
}
