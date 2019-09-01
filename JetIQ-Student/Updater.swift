//
//  Updater.swift
//  JetIQ-Student
//
//  Created by Max on 10/31/18.
//  Copyright © 2018 VNTU. All rights reserved.
//
import UIKit
import Foundation

class Updater
{
    static let sharedInstance = Updater()
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    var ScheduleTableViewController:ScheduleTableViewController? = nil
    var SettingsTableViewController:SettingsTableViewController? = nil
    var SuccessLogMaterTableViewController:SuccessLogMasterTableViewController? = nil
    //var MarkbookViewController:MarkbookViewController? = nil
    var MarkbookMasterTableViewController:MarkbookMasterTableViewController? = nil
    //var SuccessLogController:SucessLogViewController? = nil
    var TabBarController:TabBarController? = nil
    //var MarkbookMasterNavigationController:UINavigationController? = nil
    
    func PrepareSettings()
    {
           self.SettingsTableViewController!.UpdateUIFromSettings()
    }
    
    func SettingsChsnged()
    {
        if (Settings.sharedInstance.ShouldUpdateShedule)
        {
            Updater.sharedInstance.UpdateShedule()
            Settings.sharedInstance.ShouldUpdateShedule = false
        }

    }
    
    
//    func UpdateMarkbook()
//    {
//
//        if Reachability.isConnectedToNetwork() && LoginManager.sharedInstance.LoginURL != nil && self.MarkbookViewController!.webView != nil
//        {
//            //let UserData:UserData? = LoginManager.sharedInstance.user_data
//            //print ("\(LoginManager.sharedInstance.user_data?.id ?? "")")
//            //let url = URL(string: "https://iq.vntu.edu.ua/b06175/exam/markbook.php?id=\(LoginManager.sharedInstance.user_data?.id ?? "")")!
//            //webView.load(URLRequest(url: url))
//
//            //let m_url = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?markbook=1")!
//            let m_url = URL(string: "https://iq.vntu.edu.ua/b06175/exam/markbook.php?id=\(LoginManager.sharedInstance.user_data?.id ?? "")")!
//
//            var request = URLRequest(url: m_url)
//            request.httpShouldHandleCookies = true
//            let session = appDelegate!.NetSession
//            let task = session!.dataTask(with: request) { (data, response, error) in if error == nil {
//                guard let data = data else { return }
//                let HtmlString = String(data: data, encoding: .utf8)!
//                //print(HtmlString)
//                DispatchQueue.main.async {
//                    self.MarkbookViewController!.webView.loadHTMLString(HtmlString, baseURL: nil)
//
//                }
//
//                }}
//
//                let dataTask = appDelegate!.NetSession!.dataTask(with: LoginManager.sharedInstance.LoginURL!) {(data, response, error) in
//                    guard data != nil && error == nil else { return }
//                    task.resume()
//                }
//                dataTask.resume()
//
//        }
//}

