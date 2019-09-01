//
//  MarkbookDetailTableViewController.swift
//  JetIQ-Student
//
//  Created by Max on 11/7/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class MarkbookDetailTableViewController: UITableViewController {

    @IBOutlet weak var form: UILabel!
    @IBOutlet weak var total: UILabel!
    @IBOutlet weak var mark: UILabel!
    @IBOutlet weak var ects: UILabel!
    @IBOutlet weak var credits: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var teacher: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail: Markbook.Semester.Subject = detailItem
        {
            
            if self.form != nil
            {
                form.text = detail.form
                total.text = String(detail.total)
                mark.text = detail.mark
                ects.text = detail.ects
                credits.text = detail.credits
                date.text = detail.date
                teacher.text = detail.teacher
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    var detailItem: Markbook.Semester.Subject? {
        didSet {
            configureView()
        }
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
