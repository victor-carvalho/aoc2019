#!/usr/bin/env day6.d

import std.algorithm;
import std.array;
import std.stdio;
import std.string;
import std.typecons;

alias Graph = string[][string];

long numberOfOrbits(Graph graph, string key) {
    auto entry = key in graph;
    if (entry !is null) {
        auto sum = entry.length;
        foreach(k; *entry) {
            sum += numberOfOrbits(graph, k);
        }
        return sum;
    }
    return 0;
}

long numberOfOrbits(Graph graph) {
    auto sum = 0;
    foreach(key, conns; graph) {
        sum += conns.length;
        foreach(conn; conns) {
            sum += graph.numberOfOrbits(conn);
        }
    }
    return sum;
}

long puzzle1() {
    auto file = File("input/day6.txt");
    Graph graph;
    foreach(kv; file.byLineCopy.map!(line => line.strip.split(")"))) {
        graph.require(kv[0], []) ~= kv[1];
    }
    return graph.numberOfOrbits;
}

int distance(Graph graph, string src, string dst) {
    int[string] dist;
    string[] queue;
    dist[src] = 0;
    queue ~= src;
    while(!queue.empty) {
        auto index = queue.minIndex!((a,b) => dist.require(a, int.max) < dist.require(b, int.max));
        auto node = queue[index];
        if (node == dst)
            break;
        queue = remove!(SwapStrategy.unstable)(queue, index);
        foreach(neighbor; graph[node]) {
            const alt = dist[node] + 1;
            if(alt < dist.require(neighbor, int.max)) {
                dist[neighbor] = alt;
                queue ~= neighbor;
            }
        }
    }
    return dist[dst] - 2;
}

long puzzle2() {
    auto file = File("input/day6.txt");
    Graph graph;
    foreach(kv; file.byLineCopy.map!(line => line.strip.split(")"))) {
        auto key = kv[0];
        auto value = kv[1];
        graph.require(key, []) ~= value;
        graph.require(value, []) ~= key;
    }
    return graph.distance("YOU", "SAN");
}

void main() {
    writeln("AOC2019 day6 puzzle1: ", puzzle1());
    writeln("AOC2019 day6 puzzle2: ", puzzle2());
}