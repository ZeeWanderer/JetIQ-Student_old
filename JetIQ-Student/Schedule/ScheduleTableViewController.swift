//
//  SheduleTableViewController.swift
//  JetIQ-Student
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class ScheduleTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    var lastUpdateDate:Date? = nil

    var Schedule:Schedule? = nil
    
    @objc func refresh(sender:AnyObject)
    {
        Updater.sharedInstance.UpdateShedule()
    }
    
    override func viewDidLoad() {
       // Updater.sharedInstance.PrepareShedule()
        super.viewDidLoad()
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        

        self.tableView.separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.activityIndicatorView = activityIndicatorView
        self.tableView.backgroundView = activityIndicatorView
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    // Sections per table
    override func numberOfSections(in tableView: UITableView) -> Int {
        return (self.Schedule?.sectionNumber) ?? 0
    }

    // Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "\(self.Schedule!.days[section].dow) \(self.Schedule!.days[section].date)    нд \(self.Schedule!.days[section].week_num)(\(self.Schedule!.days[section].weeks_shift))"
    }
    
    // Rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Schedule!.days[section].Lessons.count
    }

    
    // Cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SheduleTableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SheduleTableViewCell
        
        let lesson = self.Schedule!.days[indexPath.section].Lessons[indexPath.row]
        
        if !(lesson.isWindow)
        {
            cell.TextLabel.text = "\(lesson.SbType) \(lesson.Subject) \(lesson.Comment)"
            cell.TextLabel.textAlignment = .left
            
            if(!lesson.isSession)
            {
                cell.DetailTextLabel.text = "\(ScheduleHelpers.GetLessonTime(lesson.Number)) \(lesson.Auditory)"
            }
            else
            {
                cell.DetailTextLabel.text = "\(lesson.AddInfo) \(lesson.Auditory)"
            }
            
            cell.IndexLable.text = String(lesson.Number)
            cell.backgroundColor = ScheduleHelpers.GetLessonColor(type: (lesson.SbType))
            return cell
      
        }
        else
        {
            cell.IndexLable.text = "-"
            cell.TextLabel.text = "Вікно"
            cell.TextLabel.textAlignment = .center
            cell.DetailTextLabel.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
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
        
//        if (lastUpdateDate != nil)
//        {
//            let time_interval_ = DateInterval(start: lastUpdateDate!, end: Date())
//            if time_interval_.duration > 60*60*12
//            {
//                self.navigationItem.prompt = "Last update was more than 12 hours ago. Pull down to update."
//            }
//            //let max_time_interval_ = TimeInterval(
//        }
        
        if (Settings.sharedInstance.ShouldUpdateShedule)
        {
            Updater.sharedInstance.UpdateShedule()
            Settings.sharedInstance.ShouldUpdateShedule = false
        }
        
        if (self.refreshControl?.isRefreshing)!
        {
            let offset = self.tableView.contentOffset
            
            self.refreshControl?.endRefreshing( )
            self.refreshControl?.beginRefreshing()
            self.tableView.contentOffset = offset
        }
        
        if (Schedule == nil && !activityIndicatorView.isAnimating)
        {
            
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            activityIndicatorView.startAnimating()
        }
        
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == "ScheduleInfoPopover"
        {
            let popover = segue.destination
            popover.modalPresentationStyle = .popover
            popover.popoverPresentationController!.delegate = self
        }
    }
    
    func LogOut()
    {
        self.Schedule = nil
        self.tableView.reloadData()
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