    func UpdateMarkbook()
    {
        
        if LoginManager.sharedInstance.LoginURL != nil
        {
            let m_url = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?markbook=1")!
            
            var request = URLRequest(url: m_url)
            request.httpShouldHandleCookies = true
            let session = appDelegate!.NetSession
            let m_task = session!.dataTask(with: request) { (data, response, error) in if error == nil {
                guard let data = data else
                {
                    self.MarkbookMasterTableViewController?.StopRefreshAnimation()
                    return
                }
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
                //var Schedule:[String:AnyObject]? = nil
                //                #if DEBUG
                //                print(jsonString!)
                //                #endif
                do
                {
                    let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
                    let Markbook_ = Markbook(json:json)
                    
                    DispatchQueue.main.async
                        {
                            self.MarkbookMasterTableViewController?.Markbook = Markbook_
                            self.MarkbookMasterTableViewController?.StopRefreshAnimation()
                            self.MarkbookMasterTableViewController?.StopActivityIndicator()
                            self.MarkbookMasterTableViewController?.tableView.reloadData()
                            
                    }
                    
                }
                catch _
                {
                    self.TabBarController?.PresenExceptionAlert(title: "Error", message: "Something is wrong with the API server.\nWait and refresh.", animated: true)
                    // TODO:
                    //                    #if DEBUG
                    //                    print(error)
                    //                    #endif
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

    func UpdateSuccessLogMaster()
    {
        if LoginManager.sharedInstance.LoginURL != nil
        {
            let m_url = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?action=journ_list")!
            
            var request = URLRequest(url: m_url)
            request.httpShouldHandleCookies = true
            let session = appDelegate!.NetSession
            let m_task = session!.dataTask(with: request) { (data, response, error) in if error == nil {
                guard let data = data else
                {
                    self.SuccessLogMaterTableViewController?.StopRefreshAnimation()
                    return
                }
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
                do
                {
                    let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
                    let SuccessLog_ = SuccessLog(json)
                    
                    DispatchQueue.main.async
                        {
                            self.SuccessLogMaterTableViewController?.SuccessLog = SuccessLog_
                            
                            self.SuccessLogMaterTableViewController?.StopRefreshAnimation()
                            self.SuccessLogMaterTableViewController?.StopActivityIndicator()
                            self.SuccessLogMaterTableViewController?.tableView.reloadData()
                    }
                    
                }
                catch _
                {
                    self.TabBarController?.PresenExceptionAlert(title: "Error", message: "Something is wrong with the API server.\nWait and refresh.", animated: true)
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
    
    func UpdateShedule()
    {
        
        if LoginManager.sharedInstance.user_data != nil
            //&& Reachability.isConnectedToNetwork()
        {
            if(Settings.sharedInstance.user_settings?.Subgroup == nil)
            {
                self.appDelegate!.TabBarController!.ShowSubgroupSelector()
                return
            }
            
            let user = LoginManager.sharedInstance.user_data
            //let date = Date()
            
            let url:URL? = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?view=g&group_id=\(user!.gr_id)&f_id=\(user!.f_id)")!

            let dataTask:URLSessionDataTask? = appDelegate!.NetSession!.dataTask(with: url!) {(data, response, error) in
                guard let data = data else
                {
                    self.ScheduleTableViewController?.StopRefreshAnimation()
                    return
                }
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)

                do
                {
                    let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
                    let Schedule_ = Schedule(json:json)
                    self.SaveDayForWidget(Schedule_)
                        DispatchQueue.main.async
                            {
                                self.ScheduleTableViewController?.Schedule = Schedule_
                                self.ScheduleTableViewController?.lastUpdateDate = Date()
                                
                                //self.SheduleTableViewComtroller?.numberOfSections = Usable.count // TODO
                                //self.SheduleTableViewComtroller?.leastLesson = -1
                                
                                self.ScheduleTableViewController?.StopRefreshAnimation()
                                self.ScheduleTableViewController?.StopActivityIndicator()
                                self.ScheduleTableViewController?.tableView.reloadData()
                        }

                }
//                catch is DecodingError
//                {
//                    // TODO:
//                    return
//                }
                catch _
                {
                    self.TabBarController?.PresenExceptionAlert(title: "Error", message: "Something is wrong with the API server.\nWait and refresh.", animated: true)
                    // TODO:
//                    #if DEBUG
//                    print(error)
//                    #endif
                    return
                }


            }
            dataTask?.resume()

        }
    }
    
    func UpdateAll()
    {
        self.UpdateShedule()
        self.UpdateMarkbook()
        self.UpdateSuccessLogMaster()
    }
    
    func SaveDayForWidget(_ sched:Schedule)
    {
        let day = sched.days[0]
        let encoder = JSONEncoder()
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        //let defaults_s = UserDefaults.standard
        if let encoded = try? encoder.encode(day)
        {
            defaults.set(encoded, forKey: "WidgetDayData")
        }
        //let tmp = self.day
    }
    
    private func GetSeason(_ month:Int) -> Int
    {
        switch month {
        case 9...11:
            return 0 // Autumn
        case 3...5:
            return 1 // Spring
        case 6...8:
            return 2 // Summer
        default:
            return 0 // TODO: WINTER?
        }
    }
    
    init()
    {
        
    }
}
