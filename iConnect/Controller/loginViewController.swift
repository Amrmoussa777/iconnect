//
//  loginViewController.swift
//  iConnect
//
//  Created by Amr Moussa on 5/4/20.
//  Copyright © 2020 Amr Moussa. All rights reserved.
//

import UIKit
import Firebase
class loginViewController: UIViewController {
    
    @IBOutlet weak var emailTextFeild: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var bkgndImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    let DB = DBop()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupToHideKeyboardOnTapOnView()
        emailTextFeild.addButtomLine()
        passTextField.addButtomLine()
        loginButton.layer.cornerRadius = 20
        registerButton.layer.cornerRadius = 20

 
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
        bkgndImageView.subviews.forEach({ $0.removeFromSuperview() })
    }
    @IBAction func loginPressed(_ sender: UIButton) {
        bkgndImageView.subviews.forEach({ $0.removeFromSuperview() })
        if let email = emailTextFeild.text , let password = passTextField.text{
            
            DB.CheckAuthenticate(email, password){(user : Firebase.User?) in
                if user == nil {
                    print("user not found")
                }else{
                    self.performSegue(withIdentifier: const.segues.loginToconversations , sender: self)
                }
                
            }
            
        }
    }
    //    animator
    var animator :UIViewPropertyAnimator!
    
    @IBAction func beginEdiiting(_ sender: UITextField) {
        DispatchQueue.main.async {
            self.bkgndImageView.subviews.forEach({ $0.removeFromSuperview() })
            self.animateview()
        }
        
    }
    //
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    func animateview(){
        self.loginButton.backgroundColor = UIColor.init(named: "bluuredbuttonColor")
        
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animator = UIViewPropertyAnimator(duration: 3.0 , curve: .linear, animations: {
            let blurEffect = UIBlurEffect(style: .dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            self.bkgndImageView.addSubview(blurEffectView)
            blurEffectView.fillSuperview()
            
        })
        animator.startAnimation()
    }
    
}
extension loginViewController:UIGestureRecognizerDelegate
{
    
    func setupToHideKeyboardOnTapOnView()
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(loginViewController.dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard()
    {
        print("asdzv")
        bkgndImageView.subviews.forEach({ $0.removeFromSuperview() })
        
    }
}

extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}




extension UITextField {
    func setGradient(startColor:UIColor,endColor:UIColor) {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.locations = [0.0 , 1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradient.frame = self.bounds
        self.layer.addSublayer(gradient)
    }
    
}
