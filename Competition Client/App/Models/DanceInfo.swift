//
//  DanceInfo.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/24/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON


final class DanceInfo: NSObject, JSONAble {
	let roundID : String
	let setName : String
	let setSpeed : String
	let danceType : String
	let shoeType : String
	
	
	init(roundID : String, setName : String, setSpeed : String, danceType : String, shoeType : String) {
		self.roundID = roundID
		self.setName = setName
		self.setSpeed = setSpeed
		self.danceType = danceType
		self.shoeType = shoeType
	}
	
	static func fromJSON(_ source: [String : Any]) -> DanceInfo {
		let json = JSON(source)
		
		//TODO FIX
		
		let roundID = json["roundId"].stringValue
		let setName = json["setName"].stringValue
		let setSpeed = json["setSpeed"].stringValue
		let danceType = json["danceType"].stringValue
		let shoeType = json["shoeType"].stringValue
		
		return DanceInfo(roundID: roundID, setName: setName, setSpeed: setSpeed, danceType: danceType, shoeType: shoeType)
	}
}
