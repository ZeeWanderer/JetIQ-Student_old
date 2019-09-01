//
//  SubgroupSelectorViewController.swift
//  JetIQ-Student
//
//  Created by Max on 11/1/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class SubgroupSelectorViewController: UIViewController {

    @IBOutlet weak var SegmentControl: UISegmentedControl!
    
    @IBAction func ButtonTapped(_ sender: UIButton) {

        if SegmentControl.selectedSegmentIndex == 0
        {
            Settings.sharedInstance.user_settings?.Subgroup = ""
        }
        else
        {
            Settings.sharedInstance.user_settings?.Subgroup = String( SegmentControl.selectedSegmentIndex)
        }
        Settings.sharedInstance.SaveSettings()
        Updater.sharedInstance.UpdateAll()
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        // Or to rotate and lock
        // AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Don't forget to reset when view is being removed
        AppUtility.lockOrientation(.all)
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
