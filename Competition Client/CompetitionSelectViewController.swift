//
//  CompetitionSelectViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 12/26/16.
//  Copyright © 2016 Feis.io. All rights reserved.
//

import UIKit

class CompetitionSelectViewController: UITableViewController {
	
	var detailViewController: DetailViewController? = nil
	var competitions = [Competition]()
	var networkModel : MainNetworkModel?
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
		/*
		self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(backButtonSegue(_:)))
		*/
		
		/*
		if let split = self.splitViewController {
			let controllers = split.viewControllers
			self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
		}
		*/
		if let networkModel = appDelegate.getNetworkModel() {
			self.competitions = networkModel.getCompetitions()
		}
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitions.count
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompCell", for: indexPath)

        // Configure the cell...
		let comp = competitions[indexPath.row]
		cell.textLabel!.text = comp.name
		
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
    }
	
	/*
	func backButtonSegue(_ sender : Any?) {
		//TODO: get segue
		self.performSegue(withIdentifier: "TOOD GET A SEGUE GREG", sender: self)
	}
	
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
