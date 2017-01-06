//
//  Scoresheet.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/6/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Score : NSObject, JSONAble {
	let name : String
	let value : Int
	
	init(name : String, value : Int) {
		self.name = name
		self.value = value
	}
	
	static func fromJSON(_ source: [String : Any]) -> Score {
		let json = JSON(source)
		let name = json["name"].stringValue
		let value = json["value"].numberValue as Int
		return Score(name: name, value: value)
	}
}

enum ScoringStatus {
	case notAccessed
	case inProgress
	case complete
	case finalized
}

final class Scoresheet : NSObject, JSONAble {
	let feisId : String
	let roundId : String
	let dancerId : String
	let scoringStatus : String
	let scores : [Score]
	let comments : String?
	
	// ok for not not using scoring status, will use round's scoring status
	init(feisId: String, roundId: String, dancerId : String, scores: [Score], comments: String?, scoringStatus: String?) {
		self.feisId = feisId
		self.roundId = roundId
		self.dancerId = dancerId
		self.scoringStatus = scoringStatus ?? "in_progress"
		self.scores = scores
		self.comments = comments
	}
	
	static func fromJSON(_ source: [String : Any]) -> Scoresheet {
		let json = JSON(source)
		
		let feisId = json["feisId"].stringValue
		let roundId = json["roundId"].stringValue
		let dancerId = json["dancerId"].stringValue

		let scoringStatus = json["scoringStatus"].stringValue
		let comments = json["comments"].stringValue
		var scores: [Score] = []

		
		if let scoreArray = json["scores"].arrayObject as? Array<[String: AnyObject]> {
			scores = scoreArray.map{ return Score.fromJSON($0) }
		}
		
		
		return Scoresheet(feisId: feisId, roundId: roundId, dancerId: dancerId, scores: scores, comments: comments, scoringStatus: scoringStatus)
	}
	
}
