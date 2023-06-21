//
//  MKMapView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/10.
//

import MapKit

extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 500) {
        let coordinatorRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinatorRegion, animated: true)
    }
    
    func drawRoute(routeCoordinators: [CLLocationCoordinate2D]) {
        let polyline = MKPolyline(coordinates: routeCoordinators, count: routeCoordinators.count)
        addOverlay(polyline)
    }
    
    func updateUserRoute(lastCoordinate: CLLocation, newCoordinate: CLLocation) {
        let coordinates: [CLLocationCoordinate2D] = [lastCoordinate.coordinate, newCoordinate.coordinate]
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        addOverlay(polyline)
    }
}
