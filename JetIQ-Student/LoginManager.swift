//
//  File.swift
//  JetIQ-Student
//
//  Created by Max on 10/13/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import Foundation
import UIKit

class Credentials: Codable {
    var login:String
    var nickname:String
    var password:String
    public init()
    {
        login = ""
        nickname = ""
        password = ""
    }
    public init(log:String,nick:String,psw:String)
    {
        login = log
        nickname = nick
        password = psw
    }
}

class LoginManager{
    static let sharedInstance = LoginManager()
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    //var credentials = Credentials()
    
    var  Shedule:[String:Any]? = nil;
    var LoginURL:URL? = nil
    
    
    var bIsLoggedIn = false
    var user_data:UserData? = nil
    var credentials:Credentials? = nil
    var dataTask: URLSessionDataTask? = nil
    func LogIn(cred:Credentials, sender: LogInViewController)
    {
        dataTask?.cancel()
        
        if !Reachability.isConnectedToNetwork()
        {
            sender.label.text = "No Internet access"
            sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        if cred.password.isEmpty && cred.nickname.isEmpty && cred.login.isEmpty
        {
            sender.label.text = "No data supplied"
            sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            return
        }
        
        if !cred.password.isEmpty
        {
            //var url:URL? = nil
            if !cred.nickname.isEmpty
            {
                LoginURL = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?login=\(cred.nickname)&pwd=\(cred.password)")!
            }
            else
            if !cred.login.isEmpty
            {
                LoginURL = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?login=\(cred.login)&pwd=\(cred.password)")!
            }
            if (LoginURL != nil)
            {
                dataTask = appDelegate!.NetSession!.dataTask(with: LoginURL!) {(data, response, error) in
                    guard let data = data else { return }
                    let jsonString = String(data: data, encoding: .utf8)
                    let jsonData = jsonString!.data(using: .utf8)
//                    #if DEBUG
//                    print(jsonString!)
//                    #endif
                    let decoder = JSONDecoder()
                    do
                    {
                        self.user_data = try decoder.decode(UserData.self, from: jsonData!)
                        self.credentials = cred
//                        #if DEBUG
//                        let tmp = self.user_data
//                        #endif
                        DispatchQueue.main.async
                            {
                                sender.view.endEditing(true)
                                sender.dismiss(animated: false, completion: nil)
                                Updater.sharedInstance.UpdateAll()
                                
                                
                                self.bIsLoggedIn = true
                                self.dataTask = nil
                                
                                //Updater.sharedInstance.PrepareSettings()
                                
                                
                                let encoder = JSONEncoder()
                                let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
                                if let encoded = try? encoder.encode(self.user_data)
                                {
                                    defaults.set(encoded, forKey: "UserData")
                                }
                                if let encoded = try? encoder.encode(self.credentials)
                                {
                                    defaults.set(encoded, forKey: "UserCredentials")
                                }
                                
                        }
                    }
                    catch is DecodingError
                    {
                        DispatchQueue.main.async
                            {
                                sender.pwd_tf.text?.removeAll(keepingCapacity: true)
                                sender.label.text = "Wrong data supplied"
                                sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)

                            }
                        return
                    }
                    catch _
                    {
                        // TODO:
//                        #if DEBUG
//                        print(error)
//                        DispatchQueue.main.async
//                            {
//                                sender.label.text = "Error:\(error.localizedDescription)"
//                                sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//                            }
//                        #endif
                    }
}
                dataTask?.resume()
//                #if DEBUG
//                let tmp0 = dataTask
//                #endif
            }
            else
            {
                sender.label.text = "Either Nickname or Dashed Login is required"
                sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
            }
        }
        else
        {
        sender.label.text = "Password is required"
        sender.label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
    }
    
    func LogIn(cred:Credentials)
    {
        //dataTask?.cancel()
        
//        if !Reachability.isConnectedToNetwork()
//        {
//            return
//        }
        //MockLogin(cred: cred)
        
        if cred.password.isEmpty && cred.nickname.isEmpty && cred.login.isEmpty
        {
            return
        }
        
        if !cred.password.isEmpty
        {
//            var url:URL? = nil
            if !cred.nickname.isEmpty
            {
                LoginURL = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?login=\(cred.nickname)&pwd=\(cred.password)")!
            }
            else
                if !cred.login.isEmpty
                {
                    LoginURL = URL(string: "https://iq.vntu.edu.ua/b04213/curriculum/api.php?login=\(cred.login)&pwd=\(cred.password)")!
            }
            if (LoginURL != nil)
            {
                //let tmp0 = appDelegate
                //let tmp1 = tmp0?.NetSession
                dataTask = appDelegate!.NetSession!.dataTask(with: LoginURL!) {(data, response, error) in
                    guard let data = data else { return }
                    let jsonString = String(data: data, encoding: .utf8)
                    let jsonData = jsonString!.data(using: .utf8)
//                    #if DEBUG
//                    print(jsonString!)
//                    #endif
                    let decoder = JSONDecoder()
                    do
                    {
                        self.user_data = try decoder.decode(UserData.self, from: jsonData!)
                        self.credentials = cred
                        DispatchQueue.main.async
                            {
                                self.bIsLoggedIn = true
                                self.dataTask = nil
                                //self.MockLogin()
                            }
                    }
                    catch is DecodingError
                    {
                        return
                    }
                    catch _
                    {
                        // TODO:
//                        #if DEBUG
//                        print(error)
//                        #endif
                    }
//                    #if DEBUG
//                    let tmp = self.user_data
//                    #endif
 }
                dataTask!.resume()
//                #if DEBUG
//                let tmp0 = dataTask
//                #endif
            }
        }
    }
    
    func LoadUserLogIn() -> Bool
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
        if let savedPerson = defaults.object(forKey: "UserCredentials") as? Data
        {
            if let loadedPerson = try? decoder.decode(Credentials.self, from: savedPerson)
            {
                self.credentials = loadedPerson
                self.LogIn(cred: self.credentials!)
                
                //self.LogIn(cred: self.credentials!)
                //Updater.sharedInstance.PrepareSettings()
                return false
            }
        }
        
        return true
    }
    
    func LogOut()
    {
        self.DeleteData()

    }
    
    func DeleteData()
    {
        let defaults = UserDefaults(suiteName: "group.JetIQ-Student")!
        defaults.removeObject(forKey: "UserData")
        defaults.removeObject(forKey: "UserCredentials")
        
        self.bIsLoggedIn = false
        self.user_data = nil
        self.LoginURL = nil
    }
    
    private init()
    {
    }
    
    
    
    
}
