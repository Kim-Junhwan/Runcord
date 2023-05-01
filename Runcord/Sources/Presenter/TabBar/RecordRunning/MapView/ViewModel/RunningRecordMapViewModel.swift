//
//  RunningRecordMapViewModel.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/26.
//
import UIKit
import CoreLocation

class RunningRecordMapViewModel {
    
    private let locationManager: CLLocationManager
    private var imageList: [ImageInfo] = []
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func saveImage(image: UIImage) {
    }
    
}
