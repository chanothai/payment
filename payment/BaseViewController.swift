//
//  BaseViewController.swift
//  payment
//
//  Created by Pakgon on 7/12/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BaseViewController: BaseViewModelDelegate {
    func showLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.label.text = "Loading..."
        loadingNotification.mode = .indeterminate
    }
    
    func hideLoading() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
    func onDataDidLoad() {
        
    }
    
    func onDataDidLoadErrorWithMessage(errorMessage: String) {
        
    }
}
