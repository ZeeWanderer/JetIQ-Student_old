//
//  TabBarController.swift
//  JetIQ-Student
//
//  Created by Max on 10/12/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    let SheduleNavigationController_idx:Int = 0
    //let Old_MarkbookViewController_idx:Int = 1
    let SuccessLogSplitViewController_idx:Int = 1
    let MarkbookSplitViewController_idx:Int = 2
    //let SuccessLogViewController_idx:Int = 2
    let SettingsNavigationController_idx:Int = 3
    
    let appDelegate: AppDelegate? = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        appDelegate!.TabBarController = self
        Updater.sharedInstance.SettingsTableViewController = self.viewControllers![SettingsNavigationController_idx].children.first as? SettingsTableViewController
        
        Updater.sharedInstance.TabBarController = self
        
        Updater.sharedInstance.ScheduleTableViewController = self.viewControllers![SheduleNavigationController_idx].children.first as? ScheduleTableViewController
        
        //Updater.sharedInstance.MarkbookViewController = self.viewControllers![Old_MarkbookViewController_idx].children.first as? MarkbookViewController
        
        let controllers = (self.viewControllers![MarkbookSplitViewController_idx] as! UISplitViewController).viewControllers
        Updater.sharedInstance.MarkbookMasterTableViewController = (controllers.first as! UINavigationController).topViewController as? MarkbookMasterTableViewController
        //Updater.sharedInstance.SuccessLogController = self.viewControllers![SuccessLogViewController_idx].children.first as? SucessLogViewController

        let controllers_1 = (self.viewControllers![SuccessLogSplitViewController_idx] as! UISplitViewController).viewControllers
        Updater.sharedInstance.SuccessLogMaterTableViewController = (controllers_1.first as! UINavigationController).topViewController as? SuccessLogMasterTableViewController
        
        super.viewDidLoad()
        
        self.ShowLogin()
        //Updater.sharedInstance.PrepareSettings()
        Updater.sharedInstance.UpdateAll()
 
        
        // Do any additional setup after loading the view.
//        let splitViewController = self.viewControllers![MarkbookMasterViewController_idx] as! UISplitViewController
//        let navigationController = splitViewController.viewControllers[splitViewController.viewControllers.count-1] as! UINavigationController
//        navigationController.topViewController!.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
//        splitViewController.delegate = appDelegate
//        
//        let masterNavigationController = splitViewController.viewControllers[0] as! UINavigationController
//        let controller = masterNavigationController.topViewController as! MasterViewController
//        controller.managedObjectContext = appDelegate?.persistentContainer.viewContext
    }

    func ShowSubgroupSelector()
    {
        if (Settings.sharedInstance.user_settings?.isEmpty())!
        {
            //let login = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            //self.present(login, animated: false, completion: nil)
            performSegue(withIdentifier:"SubgroupSelect", sender: self)
        }
    }
    
    func ShowLogin()
    {
        if LoginManager.sharedInstance.LoadUserLogIn()
        {
            //let login = self.storyboard?.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
            //self.present(login, animated: false, completion: nil)
            performSegue(withIdentifier:"LogIn", sender: self)
        }
    }
    
    func LogOut()
    {
        performSegue(withIdentifier:"LogIn", sender: self)
        Updater.sharedInstance.ScheduleTableViewController!.LogOut()
        self.selectedIndex = 0
    }
    
    func PresenExceptionAlert(title:String, message:String, animated:Bool)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        //alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
       self.present(alert, animated: animated)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
