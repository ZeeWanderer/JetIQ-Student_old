//
//  Settings.swift
//  JetIQ-Student
//
//  Created by Max on 11/1/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation


class Settings
{
    static let sharedInstance = Settings()
    var user_settings:UserSettings? = nil
    
    var ShouldUpdateShedule:Bool = false
    
    func LoadSettings()
    {
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        let decoder = JSONDecoder()
        if let savedAdditionalUserData = defaults.object(forKey: "UserSettings") as? Data
        {
            if let loadedAdditionalUserData = try? decoder.decode(UserSettings.self, from: savedAdditionalUserData)
            {
                self.user_settings = loadedAdditionalUserData
            }
        }
        else
        {
            user_settings = UserSettings()
        }
        
    }
    
    func SaveSettings()
    {
        let encoder = JSONEncoder()
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        if let encoded = try? encoder.encode(self.user_settings)
        {
            defaults.set(encoded, forKey: "UserSettings")
        }
    }
    func DeleteSettings()
    {
        self.user_settings = nil
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        defaults.removeObject(forKey: "UserSettings")
    }
    
    enum SettingKeys
    {
        
    }
    
    private func GetDefailtValue(for:SettingKeys)->Any
    {
        return 0
    }
    
    private init()
    {
    }
}
