//
//  Structs.swift
//  JetIQ-Student
//
//  Created by Max on 10/15/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation

struct UserSettings: Codable{
    var Subgroup:String? = nil
    
    init() {

    }
    
    func isEmpty()->Bool
    {
        return Subgroup == nil
    }
    
}

struct UserData: Codable
{
    let session:String?
    let id:String
    let u_name:String
    let gr_id:String
    let gr_name:String
    let course_num:Int
    let d_id:String
    let d_name:String
    let email:String
    let dob:String?
    let photo_url:String
    let spec_id:String
    let f_id:String
}

extension UserData: Equatable {}

func ==(lhs: UserData, rhs: UserData) -> Bool {
    let areEqual = lhs.id == rhs.id
    
    return areEqual
}

struct UserCheck: Codable
{
    let u_uid:String?
    let isteacher:Int?
}
