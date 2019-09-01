//
//  SuccessLog.swift
//  JetIQ-Student
//
//  Created by Max on 11/10/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation

class SuccessLog
{
    var numSections:Int {return semesters.count}
    var semesters:[Semester] = []
    init(_ json:[String:AnyObject])
    {
        // TODO: This is Unoptimal. FIX.
        var SubjKeys = Array(json.keys).sorted{$0.compare($1, options: .numeric) == .orderedDescending}
        var SemSet:Set<String> = []
        
        for SubjKey in SubjKeys
        {
            let subj = json[SubjKey] as![String:AnyObject]
            SemSet.insert(subj["sem"] as! String)
        }
        
        let SemKeys = SemSet.sorted{$0.compare($1, options: .numeric) == .orderedDescending}
        
        for SemKey in SemKeys
        {
            semesters.append(Semester(json,semKey: SemKey, subjKeys: &SubjKeys))
        }
    }
}
class Semester
{
    var numRows:Int {return subjects.count}
    let semester_number:String
    var subjects:[Subject] = []
    init(_ json:[String:AnyObject], semKey:String, subjKeys: inout [String]) {
        self.semester_number = semKey
        var endDeleteidx = -1
        for subjKey in subjKeys
        {
            let subject = json[subjKey] as! [String:AnyObject]
            if ((subject["sem"] as! String) == self.semester_number)
            {
                endDeleteidx = endDeleteidx + 1
                subjects.append(Subject(subject))
            }
            else
            {
                break
            }
        }

        subjKeys.removeSubrange(0...endDeleteidx)

        
    }
}
class Subject
{
    let card_id:String
    let subject:String
    let t_name:String
    let scale:String
    init(_ json:[String:AnyObject])
    {
        self.card_id = json["card_id"] as! String
        self.subject = json["subject"] as! String
        self.t_name = json["t_name"] as! String
        let scale_tmp = json["scale"] as! String
        switch scale_tmp
        {
        case "0":
            self.scale = "ECTS"
        default:
            self.scale = scale_tmp
        }
    }
}

class SL_detailItem
{
    let total:Int
    let total_prev:Int
    let ects:String
    let module_1:SL_module?
    let module_2:SL_module?
    init(_ json:[String:AnyObject])
    {
        self.total = json["total"] as! Int
        self.total_prev = json["total_prev"] as! Int
        self.ects = json["ects"] as! String
        
        var keys = Array(json.keys).sorted{$0.compare($1, options: .numeric) == .orderedDescending}
        
        if(keys.allSatisfy{$0.count > 3})
        {
            module_1 = nil
            module_2 = nil
        }
        else
        {
            keys.removeAll{$0.count > 3}
            module_1 = SL_module(json, m_key:"1", keys:keys)
            module_2 = SL_module(json, m_key:"2", keys:keys)
        }
    }
}
class SL_module
{
    var categories:[SL_category] = []
    let sum:Int
    let mark:Int
    let h_pres:Int
    let for_pres:Int
    init(_ json:[String:AnyObject], m_key:String, keys:[String])
    {
        self.sum = json["sum\(m_key)"] as! Int
        self.mark = json["mark\(m_key)"] as! Int
        self.h_pres = json["h_pres\(m_key)"] as! Int
        self.for_pres = json["for_pres\(m_key)"] as! Int
        
        for key in keys
        {
            let category = json[key] as! [String:AnyObject]
            if ((category["num_mod"] as! String) == m_key)
            {
                self.categories.append(SL_category(category))
            }
        }
    }
}

class SL_category
{
    let legeng:String
    let points:Int
    init(_ json:[String:AnyObject])
    {
        self.legeng = json["legend"] as! String
        self.points = json["points"] as! Int
    }
}
