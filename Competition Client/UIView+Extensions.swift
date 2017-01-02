//
//  UIView+Extensions.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/31/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import UIKit

extension UIView{
	func bindToKeyboard(){
		NotificationCenter.default.addObserver(self, selector: #selector(UIView.keyboardWillChange), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
	}
	
	
	func keyboardWillChange(notification: NSNotification) {
		
		let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
		let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
		let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
		let targetFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
		let deltaY = targetFrame.origin.y - curFrame.origin.y
		
		
		UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
			self.frame.origin.y+=deltaY
			
		},completion: nil)
		
	}
}
