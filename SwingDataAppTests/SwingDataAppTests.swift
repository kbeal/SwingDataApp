//
//  SwingDataAppTests.swift
//  SwingDataAppTests
//
//  Created by kylebeal-outlook on 2/28/19.
//  Copyright © 2019 kylebeal-outlook. All rights reserved.
//

import XCTest
@testable import SwingDataApp

class SwingDataAppTests: XCTestCase {
    
    var sdt1 = SwingDataPointTree(index: 0, timestamp: timestamps[0], value: values1[0])
    var sdt2 = SwingDataPointTree(index: 0, timestamp: timestamps[0], value: values2[0])

    override func setUp() {
        for (i, value) in values1.enumerated() {
            if i > 0 {
//                print("\(i): \(values1[i]), \(values2[i])")
                sdt1.insert(index: i, timestamp: timestamps[i], value: values1[i])
                sdt2.insert(index: i, timestamp: timestamps[i], value: values2[i])
            }
        }
    }

    func testSearchContinuityAbove() {
        let idx = SwingDataSearch.searchContinuityAboveValue(data: sdt1, indexBegin: 0, indexEnd: 999, threshold: 50.0, winLength: 6)
        XCTAssertEqual(idx, 121)
    }
    
    func testSearchContinuityAboveLinear() {
        let idx = SwingDataSearchLinear.searchContinuityAboveValue(data: values1, indexBegin: 0, indexEnd: 999, threshold: 50.0, winLength: 6)
        XCTAssertEqual(idx, 121)
    }
    
    func testBackSearchContinuityBetweenInvertedIndex() {
        let idx = SwingDataSearch.backSearchContinuityWithinRange(data: sdt1, indexBegin: 0, indexEnd: 999, thresholdLo: 40.0, thresholdHi: 80.0, winLength: 3)
        XCTAssertEqual(idx, -1)
    }
    
    func testSearchContinuityAboveValueTwoSignals() {
        let idx = SwingDataSearch.searchContinuityAboveValueTwoSignals(data1: sdt1, data2: sdt2, indexBegin: 0, indexEnd: 999, threshold1: 25.0, threshold2: 75.0, winLength: 4)
        XCTAssertEqual(idx, 906)
    }
    
    func testSearchContinuityAboveValueTwoSignalsLinear() {
        let idx = SwingDataSearchLinear.searchContinuityAboveValueTwoSignals(data1: values1, data2: values2, indexBegin: 0, indexEnd: 999, threshold1: 25.0, threshold2: 75.0, winLength: 4)
        XCTAssertEqual(idx, 906)
    }
    
    func testSearchMultiContinuityWithinRange() {
        let idxs = SwingDataSearch.searchMultiContinuityWithinRange(data: sdt1, indexBegin: 0, indexEnd: 999, thresholdLo: 45.0, thresholdHi: 85.0, winLength: 5)
        XCTAssertEqual(idxs[2][0], 205)
        XCTAssertEqual(idxs[2][1], 213)
    }
    
    func testSearchMultiContinuityWithinRangeLinear() {
        let idxs = SwingDataSearchLinear.searchMultiContinuityWithinRange(data: values1, indexBegin: 0, indexEnd: 999, thresholdLo: 45.0, thresholdHi: 85.0, winLength: 5)
        XCTAssertEqual(idxs![2][0], 205)
        XCTAssertEqual(idxs![2][1], 213)
    }
    
    func testBackSearchContinuityBetween() {
        let idx = SwingDataSearch.backSearchContinuityWithinRange(data: sdt1, indexBegin: 999, indexEnd: 0, thresholdLo: 40.0, thresholdHi: 80.0, winLength: 7)
        XCTAssertEqual(idx, 217)
    }
    
