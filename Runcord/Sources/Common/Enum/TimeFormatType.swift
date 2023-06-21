//
//  StringFormat.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/06/21.
//

enum TimeFormatType {
    case hourMinuteSecond
}

extension TimeFormatType {
    var timeFormatter: String {
        switch self {
        case .hourMinuteSecond:
            return "%02d:%02d:%02d"
        }
    }
    
    func convertTimeToString(seconds: Int) -> String {
        switch self {
        case .hourMinuteSecond:
            let hour = seconds / 3600
            let minute = (seconds % 3600) / 60
            let second = seconds % 60
            return String(format: timeFormatter, hour, minute, second)
        }
    }
}
