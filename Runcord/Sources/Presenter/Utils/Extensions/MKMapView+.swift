//
//  MKMapView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/04/10.
//

import MapKit

extension MKMapView {
    func centerToLocation(location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let coordinatorRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(coordinatorRegion, animated: true)
    }
    
    func drawRoute(routeCoordinators: [CLLocation]) {
        var coordinates: [CLLocationCoordinate2D] = []
        for location in routeCoordinators {
            let coordinate = location.coordinate
            coordinates.append(coordinate)
        }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        addOverlay(polyline)
    }
    
    func updateUserRoute(route: MKPolyline, newCoordinate: CLLocation) {
        let newCoordinate = newCoordinate.coordinate
        
    }
}
