//
//  CompetitionSelectViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/26/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CompetitionSelectViewController: UITableViewController {
	
	var detailViewController: DetailViewController? = nil

	var networkModel : MainNetworkModel?
	let appDelegate = UIApplication.shared.delegate as! AppDelegate
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
			if (self.detailViewController != nil) {
				//self.navigationController?.pushViewController(self.detailViewController!, animated:true)
			}
		}
		
		self.networkModel = appDelegate.getNetworkModel()

		networkModel?.competitions
			.asObservable()
			.subscribe(onNext: { stuff in
				self.tableView.reloadData()
			})
			.addDisposableTo(rx_disposeBag)
		
		
    }
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if (section == 1) {
			return self.networkModel?.competitions.value.count ?? 0
		}
		return 1
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompCell", for: indexPath)

        // Configure the cell...
		if (indexPath.section == 1) {
			let comp = networkModel!.competitions.value[indexPath.row]
		
			cell.textLabel!.text = comp.name
		} else {
			cell.textLabel!.text = "Dashboard"
		}
	
        return cell
    }
	
	override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		if (section == 1) {
			return "Competitions"
		}
		
		return "Settings"
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		if (indexPath.section == 0) {
			if (indexPath.row == 0) {
				self.performSegue(withIdentifier: "showDashboardViewController", sender: self)
			}
		} else {
			self.performSegue(withIdentifier: "showRoundSelectViewController", sender: self)
		}
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

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.

		if (segue.identifier == "showRoundSelectViewController") {
			let destVC = segue.destination as! RoundSelectViewController
			let selectedIndex = self.tableView.indexPathForSelectedRow

			if (selectedIndex != nil) {
				destVC.selectedCompetition.value = networkModel!.competitions.value[selectedIndex!.row]
			}
		} else {
			
		}
    }
	
	/*
	
	func pushRoundDetailController() {
		if let viewController = UIStoryboard(name: "Main", bundle: nil)
			.instantiateViewController(withIdentifier: "RoundDetailViewController") as? RoundDetailViewController {
			viewController.
			if let navigator = navigationController {
				navigator.pushViewController(viewController, animated: true)
			}
		}
	}
*/

}
