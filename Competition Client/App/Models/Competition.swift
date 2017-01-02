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
	let roundIDs : [String]
	let name : String
	let judgingStatus : String
	let currentRound : String?
	
	init (id : String, feisID : String, roundIDs : [String], name : String, judgingStatus : String, currentRound : String?) {
		self.id = id
		self.feisID = feisID
		self.roundIDs = roundIDs
		self.name = name
		self.judgingStatus = judgingStatus
		self.currentRound = currentRound
	}
	
	static func fromJSON(_ source: [String : Any]) -> Competition {
		let json = JSON(source)
		
		let id = json["id"].stringValue
		let feisID = json["feisID"].stringValue
		let name = json["name"].stringValue
		let judgingStatus = json["judgingStatus"].stringValue
		let currentRound = json["currentRound"].stringValue
		
		let roundIDs = (json["scoresheetIDs"].object as? [String]) ?? []
		
		return Competition(id: id, feisID: feisID, roundIDs: roundIDs, name: name, judgingStatus: judgingStatus, currentRound: currentRound)
	}
}
