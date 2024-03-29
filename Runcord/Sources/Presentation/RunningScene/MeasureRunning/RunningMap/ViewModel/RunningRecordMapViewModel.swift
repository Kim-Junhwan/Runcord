//
//  RunningRecordMapViewModel.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/26.
//

import CoreLocation
import RxCocoa
import RxSwift
import UIKit

class RunningRecordMapViewModel {
    
    private let locationService: LocationService
    var imageList: BehaviorRelay<[ImageInfo]> = BehaviorRelay(value: [])
    var imageListDriver: Driver<[ImageInfo]> {
        return imageList.asDriver()
    }
    let disposeBag = DisposeBag()
    
    init(locationService: LocationService) {
        self.locationService = locationService
    }
    
    func saveImage(image: UIImage, metaData: NSDictionary) {
        locationService.currentLocationSubject
            .compactMap({ $0 })
            .take(1)
            .subscribe(with: self) { owner, currentLocation in
                let currentLocationCoordinate = currentLocation.coordinate
                owner.imageList.accept(owner.imageList.value+[ImageInfo(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude, image: image, saveTime: Date())])
            }.dispose()
    }
    
}
