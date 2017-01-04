//
//  RootSplitViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/30/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import UIKit

class RootSplitViewController: UISplitViewController {

	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var networkModel : MainNetworkModel?
	var offlineViewPresent: Bool = false
	var offlineViewController : UIViewController?
	var loginViewController : UIViewController?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		

		/* not needed but cool stuff to look at later
		NotificationCenter.default.addObserver(self, selector: #selector(showLoginViewController),
		                                       name: NSNotification.Name(rawValue: "segue"), object: nil)
		*/
		
        // Do any additional setup after loading the view.
		networkModel = appDelegate.getNetworkModel()
		networkModel!.initialConnect()
		networkModel!.reachability
			
			.subscribe(onNext: { status in
				// not reactive but it's ok
				if (self.offlineViewPresent && status && self.offlineViewController != nil) {
						self.offlineViewController!.performSegue(withIdentifier: "unwindNoInternetConnectionViewController", sender: self)
						self.offlineViewPresent = false
						if (!self.networkModel!.isAuthenticated()) {
							self.showLoginViewController()
						}
					} else if (!self.offlineViewPresent && !status) {
						if (self.loginViewController != nil && self.loginViewController!.view.superview != nil) {
							print(status)
							self.loginViewController?.dismiss(animated: true) {
								self.performSegue(withIdentifier: "showNoInternetConnectionViewController", sender: self)
							}
						} else {
							self.performSegue(withIdentifier: "showNoInternetConnectionViewController", sender: self)
						}
						
					}
			})
			.addDisposableTo(rx_disposeBag)

    }
	
	override func viewDidAppear(_ animated: Bool) {
		if let networkModel = networkModel {
			if (!networkModel.isAuthenticated()) {
				showLoginViewController()
			}
			
		} else {
			showLoginViewController()
		}
		
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if (segue.identifier == "showLoginViewController") {
			loginViewController = segue.destination
			
		} else if (segue.identifier == "showNoInternetConnectionViewController") {
			offlineViewPresent = true
			offlineViewController = segue.destination
		}
    }
	
	func showLoginViewController() {
		self.performSegue(withIdentifier: "showLoginViewController", sender: self)
	}
	
	
	@IBAction func unwindToSplitVC(segue: UIStoryboardSegue) {
		
	}

}
