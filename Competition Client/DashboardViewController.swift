//
//  DashboardViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/24/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DashboardViewController: UIViewController {
	
	@IBOutlet weak var welcomeLabel : UILabel?
	@IBOutlet weak var feisNameLabel : UILabel?
	
	var feisInfo : Variable<Optional<FeisInfo>> = Variable(nil)
	var user : Variable<Optional<FeisUser>> = Variable(nil)
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		user.asObservable()
			.map(){ nextUser in
				if (nextUser != nil) {
					return "Welcome \(nextUser!.firstName) \(nextUser!.lastName)."
				}
				return ""
			}
			.bindTo(welcomeLabel!.rx.text)
			.addDisposableTo(rx_disposeBag)
		
		feisInfo.asObservable()
			.map() { nextFeisInfo in
				if (nextFeisInfo != nil) {
					return nextFeisInfo!.name
				}
				return ""
				
			}
			.bindTo(feisNameLabel!.rx.text)
			.addDisposableTo(rx_disposeBag)

	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
}

