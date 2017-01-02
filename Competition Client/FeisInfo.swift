//
//  FeisInfo.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/27/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON

final class FeisInfo: NSObject, JSONAble {
	let id: String
	let name: String
	
	init(id: String, name: String) {
		self.id = id
		self.name = name
	}
	
	static func fromJSON(_ source: [String : Any]) -> FeisInfo {
		let json = JSON(source)
		
		let id = json["_id"].stringValue
		let name = json["name"].stringValue
		
		return FeisInfo(id: id, name: name)
	}
	
}
