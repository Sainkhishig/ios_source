//
//  AttendanceScannerViewController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/26/20.
//

import UIKit
import Foundation
import AVFoundation
import CoreLocation
import Alamofire
import SwiftyJSON

class AttendanceScannerViewController: UIViewController {
    var db:DBHelper = DBHelper()
    
    var currentLocation: CLLocation!
    var avCaptureSession: AVCaptureSession!
    var avPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var employee_server_id: Int32 = 0
    let employee_name: String = ""
    var attendance_id: Int32 = 0
    
    @IBOutlet weak var stckBackgroundYellow: UIView!
    @IBOutlet weak var stackYellowBG: UIStackView!
    @IBOutlet weak var stackGreen: UIStackView!
    @IBOutlet weak var stackYellow: UIStackView!
    @IBOutlet weak var btnAttendance: UIButton!
    @IBOutlet weak var btnAttendance_TouchDown: UIButton!

    override func viewDidLoad() {
       super.viewDidLoad()
        stackYellow.insertViewIntoStack(background: UIColor(named: "attendance_yellow")!,  cornerRadius: 10)
        stackGreen.insertViewIntoStack(background: UIColor(named: "attendance_green")!,  cornerRadius: 10)

        var hrEmployee:HrEmployee = HrEmployee(id: 0, name: "", display_name: "")
        let employees = self.db.readEmployee()
        for p in employees
        {
            hrEmployee = p
        }
        
        employee_server_id = Int32(hrEmployee.id)
        getNowAttendance()
    }
    
    
//  Ирцийн мэдээлэл авах
    func getNowAttendance(){
        if Connectivity.isConnectedToInternet {
             print("Connected Internet")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
            return
        }
        
        var userInfo: UserInfo
        userInfo =  self.db.readUserInfo()
        let txtURL = userInfo.web!+"/web/dataset/call_kw"
        let id = arc4random_uniform(9999)
        let params = " {\"jsonrpc\": \"2.0\", \"method\": \"call\", \"params\":{\"model\": \"hr.attendance\", \"method\": \"get_now_attendance_mobile\",\"args\":[\"hr.attendance\", \"\(String(describing: userInfo.uid))\"], \"kwargs\":{}, \"context\": {\"lang\": \"mn_MN\", \"tz\": \"Asia/Shanghai\",\"uid\":1}},\"id\":\"\(id)\"}"
        
        let url = URL(string: txtURL)!
        let jsonParams = params.data(using: .utf8, allowLossyConversion: false)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonParams
        AF.request(request).responseJSON {
            (response) in
            if response.response?.statusCode == 200 {
                switch response.result {
                    case .success(let value):
                        let json =  JSON(value)
                        let id = (json["result"]["id"]).int
                        if(id == nil){
                            self.attendance_id = 0
                        }else{
                            self.attendance_id = Int32(id!)
                        }
                
                case .failure(let error):
                        self.showToast(message: "Ирцийн мэдээлэл илгээхэд алдаа гарлаа.\(error)", font: .systemFont(ofSize: 12.0))
                }
            }else{
                self.showToast(message: "Серверт холбогдоход алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
    @IBAction func btnAttendance_touchDown(_ sender: Any) {
        scanQRCode()
    }
   
    //QRCODE SCANNING FUNCTION START
    func scanQRCode(){
        avCaptureSession = AVCaptureSession()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
                self.failed()
                return
            }
            let avVideoInput: AVCaptureDeviceInput
            
            do {
                avVideoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
            } catch {
                self.failed()
                return
            }
            
            if (self.avCaptureSession.canAddInput(avVideoInput)) {
                self.avCaptureSession.addInput(avVideoInput)
            } else {
                self.failed()
                return
            }
            
            let metadataOutput = AVCaptureMetadataOutput()
            
            if (self.avCaptureSession.canAddOutput(metadataOutput)) {
                self.avCaptureSession.addOutput(metadataOutput)
                
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .qr]
            } else {
                self.failed()
                return
            }
            
            self.avPreviewLayer = AVCaptureVideoPreviewLayer(session: self.avCaptureSession)
            self.avPreviewLayer.frame = self.view.layer.bounds
            self.avPreviewLayer.videoGravity = .resizeAspectFill
            self.view.layer.addSublayer(self.avPreviewLayer)
            self.avCaptureSession.startRunning()
        }
    }
    
   func failed() {
       let ac = UIAlertController(title: "Scanner not supported", message: "Please use a device with a camera. Because this device does not support scanning a code", preferredStyle: .alert)
       ac.addAction(UIAlertAction(title: "OK", style: .default))
       present(ac, animated: true)
       avCaptureSession = nil
   }
   
   override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(animated)
       
       if (avCaptureSession?.isRunning == false) {
           avCaptureSession.startRunning()
       }
   }
   
