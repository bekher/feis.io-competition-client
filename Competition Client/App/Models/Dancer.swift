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
	let competitionIds : [String]
	let number : Int
	let firstName : String
	let lastName : String
	let ageGroup : String
	let danceInfos : [DanceInfo]
	let scoresheetIDs : [String]
	
	init(id: String, competitionIds: [String], number : Int, firstName : String , lastName: String, ageGroup : String, danceInfos : [DanceInfo], scoresheetIDs : [String]) {
		self.id = id
		self.competitionIds = competitionIds
		self.number = number
		self.firstName = firstName
		self.lastName = lastName
		self.ageGroup = ageGroup
		self.danceInfos = danceInfos
		self.scoresheetIDs = scoresheetIDs
	}
	
	static func fromJSON(_ source: [String : Any]) -> Dancer {
		let json = JSON(source)
		
		let id = json["_id"].stringValue
		let competitionIds = (json["competitionIds"].arrayObject as? [String]) ?? []
		let number = json["number"].intValue
		let firstName = json["firstName"].stringValue
		let lastName = json["lastName"].stringValue
		let ageGroup = json["ageGroup"].stringValue
		var danceInfos : [DanceInfo] = []
		if let danceInfoArray = json["danceInfo"].arrayObject as? Array<[String: AnyObject]> {
			danceInfos = danceInfoArray.map{ return DanceInfo.fromJSON($0) }
		}
		let scoresheetIDs = (json["scoresheetIDs"].object as? [String]) ?? []

		return Dancer(id: id, competitionIds: competitionIds, number: number, firstName: firstName, lastName: lastName, ageGroup: ageGroup, danceInfos: danceInfos, scoresheetIDs: scoresheetIDs)
	}
}
