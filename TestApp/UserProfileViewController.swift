//
//  ViewController.swift
//  TestApp
//
//  Created by Tamas Sagi on 02/11/2016.
//  Copyright © 2016 Tamas Sagi. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class UserProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet private weak var fbLoginButton: FBSDKLoginButton!
    @IBOutlet private weak var NameLbl: UILabel!
    @IBOutlet private weak var emailLbl: UILabel!
    @IBOutlet private weak var profilePictureImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureLogin()
        let token = FBSDKAccessToken.current()
        print(token)
        if token != nil {
            requestUserData()
        } else {
            defaultUiState()
        }
    }

    private func defaultUiState(){
        NameLbl.isHidden = true
        profilePictureImageView.isHidden = true
        NameLbl.text = ""
        emailLbl.text = "Please Log In to view User Profile"
        profilePictureImageView.image = nil
    }

    private func configureLogin() {
        fbLoginButton.delegate = self
        fbLoginButton.readPermissions = ["public_profile", "email"]
    }


    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            print(error)
            return
        }
        requestUserData()

    }

    private func configureUI(fname: String, lname: String, email: String, image: Data){
        NameLbl.isHidden = false
        emailLbl.isHidden = false
        profilePictureImageView.isHidden = false
        NameLbl.text = "\(fname) \(lname)"
        emailLbl.text = email
        profilePictureImageView.image = UIImage(data: image)

    }

    private func requestUserData(){
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "first_name, last_name, email"]).start { (connection, result, error) in
            if error != nil {
                print(error!)
                return
            }
            if let result = result as?[String: Any] {
                guard let fname = result["first_name"] as? String else { return }
                guard let lname = result["last_name"] as? String else { return }
                guard let email = result["email"] as? String else { return }
                guard let user_id = result["id"] as? String else { return }

                //Add DO and Catch Block
                let url = URL(string: "http://graph.facebook.com/\(user_id)/picture?type=large")
                let data = try! Data(contentsOf: url!)
                self.configureUI(fname: fname, lname: lname, email: email, image: data)
            }
        }
    }

    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        defaultUiState()
    }
    
}
