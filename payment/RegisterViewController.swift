//
//  RegisterViewController.swift
//  payment
//
//  Created by Pakgon on 8/30/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus

class RegisterViewController: BaseViewController {

    // Make: outlet
    @IBOutlet var genIdLabel: UILabel!
    @IBOutlet var testPath: UILabel!
    @IBOutlet var testQuery: UILabel!
    
    // Make: properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
        DispatchQueue.main.async {
            self.registerUser()
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func registerUser() {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        if appDelegate.query != nil {
//            let queryStr = appDelegate.query.components(separatedBy: "=")
//            self.testQuery.text = "Query: " + queryStr[1]
//            AuthenStore().storeToken(queryStr[1])
//            setRequest(queryStr[1])
//        }else{
//            let token:String = AuthenStore().restoreToken()
//            if !token.isEmpty {
//                setRequest(token)
//            }else{
//                ClientHttp.getInstance().requestCode()
//            }
//        }
    
        self.intentMainController("201799990001030044")
    }
    
    func setRequest(_ token: String) {
        var deviceToken = [String: Any]()
        var authToken = [String: String]()
        authToken["auth_token"] = token
        deviceToken["DeviceToken"] = authToken
        
        showLoading()
        ClientHttp.getInstance().requestRegister(parameter: deviceToken)
    }
}

// setEventBus
extension RegisterViewController {
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "RegisterResponse") { (result) in
            let responseResult = result.object as? RegisterResult
            
            if responseResult?.success == "OK" {
                self.genIdLabel.text = responseResult?.data?.code
            }else{
                print((responseResult?.error)!)
            }
            
            self.hideLoading()
        }
        
        SwiftEventBus.onMainThread(self, name: "RegisterAccountResponse") { (result) in
            let response = result.object as? ResultAccount
            
            if response?.code == "SUCCESS" {
                self.intentMainController((response?.accountNo)!)
            }
            
            self.hideLoading()
        }
    }
    
    func intentMainController(_ account: String) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let registerController = storyBoard.instantiateViewController(withIdentifier: "MainController") as! MainController
        registerController.accountFix = account
        
        let nav = UINavigationController(rootViewController: registerController)
        self.present(nav, animated: true, completion: nil)
    }
}
