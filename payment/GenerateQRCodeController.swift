//
//  GenerateQRCodeViewController.swift
//  payment
//
//  Created by Pakgon on 4/25/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit

class GenerateQRCodeViewController: UIViewController {
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var qrcodeImg: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    
    var image:CIImage!
    
    var time:Int = 60
    var countDown = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "QR Code"
        balanceLabel.text = ModelCart.getInstance().getInformation.balance
        amountLabel.text = moneyFormatter().thaiFormatter(Double(ModelCart.getInstance().getInformation.amount)!)
        
        let qrcode = "\(ModelCart.getInstance().getInformation.amount),\(ModelCart.getInstance().getInformation.transactionRef)"
        let newImage:UIImage = generateQRCode(from: qrcode)!
        qrcodeImg.image = newImage
        
        runTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension GenerateQRCodeViewController {
    func runTime() {
        countDown = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.countDownTimer), userInfo: nil, repeats: true)
    }
    
    func generateQRCode(from string:String) -> 	UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            image = filter.outputImage
            
            let scaleX = 200
            let scaleY = 200
            
            let transform = CGAffineTransform(scaleX: CGFloat(scaleX), y: CGFloat(scaleY))
            
            if let output = image?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    @objc private func countDownTimer() {
        if time > 0 {
            time -= 1
            timeLabel.text = String(time)
        }else{
            countDown.invalidate()
            qrcodeExpire()
        }
    }
    
    private func qrcodeExpire(){
        let alert = UIAlertController(title: "QRCode หมดอายุแล้ว!", message: "เนื่องจาก QR Code ครบกำหนดการใช้งานแล้ว โปรดสร้าง QR Code ขึ้นใหม่", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {
            (_)in
            self.performSegue(withIdentifier: "unwindToReceiveCash", sender: self)
        })
        
        alert.addAction(actionOK)
        self.present(alert, animated: true, completion: nil)
    }
}
