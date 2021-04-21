//  ViewController.swift
//  Od10IOSMobile
//  Created by Sainkhishig Ariunaa on 11/26/20.

import UIKit
import Alamofire
import SwiftyJSON

class LoginViewController: UIViewController {
    var db:DBHelper = DBHelper()
    @IBOutlet weak var indicatorOdmobile: UIActivityIndicatorView!
    @IBOutlet weak var indicatorURLcheck: UIActivityIndicatorView!
    @IBOutlet weak var tfURL: UITextField!
    @IBOutlet weak var tfUserName: UITextField!
    @IBOutlet weak var tfPassword: UITextField!
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var tfDatabase: UITextField!
    @IBOutlet weak var pickerDatabase: UIPickerView!
    @IBOutlet weak var stackVURL: UIStackView!
    @IBOutlet weak var stackHUser: UIStackView!
    @IBOutlet weak var stackHPassword: UIStackView!
    @IBOutlet weak var stackHDB: UIStackView!
    @IBOutlet weak var imgErrorURL: UIImageView!
    @IBOutlet weak var imgCheckedURL: UIImageView!
    @IBOutlet weak var imgErrorUsername: UIImageView!
    @IBOutlet weak var imgErrorPassword: UIImageView!
    @IBOutlet weak var imgErrorDatabase: UIImageView!
    var lstDB: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pickerDatabase.dataSource = self
        self.pickerDatabase.delegate = self
        self.pickerDatabase.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        
        stackVURL.insertViewIntoStack(background: UIColor.white, cornerRadius: 4)
        stackHUser.insertViewIntoStack(background: UIColor.white, cornerRadius: 4)
        stackHPassword.insertViewIntoStack(background: UIColor.white, cornerRadius: 4)
        stackHDB.insertViewIntoStack(background: UIColor.white, cornerRadius: 4)
        indicatorURLcheck.hidesWhenStopped = true
        indicatorOdmobile.hidesWhenStopped = true
    }
    
    @IBAction func txt_editingChanged(_ sender: Any) {
        switch (sender as! UITextField).tag
        {
            case 1:
                imgErrorURL.isHidden = true
                imgCheckedURL.isHidden = true
            case 2:
                imgErrorUsername.isHidden = true
            case 3:
                imgErrorPassword.isHidden = true
            case 4:
                imgErrorDatabase.isHidden = true
            default:
                return
        }
    }
    
    //Database сонгох
    @IBAction func pickerDatabase_touchdown(_ sender: Any) {
        self.pickerDatabase.reloadAllComponents()
        self.pickerDatabase.reloadInputViews()
    }
    
    //URL өөрчлөгдөх үед орох үзэгдэл
    @IBAction func tfURL_editingDidEnd(_ sender: Any) {
        if (!(tfURL.text?.trimmingCharacters(in: .whitespaces)).isNilOrEmpty) {
            indicatorURLcheck.startAnimating()
            setURLDatabase()
        }
    }
    
    //Нэвтрэх товч дарах үед орох үзэгдэл
    @objc func btnLogin_touchDown(_ sender: Any) {
        if(!imgErrorURL.isHidden){
            return
        }
//        ChangeView()
        if hasValidate(){
            return
        }else{
            indicatorOdmobile.startAnimating()
            checkModuleInstalled()
            AUTHENTICATE()
        }
    }
    
    //Validation check
    func hasValidate() -> Bool{
        if ((tfURL.text?.trimmingCharacters(in: .whitespaces)).isNilOrEmpty) {
            tfURL.attributedPlaceholder = NSAttributedString(string: "Серверийн хаяг оруулна уу!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            imgErrorURL.isHidden = false
            return true
        }
        else{
            imgErrorURL.isHidden = true
            tfURL.attributedPlaceholder = NSAttributedString(string: "Серверийн хаяг", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        }
        
        if ((tfUserName.text?.trimmingCharacters(in: .whitespaces)).isNilOrEmpty) {
            tfUserName.attributedPlaceholder = NSAttributedString(string: "Нэвтрэх нэр оруулна уу!.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            imgErrorUsername.isHidden = false
            return true
        }
        else{
            tfUserName.attributedPlaceholder = NSAttributedString(string: "Нэвтрэх нэр", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
            imgErrorUsername.isHidden = true
        }
        
        if ((tfPassword.text?.trimmingCharacters(in: .whitespaces)).isNilOrEmpty) {
            tfPassword.attributedPlaceholder = NSAttributedString(string: "Нууц үг оруулна уу!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            imgErrorPassword.isHidden = false
            return true
        }
        else{
            imgErrorPassword.isHidden = true
            tfPassword.attributedPlaceholder = NSAttributedString(string: "Нууц үг", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        }

        
        if ((tfDatabase.text?.trimmingCharacters(in: .whitespaces)).isNilOrEmpty) {
            tfDatabase.attributedPlaceholder = NSAttributedString(string: "Бааз оруулна уу!", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            imgErrorDatabase.isHidden = false
            return true
        }
        else{
            imgErrorDatabase.isHidden = true
            tfDatabase.attributedPlaceholder = NSAttributedString(string: "Бааз", attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray3])
        }
        let db = (tfDatabase.text?.trimmingCharacters(in: .whitespaces))
        if(lstDB.contains(db!)){
            print("URL typed")
        }
        else {
            
            tfDatabase.text = ""
            tfDatabase.attributedPlaceholder = NSAttributedString(string: "Бааз сонгоно уу", attributes: [NSAttributedString.Key.foregroundColor: UIColor.red])
            imgErrorDatabase.isHidden = false
            return true
        }
        
        return false
    }
    
    //Нэвтрэх функц дуудах
    func AUTHENTICATE() -> Bool{
        ///AUTHENTICATE
        if Connectivity.isConnectedToInternet {
             print("Connected")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
            return false
        }
        
        let txtURL = (tfURL.text?.trimmingCharacters(in: .whitespacesAndNewlines))!+"/web/session/authenticate"
        let userName = tfUserName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = tfPassword.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let database = tfDatabase.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let params = " {\"jsonrpc\": \"2.0\", \"method\": \"call\", \"params\": {\"db\": \"\(database)\", \"login\": \"\(String(describing: userName))\",\"password\": \"\(password)\"}} "
        let url = URL(string: txtURL)!
        let jsonParams = params.data(using: .utf8, allowLossyConversion: false)!
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        var loggedIn = true
        request.httpBody = jsonParams
        AF.request(request).responseJSON {
            (response) in
            if response.response?.statusCode == 200 {
                switch response.result {
                        case .success(let responseValue):
                            print("Authentication success")
                            let json =  JSON(responseValue)
                            if json["result"].exists() {
                                let originalObjects = (json["result"])
                                let encoder = JSONEncoder()
                                let data = try! encoder.encode(originalObjects)

                                let decoder = JSONDecoder()
                                decoder.dateDecodingStrategy = .secondsSince1970

                                let userInfo = try! decoder.decode(UserInfo.self, from: data)
                                self.db.insertUserInfo(userInfo: userInfo)
                                loggedIn = true
                                
                                ChangeView()
                            }
                            else if json["error"].exists() {
                                loggedIn = false
                                self.showToast(message: "Нэвтрэх нэр эсвэл нууц үг буруу байна!", font: .systemFont(ofSize: 12.0))
                                self.imgErrorUsername.isHidden = false
                            }
                case .failure( _):
                            self.imgErrorUsername.isHidden = false
                            loggedIn = false
                            self.showToast(message: "Нэвтрэх нэр эсвэл нууц үг буруу байна.", font: .systemFont(ofSize: 12.0))
                }
                self.indicatorOdmobile.stopAnimating()
            }else{
                self.showToast(message: "Серверт холбогдоход алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
                loggedIn = false
                self.imgErrorUsername.isHidden = false
            }
        }
        return loggedIn
    }
    
    //Модуль суусан эсэхийг шалгах
    func checkModuleInstalled() -> Bool{
        if Connectivity.isConnectedToInternet {
             print("Connected Internet")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
            return false
        }
        
        var userInfo: UserInfo
        userInfo =  self.db.readUserInfo()
        
        if userInfo.web == nil
        {
            return false
        }
        let txtURL = userInfo.web!+"/web/dataset/call_kw"
        let id = arc4random_uniform(9999)
        let moduleNameLst = ["l10n_mn_hr", "l10n_mn_hr_attendance_mobile"]
        for moduleName in moduleNameLst {
            let params = " {\"jsonrpc\": \"2.0\", \"method\": \"call\", \"params\":{\"model\": \"ir.module.module\", \"method\": \"check_module_installed_mobile\",\"args\":[\"ir.module.module\", \"\(moduleName)\"], \"kwargs\":{}, \"context\": {\"lang\": \"mn_MN\", \"tz\": \"Asia/Shanghai\",\"uid\":1}},\"id\":\"\(id)\"}"
            
            print("jsonReq")
            print(params)
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
                            print(value)
                            let json =  JSON(value)
                            let originalObjects = (json["result"])
                            let encoder = JSONEncoder()
                            let data = try! encoder.encode(originalObjects)
                            let decoder = JSONDecoder()
                            let irModules = try! decoder.decode([IrModule].self, from: data)
                            
                            for module in irModules {
                                self.db.insertIrModule(id: module.id, name: module.name, state: module.state)
                            }
                            
                            let modules = self.db.readIrModuleInstalled()
                            print("resulsModule")
                            
                            for module in modules {
                                print("modules")
                                print(module.id)
                                print(module.name)
                                print(module.state)
                            }
                    case .failure(let error):
                                self.showToast(message: "Модуль шалгахад алдаа гарлаа. \(error)", font: .systemFont(ofSize: 12.0))
                    }
                }else{
                    self.showToast(message: "Серверт холбогдоход алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
                }
            }
        }
        
        return true
    }

    // url-д хамааралтай баазыг авчрах функц
    func setURLDatabase(){
        //GET DATABASE
        if Connectivity.isConnectedToInternet {
             print("Connected")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
            return
        }
        
        let txtURL = tfURL.text!
        let urlString = txtURL + "/web/database/list"
        print(urlString)
        let json = "{}"
        let url = URL(string: urlString)!
        let jsonData = json.data(using: .utf8, allowLossyConversion: false)!

        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = jsonData
        print("start")
        _ =  URLSession.shared.dataTask(with: request){
            data, response, error in guard let _ = data, error == nil else{
                print("errrr")
                return
            }
            let responseJSON = try? JSONSerialization.jsonObject(with: jsonData, options: [])
        if (responseJSON as? [String:Any]) != nil{
                print("okkk")
            }
        }
        print("end")
        AF.request(request).responseJSON { [self]
            response in
            if response.response?.statusCode == 200 {
                imgErrorURL.isHidden = true
                imgCheckedURL.isHidden = false

                switch response.result {
                    case .success(let value):
                        let json =  JSON(value)
                        self.lstDB = (json["result"].arrayObject as? [String])!
                        self.tfDatabase.inputView = self.pickerDatabase
                        self.pickerDatabase.reloadAllComponents()
                    case .failure(let error):
                        self.showToast(message: "URL хаяг буруу байна.", font: .systemFont(ofSize: 12.0))
                        print("Request failed with error: \(error)")
                        self.lstDB = [""]
                }
            }
            else {
                self.showToast(message: "URL хаяг буруу байна.", font: .systemFont(ofSize: 12.0))
                imgErrorURL.isHidden = false
                pickerDatabase.isHidden = true
                self.lstDB = [""]
            }
            indicatorURLcheck.stopAnimating()
        }
    }
}

//Нэвтрэх , гарах үед дуудах функц
func ChangeView(){
    guard let rootVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainMenuView") as? MainMenuViewController else {
                    return
                }
                let navigationController = UINavigationController(rootViewController: rootVC)

                UIApplication.shared.windows.first?.rootViewController = navigationController
                UIApplication.shared.windows.first?.makeKeyAndVisible()
}

// Database харуулах контролын үзэгдлүүд START
extension LoginViewController: UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lstDB.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        tfDatabase.text = self.lstDB[row]
        tfDatabase.resignFirstResponder()
    }
}

extension LoginViewController:UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lstDB[row]
    }
}

extension LoginViewController:UITextFieldDelegate{
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
          if textField == tfDatabase {
            tfDatabase.resignFirstResponder();
          }
          return false
       }
}
// Database харуулах контролын үзэгдлүүд END

//Userinterface кодоос өөрчлөлт хийх START
extension UIViewController {
    func showToast(message : String, font: UIFont) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 100, y: self.view.frame.size.height-100, width: 200, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        toastLabel.numberOfLines = 3
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
             toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIStackView {
     func insertViewIntoStack(background: UIColor, cornerRadius: CGFloat) {
        let subView = UIView(frame: bounds)
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = cornerRadius
        subView.backgroundColor = background
        insertSubview(subView, at: 0)
    }
}
//Userinterface кодоос өөрчлөлт хийх START

extension Optional where Wrapped == String {
    var isNilOrEmpty: Bool {
        return self?.trimmingCharacters(in: .whitespaces).isEmpty ?? true
    }
}

//Интернэт шалгах функц
struct Connectivity {
  static let sharedInstance = NetworkReachabilityManager()!
  static var isConnectedToInternet:Bool {
      return self.sharedInstance.isReachable
    }
}
