//
//  Petition.swift
//  Project7_WhitehousePetitions
//
//  Created by Shoko Hashimoto on 2020-06-02.
//  Copyright © 2020 Shoko Hashimoto. All rights reserved.
//

import Foundation

struct Petition: Codable {
	var title: String
	var body: String
	var signatureCount: Int
}