    func testBackSearchContinuityBetweenLinear() {
        let idx = SwingDataSearchLinear.backSearchContinuityWithinRange(data: smalldata, indexBegin: 12, indexEnd: 2, thresholdLo: 25.0, thresholdHi: 50.0, winLength: 4)
        XCTAssertEqual(idx, 9)
        let idx2 = SwingDataSearchLinear.backSearchContinuityWithinRange(data: smalldata, indexBegin: 6, indexEnd: 0, thresholdLo: 25.0, thresholdHi: 50.0, winLength: 4)
        XCTAssertEqual(idx2, 3)
        let idx3 = SwingDataSearchLinear.backSearchContinuityWithinRange(data: values1, indexBegin: 999, indexEnd: 0, thresholdLo: 40.0, thresholdHi: 80.0, winLength: 7)
        XCTAssertEqual(idx3, 217)
    }
    
//    func testPerformanceSearchAboveBST() {
//        self.measure {
//            for i in Range(0...1000) {
//                let _ = sdt1.searchValuesAbove(threshold: 50.0)
//            }
//        }
//        //let _ = sdt1.searchValuesAbove(threshold: 50.0)
//    }
//
//    func testPerformanceSearchContinuityAbove() {
//        self.measure {
//            for _ in Range(0...1000) {
//                let _ = SwingDataSearch.searchContinuityAboveValue(data: sdt1, indexBegin: 0, indexEnd: 999, threshold: 50.0, winLength: 5)
//            }
//        }
//    }
//
//    func testPerformanceSearchAboveLinear() {
//        self.measure {
//            for _ in Range(0...1000) {
//                let _ = SwingDataSearchLinear.searchContinuityAboveValue(data: values1, indexBegin: 0, indexEnd: 999, threshold: 50.0, winLength: 5)
//            }
//        }
//    }
}

let smalldata = [26.0, 49.0, 28.5, 27.0, 23.0, 6.0, 41.0, 27.0, 25.1, 26.0, 11.0, 29.0, 26.0, 27.0, 49.0]

