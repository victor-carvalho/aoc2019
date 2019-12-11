import std.algorithm;
import std.array: array;
import std.conv: text, to;
import std.file: readText;
import std.string;

struct ExecutionResult {
    private enum ExecutionResultTag {
        Halted,
        AskedInput,
        Output,
    }

    static ExecutionResult halted() {
        return ExecutionResult(0, ExecutionResultTag.Halted);
    }

    static ExecutionResult output(long payload) {
        return ExecutionResult(payload, ExecutionResultTag.Output);
    }

    static ExecutionResult waitingInput() {
        return ExecutionResult(0, ExecutionResultTag.AskedInput);
    }

    @property bool hasHalted() {
        return tag == ExecutionResultTag.Halted;
    }

    @property bool hasAskedForInput() {
        return tag == ExecutionResultTag.AskedInput;
    }

    @property bool hasGivenOutput() {
        return tag == ExecutionResultTag.Output;
    }

    @property long value() {
        assert(hasGivenOutput);
        return payload;
    }

    private long payload = 0;
    private ExecutionResultTag tag;
}

enum ComputerState {
    NotStarted,
    Halted,
    WaitingInput,
    PausedForOutput,
}

struct Computer {
    this(long[] code) {
        program = code;
        state = ComputerState.NotStarted;
        paramModes = [0,0,0,0];
        ip = 0;
    }

    ExecutionResult run() {
        assert(state == ComputerState.NotStarted || state == ComputerState.PausedForOutput);
        return execute();
    }

    ExecutionResult run(long value) {
        assert(state == ComputerState.WaitingInput);
        writeToParameter(1, value);
        ip += 2;
        return execute();
    }

    @property bool isHalted() {
        return state == ComputerState.Halted;
    }

    @property bool isWaitingInput() {
        return state == ComputerState.WaitingInput;
    }

private:
    ExecutionResult execute() {
        while(true) {
            auto instruction = nextInstruction();
            switch(instruction) {
                case 1:
                    writeToParameter(3, readParameter(1) + readParameter(2));
                    ip += 4;
                    break;
                case 2:
                    writeToParameter(3, readParameter(1) * readParameter(2));
                    ip += 4;
                    break;
                case 3:
                    state = ComputerState.WaitingInput;
                    return ExecutionResult.waitingInput();
                case 4:
                    auto value = readParameter(1);
                    ip += 2;
                    state = ComputerState.PausedForOutput;
                    return ExecutionResult.output(value);
                case 5:
                    if(readParameter(1) != 0)
                        ip = readParameter(2);
                    else
                        ip += 3;
                    break;
                case 6:
                    if(readParameter(1) == 0)
                        ip = readParameter(2);
                    else
                        ip += 3;
                    break;
                case 7:
                    writeToParameter(3, readParameter(1) < readParameter(2));
                    ip += 4;
                    break;
                case 8:
                    writeToParameter(3, readParameter(1) == readParameter(2));
                    ip += 4;
                    break;
                case 9:
                    relativeBase += readParameter(1);
                    ip += 2;
                    break;
                case 99:
                    state = ComputerState.Halted;
                    return ExecutionResult.halted();
                default:
                    assert(false, text("invalid instruction ", instruction));
            }
        }
    }

    long nextInstruction() {
        auto code = program[ip];
        auto instruction = code % 100;
        paramModes[] = 0;
        for (auto i = 0, num = code / 100; i < paramModes.length && num > 0; i++, num /= 10)
            paramModes[i] = cast(ubyte) num % 10;
        return instruction;
    }

    long readParameter(size_t index) {
        assert(index > 0, "index has to be bigger than zero");
        auto operand = program[ip + index];
        final switch(paramModes[index - 1]) {
            case 0:
                return program[operand];
            case 1:
                return operand;
            case 2:
                return program[relativeBase + operand];
        }
    }

    void writeToParameter(size_t index, long value) {
        assert(index > 0, "index has to be bigger than zero");
        auto operand = program[ip + index];
        final switch(paramModes[index - 1]) {
            case 0:
                program[operand] = value;
                break;
            case 2:
                program[relativeBase + operand] = value;
                break;
        }
    }

    size_t ip = 0;
    long[] program;
    ubyte[4] paramModes;
    long relativeBase = 0;
    ComputerState state;
}

long[] parseProgram(string filename) {
    return readText(filename).strip.splitter(",").map!(to!long).array;
}