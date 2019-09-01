//
//  UserSettingsTableViewController.swift
//  JetIQ-Student
//
//  Created by Max on 11/3/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class UserSettingsTableViewController: UITableViewController {

    @IBOutlet weak var Subgroup_sc: UISegmentedControl!
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "User"
        UpdateUIFromSettings()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    @IBAction func UserSubgroupChanged(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0
        {
            Settings.sharedInstance.user_settings?.Subgroup = ""
        }
        else
        {
            Settings.sharedInstance.user_settings?.Subgroup = String( sender.selectedSegmentIndex)
        }
        Settings.sharedInstance.ShouldUpdateShedule = true
    }
    
    @IBAction func LogOut(_ sender: UIButton)
    {
        Settings.sharedInstance.DeleteSettings()
        LoginManager.sharedInstance.LogOut()
        appDelegate?.TabBarController?.LogOut()
        Settings.sharedInstance.LoadSettings()
        //Updater.sharedInstance.SheduleTableViewController?.Schedule = nil
        //appDelegate?.TabBarController?.selectedIndex = 0
    }
    func UpdateUIFromSettings()
    {
        if let UserSettings = Settings.sharedInstance.user_settings
        {
            if let UserData = LoginManager.sharedInstance.user_data
            {
                if (UserSettings.Subgroup?.isEmpty)!
                {
                    Subgroup_sc.selectedSegmentIndex = 0
                }
                else
                {
                    Subgroup_sc.selectedSegmentIndex = Int(UserSettings.Subgroup!)!
                }
            }
            
        }
    }
    
    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

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
