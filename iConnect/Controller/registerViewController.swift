//
//  registerViewController.swift
//  iConnect
//
//  Created by Amr Moussa on 5/6/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit
import Firebase
class registerViewController: UIViewController {
    
    let DB = DBop()
    @IBOutlet weak var imageVeiwPicker: UIButton!
    @IBOutlet weak var bkimage: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enmailTextFeild: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var confirmPassTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    let imagePicker = UIImagePickerController()
    var userIamge:UIImage?
    let placeholders = ["Name","Email","password","Confirm Password"]
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        registerButton.layer.cornerRadius = 20
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        bkimage.addSubview(blurEffectView)
        blurEffectView.fillSuperview()
        addLineToTextField([nameTextField,enmailTextFeild,passTextField,confirmPassTextField])
        addCustumPlaceholder(textfeilds: [nameTextField,enmailTextFeild,passTextField,confirmPassTextField], plachoders: placeholders)
        imageVeiwPicker.layer.cornerRadius = imageVeiwPicker.frame.width / 2
        imageVeiwPicker.clipsToBounds = true
    }
    //
    @IBAction func imagePickerPressed(_ sender: Any) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func registerBtnPressed(_ sender: UIButton) {
        if let email = enmailTextFeild.text,let password = passTextField.text,let username = nameTextField.text {
            DB.registerUser(email, password, username, userIamge) { (user:Firebase.User?) in
                if user == nil{
                    print("error while registering")
                }else{
                    self.performSegue(withIdentifier: const.segues.registerToconversations, sender: self)
                }
            }
        }
        
    }
    func addUserdataToFireStrore(_ email:String,_ username:String,_ imgDownLink:String){
        
    }
    func addCustumPlaceholder(textfeilds:[UITextField],plachoders:[String]){
        for i in 0..<textfeilds.count{
            textfeilds[i].customizePlaceholder(text:plachoders[i],color: UIColor.white)
        }
        
    }
}
func addLineToTextField(_ textields:[UITextField]){
    for field in textields{
        field.addButtomLine()
    }
    
    
}


extension UITextField {
    func addButtomLine(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(origin: CGPoint(x: 0, y:self.bounds.height - 1), size: CGSize(width: self.bounds.width, height:  1))
        bottomLine.backgroundColor = UIColor.init(named: const.colors.registerButtonColor)?.cgColor
        self.borderStyle = UITextField.BorderStyle.none
        self.layer.addSublayer(bottomLine)
    }
}
extension UITextField{
    func customizePlaceholder(text:String,color :UIColor){
        self.attributedPlaceholder =  NSAttributedString(string: text,
                                                         attributes: [NSAttributedString.Key.foregroundColor: color])
    }
    
    
}
extension registerViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageVeiwPicker.contentMode = .scaleAspectFit
            imageVeiwPicker.setImage(pickedImage , for: .normal)
            userIamge = pickedImage
            
        }
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}
