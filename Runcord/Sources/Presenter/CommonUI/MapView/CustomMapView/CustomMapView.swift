//
//  CustomMapView.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/05.
//

import UIKit
import MapKit

class CustomMapView: UIView {
    
    let mapView: MKMapView = MKMapView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mapView)
        mapView.frame = bounds
        mapView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mapView.frame = bounds
    } 
    
    func updateRoute(from: CLLocation, to: CLLocation) {
        mapView.updateUserRoute(lastCoordinate: from, newCoordinate: to)
    }
    
    func drawRoute(routeList: [CLLocationCoordinate2D]) {
        mapView.drawRoute(routeCoordinators: routeList)
    }
    
    func appendImageAnnotation(imageAnnotation: ImageAnnotation) {
        mapView.addAnnotation(imageAnnotation)
    }
    
    func setMapRouteRegion(route: [CLLocationCoordinate2D]) {
        let center = getRunningRouteCenterCoordinate(coordinates: route)
        setRouteSizeRegion(center: center, coordinates: route)
    }
    
    func setRouteSizeRegion(center: CLLocationCoordinate2D, coordinates: [CLLocationCoordinate2D]) {
        let minLatitude = coordinates.min(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let maxLatitude = coordinates.max(by: { $0.latitude < $1.latitude })?.latitude ?? 0
        let minLongitude = coordinates.min(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        let maxLongitude = coordinates.max(by: { $0.longitude < $1.longitude })?.longitude ?? 0
        let span = MKCoordinateSpan(latitudeDelta: (maxLatitude - minLatitude) * 1.5, longitudeDelta: (maxLongitude - minLongitude) * 1.5)
        mapView.setRegion(MKCoordinateRegion(center: center, span: span), animated: false)
    }
    
    func getRunningRouteCenterCoordinate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
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
    
}

extension CustomMapView: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { fatalError() }
        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .tabBarSelect
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        var annotationView: ImageAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: ImageAnnotationView.identifier) as? ImageAnnotationView
        if annotationView == nil {
            annotationView = ImageAnnotationView(annotation: annotation, reuseIdentifier: ImageAnnotationView.identifier)
        }
        guard let imageAnnotation = annotation as? ImageAnnotation else { return nil}
        annotationView?.image = imageAnnotation.image
        annotationView?.annotation  = imageAnnotation
        annotationView?.centerOffset = CGPoint(x: 0, y: -(annotationView?.frame.size.height)!/2)
        return annotationView
    }
}
