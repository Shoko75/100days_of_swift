//
//  Capital.swift
//  Project16_CapitalCities
//
//  Created by Shoko Hashimoto on 2020-06-02.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import MapKit
import UIKit

class Capital: NSObject, MKAnnotation {
	var title: String?
	var coordinate: CLLocationCoordinate2D
	var info: String
	
	init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
		self.title = title
		self.coordinate = coordinate
		self.info = info
	}
}
