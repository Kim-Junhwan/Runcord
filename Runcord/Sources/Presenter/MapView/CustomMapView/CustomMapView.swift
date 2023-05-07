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
    
    func drawRoute(routeList: [CLLocation]) {
        mapView.drawRoute(routeCoordinators: routeList)
    }
    
    func appendImageAnnotation(imageAnnotation: ImageAnnotation) {
        mapView.addAnnotation(imageAnnotation)
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
