//
//  ViewController.swift
//  payment
//
//  Created by Pakgon on 4/18/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus
import AlamofireImage

class MainController: BaseViewController {
    
    // Make: Outlet
    @IBOutlet var imgProfile: UIImageView!
    @IBOutlet var statementTableView: UITableView!
    @IBOutlet var balanceLabel: UILabel!
    
    // Make: properties
    var borderWidth:Float = 2.0
    let cash:Double? = nil
    var balance:String?
    var accountFix: String?
    var token: String?
    var spendController: SpendCashController?
    var currency = "THB"
    
    var information:InformationUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableProperty()
        //Remove the title of back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
        
        requestAccount()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "AccountResponse") { (result) in
            if let accountResponse = result.object as? AccountResult {
                print("token: \(accountResponse.token!)")
                self.requestProfile(token: accountResponse.token!)
                
                self.token = accountResponse.token!
            }
        }
        
        SwiftEventBus.onMainThread(self, name: "ProfileResponse") { (result) in
            if let profileResponse = result.object as? ProfileResult {
                print(profileResponse.balance! + " , \(profileResponse.transaction!.count)")
                
                ModelCart.getInstance().getModel().profileresponse = profileResponse
                self.statementTableView.dataSource = self
                self.statementTableView.delegate = self
                self.statementTableView.reloadData()
                
                self.setImageProfile()
                self.setBalance()
            }
            
            self.hideLoading()
        }
    }
    
    func setBalance() {
        let resultBalance = (ModelCart.getInstance().getModel().profileresponse.symbolLeft)! +
            (ModelCart.getInstance().getModel().profileresponse.balance)! +
            (ModelCart.getInstance().getModel().profileresponse.symbolRight)!
        
        if !resultBalance.isEmpty {
            balance = resultBalance
        }else{
            balance = "0.00"
        }
        
        balanceLabel.text = balance
        
        information = InformationUser()
        information.balance = balance!
        information.account = accountFix!
        information.currency = currency
        information.token = self.token!
        information.symbolLeft = ModelCart.getInstance().getModel().profileresponse.symbolLeft!
        information.symbolRight = ModelCart.getInstance().getModel().profileresponse.symbolRight!
    }
    
    func setImageProfile() {
        imgProfile.layer.borderColor = UIColor.white.cgColor
        imgProfile.layer.borderWidth = CGFloat(borderWidth)
        
        if let url = URL(string: (ModelCart.getInstance().getModel().profileresponse.customer?.img)!) {
            imgProfile.af_setImage(withURL: url, placeholderImage: nil, filter: nil, progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        }else{
            imgProfile.image = UIImage(named:"people")
        }
    }
    
    func setTableProperty(){
        statementTableView.backgroundColor = UIColor.white
        statementTableView.tableFooterView = UIView(frame: CGRect.zero) //remove empty rows of table
        statementTableView.separatorColor = UIColor(red: 240.0/255.0, green: 240.0/255.0, blue: 240.0/255.0, alpha: 0.8)
    }
    
    @IBAction func pushSpendController(_ sender: UIButton) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        spendController = (storyBoard.instantiateViewController(withIdentifier: "SpendController") as! SpendCashController)
        spendController?.isPayment = true
        spendController?.information = information
        
        let backButton = UIBarButtonItem(image: UIImage(named:"back_screen"), style: .plain, target: self, action: #selector(backScreen))
        
        spendController?.navigationItem.leftBarButtonItem = backButton
        spendController?.title = "จ่ายเงิน"
        
        self.show(spendController!, sender: nil)
    }
    
    @objc func backScreen() {
        print("back")
        spendController?.navigationController?.popViewController(animated: true
        )
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "receiveController" {
            let destinationController = segue.destination as! ReceiveCashController
            destinationController.information = information
        }
    }
}

extension MainController {
    func requestAccount() {
        var parameters: [String: String] = [String: String]()
        parameters["account_no"] = accountFix
        
        showLoading()
        ClientHttp.getInstance().requestToken(parameter: parameters)
    }
    
    func requestProfile(token: String) {
        var parameters = [String: String]()
        parameters["account_no"] = accountFix
        parameters["token"] = token
        parameters["currency"] = currency
        
        ClientHttp.getInstance().requestProfile(parameter: parameters)
    }
}

extension MainController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let transaction = ModelCart.getInstance().getModel().profileresponse.transaction?.count {
            return transaction
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellStatement", for: indexPath) as! StatementTableViewCell
        
        if let url = URL(string: (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].img)!) {
            cell.imgProfileDetail.af_setImage(withURL: url, placeholderImage: nil, filter: nil , progress: nil, progressQueue: .global(), imageTransition: .crossDissolve(0.5), runImageTransitionIfCached: true, completion: nil)
        }else{
            cell.imgProfileDetail.image = UIImage(named: "people")
        }
        
        cell.imgProfileDetail.image = UIImage(named: "people")
        cell.imgProfileDetail.layer.borderWidth = CGFloat(borderWidth)
        cell.imgProfileDetail.layer.borderColor = UIColor.white.cgColor
        
        if let firstName = ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].firstName,
            let lastName = ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].lastName {
            
            let screenName = "\(firstName) \(lastName)"
            cell.nameDetailLabel.text = screenName
        }else{
            cell.nameDetailLabel.text = ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].firstName
        }
        
        let dateAgo = ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].dateAgo
        cell.timeDetailLabel.text = dateAgo!
        
        let symbol = ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].symbol
        if symbol == "+" {
            let credit = (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].symbolLeft)!
                +  (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].credit)!
                + (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].symbolRight)!
            cell.amountDetailLabel.text = "\(symbol!) \(credit)"
            cell.amountDetailLabel.textColor = UIColor.green
        }else{
            let debit = (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].symbolLeft)!
                + (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].debit)!
                + (ModelCart.getInstance().getModel().profileresponse.transaction?[indexPath.row].symbolRight)!
            cell.amountDetailLabel.text = "\(symbol!) \(debit)"
            cell.amountDetailLabel.textColor = UIColor.red
        }
        
        //make cell to transparent
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.statementTableView.deselectRow(at: indexPath, animated: false)
    }
}
