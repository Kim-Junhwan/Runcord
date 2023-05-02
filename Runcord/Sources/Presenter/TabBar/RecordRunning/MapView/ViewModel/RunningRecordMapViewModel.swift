//
//  RunningRecordMapViewModel.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/26.
//
import UIKit
import CoreLocation
import RxCocoa

class RunningRecordMapViewModel {
    
    private let locationManager: CLLocationManager
    private var imageList: BehaviorRelay<[ImageInfo]> = BehaviorRelay(value: [])
    var imageListDriver: Driver<[ImageInfo]> {
        return imageList.asDriver()
    }
    
    init(locationManager: CLLocationManager) {
        self.locationManager = locationManager
    }
    
    func saveImage(image: UIImage, metaData: NSDictionary) {
        
    }
    
}
