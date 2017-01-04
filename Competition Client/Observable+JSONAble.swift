//
//  Observable+JSONAble.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/30/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//  Modified from the Artsy Auction app

import Foundation
import Moya
import RxSwift
import SwiftyJSON

enum EidolonError: String {
	case couldNotParseJSON
	case notLoggedIn
	case missingData
}

extension EidolonError: Swift.Error { }

extension Observable {
	
	typealias Dictionary = [String: AnyObject]
	
	/// Get given JSONified data, pass back objects
	func mapTo<B: JSONAble>(object classType: B.Type) -> Observable<B> {
		return self.map { json in
			guard let dict = json as? Dictionary else {
				throw EidolonError.couldNotParseJSON
			}
			
			return B.fromJSON(dict)
		}
	}
	
	/// Get given JSONified data, pass back objects as an array
	func mapTo<B: JSONAble>(arrayOf classType: B.Type) -> Observable<[B]> {
		return self.map { json in
			
			guard let array = JSON(json)["data"].arrayObject as? [AnyObject] else {
				throw EidolonError.couldNotParseJSON
			}
			
			guard let dicts = array as? [Dictionary] else {
				throw EidolonError.couldNotParseJSON
			}

			return dicts.map { B.fromJSON($0) }
		}
	}
	
}
