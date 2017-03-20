//
//  ComposeViewController.swift
//  Myinsta
//
//  Created by Nanxin Jin on 3/19/17.
//  Copyright © 2017 Nanxin Jin. All rights reserved.
//

import UIKit
import MBProgressHUD

class ComposeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var picImageView: UIImageView!
    @IBOutlet weak var descriptonTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        picImageView.image = #imageLiteral(resourceName: "Placeholder")
        descriptonTextField.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func onSend(_ sender: Any) {
        
        //Display HUD
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        if(picImageView.image == #imageLiteral(resourceName: "Placeholder")) {
            let errorAlertController = UIAlertController(title: "Error!", message: "Can't upload empty image", preferredStyle: .alert)
            let errorAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                //dismiss
            })
            errorAlertController.addAction(errorAction)
            self.present(errorAlertController, animated: true)
        } else {
            let image = picImageView.image
            let caption = descriptonTextField.text
            
            Post.postUserImage(image: image, withCaption: caption, withCompletion: { (success: Bool, error: Error?) in
                if(success == true) {
                    //Dismiss HUD
                    MBProgressHUD.hide(for: self.view, animated: true)
                    
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let errorAlertController = UIAlertController(title: "Error!", message: "Some error occured", preferredStyle: .alert)
                    let errorAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
                        //dismiss
                    })
                    errorAlertController.addAction(errorAction)
                    self.present(errorAlertController, animated: true)
                }
            })
        }
    }
    
    @IBAction func onCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func onTapTakePic(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc .allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTapCameraRoll(_ sender: Any) {
        let vc = UIImagePickerController()
        vc.delegate = self
        vc .allowsEditing = true
        vc.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //Get image
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            //display the pic taken
            let size = CGSize(width: 275, height: 275)
            let newImage = resize(image: originalImage, newSize: size)
            picImageView.image = newImage
        } else if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            //display the pic taken
            let size = CGSize(width: 275, height: 275)
            let newImage = resize(image: editedImage, newSize: size)
            picImageView.image = newImage
        } else {
            print("Error")
        }
        
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
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
