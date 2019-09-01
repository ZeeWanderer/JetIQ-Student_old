//
//  Schedule.swift
//  JetIQ-Student
//
//  Created by Max on 11/2/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation


class Schedule
{
    var sectionNumber: Int {return days.count }
    var days:[Day] = []
    init(json:[String:AnyObject])
    {
        let date = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy'T'HH:mm"
        formatter.locale = Locale.current
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.autoupdatingCurrent

        let calendar = Calendar.current

        let year = ".\(calendar.component(.year, from: date))T18:45"
        
        let sched = (json["sched"] as! [String:AnyObject])
        
        let dayKeys = Array(sched.keys).sorted{$0.compare($1, options: .numeric) == .orderedAscending}
        
        for dayKey in dayKeys
        {
            let day = sched[dayKey] as! [String:AnyObject]
            let sect_date = formatter.date(from: (day["date"] as! String)+year)!
            
            if !(day.keys.allSatisfy{$0.count>2}) && sect_date >= date // TODO: use date-time of the end of the last lesson of the day
            {
                self.days.append(Day(day: day, idx:Int(dayKey)!))
                // TODO: not the best solution. Insert sorted?
//                let newDay = Day(day: day.value as! [String : AnyObject], idx:Int(day.key)!)
//                let index = days.index(where: { $0.idx > newDay.idx })
//                self.days.insert(newDay, at: index ?? 0)
                
            }
        }
        //self.days.sort(by: {$0.idx < $1.idx})
    }
    
    

}
class Day : Codable
{
    let idx:Int
    let date:String
    let dow:String
    let week_num:Int
    let weeks_shift:Int
    var Lessons:[Lesson] = []
    init(day:[String:AnyObject], idx:Int)
    {
        self.idx = idx
        self.date = (day["date"] as! String)
        self.dow = (day["dow"] as! String)
        self.week_num = (day["week_num"] as! Int)
        self.weeks_shift = (day["weeks_shift"] as! Int)
        
        var lessonKeys = Array((day).keys)
        lessonKeys.removeAll(where: {$0.count > 2})
        lessonKeys.sort{$0.compare($1, options: .numeric) == .orderedDescending}
        //let min = Int(lessonKeys[lessonKeys.count-1])!
        for lessonKey in lessonKeys // Window Detection
        {
            if ((day[lessonKey] as! [String:AnyObject]).keys.contains("") || (day[lessonKey] as! [String:AnyObject]).keys.contains((Settings.sharedInstance.user_settings?.Subgroup!)!) )
            {
                break
            }
            else
            {
                lessonKeys.removeFirst()
            }
        }
        
        lessonKeys = lessonKeys.reversed()
        
        for lessonKey in lessonKeys // Window Detection
        {
            if ((day[lessonKey] as! [String:AnyObject]).keys.contains("") || (day[lessonKey] as! [String:AnyObject]).keys.contains((Settings.sharedInstance.user_settings?.Subgroup!)!) )
            {
                break
            }
            else
            {
                lessonKeys.removeFirst()
            }
        }
        
        
        //var bIsWindow = false
        var key:String = ""
        var PreviousKey:Int = Int(lessonKeys.first!)!
        for lessonKey in lessonKeys
        {
            if(Int(lessonKey)!-PreviousKey)>1
            {
                for _ in 2...(Int(lessonKey)!-PreviousKey)
                {
                    Lessons.append(Lesson())
                }
            }
            PreviousKey = Int(lessonKey)!
            
            key = ""
            if !(day[lessonKey] as! [String:AnyObject]).keys.contains("")
            {
                if (day[lessonKey] as![String:AnyObject]).keys.contains((Settings.sharedInstance.user_settings?.Subgroup!)!)
                {
                    key = (Settings.sharedInstance.user_settings?.Subgroup!)!
                }
                else
                {
                    Lessons.append(Lesson())
                    continue
                }
            }
            Lessons.append(Lesson(lesson: ((day[lessonKey] as! [String:AnyObject])[key] as! [String : AnyObject])))
            
        }
        
        //Lessons.append(Lesson(leastLesson: min, rows: Intmax-min, idx: <#T##Int#>, isWindow: <#T##Bool#>))
    }
    
}

struct Lesson : Codable
{
    let Auditory:String
    let SbType:String
    let Subject:String
    let Number:Int
    let Comment:String
    let AddInfo:String
    let Teacher:String
    let isWindow:Bool
    let isSession:Bool
    init(lesson:[String:AnyObject]?)
    {
        
        self.Auditory = lesson!["aud"] as! String
        self.SbType = lesson!["type"] as! String
        self.Subject = lesson!["subject"] as! String
        self.Number = lesson!["num_lesson"] as! Int
        self.Comment = lesson!["comment"] as! String
        self.AddInfo = lesson!["add_info"] as! String
        self.Teacher = lesson!["t_name"] as! String
        self.isWindow = false
        self.isSession = !self.AddInfo.isEmpty
    }
    init()
    {
        
        // TODO fix this
        self.Auditory = ""
        self.SbType = ""
        self.Subject = ""
        self.Number = 0
        self.Comment = ""
        self.AddInfo = ""
        self.Teacher = ""
        self.isWindow = true
        self.isSession = false
        
    }
}
