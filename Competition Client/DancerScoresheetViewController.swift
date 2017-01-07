//
//  DancerScoresheetViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/5/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

// Judge edit VC

import UIKit
import RxSwift
import RxCocoa

class DancerScoresheetViewController: UIViewController {
	
	@IBOutlet weak var dancerNumberLabel : UILabel?
	@IBOutlet weak var roundCompLabel : UILabel?
	var dancer : Variable<Optional<Dancer>> = Variable(nil)
	var round : Variable<Optional<Round>> = Variable(nil)
	var competition : Variable<Optional<Competition>> = Variable(nil)
	var dancerNetworkModel : Variable<Optional<DancerNetworkModel>> = Variable(nil)
	weak var scoresheetTableViewController : EmbedScoresheetTableViewController?
	weak var dancerSelectViewController : DancerSelectViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
		
		dancer.asObservable()
			.map() { curDancer in
				guard (curDancer != nil) else  { return ""}
				return "#\(curDancer!.number)"
				
			}
			.bindTo(dancerNumberLabel!.rx.text)
			.addDisposableTo(rx_disposeBag)
		
		round.asObservable()
			.map() { round in
				guard (round != nil && self.competition.value != nil) else { return "" }
				return "\(self.competition.value!.name) Round \(self.round.value!.number)"
			}
			.bindTo(roundCompLabel!.rx.text)
			.addDisposableTo(rx_disposeBag)
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
		
		if (segue.identifier == "embedScoresheetTableViewController") {
			let destVC = segue.destination as! EmbedScoresheetTableViewController
			destVC.dancerNetworkModel = self.dancerNetworkModel
			destVC.round.value = self.round.value
			destVC.dancer.value = self.dancer.value
			/*
			self.dancer
				.asObservable()
				.bindTo(destVC.dancer)
				.addDisposableTo(rx_disposeBag)
			*/
			self.scoresheetTableViewController = destVC
			
		}
    }
	
	@IBAction func nextDancerInTableView() {
		self.dancerSelectViewController?.nextDancer()
	}
	
	@IBAction func prevDancerInTableView() {
		self.dancerSelectViewController?.prevDancer()
	}


}
