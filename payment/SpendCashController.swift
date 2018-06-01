//
//  SpendCashController.swift
//  payment
//
//  Created by Pakgon on 4/20/2560 BE.
//  Copyright © 2560 Pakgon. All rights reserved.
//

import UIKit
import AVFoundation
import SwiftEventBus

class SpendCashController: BaseViewController {
    
    //Make: outlet
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var lineView: UIView!
    @IBOutlet var layoutBalance: UIView!
    @IBOutlet var layoutMessageScan: UIView!
    
    //Make: properties
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var information: InformationUser?
    var photo = 0
    var isPayment:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        balanceLabel.text = information?.balance
        
        createVideoCapture()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        SwiftEventBus.unregister(self)
        self.navigationController?.popToRootViewController(animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setEventBus()
    }
}

extension SpendCashController {
    func requestBuyer(qrcode: String) {
        if isPayment! {
            let splitStr:[String] = qrcode.components(separatedBy: ",")
            var parameter = [String: String]()
            parameter["account_no"] = information?.account
            parameter["amount"] = splitStr[0]
            parameter["token"] = information?.token
            parameter["transaction_ref"] = splitStr[1]
            parameter["currency"] = information?.currency
            
            information?.amount = splitStr[0]
            
            showLoading()
            ClientHttp.getInstance().payCash(parameter: parameter)
            
        }else{
            var parameters = [String: String]()
            parameters["account_no"] = qrcode
            parameters["amount"] = information?.amount
            parameters["token"] = information?.token
            parameters["transaction_ref"] = information?.transactionRef
            parameters["currency"] = information?.currency
            
            showLoading()
            ClientHttp.getInstance().payCash(parameter: parameters)
        }
    }
    
    func setEventBus() {
        SwiftEventBus.onMainThread(self, name: "BuyerResponse") { (result) in
            if let response = result.object as? BuyerResult {
                if response.code == "SUCCESS" {
                    print(response.balanceDebit!)
                    self.pushNewController(response.balanceDebit!)
                }
            }
            
            self.hideLoading()
        }
    }
    
    func pushNewController(_ debitBalance: String?){
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "ResultPayment") as! ResultPaymentViewController
        destinationController.information = self.information
        destinationController.isPay = self.isPayment
        destinationController.debitBalance = debitBalance
        
        let nav = UINavigationController(rootViewController: destinationController)
        nav.topViewController?.navigationItem.title = "Transaction"
        
        self.show(nav, sender: nil)
    }
}

extension SpendCashController: AVCaptureMetadataOutputObjectsDelegate {
    func createVideoCapture(){
        // Get an instance of the AVCaptureDevice class to initialize a device object and provide the video as the media type parameter.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            
            // Set the input device on the capture session
            captureSession?.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            
            // Start video capture.
            captureSession?.startRunning()
            
            //Move layout to font of screen
            view.bringSubview(toFront: layoutBalance)
            view.bringSubview(toFront: lineView)
            view.bringSubview(toFront: layoutMessageScan)
            
            //Initialize QR Code Frame to hightlight the QR code.
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more
            print(error)
            return
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        
        //Check if the metadataObject array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            let barcodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barcodeObject!.bounds
            
            if let qrcode = metadataObj.stringValue {
                photo += 1
                print(qrcode)
                if photo == 1 {
                    self.requestBuyer(qrcode: qrcode)
                }
            }
        }
    }
}
