//
//  LogInViewController.swift
//  JetIQ-Student
//
//  Created by Max on 10/13/18.
//  Copyright © 2018 VNTU. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var login_tf: UITextField!
    @IBOutlet weak var nick_tf: UITextField!
    @IBOutlet weak var pwd_tf: UITextField!
    @IBOutlet weak var label: UILabel!
    
    var DL_count: Int! = 0;
    
    @IBAction func LogInButtonTapped(_ sender: Any) {
        LoginManager.sharedInstance.LogIn(cred: Credentials(log: login_tf.text ?? "",nick: nick_tf.text ?? "",psw: pwd_tf.text ?? ""),sender: self)
    }
    @IBAction func DashedLoginValueChanged(_ sender: UITextField) {
        guard let UITF = sender.text else{return}
        if((UITF.count) > DL_count)
        {
            switch UITF.count {
            case 2:
                sender.text! = UITF + "-"
            case 5:
                sender.text! = UITF + "-"
            default:
                return
            }
        }
        DL_count = sender.text!.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if !Reachability.isConnectedToNetwork()
        {
            label.text = "No Internet access"
            label.textColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        }
        
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

//    @objc func keyboardWillShow(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y == 0{
//                self.view.frame.origin.y -= keyboardSize.height
//            }
//        }
//    }
//
//    @objc func keyboardWillHide(notification: NSNotification) {
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//            if self.view.frame.origin.y != 0{
//                self.view.frame.origin.y += keyboardSize.height
//            }
//        }
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
