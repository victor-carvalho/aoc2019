module challenges.day8;

import std.algorithm;
import std.array: array;
import std.conv;
import std.file;
import std.range;
import std.stdio;
import std.string;
import std.utf: byCodeUnit;

enum WIDTH = 25;
enum HEIGHT = 6;
enum LENGTH = WIDTH * HEIGHT;

long puzzle1() {
    auto input = readText("input/day8.txt").strip.byCodeUnit.map!(c => c - '0').array;
    auto layerMinZero = input.chunks(LENGTH).minElement!(layer => layer.count(0));
    return layerMinZero.count(1) * layerMinZero.count(2);
}

void puzzle2() {
    auto input = readText("input/day8.txt").strip.byCodeUnit.map!(c => c - '0').array;
    auto image = repeat(2, LENGTH).array;
    foreach(layer; input.chunks(LENGTH)) {
        auto nonTransparentColor = 0;
        foreach(index; 0..LENGTH) {
            if (image[index] == 2)
                image[index] = layer[index];
            if (image[index] != 2)
                nonTransparentColor += 1;
        }
        if (nonTransparentColor == LENGTH)
            break;
    }
    foreach(row; image.chunks(WIDTH)) {
        writeln(row.map!(pixel => pixel == 1 ? '*' : ' '));
    }
}

version(day8) {
    void main() {
        writeln("AOC2019 day8 puzzle1: ", puzzle1());
        writeln("AOC2019 day8 puzzle2:");
        puzzle2();
    }
}