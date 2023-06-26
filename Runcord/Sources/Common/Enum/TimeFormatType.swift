//
//  StringFormat.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

enum TimeFormatType {
    case hourMinuteSecond
    case hourMinute
    case goalDistanceFormat
}

extension TimeFormatType {
    var timeFormatter: String {
        switch self {
        case .hourMinuteSecond:
            return "%02d:%02d:%02d"
        case .hourMinute:
            return "%02d:%02d"
        case .goalDistanceFormat:
            return "%02d%02d"
        }
    }
    
    func convertTimeToString(seconds: Int) -> String {
        
        let hour = seconds / 3600
        let minute = (seconds % 3600) / 60
        let second = seconds % 60
        
        switch self {
        case .hourMinuteSecond:
            return String(format: timeFormatter, hour, minute, second)
        case .hourMinute:
            return String(format: timeFormatter, hour, minute)
        case .goalDistanceFormat:
            return String(format: timeFormatter, hour, minute)
        }
    }
}
