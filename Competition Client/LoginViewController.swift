//
//  LoginViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/31/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
	
	@IBOutlet weak var usernameTextfield: UITextField?
	@IBOutlet weak var passwordTextfield: UITextField?
	@IBOutlet weak var loginLabel: UILabel?
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	var networkModel : MainNetworkModel?
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		usernameTextfield?.delegate = self
		passwordTextfield?.delegate = self
		
		networkModel = appDelegate.getNetworkModel()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		if (textField === usernameTextfield) {
			passwordTextfield?.becomeFirstResponder()
			
		} else if (textField === passwordTextfield) {
			passwordTextfield?.resignFirstResponder()
			tryLogin(textField)
			
		} else {
			
			
		}
		
		return true
	}
	
	@IBAction func loginButtonPressed(_ sender: Any) {
		tryLogin(sender)
	}

	
	func tryLogin(_ sender : Any) {
		guard networkModel != nil else {
			// show error
			return
		}
		
		let username = self.usernameTextfield?.text ?? ""
		let password = self.passwordTextfield?.text ?? ""
		self.loginLabel?.isHidden = true
		
		_ = self.networkModel?.login(username: username, password: password)
			.subscribe(onNext: { isLoggedIn in
				if (isLoggedIn) {
					self.performSegue(withIdentifier: "unwindToSplitVC", sender: self)
				} else {
					self.loginLabel?.isHidden = false
					
				}
			})
		/*
		DispatchQueue.global(qos: .userInitiated).async {
		if (self.networkModel?.login(username: self.usernameTextfield?.text ?? "", password: self.passwordTextfield?.text ?? ""))! {
			print("login success")
		} else {
			print("login fail")
		}
		}
*/
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
