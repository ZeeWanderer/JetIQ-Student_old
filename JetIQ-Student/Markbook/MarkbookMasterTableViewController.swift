//
//  MarkbookMasterTableViewController.swift
//  JetIQ-Student
//
//  Created by Max on 11/7/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class MarkbookMasterTableViewController: UITableViewController, UISplitViewControllerDelegate {
    fileprivate var collapseDetailViewController = true
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var Markbook:Markbook? = nil
    
    var detailViewController: MarkbookDetailTableViewController? = nil
    //var objects = [AnyObject]()
    
    @objc func refresh(sender:AnyObject)
    {
        Updater.sharedInstance.UpdateMarkbook()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        
        self.tableView.separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.activityIndicatorView = activityIndicatorView
        self.tableView.backgroundView = activityIndicatorView
        
        splitViewController?.delegate = self
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as!
                UINavigationController).topViewController
                as? MarkbookDetailTableViewController
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return self.Markbook?.Semesters.count ?? 0
    }

//    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    // Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Семестр \((self.Markbook?.Semesters.count)! - section)"
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //let header = view as! UITableViewHeaderFooterView
        //header.textLabel?.textColor = UIColor.darkGray
        //header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.Markbook!.Semesters[section].Subjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MarkbookTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarkbookCell",
                                                 for: indexPath) as! MarkbookTableViewCell
        let subject = self.Markbook!.Semesters[indexPath.section].Subjects[indexPath.row]
        cell.subject!.text = subject.subj_name
        cell.form!.text = subject.form
        cell.mark!.text = subject.mark
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let subject = self.Markbook!.Semesters[indexPath.section].Subjects[indexPath.row]
                
                let controller = (segue.destination
                    as! UINavigationController).topViewController
                    as! MarkbookDetailTableViewController
                
                controller.detailItem = subject
                controller.title = subject.subj_name
                //controller.navigationItem.prompt = "Test"
                controller.navigationItem.leftBarButtonItem =
                    splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton
                    = true
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
    
    func StopRefreshAnimation()
    {
        if self.refreshControl!.isRefreshing
        {
            self.refreshControl!.endRefreshing()
        }
    }
    
    func StopActivityIndicator()
    {
        if self.activityIndicatorView!.isAnimating
        {
            activityIndicatorView.stopAnimating()
            tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if (Settings.sharedInstance.ShouldUpdateShedule)
//        {
//            Updater.sharedInstance.UpdateShedule()
//            Settings.sharedInstance.ShouldUpdateShedule = false
//        }
        
        if (self.refreshControl?.isRefreshing)!
        {
            let offset = self.tableView.contentOffset
            
            self.refreshControl?.endRefreshing( )
            self.refreshControl?.beginRefreshing()
            self.tableView.contentOffset = offset
        }
        
        if (self.Markbook == nil && !activityIndicatorView.isAnimating)
        {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            activityIndicatorView.startAnimating()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