   override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
       
       if (avCaptureSession?.isRunning == true) {
           avCaptureSession.stopRunning()
       }
   }
   
   override var prefersStatusBarHidden: Bool {
       return true
   }
   
   override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
       return .portrait
   }
    //QRCODE SCANNING FUNCTION END
    
    // Ирцийн мэдээлэл илгээх
    func sendAttendance(location_id: Int, lat:Double, lng:Double){
        if Connectivity.isConnectedToInternet {
             print("Connected Internet")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
        }
        
        var imei: String
        if let imei_uuid = UIDevice.current.identifierForVendor?.uuidString {
                print(imei_uuid)
            imei = imei_uuid
            }
        else{
            imei = "0"
        }
        
        var userInfo: UserInfo
        userInfo =  self.db.readUserInfo()
        let txtURL = userInfo.web!+"/web/dataset/call_kw"
        let id = arc4random_uniform(9999)
        let params = " {\"jsonrpc\": \"2.0\", \"method\": \"call\", \"params\":{\"model\": \"hr.attendance\", \"method\": \"create_attendance_mobile\",\"args\":[\"hr.attendance\", \"\(imei)\", \(attendance_id),\(location_id),\(lat), \(lng)], \"kwargs\":{}, \"context\": {\"lang\": \"mn_MN\", \"tz\": \"Asia/Shanghai\",\"uid\":1}},\"id\":\"\(id)\"}"
        let url = URL(string: txtURL)!
        let jsonParams = params.data(using: .utf8, allowLossyConversion: false)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonParams
        AF.request(request).responseJSON {
            (response) in
            if response.response?.statusCode == 200 {
                switch response.result {
                        case .success(let result):
                            let json =  JSON(result)
                            print(result)
                            if json["result"]["success"].exists(){
                                print("Ирцийн мэдээлэл амжилттай бүртгэлээ.")
                            }
                            else if json["result"]["imei"].exists(){
                                print("imei wrong")
                                self.showToast(message: "IMEI код бүртгэлгүй байна.", font: .systemFont(ofSize: 12.0))
                            }
                            else if json["result"]["range"].exists(){
                                print("range wrong")
                                print(json["result"]["range"])
                                self.showToast(message: "Ирцийн байршил буруу!", font: .systemFont(ofSize: 12.0))
                            }
                            else
                            {
                                self.showToast(message: "Ирцийн мэдээлэл илгээхэл алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
                            }
                case .failure(let error):
                        self.showToast(message: "Ирцийн мэдээлэл илгээхэд алдаа гарлаа.\(error)", font: .systemFont(ofSize: 12.0))
                }
            }else{
                self.showToast(message: "Серверт холбогдоход алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
            }
        }
    }
    
}

// QRCode мэдээлэл шалгах хэсэг
extension AttendanceScannerViewController : AVCaptureMetadataOutputObjectsDelegate {
   func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
       avCaptureSession.stopRunning()
       
       if let metadataObject = metadataObjects.first {
           guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
           guard let stringValue = readableObject.stringValue else { return }
        
            do {
                if (readableObject.stringValue?.data(using: .utf8)) != nil{
                    AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                }
            }
            catch {
                print(error.localizedDescription)
            }
           AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
           found(code: stringValue)
       }
       dismiss(animated: true)
   }
   
    // QRcode амжилттай уншсан үед
    func found(code: String) {
        if let imei_uuid = UIDevice.current.identifierForVendor?.uuidString {
                print(imei_uuid)
            }
            
        struct QrData: Codable {
            var id: Int
            var company_id: Int
        }
        
        let json = code.data(using: .utf8)!
        let qrData = try! JSONDecoder().decode(QrData.self, from: json)
        
        self.avCaptureSession.stopRunning()
        self.avPreviewLayer.removeFromSuperlayer()
        
        let locManager = CLLocationManager()
        locManager.requestWhenInUseAuthorization()
        if
           CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
           CLLocationManager.authorizationStatus() ==  .authorizedAlways
        {
            currentLocation = locManager.location
        }
        
        let latitude = (currentLocation.coordinate.latitude * 100000).rounded()/100000
        let longitude = (currentLocation.coordinate.longitude * 100000).rounded()/100000
        
        sendAttendance(location_id: qrData.id, lat: latitude, lng: longitude)
   }
}


