//
//  SwingDataPointTree.swift
//  SwingDataApp
//
//  Created by kylebeal-outlook on 2/28/19.
//  Copyright © 2019 kylebeal-outlook. All rights reserved.
//

import Foundation

// Binary Search Tree with specialized search functions to return values above/below thresholds
public class SwingDataPointTree {
    public var index: Int
    public var timestamp: Int
    public var value: Double
    var parent: SwingDataPointTree?
    var left: SwingDataPointTree?
    var right: SwingDataPointTree?
    
    public init(index: Int, timestamp: Int, value: Double) {
        self.index = index
        self.timestamp = timestamp
        self.value = value
    }
    
    // insert a new node into the tree, values larger than current go the right
    // values smaller than current go to the left
    public func insert(index: Int, timestamp: Int, value: Double) {
        if value < self.value {
            if let left = self.left {
                left.insert(index: index, timestamp: timestamp, value: value)
            } else {
                self.left = SwingDataPointTree(index: index, timestamp: timestamp, value: value)
                self.left?.parent = self
            }
        } else {
            if let right = self.right {
                right.insert(index: index, timestamp: timestamp, value: value)
            } else {
                self.right = SwingDataPointTree(index: index, timestamp: timestamp, value: value)
                self.right?.parent = self
            }
        }
    }
    
    // finds all nodes having values above given threshold
    public func searchValuesAbove(threshold: Double) -> [SwingDataPointTree]? {
        var result: [SwingDataPointTree]?

        if self.value <= threshold {
            result = self.right?.searchValuesAbove(threshold: threshold)
        } else {
            //let right = self.right?.inOrder()
            let right = self.right?.searchValuesAbove(threshold: threshold)
            let left = self.left?.searchValuesAbove(threshold: threshold)

            result = [self] + (right ?? []) + (left ?? [])
        }

        return result
    }
    
    // finds all nodes having values below given threshold
    public func searchValuesBelow(threshold: Double) -> [SwingDataPointTree]? {
        var result: [SwingDataPointTree]?
        
        if self.value >= threshold {
            result = self.left?.searchValuesBelow(threshold: threshold)
        } else {
            let right = self.right?.searchValuesBelow(threshold: threshold) // right nodes might be above or below threshold
            let left = self.left?.inOrder() // left nodes are below threshold
            
            result = [self] + (left ?? []) + (right ?? [])
        }
        
        return result
    }
    
    public func searchValuesBetween(thresholdLo: Double, thresholdHi: Double) -> [SwingDataPointTree]? {
        var left: [SwingDataPointTree]?
        var right: [SwingDataPointTree]?
        
        if self.value > thresholdLo {
            left = self.left?.searchValuesBetween(thresholdLo: thresholdLo, thresholdHi: thresholdHi)
        }
        
        if self.value < thresholdHi {
            right = self.right?.searchValuesBetween(thresholdLo: thresholdLo, thresholdHi: thresholdHi)
        }
        
        if self.value >= thresholdLo && self.value <= thresholdHi {
            return [self] + (left ?? []) + (right ?? [])
        } else {
            return (left ?? []) + (right ?? [])
        }
    }
    
    public func inOrder() -> [SwingDataPointTree] {
        var result: [SwingDataPointTree] = []
        
        if let left = self.left?.inOrder() {
            result = result + left
        }
        
        result.append(self)
        
        if let right = self.right?.inOrder() {
            result = result + right
        }
        
        return result
    }
}

