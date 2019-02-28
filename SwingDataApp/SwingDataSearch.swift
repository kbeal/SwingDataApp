//
//  SwingDataSearch.swift
//  SwingDataApp
//
//  Created by kylebeal-outlook on 2/28/19.
//  Copyright © 2019 kylebeal-outlook. All rights reserved.
//

import Foundation

public class SwingDataSearch {
    public static func searchContinuityAboveValue(data: SwingDataPointTree, indexBegin: Int, indexEnd: Int, threshold: Double, winLength: Int) -> Int {
        // get all values above threshold
        guard let pointsAboveThresh: [SwingDataPointTree] = data.searchValuesAbove(threshold: threshold), pointsAboveThresh.count >= winLength else {
            return -1
        }
        
        // select only the data points between the given index values
        let sliced = pointsAboveThresh.filter { $0.index >= indexBegin && $0.index <= indexEnd }
        // sort by index
        let sortedByIndex = sliced.sorted(by: {$0.index < $1.index})
        let indices = sortedByIndex.map { $0.index }
        
        // iterate through each index and find the first
        // window of consecutive values at least winLength long
        var currWinLen = 1
        var winStart = 0
        for (i, value) in indices.enumerated() {
            if i != 0 {
                if (value - indices[i-1] == 1) {
                    currWinLen += 1
                    if winStart == -1 {
                        winStart = indices[i-1]
                    }
                    if currWinLen >= winLength {
                        break
                    }
                } else {
                    currWinLen = 1
                    winStart = -1
                }
            }
        }
        
        return winStart
    }
    
    public static func backSearchContinuityWithinRange(data: SwingDataPointTree, indexBegin: Int, indexEnd: Int, thresholdLo: Double, thresholdHi: Double, winLength: Int) -> Int {
        if indexBegin < indexEnd {
            return -1
        }
        
        // get all values between thresholds
        guard let pointsInThresh = data.searchValuesBetween(thresholdLo: thresholdLo, thresholdHi: thresholdHi), pointsInThresh.count >= winLength else {
            return -1
        }
        
        
        // select only the data points between the given index values
        let sliced = pointsInThresh.filter { $0.index <= indexBegin && $0.index >= indexEnd }
        // sort by index
        let sortedByIndex = sliced.sorted(by: {$0.index > $1.index})
        let indices = sortedByIndex.map { $0.index }
        
        // iterate through each index and find the first
        // window of consecutive values at least winLength long
        var currWinLen = 1
        var winStart = indexBegin
        for (i, value) in indices.enumerated() {
            if i != 0 {
                if (value - indices[i-1] == -1) {
                    currWinLen += 1
                    if winStart == -1 {
                        winStart = value + 1
                    }
                    if currWinLen >= winLength {
                        break
                    }
                } else {
                    currWinLen = 1
                    winStart = -1
                }
            }
        }
        
        return winStart
    }
    
    public static func searchContinuityAboveValueTwoSignals(data1: SwingDataPointTree, data2: SwingDataPointTree, indexBegin: Int, indexEnd: Int, threshold1: Double, threshold2: Double, winLength: Int) -> Int {
        // get all values above thresholds
        guard let data1values = data1.searchValuesAbove(threshold: threshold1), let data2values = data2.searchValuesAbove(threshold: threshold2), data1values.count >= winLength, data2values.count >= winLength else {
            return -1
        }

        // select only the data points between the given index values
        let sliced1 = data1values.filter { $0.index >= indexBegin && $0.index <= indexEnd }
        let sliced2 = data2values.filter { $0.index >= indexBegin && $0.index <= indexEnd }
        // sort by index
        let sortedByIndex1 = sliced1.sorted(by: {$0.index < $1.index})
        let sortedByIndex2 = sliced2.sorted(by: {$0.index < $1.index})
        let indices1 = sortedByIndex1.map { $0.index }
        let indices2 = sortedByIndex2.map { $0.index }
        // find all windows of at least winLength
        let ranges1 = findIndexRanges(indices: indices1, indexEnd: indexEnd, winLength: winLength)
        let ranges2 = findIndexRanges(indices: indices2, indexEnd: indexEnd, winLength: winLength)

        if ranges1.count > 0 && ranges2.count > 0 {
            // for each of the windows found in the first data
            for range in ranges1 {
                // look for intersections with each range above threshold in second data
                for range2 in ranges2 {
                    // if there is an intersection at least winLength, return the largest starting value of the two ranges
                    if let intersection = range.intersection(range2), intersection.length >= winLength {
                        return max(range.location, range2.location)
                    }
                }
            }
        }

        return -1
    }
    
    // for a given array of indices
    private static func findIndexRanges(indices: [Int], indexEnd: Int, winLength: Int) -> [NSRange] {
        var windows: [NSRange] = []
        var currWinLen = 1
        var winStart = 0
        var winEnd = 0
        for (i, value) in indices.enumerated() {
            if i != 0 {
                if (value - indices[i-1] == 1) {
                    currWinLen += 1
                } else {
                    if currWinLen >= winLength {
                        winEnd = indices[i-1]
                        windows.append(NSMakeRange(winStart, (winEnd-winStart + 1)))
                    }
                    currWinLen = 1
                    winStart = value
                    winEnd = -1
                }
            }
        }
        
        if currWinLen >= winLength {
            winEnd = indexEnd
            windows.append(NSMakeRange(winStart, (winEnd-winStart + 1)))
        }
        
        return windows
    }
    
    public static func searchMultiContinuityWithinRange(data: SwingDataPointTree, indexBegin: Int, indexEnd: Int, thresholdLo: Double, thresholdHi: Double, winLength: Int) -> [[Int]] {
        // get all values between thresholds
        guard let pointsInThresh = data.searchValuesBetween(thresholdLo: thresholdLo, thresholdHi: thresholdHi), pointsInThresh.count >= winLength else {
            return [[-1]]
        }
        
        // select only the data points between the given index values
        let sliced = pointsInThresh.filter { $0.index >= indexBegin && $0.index <= indexEnd }
        // sort by index
        let sortedByIndex = sliced.sorted(by: {$0.index < $1.index})
        let indices = sortedByIndex.map { $0.index }
        
        var windows: [[Int]] = []
        var currWinLen = 1
        var winStart = 0
        var winEnd = 0
        for (i, value) in indices.enumerated() {
            if i != 0 {
                if (value - indices[i-1] == 1) {
                    currWinLen += 1
                } else {
                    if currWinLen >= winLength {
                        winEnd = indices[i-1]
                        windows.append([winStart,winEnd])
                    }
                    currWinLen = 1
                    winStart = value
                    winEnd = -1
                }
            }
        }
        
        if currWinLen >= winLength {
            winEnd = indexEnd
            windows.append([winStart,winEnd])
        }
        
        return windows
    }
}

