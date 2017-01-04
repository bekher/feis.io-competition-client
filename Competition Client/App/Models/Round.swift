//
//  Round.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/2/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Round: NSObject, JSONAble {
	let id: String
	let number: Int
	let competitionId: String
	let feisId: String
	let location: String
	let danceType: String
	let shoeType: String
	let judgingStatus: String
	let dancerIds: [String]
	
	init(id: String, number : Int, competitionId: String, feisId: String, location: String, danceType: String, shoeType: String, judgingStatus: String, dancerIds: [String]) {
		self.id = id
		self.number = number
		self.competitionId = competitionId
		self.feisId = feisId
		self.location = location
		self.danceType = danceType
		self.shoeType = shoeType
		self.judgingStatus = judgingStatus
		self.dancerIds = dancerIds
	}
	
	static func fromJSON(_ source: [String : Any]) -> Round {
		let json = JSON(source)
		
		let id = json["_id"].stringValue
		let number = json["number"].numberValue.intValue
		let competitionId = json["competitionId"].stringValue
		let feisId = json["feisId"].stringValue
		let location = json["location"].stringValue
		let danceType = json["danceType"].stringValue
		let shoeType = json["shoeType"].stringValue
		let judgingStatus = json["judgingStatus"].stringValue
		let dancerIds : [String] = []//TODO: Parse
		
		return Round(id: id, number: number, competitionId: competitionId, feisId: feisId, location: location, danceType: danceType, shoeType: shoeType, judgingStatus: judgingStatus, dancerIds: dancerIds)
	}
}
