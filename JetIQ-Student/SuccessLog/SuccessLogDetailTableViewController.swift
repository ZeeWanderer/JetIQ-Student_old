//
//  SuccessLogDetailTableViewController.swift
//  JetIQ-Student
//
//  Created by Max on 11/10/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class SuccessLogDetailTableViewController: UITableViewController {
weak var activityIndicatorView: UIActivityIndicatorView!
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    //var test:String? = nil
    var SL_Detail:SL_detailItem? = nil
    var MasterController:SuccessLogMasterTableViewController? = nil
    @objc func refresh(sender:AnyObject)
    {
        //Updater.sharedInstance.UpdateSuccessLogMaster()
        self.UpdateSelf()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureView()
        
        self.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        let activityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        
        
        self.tableView.separatorColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        
        self.activityIndicatorView = activityIndicatorView
        self.tableView.backgroundView = activityIndicatorView
        
        
        
        self.InitialUpdate()
    }
    
//    func configureView() {
//        // Update the user interface for the detail item.
//
//        if let detail: String = detailItem {
//            self.title = detail.subj_name
//            if self.form != nil {
//                form.text = detail.form
//                total.text = String(detail.total)
//                mark.text = detail.mark
//                ects.text = detail.ects
//                credits.text = detail.credits
//                date.text = detail.date
//                teacher.text = detail.teacher
//            }
//        }
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    var detailItem: Subject? = nil
//    {
////        didSet {
////            configureView()
////        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        if SL_Detail == nil
        {
            return 3
        }
        return 3
    }

    // Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        switch section {
        case 0:
            return "модуль 1"
        case 1:
            return "модуль 2"
        default:
            return "всього"
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        //let header = view as! UITableViewHeaderFooterView
        //header.textLabel?.textColor = UIColor.darkGray
        //header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0:
            return ((SL_Detail?.module_1?.categories.count ?? 0) + 4)
        case 1:
            return ((SL_Detail?.module_2?.categories.count ?? 0) + 4)
        default:
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SeccessLogDetailTableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuccessLogDetailCell",
                                                 for: indexPath) as! SeccessLogDetailTableViewCell
        
        let module_1 = SL_Detail?.module_1
        let module_2 = SL_Detail?.module_2
        
        let m1_count = (module_1?.categories.count)
        let m2_count = (module_2?.categories.count)
        
        
        
        
        switch indexPath.section {
        case 0:
            switch indexPath.row
            {
            case -1...((m1_count ?? 0) - 1):
                let category1 = SL_Detail?.module_1?.categories[indexPath.row]
                cell.descr.text = category1?.legeng ?? "description:"
                cell.mark.text = String(category1?.points ?? 0)
            case (m1_count ?? 0):
                cell.descr.text = "Годин пропущено:"
                cell.mark.text = String(module_1?.h_pres ?? 0)
            case ((m1_count ?? 0) + 1):
                cell.descr.text = "Оцінка за присутність:"
                cell.mark.text = String(module_1?.for_pres ?? 0)
            case ((m1_count ?? 0) + 2):
                cell.descr.text = "Оцінка:"
                cell.mark.text = String(module_1?.mark ?? 0)
            case ((m1_count ?? 0) + 3):
                cell.descr.text = "Всього:"
                cell.mark.text = String(module_1?.sum ?? 0)
            default:
                return cell
            }
        case 1:
            switch indexPath.row
            {
            case -1...((m2_count ?? 0) - 1):
                let category2 = SL_Detail?.module_2?.categories[indexPath.row]
                cell.descr.text = category2?.legeng ?? "description:"
                cell.mark.text = String(category2?.points ?? 0)
            case (m2_count ?? 0):
                cell.descr.text = "Годин пропущено:"
                cell.mark.text = String(module_2?.h_pres ?? 0)
            case ((m2_count ?? 0) + 1):
                cell.descr.text = "Оцінка за присутність:"
                cell.mark.text = String(module_2?.for_pres ?? 0)
            case ((m2_count ?? 0) + 2):
                cell.descr.text = "Оцінка:"
                cell.mark.text = String(module_2?.mark ?? 0)
            case ((m2_count ?? 0) + 3):
                cell.descr.text = "Всього:"
                cell.mark.text = String(module_2?.sum ?? 0)
            default:
                return cell
            }
        case 2:
                switch indexPath.row
                {
                case 0:
                    cell.descr.text = "Всього:"
                    cell.mark.text = String(SL_Detail?.total ?? 0)
                case 1:
                    cell.descr.text = "ECTS:"
                    cell.mark.text = SL_Detail?.ects ?? "null"
                default:
                    cell.descr.text = "Всього за минулий семестр:"
                    cell.mark.text = String(SL_Detail?.total_prev ?? 0)
                }
        default:
            return cell
        }
        return cell
    }
    
    func InitialUpdate()
    {
        if detailItem == nil
        {
            return
        }
        
        if (MasterController?.DetailItems.keys.contains(detailItem!.card_id))!
        {
            self.SL_Detail = MasterController?.DetailItems[(detailItem?.card_id)!]
        }
        else
        {
            UpdateSelf()
        }
    }
    
    func UpdateSelf()
    {
        if LoginManager.sharedInstance.LoginURL != nil
        {
            let m_url = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?action=journ_view&card_id=\(self.detailItem!.card_id)")!
            
            var request = URLRequest(url: m_url)
            request.httpShouldHandleCookies = true
            let session = appDelegate!.NetSession
            let m_task = session!.dataTask(with: request) { (data, response, error) in if error == nil {
                guard let data = data else
                {
                    self.StopRefreshAnimation()
                    return
                }
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
                do
                {
                    let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
                    let SL_Detail_ = SL_detailItem(json)
                    
                    DispatchQueue.main.async
                        {
                            self.SL_Detail = SL_Detail_
                            self.MasterController?.DetailItems[(self.detailItem?.card_id)!] = SL_Detail_
                            self.StopRefreshAnimation()
                            self.StopActivityIndicator()
                            self.tableView.reloadData()
                    }
                    
                }
                catch _
                {
                    self.appDelegate!.TabBarController?.PresenExceptionAlert(title: "Error", message: "Something is wrong with the API server.\nWait and refresh.", animated: true)
                    return
                }
                
                }}
            
            let dataTask = appDelegate!.NetSession!.dataTask(with: LoginManager.sharedInstance.LoginURL!) {(data, response, error) in
                guard data != nil && error == nil else { return }
                m_task.resume()
            }
            dataTask.resume()
            
            
        }
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
        
        if (self.SL_Detail == nil && !activityIndicatorView.isAnimating)
        {
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
            activityIndicatorView.startAnimating()
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
