//
//  SHelpers.swift
//  JetIQ-Schedule_Widget
//
//  Created by Max on 11/9/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation
import SystemConfiguration

struct Lesson:Codable
{
    let Auditory:String
    let SbType:String
    let Subject:String
    let Number:Int
    let Comment:String
    let Teacher:String
    let isWindow:Bool
    init(lesson:[String:AnyObject]?)
    {
        
        self.Auditory = lesson!["aud"] as! String
        self.SbType = lesson!["type"] as! String
        self.Subject = lesson!["subject"] as! String
        self.Number = lesson!["num_lesson"] as! Int
        self.Comment = lesson!["comment"] as! String
        self.Teacher = lesson!["t_name"] as! String
        self.isWindow = false
        
    }
    init()
    {
        
        // TODO fix this
        self.Auditory = ""
        self.SbType = ""
        self.Subject = ""
        self.Number = 0
        self.Comment = ""
        self.Teacher = ""
        self.isWindow = true
        
    }
}

struct Day:Codable
{
    let idx:Int
    let date:String
    let dow:String
    let week_num:Int
    let weeks_shift:Int
    var Lessons:[Lesson] = []
    init(day:[String:AnyObject], idx:Int, cont:TodayViewController) {
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
            if ((day[lessonKey] as! [String:AnyObject]).keys.contains("") || (day[lessonKey] as! [String:AnyObject]).keys.contains((cont.user_settings?.Subgroup!)!) )
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
            if ((day[lessonKey] as! [String:AnyObject]).keys.contains("") || (day[lessonKey] as! [String:AnyObject]).keys.contains((cont.user_settings?.Subgroup!)!) )
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
                if (day[lessonKey] as![String:AnyObject]).keys.contains((cont.user_settings?.Subgroup!)!)
                {
                    key = (cont.user_settings?.Subgroup!)!
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



public class Reachability {
    
    class func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags: SCNetworkReachabilityFlags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            return false
        }
        
        /* Only Working for WIFI
         let isReachable = flags == .reachable
         let needsConnection = flags == .connectionRequired
         
         return isReachable && !needsConnection
         */
        
        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        
        return ret
        
    }
}
