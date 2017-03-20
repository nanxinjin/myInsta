//
//  LoginViewController.swift
//  Myinsta
//
//  Created by Nanxin Jin on 3/19/17.
//  Copyright © 2017 Nanxin Jin. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        userNameTextField.delegate = self
        passwordTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogin(_ sender: Any) {
        login()
    }
    
    @IBAction func onSignup(_ sender: Any) {
        if(userNameTextField.text == "" || passwordTextField.text == "") {
            //Alert
            let errorAlertController = UIAlertController(title: "Error!", message: "Empty user name or password", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                //dismiss
            })
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
        } else {
            signup()
        }
    }
    
    func signup() {
        let newUser = PFUser()
        
        newUser.username = userNameTextField.text
        newUser.password = passwordTextField.text
        
        newUser.signUpInBackground { (success: Bool, error: Error?) in
            if(success) {
                print("Created a new user")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let errorCode = (error as! NSError).code
                if(errorCode == 202) {
                    let errorAlertController = UIAlertController(title: "Error!", message: "User name is taken", preferredStyle: .alert)
                    let errorAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                        //dismiss
                    })
                    errorAlertController.addAction(errorAction)
                    self.present(errorAlertController, animated: true)
                }
            }
        }
    }
    
    func login() {
        PFUser.logInWithUsername(inBackground: userNameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: Error?) in
            if(user != nil) {
                print("Logged in")
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                let errorAlertController = UIAlertController(title: "Error!", message: error!.localizedDescription, preferredStyle: .alert)
                let errorAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                    //dismiss
                })
                errorAlertController.addAction(errorAction)
                self.present(errorAlertController, animated: true)
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
