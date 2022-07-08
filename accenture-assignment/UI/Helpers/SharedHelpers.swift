//
//  SharedHelpers.swift
//  accenture-assignment
//
//  Created by Mohammad Bitar on 7/8/22.
//

import Foundation

func convertArrayToString(items: [String]) -> String {
    let formatter = ListFormatter()
    if let string = formatter.string(from: items) {
        return string
    }
    return ""
}