let values1 = [50.0,40.0,12.0,55.0,9.0,73.0,46.0,32.0,85.0,96.0,51.0,25.0,62.0,13.0,86.0,76.0,93.0,6.0,74.0,74.0,62.0,27.0,8.0,90.0,4.0,71.0,39.0,13.0,44.0,86.0,36.0,3.0,79.0,38.0,15.0,77.0,36.0,42.0,34.0,95.0,11.0,23.0,100.0,30.0,13.0,3.0,75.0,88.0,53.0,91.0,40.0,94.0,97.0,27.0,57.0,79.0,16.0,42.0,19.0,15.0,45.0,98.0,57.0,33.0,26.0,26.0,89.0,35.0,64.0,92.0,47.0,94.0,99.0,55.0,23.0,32.0,55.0,24.0,64.0,56.0,21.0,89.0,47.0,63.0,4.0,2.0,21.0,36.0,42.0,79.0,39.0,88.0,1.0,12.0,92.0,25.0,87.0,48.0,67.0,28.0,99.0,47.0,42.0,56.0,24.0,87.0,85.0,23.0,1.0,48.0,12.0,20.0,64.0,98.0,85.0,22.0,83.0,77.0,7.0,91.0,2.0,66.0,87.0,93.0,64.0,74.0,84.0,62.0,62.0,12.0,22.0,40.0,57.0,83.0,67.0,40.0,28.0,67.0,35.0,4.0,38.0,81.0,35.0,93.0,36.0,71.0,81.0,63.0,79.0,74.0,27.0,66.0,50.0,99.0,33.0,58.0,76.0,95.0,73.0,35.0,23.0,55.0,16.0,24.0,16.0,100.0,87.0,83.0,65.0,43.0,11.0,28.0,94.0,31.0,50.0,86.0,19.0,5.0,82.0,18.0,58.0,96.0,30.0,16.0,85.0,42.0,26.0,66.0,69.0,50.0,41.0,36.0,48.0,67.0,42.0,15.0,3.0,1.0,1.0,57.0,74.0,21.0,16.0,49.0,87.0,74.0,68.0,57.0,62.0,49.0,78.0,71.0,50.0,52.0,43.0,51.0,41.0,79.0,10.0,62.0,23.0,32.0,49.0,70.0,8.0,7.0,19.0,37.0,46.0,51.0,72.0,93.0,65.0,9.0,62.0,84.0,80.0,8.0,93.0,13.0,31.0,78.0,79.0,4.0,17.0,85.0,16.0,29.0,34.0,82.0,63.0,33.0,13.0,24.0,5.0,35.0,14.0,9.0,9.0,75.0,51.0,58.0,91.0,24.0,71.0,97.0,82.0,98.0,36.0,62.0,68.0,9.0,10.0,97.0,70.0,74.0,84.0,11.0,13.0,82.0,11.0,52.0,54.0,80.0,20.0,91.0,47.0,60.0,71.0,72.0,62.0,39.0,40.0,95.0,65.0,83.0,68.0,29.0,39.0,89.0,13.0,41.0,57.0,66.0,60.0,99.0,32.0,53.0,10.0,79.0,8.0,85.0,72.0,46.0,16.0,71.0,75.0,59.0,1.0,69.0,4.0,2.0,36.0,15.0,52.0,35.0,8.0,99.0,93.0,74.0,28.0,47.0,95.0,37.0,1.0,14.0,32.0,58.0,52.0,49.0,42.0,95.0,14.0,99.0,46.0,60.0,42.0,95.0,15.0,9.0,49.0,20.0,96.0,4.0,4.0,63.0,97.0,9.0,14.0,41.0,45.0,83.0,94.0,49.0,34.0,80.0,60.0,30.0,14.0,98.0,81.0,36.0,84.0,24.0,95.0,100.0,78.0,61.0,37.0,95.0,86.0,66.0,69.0,21.0,70.0,89.0,27.0,49.0,23.0,90.0,43.0,98.0,82.0,11.0,46.0,73.0,77.0,32.0,50.0,56.0,4.0,20.0,74.0,56.0,87.0,76.0,4.0,51.0,81.0,23.0,98.0,16.0,90.0,20.0,34.0,80.0,53.0,9.0,4.0,39.0,99.0,51.0,40.0,62.0,55.0,2.0,46.0,75.0,28.0,20.0,83.0,18.0,50.0,30.0,42.0,38.0,34.0,98.0,76.0,97.0,1.0,35.0,83.0,75.0,23.0,48.0,21.0,69.0,8.0,9.0,87.0,66.0,30.0,48.0,2.0,4.0,3.0,70.0,94.0,87.0,18.0,38.0,68.0,86.0,99.0,27.0,40.0,40.0,32.0,96.0,19.0,92.0,36.0,53.0,15.0,62.0,66.0,46.0,80.0,51.0,93.0,57.0,7.0,16.0,18.0,82.0,59.0,86.0,96.0,43.0,43.0,91.0,46.0,57.0,7.0,97.0,29.0,33.0,57.0,15.0,68.0,25.0,16.0,58.0,98.0,14.0,50.0,21.0,81.0,65.0,40.0,36.0,85.0,93.0,29.0,57.0,25.0,22.0,51.0,25.0,1.0,71.0,91.0,40.0,17.0,17.0,61.0,94.0,50.0,14.0,63.0,29.0,96.0,22.0,76.0,43.0,54.0,3.0,12.0,91.0,11.0,61.0,64.0,42.0,78.0,59.0,96.0,8.0,28.0,11.0,72.0,60.0,31.0,37.0,3.0,85.0,92.0,81.0,82.0,94.0,66.0,26.0,82.0,47.0,62.0,48.0,84.0,42.0,14.0,53.0,37.0,45.0,72.0,51.0,15.0,98.0,92.0,87.0,4.0,58.0,16.0,30.0,30.0,2.0,3.0,14.0,62.0,99.0,19.0,48.0,47.0,60.0,85.0,84.0,27.0,77.0,36.0,60.0,12.0,52.0,61.0,87.0,30.0,100.0,33.0,100.0,39.0,63.0,90.0,40.0,89.0,10.0,29.0,68.0,49.0,64.0,11.0,37.0,57.0,22.0,41.0,22.0,9.0,29.0,29.0,80.0,26.0,30.0,20.0,36.0,76.0,89.0,59.0,79.0,65.0,55.0,12.0,6.0,63.0,77.0,70.0,20.0,84.0,77.0,96.0,34.0,17.0,88.0,15.0,78.0,91.0,10.0,47.0,62.0,84.0,79.0,5.0,73.0,44.0,8.0,78.0,45.0,91.0,97.0,14.0,38.0,70.0,34.0,26.0,64.0,10.0,33.0,73.0,33.0,51.0,41.0,31.0,5.0,6.0,42.0,80.0,97.0,40.0,100.0,40.0,38.0,66.0,67.0,53.0,58.0,88.0,57.0,20.0,96.0,65.0,51.0,90.0,85.0,89.0,2.0,10.0,44.0,72.0,38.0,8.0,99.0,11.0,92.0,40.0,34.0,97.0,46.0,97.0,66.0,22.0,61.0,53.0,13.0,96.0,22.0,88.0,94.0,17.0,20.0,9.0,32.0,88.0,12.0,84.0,6.0,22.0,71.0,96.0,7.0,1.0,84.0,44.0,19.0,45.0,96.0,61.0,16.0,85.0,20.0,53.0,91.0,66.0,42.0,62.0,86.0,100.0,90.0,17.0,34.0,69.0,68.0,93.0,73.0,11.0,89.0,29.0,53.0,99.0,96.0,75.0,23.0,69.0,70.0,42.0,99.0,27.0,80.0,82.0,69.0,13.0,36.0,97.0,76.0,93.0,60.0,75.0,74.0,32.0,52.0,27.0,53.0,43.0,83.0,41.0,81.0,75.0,70.0,89.0,91.0,31.0,11.0,52.0,90.0,96.0,47.0,30.0,61.0,24.0,24.0,56.0,81.0,8.0,14.0,64.0,63.0,43.0,100.0,31.0,23.0,26.0,92.0,64.0,1.0,76.0,60.0,29.0,95.0,75.0,87.0,25.0,11.0,8.0,68.0,72.0,61.0,99.0,62.0,97.0,2.0,77.0,62.0,17.0,40.0,34.0,37.0,34.0,14.0,86.0,13.0,44.0,62.0,41.0,24.0,23.0,85.0,79.0,69.0,89.0,96.0,68.0,79.0,62.0,14.0,46.0,34.0,32.0,81.0,62.0,77.0,35.0,13.0,57.0,48.0,45.0,49.0,93.0,22.0,27.0,66.0,14.0,69.0,84.0,94.0,93.0,77.0,30.0,48.0,27.0,75.0,32.0,82.0,70.0,98.0,49.0,16.0,34.0,45.0,93.0,34.0,75.0,91.0,35.0,96.0,28.0,50.0,1.0,6.0,23.0,36.0,15.0,72.0,67.0,88.0,94.0,96.0,82.0,73.0,95.0,9.0,58.0,34.0,42.0,43.0,56.0,50.0,58.0,9.0,54.0,71.0,55.0,23.0,50.0,27.0,53.0,52.0,67.0,31.0,58.0,80.0,69.0,50.0,94.0,4.0,8.0,91.0,4.0,62.0,22.0,25.0,55.0,61.0,83.0,45.0,32.0,79.0,19.0,11.0,28.0,46.0,42.0,19.0,66.0,68.0,16.0,14.0,63.0,13.0,23.0,2.0,35.0,23.0,71.0,59.0,64.0,52.0,31.0,26.0,30.0,65.0,84.0,23.0,13.0,34.0,74.0,72.0,48.0,81.0,68.0,78.0,26.0,72.0,52.0,30.0,17.0,16.0,30.0,74.0,11.0,41.0,93.0,52.0,4.0,22.0,17.0,26]

