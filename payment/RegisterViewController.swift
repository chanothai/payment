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
    
    // Make: properties
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
        
        ClientHttp.getInstance().requestCode()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    }
}
