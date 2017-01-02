//
//  Networking.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/27/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import SwiftyJSON

struct AuthPlugin: PluginType {
	let token: String
	
	func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
		var request = request
		request.addValue(token, forHTTPHeaderField: "Authorization")
		return request
	}
}

enum NetworkError : Swift.Error {
	case NoConnection
	case Unauthorized
	
}


protocol NetworkModel {
	func initialConnect()
	// func testConnectivity()
}

// Adapted from Artsy's app
func responseIsOK(_ response: Response) -> Bool {
	return response.statusCode == 200
}

class APIPingManager {
	
	let syncInterval: TimeInterval = 5
	var letOnline: Observable<Bool>!
	var provider: RxMoyaProvider<FeisioAPI>
	
	init(provider: RxMoyaProvider<FeisioAPI>) {
		self.provider = provider
		
		letOnline = Observable<Int>.interval(syncInterval, scheduler: MainScheduler.instance)
			.flatMap { [weak self] _ in
				return self?.ping() ?? .empty()
			}
			.retry() // Retry because ping may fail when disconnected and error.
			.startWith(true)
	}
	
	fileprivate func ping() -> Observable<Bool> {
		return provider.request(FeisioAPI.ping).map(responseIsOK)
	}
}

class MainNetworkModel : NSObject, NetworkModel {
	
	/* Proposed workflow:
	1) try log in
	2) after successful log in, cache common info
	3) open socket, if recv change to cached info, update
	4) for noncached info, do a direct network call to collect
	*/
	

	var authorizedUser : UserCredentials?
	
	fileprivate var provider: RxMoyaProvider<FeisioAPI>!
	fileprivate var curFeis: FeisInfo?
	fileprivate var curCompetitions: [Competition]
	
	lazy var _apiPinger: APIPingManager = {
		return APIPingManager(provider: self.provider)
	}()
	
	lazy var reachability: Observable<Bool> = {
		self._apiPinger.letOnline
	}()
	
	override init() {
		self.curCompetitions = []
		self.curCompetitions.append(Competition(id: "12345", feisID: "123", roundIDs: ["12345"], name: "u18", judgingStatus: "notStarted", currentRound: "12345"))
	}
	
	func setup() {
		let endpointClosure = { (target: FeisioAPI) -> Endpoint<FeisioAPI> in
			let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
				.adding(newHTTPHeaderFields: ["Content-Type" :"application/json"])
				.adding(newParameterEncoding: JSONEncoding.default)
			// Sign all non-authenticating requests
			switch target {
			case .auth( _, _):
				return defaultEndpoint
			default:
				return defaultEndpoint.adding(newHTTPHeaderFields: ["Authentication": self.authorizedUser?.accessToken ?? ""])
			}
		}
		
		self.provider = RxMoyaProvider<FeisioAPI>(endpointClosure: endpointClosure)//, plugins: [NetworkLoggerPlugin(verbose: false)])
	}
	
	func initialConnect() {
		/*
		provider.request(.feises)
		.filterSuccessfulStatusCodes()
		.mapJSON()
		.mapTo(arrayOf: FeisInfo.self)
		.subscribe {
		print($0)
		}
		.addDisposableTo(self.disposeBag)
		*/
		
	}
	
	func login(username : String, password : String) -> Observable<Bool> {
		
		return Observable.create { observer in
			let done = Disposables.create()
			
			guard (self.provider != nil) else {
				observer.onNext(false)
				observer.on(.completed)
				return done
			}
			
			self.provider?
				.request(.auth(username: username, password: password))
				.filterSuccessfulStatusCodes()
				.subscribe() { event in
					switch event {
					case .next(let response):
						//TODO: probably some of this in login VC with a helper func to serialize token
						
						do {
							if let json = try response.mapJSON() as? [String: Any] {
								
								self.authorizedUser = UserCredentials(user: FeisUser.fromJSON(json["data"] as! [String : Any]),
								                                      accessToken: json["token"] as! String)
								
								observer.onNext(true)
								observer.on(.completed)
								
							}
							
						} catch {//let error as NSError {
							print("error happened in login network")
							observer.onNext(false)
							observer.onCompleted()
						}
					case .error(_):
						observer.onNext(false)
						observer.onCompleted()
					default:
						break
					}
				}
				.addDisposableTo(self.rx_disposeBag)
			return done
		}
		/*
		self.provider?.request(.auth(username: username, password: password)) { result in
		switch result {
		case let .failure(error):
		res = false
		case let .success(response):
		//TODO: probably some of this in login VC with a helper func to serialize token
		do {
		let data = response.data
		let statusCode = response.statusCode
		
		if let json = try response.mapJSON() as? [String: Any] {
		
		let newUser = UserCredentials(user: FeisUser.fromJSON(json["data"] as! [String : Any]),
		accessToken: json["token"] as! String)
		print(newUser)
		
		}
		
		} catch let error as NSError {
		print("error happened in login network")
		print (error)
		}
		
		}
		}
		*/
		
	}
	
	func getFeisInfo() -> FeisInfo? {
		guard authorizedUser != nil else {
			return nil
		}
		return nil
	}
	
	func isAuthenticated() -> Bool {
		return authorizedUser != nil
	}
	
	// GREG TODO TOMORROW: make observable and bind stuff
	func getCompetitions() -> [Competition] {
		guard self.authorizedUser != nil else {
			return []
		}
		
		return curCompetitions
	}
	
	private func populateCompetitions() {
		guard authorizedUser != nil && curFeis != nil else {
			return
		}
		
		// TODO finish
		/*
		authProvider!
		.request(.competitions(feisId: curFeis!.id))
		*/
	}
}