let values2 = [53.0,54.0,94.0,31.0,61.0,72.0,94.0,55.0,89.0,17.0,44.0,100.0,31.0,55.0,6.0,54.0,90.0,70.0,59.0,68.0,5.0,100.0,73.0,95.0,90.0,16.0,73.0,34.0,22.0,81.0,11.0,9.0,100.0,69.0,84.0,42.0,31.0,85.0,41.0,64.0,2.0,60.0,27.0,69.0,73.0,22.0,38.0,36.0,24.0,32.0,43.0,100.0,12.0,60.0,66.0,9.0,33.0,100.0,39.0,56.0,14.0,80.0,77.0,77.0,44.0,90.0,40.0,7.0,64.0,65.0,37.0,7.0,41.0,35.0,87.0,28.0,44.0,24.0,21.0,71.0,77.0,90.0,68.0,13.0,15.0,66.0,96.0,76.0,60.0,27.0,75.0,99.0,24.0,84.0,77.0,12.0,66.0,2.0,55.0,25.0,61.0,4.0,94.0,47.0,9.0,36.0,39.0,15.0,20.0,20.0,73.0,9.0,59.0,4.0,60.0,2.0,59.0,84.0,22.0,16.0,4.0,87.0,64.0,12.0,24.0,1.0,96.0,42.0,1.0,35.0,18.0,76.0,15.0,3.0,31.0,85.0,11.0,54.0,24.0,19.0,98.0,9.0,45.0,78.0,74.0,67.0,84.0,47.0,88.0,40.0,72.0,68.0,39.0,3.0,76.0,84.0,1.0,62.0,86.0,43.0,54.0,41.0,69.0,16.0,45.0,100.0,55.0,46.0,34.0,43.0,85.0,54.0,28.0,25.0,60.0,36.0,82.0,91.0,67.0,22.0,47.0,15.0,95.0,45.0,71.0,43.0,77.0,55.0,27.0,17.0,18.0,16.0,74.0,10.0,56.0,62.0,63.0,61.0,84.0,20.0,19.0,36.0,38.0,94.0,84.0,3.0,74.0,86.0,71.0,34.0,15.0,58.0,16.0,23.0,15.0,56.0,89.0,35.0,44.0,27.0,65.0,3.0,90.0,1.0,42.0,22.0,15.0,67.0,26.0,43.0,100.0,19.0,66.0,47.0,88.0,88.0,6.0,92.0,64.0,86.0,86.0,78.0,47.0,80.0,11.0,75.0,15.0,13.0,63.0,2.0,96.0,93.0,87.0,96.0,94.0,99.0,11.0,16.0,54.0,32.0,78.0,3.0,2.0,63.0,18.0,96.0,28.0,5.0,97.0,3.0,44.0,6.0,85.0,19.0,78.0,29.0,27.0,79.0,65.0,98.0,24.0,4.0,91.0,23.0,98.0,34.0,27.0,83.0,58.0,40.0,73.0,63.0,70.0,19.0,84.0,15.0,96.0,13.0,100.0,62.0,11.0,14.0,69.0,41.0,15.0,30.0,52.0,81.0,5.0,83.0,35.0,48.0,61.0,77.0,23.0,42.0,71.0,33.0,5.0,48.0,22.0,29.0,38.0,44.0,26.0,78.0,5.0,70.0,8.0,21.0,39.0,6.0,2.0,52.0,73.0,63.0,13.0,88.0,14.0,94.0,38.0,19.0,79.0,84.0,24.0,58.0,62.0,84.0,58.0,8.0,2.0,80.0,11.0,78.0,35.0,2.0,4.0,64.0,16.0,84.0,38.0,78.0,39.0,12.0,20.0,99.0,6.0,2.0,6.0,77.0,7.0,23.0,94.0,40.0,39.0,68.0,4.0,19.0,100.0,72.0,3.0,17.0,33.0,50.0,60.0,19.0,100.0,12.0,9.0,72.0,12.0,9.0,65.0,78.0,49.0,92.0,79.0,32.0,32.0,50.0,53.0,70.0,48.0,27.0,24.0,78.0,15.0,91.0,45.0,93.0,51.0,16.0,89.0,36.0,65.0,1.0,25.0,91.0,9.0,48.0,44.0,24.0,84.0,61.0,33.0,92.0,97.0,59.0,81.0,76.0,47.0,15.0,20.0,15.0,29.0,85.0,60.0,39.0,14.0,88.0,23.0,85.0,29.0,91.0,93.0,96.0,12.0,7.0,42.0,65.0,12.0,57.0,98.0,72.0,94.0,95.0,10.0,43.0,12.0,81.0,20.0,39.0,31.0,15.0,91.0,56.0,96.0,53.0,24.0,91.0,35.0,24.0,23.0,29.0,91.0,1.0,94.0,85.0,92.0,63.0,42.0,14.0,83.0,1.0,43.0,7.0,76.0,14.0,37.0,56.0,38.0,97.0,82.0,95.0,41.0,37.0,94.0,23.0,15.0,84.0,99.0,92.0,43.0,5.0,17.0,75.0,62.0,34.0,48.0,43.0,5.0,27.0,18.0,12.0,83.0,24.0,21.0,100.0,24.0,36.0,64.0,27.0,8.0,45.0,76.0,46.0,87.0,85.0,1.0,4.0,33.0,7.0,86.0,23.0,14.0,45.0,28.0,72.0,38.0,68.0,96.0,97.0,63.0,18.0,81.0,15.0,50.0,23.0,84.0,93.0,27.0,74.0,99.0,65.0,18.0,3.0,29.0,4.0,33.0,57.0,62.0,52.0,71.0,69.0,93.0,93.0,51.0,15.0,86.0,6.0,27.0,37.0,74.0,57.0,38.0,49.0,90.0,9.0,60.0,91.0,34.0,84.0,20.0,88.0,91.0,85.0,91.0,42.0,56.0,20.0,28.0,79.0,52.0,85.0,67.0,18.0,99.0,21.0,98.0,59.0,93.0,19.0,5.0,25.0,11.0,80.0,63.0,50.0,15.0,32.0,45.0,84.0,99.0,11.0,56.0,34.0,93.0,97.0,68.0,60.0,2.0,79.0,34.0,84.0,89.0,94.0,75.0,6.0,10.0,97.0,75.0,18.0,77.0,75.0,3.0,100.0,67.0,22.0,68.0,36.0,74.0,62.0,4.0,63.0,87.0,6.0,30.0,18.0,41.0,87.0,79.0,13.0,6.0,50.0,43.0,4.0,56.0,80.0,20.0,96.0,16.0,14.0,97.0,47.0,96.0,27.0,83.0,64.0,48.0,6.0,100.0,41.0,16.0,9.0,31.0,1.0,22.0,55.0,17.0,46.0,97.0,25.0,52.0,64.0,43.0,11.0,3.0,34.0,86.0,88.0,84.0,13.0,41.0,37.0,87.0,97.0,56.0,16.0,71.0,78.0,94.0,15.0,78.0,61.0,11.0,37.0,15.0,10.0,50.0,65.0,24.0,66.0,35.0,26.0,81.0,90.0,22.0,77.0,69.0,5.0,21.0,25.0,42.0,30.0,1.0,61.0,10.0,33.0,40.0,96.0,53.0,9.0,9.0,61.0,94.0,80.0,1.0,91.0,72.0,52.0,32.0,59.0,7.0,87.0,38.0,3.0,78.0,17.0,31.0,27.0,53.0,93.0,89.0,99.0,43.0,40.0,59.0,22.0,48.0,84.0,80.0,34.0,46.0,14.0,28.0,62.0,15.0,19.0,48.0,8.0,57.0,24.0,2.0,4.0,37.0,35.0,30.0,24.0,30.0,61.0,50.0,20.0,36.0,98.0,43.0,7.0,84.0,95.0,87.0,6.0,75.0,11.0,24.0,30.0,69.0,27.0,46.0,31.0,51.0,68.0,81.0,83.0,53.0,32.0,64.0,84.0,11.0,35.0,82.0,26.0,40.0,23.0,71.0,20.0,18.0,80.0,99.0,25.0,62.0,96.0,94.0,73.0,78.0,4.0,95.0,99.0,95.0,87.0,65.0,16.0,67.0,61.0,36.0,45.0,23.0,56.0,17.0,31.0,29.0,1.0,39.0,34.0,63.0,28.0,51.0,36.0,45.0,32.0,43.0,61.0,24.0,71.0,64.0,36.0,27.0,73.0,14.0,77.0,32.0,13.0,29.0,83.0,80.0,4.0,59.0,45.0,52.0,49.0,37.0,72.0,13.0,43.0,85.0,26.0,14.0,69.0,69.0,75.0,84.0,59.0,38.0,75.0,5.0,81.0,6.0,41.0,100.0,33.0,60.0,41.0,3.0,62.0,55.0,15.0,24.0,17.0,74.0,44.0,48.0,84.0,79.0,41.0,84.0,66.0,90.0,28.0,91.0,83.0,86.0,98.0,63.0,36.0,22.0,63.0,11.0,48.0,91.0,41.0,78.0,56.0,41.0,36.0,6.0,55.0,90.0,99.0,57.0,22.0,40.0,9.0,71.0,47.0,9.0,52.0,37.0,77.0,79.0,84.0,61.0,39.0,96.0,40.0,44.0,36.0,19.0,13.0,35.0,35.0,5.0,6.0,2.0,80.0,78.0,64.0,65.0,67.0,16.0,58.0,65.0,39.0,83.0,92.0,66.0,62.0,3.0,98.0,70.0,77.0,35.0,41.0,25.0,70.0,26.0,16.0,62.0,48.0,77.0,70.0,62.0,36.0,21.0,9.0,45.0,19.0,73.0,46.0,66.0,69.0,22.0,94.0,61.0,24.0,14.0,8.0,81.0,80.0,59.0,47.0,1.0,3]

