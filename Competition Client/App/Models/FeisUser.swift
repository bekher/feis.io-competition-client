//
//  FeisUser.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/27/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Role {
	case admin
	case judge
	case stagemgr
	case unknown
}
extension Role {
	static func fromRoleString(role: String?) -> Role {
		if (role == "admin") {
			return .judge //TODO: For testing, add admin checking later .admin
		} else if (role == "judge") {
			return .judge
		} else if (role == "stagemgr") {
			return .stagemgr
		}
		return .unknown
	}
}

final class FeisUser : NSObject, JSONAble {
	let firstName : String
	let lastName: String
	let id: String
	let role: Role
	let currentFeis: FeisInfo?
	let competitions: [Competition]
	
	init(firstName: String, lastName: String, id: String, role: Role, currentFeis: FeisInfo?, competitions: [Competition]) {
		self.firstName = firstName
		self.lastName = lastName
		self.id = id
		self.role = role
		self.currentFeis = currentFeis
		self.competitions = competitions
	}
	
	
	static func fromJSON(_ source: [String : Any]) -> FeisUser {
		let json = JSON(source)
		
		let firstName = json["firstname"].stringValue
		let lastName = json["lastname"].stringValue
		let id = json["_id"].stringValue
		let roles = (json["roles"].arrayObject as? [String])
		let role = Role.fromRoleString(role: roles?[0] ?? "")
		
		var currentFeis: FeisInfo?
		
		if let feisInfo = json["currentFeis"].object as? [String: AnyObject] {
			currentFeis = FeisInfo.fromJSON(feisInfo)
		}
		
		// TODO: Competition Ids?
		var competitions : [Competition]
		competitions = []
		
		//if let compDict = json["competitions"].object as? Array<Dictionary<String, AnyObject>> {
		if let compArray = json["competitions"].arrayObject as? Array<[String: AnyObject]> {
			competitions = compArray.map{ return Competition.fromJSON($0) }
		}
		
		
		return FeisUser(firstName: firstName, lastName: lastName, id: id, role: role, currentFeis: currentFeis, competitions: competitions)
	}
	
}
