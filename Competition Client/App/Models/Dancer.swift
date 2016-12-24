//
//  Dancer.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/24/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON


final class Dancer: NSObject, JSONAble {
	let id : String
	let number : Int
	let firstName : String
	let lastName : String
	let ageGroup : String
	let danceInfo : DanceInfo
	let scoresheetIDs : [String]
	
	init(id: String, number : Int, firstName : String , lastName: String, ageGroup : String, danceInfo : DanceInfo, scoresheetIDs : [String]) {
		self.id = id
		self.number = number
		self.firstName = firstName
		self.lastName = lastName
		self.ageGroup = ageGroup
		self.danceInfo = danceInfo
		self.scoresheetIDs = scoresheetIDs
	}
	
	static func fromJSON(_ source: [String : Any]) -> Dancer {
		let json = JSON(source)
		
		let id = json["id"].stringValue
		let number = json["number"].intValue
		let firstName = json["firstName"].stringValue
		let lastName = json["lastName"].stringValue
		let ageGroup = json["ageGroup"].stringValue
		var danceInfo : DanceInfo?
		if let danceInfoDict = json["danceInfo"].object as? [String : AnyObject] {
			danceInfo = DanceInfo.fromJSON(danceInfoDict)
		} else {
			print("@Dance: could not extract dance info from dancer JSON")
		}
		let scoresheetIDs = (json["scoresheetIDs"].object as? [String]) ?? []
		return Dancer(id: id, number: number, firstName: firstName, lastName: lastName, ageGroup: ageGroup, danceInfo: danceInfo!, scoresheetIDs: scoresheetIDs)
	}
}
