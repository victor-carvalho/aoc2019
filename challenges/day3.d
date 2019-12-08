#!/usr/bin/env rund

module day3;

import std.algorithm;
import std.array;
import std.conv: to;
import std.math;
import std.range;
import std.stdio;
import std.string;
import std.typecons;

enum Direction: ubyte {
    HORIZONTAL,
    VERTICAL,
}

struct Movement {
    Direction direction;
    int orthogonalPosition;
    int start;
    int delta;

    @property int end() {
        return start + delta;
    }
}

alias Position = Tuple!(int, int);
alias Line = Movement[];

Line parseLine(string line) {
    auto x = 0;
    auto y = 0;
    auto moves = appender!(Movement[]);
    foreach(input; line.splitter(",")) {
        auto delta = input[1..$].to!int;
        final switch(input.front) {
            case 'L':
                auto move = Movement(Direction.HORIZONTAL, y, x, -delta);
                x -= delta;
                moves.put(move);
                break;
            case 'R':
                auto move = Movement(Direction.HORIZONTAL, y, x, delta);
                x += delta;
                moves.put(move);
                break;
            case 'U':
                auto move = Movement(Direction.VERTICAL, x, y, delta);
                y += delta;
                moves.put(move);
                break;
            case 'D':
                auto move = Movement(Direction.VERTICAL, x, y, -delta);
                y -= delta;
                moves.put(move);
                break;
        }
    }
    return moves.data;
}

int distanceFromCenter(Position pos) {
    return abs(pos[0]) + abs(pos[1]);
}

bool isBetween(int n, int a, int b) {
    return (n - a) * (n - b) <= 0;
}

bool hasIntersection(Movement m1, Movement m2) {
    if (m1.direction == m2.direction)
        return false;
    return isBetween(m1.orthogonalPosition, m2.start, m2.end)
        && isBetween(m2.orthogonalPosition, m1.start, m1.end);
}

Position intersectionPosition(Movement m1, Movement m2) {
    if (m1.direction == Direction.HORIZONTAL)
        return tuple(m2.orthogonalPosition, m1.orthogonalPosition);
    else
        return tuple(m1.orthogonalPosition, m2.orthogonalPosition);
}

Position[] intersectionPositions(Line line1, Line line2) {
    auto intersections = appender!(Position[]);
    foreach(i1; line1) {
        foreach(i2; line2[1..$]) {
            if (hasIntersection(i1, i2))
                intersections.put(intersectionPosition(i1, i2));
        }       
    }
    return intersections.data;
}

int puzzle1() {
    auto file = File("../input/day3.txt");
    auto firstLine = file.readln.strip.parseLine;
    auto secondLine = file.readln.strip.parseLine;
    auto points = intersectionPositions(firstLine, secondLine);
    return points.map!distanceFromCenter.minElement;
}

int[] intersectionSteps(Line line1, Line line2) {
    auto intersections = appender!(int[]);
    auto l1steps = 0;
    foreach(i1; line1) {
        auto l2steps = abs(line2.front.delta);
        foreach(i2; line2[1..$]) {
            if (hasIntersection(i1, i2)) {
                auto l1IntersectionSteps = l1steps + abs(i2.orthogonalPosition - i1.start);
                auto l2IntersectionSteps = l2steps + abs(i1.orthogonalPosition - i2.start);
                intersections.put(l1IntersectionSteps + l2IntersectionSteps);
            }
            l2steps += abs(i2.delta);
        }       
        l1steps += abs(i1.delta);
    }
    return intersections.data;
}

int puzzle2() {
    auto file = File("../input/day3.txt");
    auto firstLine = file.readln.strip.parseLine;
    auto secondLine = file.readln.strip.parseLine;
    auto steps = intersectionSteps(firstLine, secondLine);
    return steps.minElement;
}

void main() {
    writeln("AOC2019 Day3 puzzle1: ", puzzle1());
    writeln("AOC2019 Day3 puzzle2: ", puzzle2());
}
