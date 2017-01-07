//
//  UserCredentials.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/30/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation

struct UserCredentials {
	let minutesUntilExpire = 60
	let user: FeisUser
	let accessToken: String
	let expiryDate: Date
	
	init(user: FeisUser, accessToken: String){
		self.user = user
		self.accessToken = accessToken
		self.expiryDate = Calendar.current.date(byAdding: .minute, value: minutesUntilExpire, to: Date())!
		
	}
}
