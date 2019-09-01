//
//  TodayViewController.swift
//  JetIQ-Schedule_Widget
//
//  Created by Max on 11/9/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UITableViewController, NCWidgetProviding {
    //@IBOutlet weak var tableView: UITableView!
    
    var user_data:UserData? = nil
    var user_settings:UserSettings? = nil
    var NetSession:URLSession? = nil
    var day:Day? = nil
    override func viewDidLoad() {
        //self.tableView.delegate = self
        super.viewDidLoad()
        self.extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        //self.preferredContentSize = self.extensionContext!.widgetMaximumSize(for:.compact)
        //self.extensionContext!.widgetLargestAvailableDisplayMode = .expanded
        self.PrepareSession()
        self.GetData()
        
        // Do any additional setup after loading the view from its nib.
    }
        
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        let isUpdateIneded = self.ShouldUpdate()
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
//        DispatchQueue.main.async(execute: {self.preferredContentSize = self.tableView.contentSize
//            let tmp = self.tableView.contentSize
//            let tmp_ = 1 + Int("23")!
//        })
        completionHandler(isUpdateIneded)
    }
    
//    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
//        return UIEdgeInsets.zero
//    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .compact {
            self.preferredContentSize = maxSize
        } else if activeDisplayMode == .expanded {
            self.preferredContentSize = self.tableView.contentSize
//            let tmp = self.tableView.contentSize
//            let tmp_ = 1 + Int("23")!
        }
    }
    
    func PrepareSession()
    {
        let configuration = URLSessionConfiguration.ephemeral
        //configuration.timeoutIntervalForResource = 300
        configuration.httpCookieAcceptPolicy = .always
        configuration.httpShouldSetCookies = true
//        if #available(iOS 11, *)
//        {
//            configuration.waitsForConnectivity = true
//        }
        NetSession = URLSession(configuration: configuration)
    }
    
    func GetData()
    {
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        let decoder = JSONDecoder()
        if let savedPerson = defaults.object(forKey: "UserData") as? Data
        {
            if let loadedPerson = try? decoder.decode(UserData.self, from: savedPerson)
            {
                self.user_data = loadedPerson
            }
        }
        else
        {
            ExitWiget()
        }
        if let savedAdditionalUserData = defaults.object(forKey: "UserSettings") as? Data
        {
            if let loadedAdditionalUserData = try? decoder.decode(UserSettings.self, from: savedAdditionalUserData)
            {
                self.user_settings = loadedAdditionalUserData
            }
        }
        else
        {
            ExitWiget()
        }
        //let defaults_s = UserDefaults.standard
        if let savedDayData = defaults.object(forKey: "WidgetDayData") as? Data
        {
            if let loadedDayData = try? decoder.decode(Day.self, from: savedDayData)
            {
                self.day = loadedDayData
                self.reloadTable()
            }
        }
    }
    
    func ShouldUpdate() -> NCUpdateResult
    {
        //self.GetData()
        if day == nil
        {
            return self.GetDayResults()
        }
        if (!Reachability.isConnectedToNetwork())
        {
            return .failed
        }
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy'T'HH:mm"
        formatter.locale = Locale.current
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.autoupdatingCurrent
        
        let calendar = Calendar.current
        
        let year = ".\(calendar.component(.year, from: date))T18:45"
        let sect_date = formatter.date(from: day!.date + year)!
        
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        let decoder = JSONDecoder()
        var userData:UserData? = nil
        var userSettings:UserSettings? = nil
        if let savedPerson = defaults.object(forKey: "UserData") as? Data
        {
            if let loadedPerson = try? decoder.decode(UserData.self, from: savedPerson)
            {
                userData = loadedPerson
            }
        }
        else{
            return NCUpdateResult.failed
        }
        if let savedAdditionalUserData = defaults.object(forKey: "UserSettings") as? Data
        {
            if let loadedAdditionalUserData = try? decoder.decode(UserSettings.self, from: savedAdditionalUserData)
            {
                userSettings = loadedAdditionalUserData
            }
        }
        else
        {
            return NCUpdateResult.failed
        }
        
        if self.user_data == userData && self.user_settings!.Subgroup == userSettings!.Subgroup && sect_date >= date
        {
            return NCUpdateResult.noData
        }
        else
        {
            self.user_data = userData
            self.user_settings = userSettings
            Settings.sharedInstance.user_settings = self.user_settings
            return self.GetDayResults()
        }
        
    }
    
    func ExitWiget()
    {
        self.preferredContentSize = self.extensionContext!.widgetMaximumSize(for: .compact)
        exit(0)
    }
    
    func GetDayResults() -> NCUpdateResult
    {
            if(self.user_settings?.Subgroup == nil || self.user_data == nil)
            {
                return .failed
            }
            
            let user = self.user_data

            let url:URL? = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?view=g&group_id=\(user!.gr_id)&f_id=\(user!.f_id)")! // TODO: determine season
            let (data_, _, _) = self.NetSession!.synchronousDataTask(with: url!)
            
                guard let data = data_ else
                {
                    return .failed
                }
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
               
                do
                {
                    let json = try JSONSerialization.jsonObject(with: jsonData!, options: []) as! [String: AnyObject]
                    //let Schedule_ = Schedule(json:json)
                    let date = Date()
                    
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd.MM.yyyy'T'HH:mm"
                    formatter.locale = Locale.current
                    formatter.calendar = Calendar.current
                    formatter.timeZone = TimeZone.autoupdatingCurrent
                    
                    let calendar = Calendar.current
                    
                    let year = ".\(calendar.component(.year, from: date))T18:45"
                    let Sched = (json["sched"] as! [String:AnyObject])
                    var dayKeys = Array(Sched.keys)
                    dayKeys.sort{$0.compare($1, options: .numeric) == .orderedAscending}
                    for dayKey in dayKeys
                    {
                        let DayValue = (Sched[dayKey] as! [String:AnyObject])
                        let sect_date = formatter.date(from: (DayValue["date"] as! String)+year)!
                        if DayValue.keys.count > 4 && sect_date >= date // TODO: use date-time of the end of the last lesson of the day
                        {
                            self.day = Day(day: DayValue, idx:Int(dayKey)!)
                            
                            let encoder = JSONEncoder()
                            let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
                            //let defaults_s = UserDefaults.standard
                            if let encoded = try? encoder.encode(self.day)
                            {
                                defaults.set(encoded, forKey: "WidgetDayData")
                            }
                            //let tmp = self.day
                            break
                        }
                    }

                    self.reloadTable()

                    
                }
                catch _
                {
                    return .failed
                }
           return .newData
            //dataTask?.resume()
        
    }
    
    // MARK: - Table view data source
    
    func reloadTable()
    {
        //self.tableView.reloadData()
        self.tableView.reloadData()
//        DispatchQueue.main.async
//            {
//
//                self.preferredContentSize = self.tableView.contentSize
//                let tmp = self.tableView.contentSize
//                let tmp_ = 1 + Int("23")!
//            }
    }
    
    // Sections per table
    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.day == nil
        {
            return 0
        }
        else{
            return 1
        }
    }
    
    // Section Title
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "\(self.day!.dow) \(self.day!.date)    нд \(self.day!.week_num)(\(self.day!.weeks_shift))"
    }
    
    // Rows per section
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.day!.Lessons.count
    }
    
    
    // Cell data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WidgetCell", for: indexPath) as! SheduleTableViewCell
        
        let lesson = self.day!.Lessons[indexPath.row]
        
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
            return cell as UITableViewCell
            
        }
        else
        {
            cell.IndexLable.text = "-"
            cell.TextLabel.text = "Вікно"
            cell.TextLabel.textAlignment = .center
            cell.DetailTextLabel.text = ""
            cell.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            return cell as UITableViewCell
        }
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        self.preferredContentSize = self.tableView.contentSize
//        let tmp = self.tableView.contentSize
//        let tmp_ = 1 + Int("23")!
        return UITableView.automaticDimension
        
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        self.preferredContentSize = self.tableView.contentSize
//        let tmp = self.tableView.contentSize
//        let tmp_ = 1 + Int("23")!
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {
        if (indexPath.row == (day?.Lessons.count)!-1)
        {
                    self.preferredContentSize = self.tableView.contentSize
//                    let tmp = self.tableView.contentSize
//                    let tmp_ = 1 + Int("23")!
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = (view as! UITableViewHeaderFooterView)
        header.textLabel!.textAlignment = .center
        //let header = view as! UITableViewHeaderFooterView
        //header.textLabel?.textColor = UIColor.darkGray
        //header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
}

