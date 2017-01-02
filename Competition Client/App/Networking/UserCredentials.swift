//
//  UserCredentials.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/30/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation

struct UserCredentials {
	let user: FeisUser
	let accessToken: String
	
	init(user: FeisUser, accessToken: String){
		self.user = user
		self.accessToken = accessToken
	}
}
