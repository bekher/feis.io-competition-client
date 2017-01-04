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
import RxCocoa
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
		return provider.request(FeisioAPI.ping).map(responseIsOK).catchErrorJustReturn(false)
	}
}


class MainNetworkModel : NSObject, NetworkModel {
	
	/* Proposed workflow:
	1) try log in
	2) after successful log in, cache common info
	3) open socket, if recv change to cached info, update
	4) for noncached info, do a direct network call to collect
	*/
	

	var authorizedUser : Variable<UserCredentials?> = Variable(nil)
	var competitions : Variable<[Competition]> = Variable([])
	
	fileprivate var provider: RxMoyaProvider<FeisioAPI>!
	fileprivate var curFeis: FeisInfo?
	
	lazy var _apiPinger: APIPingManager = {
		return APIPingManager(provider: self.provider)
	}()
	
	lazy var reachability: Observable<Bool> = {
		self._apiPinger.letOnline
	}()
	
	func setup() {
		let endpointClosure = { (target: FeisioAPI) -> Endpoint<FeisioAPI> in
			var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
				.adding(newHTTPHeaderFields: ["Content-Type" :"application/json"])
			
			// We want URL parameters for GET's, JSON params for all else
			switch target.method {
			case .get:
				break
			default:
				defaultEndpoint = defaultEndpoint.adding(newParameterEncoding: JSONEncoding.default)
			}
			
			// JWT Token
			switch target {
			case .auth( _, _):
				return defaultEndpoint
			default:
				return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": self.authorizedUser.value?.accessToken ?? ""])
			}
		}
		
		self.provider = RxMoyaProvider<FeisioAPI>(endpointClosure: endpointClosure)//, plugins: [NetworkLoggerPlugin(verbose: false)])
		
		self.authorizedUser
			.asObservable()
			.subscribe(onNext: { authUser in
				guard (authUser != nil) else { return }
	
				self.getCompetitions()?
					.bindTo(self.competitions)
					.addDisposableTo(self.rx_disposeBag)
			})
			.addDisposableTo(rx_disposeBag)
		
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
				.subscribe(onNext: { response in
					do {
						if let json = try response.mapJSON() as? [String: Any] {
							// DeJSONify user and install JWT
							self.authorizedUser.value =
								UserCredentials(user: FeisUser.fromJSON(json["data"] as! [String : Any]),
								                accessToken: json["token"] as! String)
							
							observer.onNext(true)
						}
						
					} catch {//let error as NSError {
						print("error happened in login network")
						observer.onNext(false)
					}
					observer.onCompleted()
				})
				.addDisposableTo(self.rx_disposeBag)
			return done
		}
		
	}
	
	fileprivate func getCompetitions() -> Observable<[Competition]>? {
		guard (self.authorizedUser.value != nil) else { return nil }

		if let feisId = authorizedUser.value!.user.currentFeis?.id  {
		return self.provider?
			.request(.competitions(feisId: feisId))
			.filterSuccessfulStatusCodes()
			.mapJSON()
			.mapTo(arrayOf: Competition.self)
			/*
			.map({ response in
				do {
					if let json = try response.mapJSON() as? [String: Any] {
						
						return json.map({ entry in
							return
						})
					}
				} catch {
					return []
				}
			})
				*/
		}
		
		return nil
	}
	
	func getFeisInfo() -> FeisInfo? {
		guard authorizedUser.value != nil else {
			return nil
		}
		return nil
	}
	
	func isAuthenticated() -> Bool {
		return authorizedUser.value != nil
	}
	

}
