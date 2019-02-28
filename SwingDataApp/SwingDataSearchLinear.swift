//
//  SwingDataSearchLinear.swift
//  SwingDataApp
//
//  Created by kylebeal-outlook on 2/28/19.
//  Copyright © 2019 kylebeal-outlook. All rights reserved.
//

import Foundation

public class SwingDataSearchLinear{
    public static func searchContinuityAboveValue(data: [Double], indexBegin: Int, indexEnd: Int, threshold: Double, winLength: Int) -> Int {
        if winLength > data.count || indexBegin >= indexEnd || indexBegin > data.count-1 {
            return -1
        }
        
        let end = indexEnd > data.count - 1 ? data.count - 1 : indexEnd
        
        let sliced = data[indexBegin...end] // values from indexBegin to indexEnd
        
        var winBegin = -1
        var cntAboveThreshold = 0
        
        // each between indexBegin and indexEnd
        for (i, value) in sliced.enumerated() {
            // if the value is above the threshold
            if value > threshold {
                // mark the beginning if not currently
                // amongst consecutive values above threshold
                // index is offset by startIndex of slice to correctly reference index in data
                if winBegin == -1 {
                    winBegin = i + sliced.startIndex
                }
                
                // increment count of values above threshold
                cntAboveThreshold += 1
                
                // if desired window length has been met return with beginning index
                if cntAboveThreshold >= winLength {
                    return winBegin
                }
            } else {
                // value is not above threshold
                // zero out counters
                winBegin = -1
                cntAboveThreshold = 0
            }
        }
        
        // not enough consecutive values above threshold
        return -1
    }
    
    public static func backSearchContinuityWithinRange(data: [Double], indexBegin: Int, indexEnd: Int, thresholdLo: Double, thresholdHi: Double, winLength: Int) -> Int {
        if winLength > data.count || indexBegin < indexEnd || indexBegin > data.count-1 {
            return -1
        }
        
        let begin = indexBegin > data.count - 1 ? data.count - 1 : indexBegin
        
        let sliced = data[indexEnd...begin] // values from indexBegin to indexEnd
        
        var winBegin = -1
        var cntAboveThreshold = 0
        
        // each between indexBegin and indexEnd, backwards
        for (i, value) in sliced.enumerated().reversed() {
            // if the value is above the threshold
            if value > thresholdLo && value < thresholdHi {
                // mark the beginning if not currently
                // amongst consecutive values above threshold
                if winBegin == -1 {
                    winBegin = i + sliced.startIndex
                }
                
                // increment count of values above threshold
                cntAboveThreshold += 1
                                
                // if desired window length has been met return with beginning index
                if cntAboveThreshold >= winLength {
                    return winBegin
                }
            } else {
                // value is not above threshold
                // zero out counters
                winBegin = -1
                cntAboveThreshold = 0
            }
        }
        
        // not enough consecutive values above threshold
        return -1
    }

    private static func searchAllContinuitiesAboveValue(data: [Double], threshold: Double, winLength: Int) -> [NSRange]? {
        var currentWindow: NSRange?
        var windows: [NSRange]?
        
        // every value in data
        for (i, value) in data.enumerated() {
            if value > threshold {
                // we're already in a window of values above threshold, extend range (window)
                if let range = currentWindow {
                    currentWindow = NSMakeRange(range.location, range.length + 1)
                } else {
                    // this is a new window
                    currentWindow = NSMakeRange(i, 1)
                }
            } else { // value is below threshold
                // if we have a currentWindow wide enough, add it to the output
                if let range = currentWindow, range.length >= winLength {
                    if windows?.append(range) == nil {
                        windows = [range]
                    }
                }
                // reset currentWindow to look for next
                currentWindow = nil
            }
        }
        
        // if we have a currentWindow wide enough, add it to the output
        if let range = currentWindow, range.length >= winLength {
            if windows?.append(range) == nil {
                windows = [range]
            }
        }
        
        return windows
    }
    
    public static func searchContinuityAboveValueTwoSignals(data1: [Double], data2: [Double], indexBegin: Int, indexEnd: Int, threshold1: Double, threshold2: Double, winLength: Int) -> Int {
        if winLength > data1.count || winLength > data2.count || indexBegin >= indexEnd || indexBegin > data1.count-1 || indexBegin > data2.count {
            return -1
        }
        
        // don't let indexEnd go beyond end of data sets
        let data1IndexEnd = indexEnd > data1.count - 1 ? data1.count - 1 : indexEnd
        let data2IndexEnd = indexEnd > data2.count - 1 ? data2.count - 1 : indexEnd
        
        let slice1 = data1[indexBegin...data1IndexEnd]
        let slice2 = data2[indexBegin...data2IndexEnd]
        
        // search each set of values for the first index of continous values above threshold
        // TODO: execute on separate threads and sync with Promises
        let data1Windows = searchAllContinuitiesAboveValue(data: Array(slice1), threshold: threshold1, winLength: winLength)
        let data2Windows = searchAllContinuitiesAboveValue(data: Array(slice2), threshold: threshold2, winLength: winLength)
        
        guard let data1ranges = data1Windows, let data2ranges = data2Windows, data1ranges.count > 0, data2ranges.count > 0 else {
            return -1
        }
        
        // for each of the windows found in the first data
        for range in data1ranges {
            // look for intersections with each range above threshold in second data
            for range2 in data2ranges {
                // if there is an intersection at least winLength, return the largest starting value of the two ranges
                if let intersection = range.intersection(range2), intersection.length >= winLength {
                    return max(range.location, range2.location)
                }
            }
        }
        
        return -1
    }
    
    public static func searchMultiContinuityWithinRange(data: [Double], indexBegin: Int, indexEnd: Int, thresholdLo: Double, thresholdHi: Double, winLength: Int) -> [[Int]]? {
        if winLength > data.count || indexBegin >= indexEnd || indexBegin > data.count-1 {
            return nil
        }
        
        let end = indexEnd > data.count - 1 ? data.count - 1 : indexEnd
        
        let sliced = data[indexBegin...end] // values from indexBegin to indexEnd
        
        var winBegin = -1
        var cntAboveThreshold = 0
        var ranges: [[Int]]?
        
        // each between indexBegin and indexEnd
        for (i, value) in sliced.enumerated() {
            // if the value is above the threshold
            if value > thresholdLo && value < thresholdHi {
                // mark the beginning if not currently
                // amongst consecutive values above threshold
                // index is offset by startIndex of slice to correctly reference index in data
                if winBegin == -1 {
                    winBegin = i + sliced.startIndex
                }
                
                // increment count of values above threshold
                cntAboveThreshold += 1
            } else { // value is not above threshold
                if winBegin != -1 && cntAboveThreshold >= winLength {
                    // just fell out of a window of values between tresholds at least winLength long
                    if (ranges?.append([winBegin, i-1]) == nil) {
                        ranges = [[winBegin, i-1]]
                    }
                }
                // zero out counters
                winBegin = -1
                cntAboveThreshold = 0
            }
        }
        
        return ranges
    }
}
