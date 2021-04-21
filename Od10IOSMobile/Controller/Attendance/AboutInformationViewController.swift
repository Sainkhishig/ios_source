//
//  AboutInformationViewController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 1/21/21.
//

import Foundation
import UIKit
class AbounInformationViewController: UIViewController {
    @IBOutlet weak var lblUniqueKey: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let imei_uuid = UIDevice.current.identifierForVendor?.uuidString {
                print(imei_uuid)
            lblUniqueKey.text = imei_uuid
        }else{
            lblUniqueKey.text = "Тодорхойгүй!"
        }
    }
}
