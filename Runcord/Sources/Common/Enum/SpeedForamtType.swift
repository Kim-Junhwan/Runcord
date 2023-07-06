//
//  SpeedForamtType.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/07/07.
//

enum SpeedForamtType {
    case defaultFormat
}

extension SpeedForamtType {
    
    var speedFormatter: String {
        switch self {
        case .defaultFormat:
            return "%.2f"
        }
    }
    
}
