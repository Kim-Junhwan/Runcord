//
//  Speed.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/07/06.
//

struct Speed {
    private let _value: Double
    
    var value: Double {
        get {
            return _value
        }
    }
    
    static var zero: Speed {
        return Speed(value: 0.0)
    }
    
    init(value: Double) {
        self._value = value
    }
    
    static func + (lhs: Speed, rhs: Speed) -> Speed {
        return Speed(value: lhs.value + rhs.value)
    }
}
