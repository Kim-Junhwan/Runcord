//
//  DistanceFormat.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

enum DistanceFormatType {
    case defaultFormat
}

extension DistanceFormatType {
    
    var distanceFormatter: String {
        switch self {
        case .defaultFormat:
            return "%.2f"
        }
    }
    
}
