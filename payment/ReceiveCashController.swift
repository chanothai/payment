//
//  ReceiveCashController.swift
//  payment
//
//  Created by Pakgon on 4/20/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import SwiftEventBus

class ReceiveCashController: BaseViewController, UIScrollViewDelegate {
    
    //Make: outlet
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var slideScrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    //Make: properties
    var receiveCashSlide:[ReceiveCashSlide]!
    var information:InformationUser!
    
    let feature = ["title":"รับเงินระหว่างบัญชี Wallet", "image":"wallet.png"]
    let feature2 = ["title":"รับเงินระหว่างบัญชี QR Card", "image":"qrcard.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "รับเงิน"
        balanceLabel.text = information.balance
        slideScrollView.delegate = self
        
        receiveCashSlide = createSlide()
        setupSlideScrollView()
        
        //init page control
        pageControl.numberOfPages = receiveCashSlide.count
        pageControl.currentPage = 0
        view.bringSubview(toFront: pageControl)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
    
    @IBAction func btnWallet(_ sender: UIButton) {
        let x = CGFloat(0) / slideScrollView.frame.width
        slideScrollView.contentOffset = CGPoint(x: x, y: 0)
        
    }
    
    @IBAction func btnQrCard(_ sender: UIButton) {
        let x = CGFloat(1) * slideScrollView.frame.width
        slideScrollView.contentOffset = CGPoint(x: x, y: 0)
    }
    
    
    func createSlide() -> [ReceiveCashSlide] {
        let receiveWallet:ReceiveCashSlide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! ReceiveCashSlide
        receiveWallet.descriptLabel.text = feature["title"]
        receiveWallet.headLineImg.image = UIImage(named: feature["image"]!)
        receiveWallet.amountTextField.inputAccessoryView = addDoneOnKeyBoard()
        
        let receiveQrCard:ReceiveCashSlide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! ReceiveCashSlide
        receiveQrCard.descriptLabel.text = feature2["title"]
        receiveQrCard.headLineImg.image = UIImage(named: feature2["image"]!)
        receiveQrCard.amountTextField.inputAccessoryView = addDoneOnKeyBoard()
        
        return [receiveWallet, receiveQrCard]
    }
    
    func addDoneOnKeyBoard() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        return toolBar
    }
    
    func doneClicked() {
        view.endEditing(true)
        if let amount = receiveCashSlide[pageControl.currentPage].amountTextField.text{
            requestTranRef(amount: amount)
        }
    }
    
    func setupSlideScrollView() {
        slideScrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        slideScrollView.contentSize = CGSize(width: view.frame.width * CGFloat(receiveCashSlide.count), height: view.frame.height - 200)
        
        for i in 0 ..< receiveCashSlide.count {
            receiveCashSlide[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            slideScrollView.addSubview(receiveCashSlide[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    @IBAction func unwindToReceiveCash(segue: UIStoryboardSegue) {
        
    }
}

//Request
extension ReceiveCashController {
    func requestTranRef(amount: String) {
        ModelCart.getInstance().getInformation.balance = information.balance
        ModelCart.getInstance().getInformation.amount = amount
        
        var parameters = [String:String]()
        parameters["account_no"] = information.account
        parameters["amount"] = amount
        parameters["token"] = information.token
        
        showLoading()
        ClientHttp.getInstance().requestTranref(parameter: parameters)
    }
}

//EventBus
extension ReceiveCashController {
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "SellerResponse") { (result) in
            if let response = result.object as? SellerResult {
                print(response.tranRef!)
                ModelCart.getInstance().getInformation.transactionRef = response.tranRef!
                
                self.pushNewController()
            }
            
            self.hideLoading()
        }
    }
    
    func pushNewController() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let genQRController = storyBoard.instantiateViewController(withIdentifier: "GenerateQRCode") as! GenerateQRCodeViewController
        let spendController = storyBoard.instantiateViewController(withIdentifier: "NavSpendController") as! NavSpendViewController
        
        if pageControl.currentPage == 0 {
            navigationController?.pushViewController(genQRController, animated: true)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }else{
            navigationController?.present(spendController, animated: true, completion: nil)
        }
    }
}
