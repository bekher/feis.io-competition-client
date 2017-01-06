//
//  FeisioDefaults.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/5/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import Foundation

final class FeisioDefaults {

	static func getUserToken() -> String? {
		let token = UserDefaults.standard.object(forKey: "io.feis.user.token") as? String

		guard (token != nil) else { return nil }

		let expirationDate = UserDefaults.standard.object(forKey: "io.feis.user.tokenExpiration") as? Date
		guard (expirationDate != nil) else { return nil }
		
		// expiration date has not passed
		guard (expirationDate! > Date()) else { return nil }
		
		return token

	}
	
	static func getUserId() -> String? {
		return UserDefaults.standard.object(forKey: "io.feis.user.id") as? String

	}
	
	static func saveUserToken(userCreds: UserCredentials) {
		UserDefaults.standard.set(userCreds.user.id, forKey: "io.feis.user.id")
		UserDefaults.standard.set(userCreds.accessToken, forKey: "io.feis.user.token")
		UserDefaults.standard.set(userCreds.expiryDate, forKey: "io.feis.user.tokenExpiration")
		
	}
}
