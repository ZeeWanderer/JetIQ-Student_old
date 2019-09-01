//
//  ScheduleHelpers.swift
//  JetIQ-Student
//
//  Created by Max on 12/21/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation
import UIKit

class ScheduleHelpers
{

    static func GetLessonColor(type:String)->UIColor
    {
        switch type {
        case "ЛК":
            return #colorLiteral(red: 1, green: 0.8869055742, blue: 0.5970449066, alpha: 1)
        case "ПЗ":
            return #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        case "ЛР":
            return #colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        case "ДЗ":
            return #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
        case "Зал":
            return #colorLiteral(red: 1, green: 0.8472312441, blue: 0.4537079421, alpha: 1)
        case "Конс":
            return #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        case "Ісп":
            return #colorLiteral(red: 0.961265689, green: 0.2604754811, blue: 0.233939329, alpha: 1)
        default:
            return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
    
    static func GetLessonTime(_ idx:Int) -> String
    {
        switch idx
        {
        case 1...6:
            return "\(8+idx-1):15"
        case 7,8:
            return "\(14+idx-7):45"
        case 9,10:
            return "16:40"
        case 11,12:
            return "18:10"
        case 13,14:
            return "19:40"
        default:
            return ""
        }
        
    }
}
