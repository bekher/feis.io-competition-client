//
//  RootSplitViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/30/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import UIKit

class RootSplitViewController: UISplitViewController {

	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var networkModel : MainNetworkModel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		/* not needed but cool stuff to look at later
		NotificationCenter.default.addObserver(self, selector: #selector(showLoginViewController),
		                                       name: NSNotification.Name(rawValue: "segue"), object: nil)
		*/
		
        // Do any additional setup after loading the view.
		networkModel = appDelegate.getNetworkModel()
		networkModel?.initialConnect()
		

    }
	
	override func viewDidAppear(_ animated: Bool) {
		if let networkModel = networkModel {
			print(networkModel.isAuthenticated())
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
			
		}
    }
	
	func showLoginViewController() {
		self.performSegue(withIdentifier: "showLoginViewController", sender: self)
	}
	
	
	@IBAction func unwindToSplitVC(segue: UIStoryboardSegue) {
		
	}

}
