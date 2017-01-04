//
//  Competition.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/26/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON


final class Competition: NSObject, JSONAble {
	let id : String
	let feisID : String
	let name : String
	let judgingStatus : String
	let currentRound : String?
	let rounds : [Round]
	
	init (id : String, feisID : String, rounds : [Round], name : String, judgingStatus : String, currentRound : String?) {
		self.id = id
		self.feisID = feisID
		self.rounds = rounds
		self.name = name
		self.judgingStatus = judgingStatus
		self.currentRound = currentRound
	}
	
	static func fromJSON(_ source: [String : Any]) -> Competition {
		let json = JSON(source)
		
		let id = json["_id"].stringValue
		let feisID = json["feisId"].stringValue
		let name = json["name"].stringValue
		let judgingStatus = json["judgingStatus"].stringValue
		let currentRound = json["currentRound"].stringValue
		var rounds : [Round] = []
		
		if let roundArray = json["rounds"].arrayObject as? Array<[String: AnyObject]> {
			rounds = roundArray.map{ return Round.fromJSON($0) }
		}
		
		//let roundIDs = (json["scoresheetIDs"].object as? [String]) ?? []
		
		return Competition(id: id, feisID: feisID, rounds: rounds, name: name, judgingStatus: judgingStatus, currentRound: currentRound)
	}
}
