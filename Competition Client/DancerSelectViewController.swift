//
//  DancerSelectViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/4/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// TODO: search bar controller

class DancerSelectViewController: UITableViewController {

    var networkModel : MainNetworkModel?
    var dancerNetworkModel : DancerNetworkModel?

    var selectedCompetition : Variable<Optional<Competition>> = Variable(nil)
    var selectedRound : Variable<Optional<Round>> = Variable(nil)

    var dancers : Variable<[Dancer]> = Variable([])
	
	var userRole : Variable<Role> = Variable(.unknown)

    let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
	var lastSeguedDancerNumber : Int? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        self.networkModel = appDelegate.getNetworkModel()
		
		guard (self.networkModel != nil) else { return }
		
	    self.dancerNetworkModel = DancerNetworkModel(parentNetworkModel: self.networkModel!)
		self.networkModel!.authorizedUser
			.asObservable()
			.map() { userCreds in
				return userCreds!.user.role
			}.bindTo(self.userRole)
			.addDisposableTo(rx_disposeBag)
		
        self.selectedCompetition
            .asObservable()
            .subscribe(onNext: {comp in
				if (comp != nil) {
					self.dancerNetworkModel!
						.getDancers(competition: comp!)
						.bindTo(self.dancers)
						.addDisposableTo(self.rx_disposeBag)
				}
            })
            .addDisposableTo(rx_disposeBag)
		
		self.dancers
			.asObservable()
			.subscribe( onNext: { d in
				self.tableView.reloadData()
			})
			.addDisposableTo(rx_disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (self.userRole.value == Role.stagemgr) {
			guard (indexPath.row != lastSeguedDancerNumber) else { return }
			self.performSegue(withIdentifier: "showDetailStagemgr", sender: self)
			
		} else if (self.userRole.value == Role.judge) {
			guard (indexPath.row != lastSeguedDancerNumber) else { return }
			self.performSegue(withIdentifier: "showDetailJudge", sender: self)
		}
		self.lastSeguedDancerNumber = indexPath.row
	}

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dancers.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dancerCell", for: indexPath)
		
		cell.textLabel?.text = "\(self.dancers.value[indexPath.row].number)"

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

	
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }


	
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
		if (self.userRole.value == .stagemgr) {
			return true
		}
		return false
    }
	

	
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
		if (segue.identifier == "showDetailJudge") {
			let destNavVC = segue.destination as! UINavigationController
			let destVC = destNavVC.viewControllers.first as! DancerScoresheetViewController
			let selectedIndex = self.tableView.indexPathForSelectedRow
			
			guard (selectedIndex != nil) else { return }
			
			destVC.round = self.selectedRound
			destVC.competition = self.selectedCompetition
			destVC.dancer.value = self.dancers.value[selectedIndex!.row]
			
		}
    }
	
	@IBAction func unwindToDancerSelectVC(segue: UIStoryboardSegue) {
		
	}
	

}
