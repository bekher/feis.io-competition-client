//
//  JSONAble.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/24/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

protocol JSONAble {
	static func fromJSON(_: [String: Any]) -> Self
}
