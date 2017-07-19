//
//  ResultPaymentViewController.swift
//  payment
//
//  Created by Pakgon on 7/19/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class ResultPaymentViewController: BaseViewController {

    //Make: outlet
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var completeLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var btnComplete: UIButton!
    
    //Make: properties
    var information: InformationUser?
    var isPay:Bool?
    var debitBalance: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    @IBAction func actionComplete(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func setView() {
        btnComplete.layer.cornerRadius = btnComplete.frame.width / 2
        btnComplete.layer.borderColor = UIColor.lightGray.cgColor
        btnComplete.layer.borderWidth = 1
        
        let balance = Double((information?.balance)!)
        let amount = Double((information?.amount)!)

        var resultCost = 0.00
        
        if isPay! {
            resultCost = balance! - amount!
        }else{
            resultCost = balance! + amount!
        }
        
        print(resultCost)
        costLabel.text = "บัตรเหลือ : \(moneyFormatter().thaiFormatter(Double(debitBalance!)!))"
        balanceLabel.text = moneyFormatter().thaiFormatter(resultCost)
    }
}
