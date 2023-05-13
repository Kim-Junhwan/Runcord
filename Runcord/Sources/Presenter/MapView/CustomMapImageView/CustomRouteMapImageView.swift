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
            let mapImage = snapshot.image
            let runningOverlayMapImage = UIGraphicsImageRenderer(size: mapImage.size).image { _ in
                mapImage.draw(at: .zero)
                let points = coordinates.map { snapshot.point(for: $0) }
                let path = UIBezierPath()
                path.move(to: points.first ?? CGPoint(x: 0, y: 0))
                
                for point in points.dropFirst() {
                    path.addLine(to: point)
                }
                
                path.lineWidth = 5
                UIColor.tabBarSelect.setStroke()
                path.stroke()
            }
            self.image = runningOverlayMapImage
        }
    }
    
    private func makeRouteSizeRegion(center: CLLocationCoordinate2D, minLatitude: CLLocationDegrees, maxLatitude: CLLocationDegrees, minLongitude: CLLocationDegrees, maxLongitude: CLLocationDegrees) -> MKCoordinateRegion {
        let span = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.5, longitudeDelta: (maxLongitude - minLongitude) * 1.5)
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
        
        let minLatitude = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let maxLatitude = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let minLongitude = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        let maxLongitude = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        options.region = makeRouteSizeRegion(center: getRunningRouteCenterCoordinate(coordinates: coordinates) ?? CLLocationCoordinate2D(latitude: 0, longitude: 0), minLatitude: minLatitude, maxLatitude: maxLatitude, minLongitude: minLongitude, maxLongitude: maxLongitude)
        options.size = CGSize(width: 400, height: 400)
        options.showsBuildings = true
        let filter: MKPointOfInterestFilter = .excludingAll
        options.pointOfInterestFilter = filter
        
        return options
    }
    
}