let timestamps = [0,1249,2497,3746,4996,6243,7492,8741,9989,11238,12487,13735,14984,16235,17483,18730,19979,21229,22477,23725,24973,26222,27471,28720,29970,31217,32465,33716,34963,36212,37460,38709,39959,41206,42455,43704,44952,46201,47451,48698,49947,51196,52444,53693,54942,56190,57439,58688,59938,61185,62434,63682,64931,66183,67430,68677,69926,71176,72423,73673,74922,76169,77418,78667,79917,81164,82413,83661,84910,86159,87410,88656,89905,91153,92402,93651,94901,96148,97397,98646,99894,101143,102394,103640,104889,106138,107386,108635,109885,111132,112381,113630,114878,116127,117376,118624,119873,121122,122372,123619,124868,126118,127368,128614,129862,131112,132360,133611,134859,136106,137355,138603,139852,141102,142349,143598,144847,146095,147344,148593,149842,151090,152339,153587,154836,156085,157335,158582,159831,161079,162330,163577,164825,166076,167327,168574,169822,171069,172318,173566,174815,176065,177312,178561,179810,181060,182307,183556,184804,186053,187302,188550,189799,191048,192298,193545,194794,196042,197291,198540,199790,201037,202286,203536,204785,206032,207281,208529,209778,211028,212277,213524,214773,216023,217270,218519,219767,221016,222265,223516,224764,226011,227259,228510,229757,231005,232254,233507,234753,236000,237249,238498,239746,240997,242245,243492,244741,245990,247238,248487,249736,250984,252233,253482,254732,255979,257228,258478,259727,260974,262222,263473,264720,265969,267217,268466,269716,270963,272212,273461,274709,275958,277207,278455,279704,280955,282203,283450,284699,285947,287196,288445,289695,290942,292191,293439,294689,295937,297186,298434,299683,300934,302182,303429,304678,305926,307175,308425,309672,310921,312170,313420,314667,315916,317164,318413,319662,320912,322161,323408,324656,325907,327154,328402,329651,330900,332150,333397,334646,335896,337145,338392,339641,340889,342138,343388,344637,345884,347133,348383,349630,350879,352127,353376,354625,355875,357124,358371,359619,360870,362117,363365,364614,365863,367113,368360,369609,370858,372106,373355,374604,375852,377101,378351,379600,380847,382096,383344,384593,385842,387092,388339,389588,390836,392086,393334,394583,395831,397080,398331,399579,400826,402075,403323,404572,405822,407069,408318,409567,410817,412064,413313,414561,415810,417059,418307,419556,420805,422055,423302,424551,425799,427048,428300,429547,430794,432043,433292,434540,435791,437039,438286,439535,440784,442032,443281,444530,445778,447027,448276,449526,450773,452022,453272,454521,455768,457016,458267,459514,460763,462013,463260,464509,465757,467006,468256,469503,470752,472001,473249,474498,475747,476995,478244,479493,480741,481990,483239,484489,485736,486985,488233,489483,490731,491980,493231,494477,495726,496974,498225,499473,500720,501969,503218,504466,505715,506965,508212,509461,510710,511958,513207,514456,515704,516953,518202,519452,520699,521948,523196,524445,525694,526944,528191,529440,530689,531937,533188,534436,535683,536932,538181,539429,540678,541927,543175,544424,545673,546923,548170,549419,550669,551918,553165,554413,555664,556914,558160,559408,560658,561907,563154,564403,565652,566900,568149,569399,570646,571895,573144,574392,575641,576890,578138,579387,580636,581886,583133,584382,585630,586879,588128,589378,590625,591874,593124,594373,595620,596869,598117,599366,600616,601865,603112,604361,605611,606858,608107,609355,610604,611853,613103,614353,615599,616847,618097,619345,620595,621844,623091,624340,625588,626837,628087,629336,630583,631832,633082,634329,635578,636826,638075,639324,640574,641821,643070,644318,645567,646816,648066,649315,650562,651810,653061,654308,655557,656805,658054,659304,660551,661800,663049,664297,665546,666796,668043,669292,670541,671789,673038,674287,675535,676784,678033,679283,680530,681779,683027,684279,685525,686774,688022,689271,690521,691771,693017,694266,695514,696763,698013,699262,700509,701758,703008,704256,705504,706752,708001,709250,710498,711749,712996,714244,715495,716745,717991,719242,720488,721737,722985,724234,725484,726731,727980,729229,730479,731726,732975,734223,735472,736721,737969,739218,740467,741717,742964,744213,745461,746712,747959,749208,750456,751705,752955,754205,755451,756700,757948,759197,760447,761696,762943,764192,765440,766689,767938,769188,770435,771684,772934,774183,775430,776678,777929,779176,780425,781673,782923,784172,785419,786668,787917,789165,790414,791663,792911,794160,795411,796659,797906,799155,800405,801654,802901,804149,805398,806647,807897,809146,810393,811642,812890,814139,815389,816639,817885,819134,820382,821631,822881,824130,825377,826626,827876,829123,830372,831620,832869,834118,835368,836617,837864,839112,840363,841610,842858,844107,845356,846606,847853,849102,850352,851599,852848,854097,855345,856594,857843,859093,860340,861589,862839,864086,865335,866583,867832,869081,870329,871580,872827,874076,875324,876573,877823,879072,880319,881568,882816,884065,885315,886562,887811,889060,890310,891557,892806,894054,895303,896552,897802,899051,900298,901546,902797,904044,905292,906541,907793,909040,910287,911536,912785,914033,915284,916532,917779,919028,920277,921525,922774,924024,925271,926520,927769,929019,930266,931515,932763,934013,935261,936510,937758,939007,940258,941506,942753,944002,945250,946499,947750,948998,950245,951494,952742,953991,955240,956490,957737,958986,960237,961485,962732,963980,965231,966478,967726,968975,970227,971474,972721,973970,975219,976467,977716,978966,980213,981462,982711,983961,985208,986457,987707,988954,990203,991451,992702,993949,995197,996448,997695,998944,1000192,1001441,1002691,1003938,1005187,1006437,1007684,1008933,1010183,1011430,1012679,1013928,1015178,1016425,1017674,1018925,1020171,1021420,1022670,1023917,1025166,1026416,1027665,1028912,1030161,1031411,1032658,1033907,1035155,1036405,1037653,1038901,1040150,1041399,1042647,1043896,1045145,1046393,1047642,1048891,1050139,1051390,1052637,1053885,1055136,1056383,1057632,1058882,1060129,1061378,1062628,1063875,1065124,1066375,1067621,1068870,1070118,1071367,1072616,1073864,1075113,1076362,1077610,1078860,1080108,1081356,1082607,1083854,1085102,1086353,1087600,1088848,1090097,1091349,1092596,1093843,1095092,1096342,1097589,1098838,1100088,1101335,1102584,1103834,1105081,1106330,1107579,1108827,1110076,1111325,1112573,1113824,1115071,1116319,1117570,1118817,1120065,1121316,1122563,1123811,1125062,1126309,1127558,1128809,1130055,1131304,1132554,1133801,1135050,1136300,1137547,1138796,1140046,1141293,1142542,1143792,1145039,1146288,1147538,1148785,1150034,1151282,1152533,1153780,1155029,1156279,1157526,1158775,1160025,1161272,1162521,1163769,1165018,1166268,1167515,1168764,1170013,1171261,1172510,1173759,1175007,1176256,1177505,1178753,1180002,1181251,1182499,1183750,1184997,1186245,1187496,1188743,1189992,1191242,1192489,1193738,1194988,1196235,1197484,1198734,1199981,1201230,1202480,1203727,1204976,1206226,1207473,1208722,1209972,1211219,1212468,1213718,1214965,1216214,1217464,1218711,1219960,1221210,1222457,1223706,1224956,1226203,1227452,1228702,1229949,1231198,1232447,1233695,1234944,1236193,1237441,1238690,1239939,1241187,1242436,1243685,1244933,1246184,1247431,1248681,1249928,1251177,1252427,1253674,1254923,1256173,1257420,1258670,1259918,1261168,1262415,1263664,1264915,1266161,1267410,1268660,1269907,1271156,1272406,1273653,1274902,1276152,1277399,1278648,1279898,1281145,1282394,1283644,1284891,1286140,1287390,1288637,1289886,1291136,1292385,1293632,1294882,1296129,1297378,1298627,1299875,1301126,1302373,1303621,1304870,1306119,1307367,1308619,1309865,1311113,1312364,1313611,1314861,1316108,1317357,1318607,1319854,1321103,1322352,1323600,1324849,1326098,1327346,1328595,1329844,1331092,1332343,1333590,1334838,1336089,1337336,1338584,1339835,1341082,1342331,1343581,1344828,1346077,1347327,1348574,1349823,1351073,1352320,1353569,1354819,1356066,1357315,1358565,1359812,1361061,1362309,1363560,1364807,1366055,1367304,1368553,1369802,1371052,1372299,1373549,1374796,1376045,1377295,1378542,1379791,1381041,1382288,1383537,1384786,1386034,1387283,1388532,1389780,1391029,1392278,1393526,1394775,1396024,1397272,1398523,1399770,1401020,1402267,1403516,1404766,1406013,1407262,1408512,1409759,1411009,1412257,1413507,1414754,1416003,1417254,1418500,1419749,1420999,1422246,1423495,1424745,1425992,1427241,1428491,1429738,1430987,1432237,1433484,1434733,1435983,1437230,1438479,1439729,1440976,1442225,1443475,1444724,1445971,1447221,1448468,1449717,1450966,1452214,1453465,1454713,1455960,1457209,1458458,1459706,1460957,1462204,1463454,1464701,1465950,1467200,1468447,1469696,1470946,1472193,1473442,1474691,1475939,1477188,1478438,1479685,1480934,1482184,1483431,1484682,1485929,1487177,1488428,1489675,1490923,1492174,1493421,1494670,1495920,1497167,1498416,1499666,1500913,1502162,1503412,1504659,1505908,1507156,1508405,1509654,1510904,1512151,1513400,1514650,1515897,1517146,1518394,1519645,1520892,1522141,1523391,1524638,1525887,1527137,1528384,1529634,1530881,1532130,1533379,1534627,1535876,1537125,1538375,1539622,1540871,1542121,1543368,1544617,1545865,1547114,1548363,1549611,1550863,1552109,1553358,1554608,1555855,1557104,1558354,1559601,1560850,1562100,1563347,1564596,1565844,1567093,1568342,1569590,1570839,1572088,1573336,1574585,1575834,1577082,1578333,1579580,1580828,1582079,1583326,1584575,1585825,1587072,1588321,1589571,1590818,1592068]
