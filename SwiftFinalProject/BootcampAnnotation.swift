//
//  BootcampAnnotation.swift
//  DevBootcamps
//
//  Created by Mark Price on 1/1/16.
//  Copyright © 2016 Mark Price. All rights reserved.
//

import Foundation
import MapKit

class BootcampAnnotation: NSObject, MKAnnotation {
    var coordinate = CLLocationCoordinate2D()
    var title: String?
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = "\(coordinate.latitude)"
    }
}