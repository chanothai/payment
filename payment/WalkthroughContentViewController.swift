//
//  WalkthroughContentViewController.swift
//  payment
//
//  Created by Pakgon on 4/24/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class WalkthroughContentViewController: UIViewController {

    @IBOutlet var balanceLabel: UILabel!
    
    var balance:String?
    var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceLabel.text = balance
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
