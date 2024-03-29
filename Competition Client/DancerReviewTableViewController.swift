//
//  DancerReviewTableViewController.swift
//  Competition Client
//
//  Created by Greg Bekher on 1/6/17.
//  Copyright © 2017 Feis.io. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class DancerReviewTableViewController: UITableViewController {
	
	var dancerScoresheets : Variable<Optional<[Dancer : Scoresheet?]>> = Variable(nil)
	var dancers : Variable<Optional<[Dancer]>> = Variable(nil)
	var dancerSelectViewController : DancerSelectViewController?
	
	// probably want this to be a dictionary?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dancers.value?.count ?? 0
    }

	
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dancerReviewCell", for: indexPath) as! DancerReviewCell

        cell.dancerIdLabel?.text = "\(dancers.value?[indexPath.row].number ?? 0)"
		cell.dancer = dancers.value?[indexPath.row]
		cell.parentVC = self

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
	
	@IBAction func unwindToDancerReviewVC(segue: UIStoryboardSegue) {
		
	}
	
	func editButtonPressed(dancer : Dancer) {
		self.dismiss(animated: true) {
			self.dancerSelectViewController?.selectDancer(dancer: dancer)
		}
	}

}
