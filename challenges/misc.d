module misc;

struct Digits {
    int current = 0;
    bool done = false;

    this(int number) {
        current = number;
    }

    @property int front() {
        return current % 10;
    }

    @property bool empty() {
        return done;
    }

    void popFront() {
        if (!done) {
            current = current / 10;
            done =  current == 0;
        }
    }
}

Digits digits(int number) {
    return Digits(number);
}
