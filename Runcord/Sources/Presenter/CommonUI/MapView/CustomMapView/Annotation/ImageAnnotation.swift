//
//  ImageAnnotation.swift
//  Runcord
//
//  Created by JunHwan Kim on 2023/05/04.
//

import Foundation
import MapKit

class ImageAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var image: UIImage?
    var colour: UIColor?

    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = nil
        self.subtitle = nil
        self.image = nil
        self.colour = UIColor.white
    }
}
