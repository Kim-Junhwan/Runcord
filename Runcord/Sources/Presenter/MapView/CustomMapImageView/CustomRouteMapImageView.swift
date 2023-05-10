//
//  CustomMapImageView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/10.
//

import UIKit
import CoreLocation
import RxSwift
import MapKit

class CustomRouteMapImageView: UIImageView {
    
    func setRouteImage(route coordinates: [CLLocationCoordinate2D]) {
        let options = setSnapshotOptions(coordinates: coordinates)
        let snapShotter = MKMapSnapshotter(options: options)
        snapShotter.start { snapshot, error in
            guard let snapshot = snapshot, error == nil else { fatalError() }
            self.image = snapshot.image
        }
    }
    
    private func makeRouteSizeRegion(center: CLLocationCoordinate2D, minLatitude: CLLocationDegrees, maxLatitude: CLLocationDegrees, minLongitude: CLLocationDegrees, maxLongitude: CLLocationDegrees) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.2, longitudeDelta: (maxLongitude - minLongitude) * 1.2)
        return MKCoordinateRegion(center: center, span: span)
    }
    
    private func getRunningRouteCenterCoordinate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D? {
        guard coordinates.isEmpty == false || coordinates.count > 1 else { return nil }
        
        var centerLat: CLLocationDegrees = 0
        var centerLon: CLLocationDegrees = 0
        
        for coordinate in coordinates {
            centerLat += coordinate.latitude
            centerLon += coordinate.longitude
        }
        
        centerLat /= Double(coordinates.count)
        centerLon /= Double(coordinates.count)
        
        return CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon)
    }
    
    private func setSnapshotOptions(coordinates: [CLLocationCoordinate2D]) -> MKMapSnapshotter.Options {
        let options = MKMapSnapshotter.Options()
        
        var minLatitude = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        var maxLatitude = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        var minLongitude = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        var maxLongitude = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        options.region = makeRouteSizeRegion(center: getRunningRouteCenterCoordinate(coordinates: coordinates) ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), minLatitude: minLatitude, maxLatitude: maxLatitude, minLongitude: minLongitude, maxLongitude: maxLongitude)
        options.size = CGSize(width: 200, height: 200)
        options.showsBuildings = false
        let filter: MKPointOfInterestFilter = .excludingAll
        options.pointOfInterestFilter = filter
        
        return options
    }
    
}
