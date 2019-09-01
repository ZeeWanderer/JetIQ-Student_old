//
//  Markbook.swift
//  JetIQ-Student
//
//  Created by Max on 11/7/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation

class Markbook
{
    
    var Semesters:[Semester] = []
    
    init(json:[String:AnyObject])
    {
        var Keys = Array(json.keys)
        
        Keys.removeAll(where: {$0 == "result"})
        Keys.sort{$0.compare($1, options: .numeric) == .orderedDescending}
        
        for key in Keys
        {
            Semesters.append(Semester(json[key] as! [String:AnyObject]))
        }
        
    }
    class Semester
    {
        var Subjects:[Subject] = []
        init(_ json:[String:AnyObject])
        {
            var Keys = Array(json.keys)
            Keys.sort{$0.compare($1, options: .numeric) == .orderedAscending}
            
            for key in Keys
            {
                Subjects.append(Subject(json[key] as! [String:AnyObject]))
            }
            
        }
        
        class Subject
        {
            let subj_name:String
            let form:String
            let hours:String
            let credits:String
            let total:Int
            let ects:String
            let mark:String
            let date:String
            let teacher:String
            
            init (_ json:[String:AnyObject])
            {
                subj_name = json["subj_name"] as! String
                form = json["form"] as! String
                hours = json["hours"] as! String
                credits = json["credits"] as! String
                total = json["total"] as! Int
                ects = json["ects"] as! String
                //mark = json["mark"] as! String
                let json_mark = json["mark"]// TODO: Correct usage of mark
                switch json_mark
                {
                case is NSNumber:
                    mark = String(json_mark as! Int64)
                default:
                    mark = json_mark as! String
                }
                date = json["date"] as! String
                teacher = json["teacher"] as! String
            }
        }
        
    }
    
}
