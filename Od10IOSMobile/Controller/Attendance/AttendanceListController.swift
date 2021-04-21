//
//  AttendanceListController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/26/20.
//

import Foundation
import UIKit

import Alamofire
import SwiftyJSON

class AttendanceListController: UIViewController
{
    @IBOutlet weak var sbAttendanceSearch: UISearchBar!
    @IBOutlet weak var AttendanceListView: UITableView!
    fileprivate let refreshCtl = UIRefreshControl()
    var db:DBHelper = DBHelper()
    var selectedAttendance: HrAttendance?
    var items: [HrAttendance]?
    var currentItems: [HrAttendance]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AttendanceListView.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(AttendanceListController.refresh(sender:)), for: .valueChanged)
        
        AttendanceListView.delegate = self
        AttendanceListView.dataSource = self
        AttendanceListView.separatorStyle = .none
        AttendanceListView.showsVerticalScrollIndicator = false
        
        setupSearchBar()
        items = self.db.readAttendance()
        currentItems = items
        self.AttendanceListView.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        getAttendance()
        refreshCtl.endRefreshing()
    }
    
    //Ирцийн жагсаалт татах
    func getAttendance(){
        if Connectivity.isConnectedToInternet {
             print("Connected Internet")
         } else {
            self.showToast(message: "Интернет холболтоо шалгана уу!", font: .systemFont(ofSize: 12.0))
            return
        }

        db.deleteAttendance()
        var userInfo: UserInfo
        userInfo =  self.db.readUserInfo()
        let txtURL = userInfo.web!+"/web/dataset/call_kw"
        let id = arc4random_uniform(9999)
        let syncDataLimit = UserDefaults.standard.integer(forKey: "SyncDataLimit")
        let jsonData = """
                        {"jsonrpc": "2.0", "method": "call", "params": {"model": "hr.attendance", "method": "get_attendance_list_mobile",
                        "args": ["hr.attendance", 1, \(syncDataLimit), []], "kwargs": {}, "context": {"lang": "mn_MN", "tz": "Asia/Shanghai", "uid": 1}}, "id": \"\(id)\"}
                        """
        
        let url = URL(string: txtURL)!
        let params = jsonData.data(using: .utf8, allowLossyConversion: false)!
        var request = URLRequest(url: url)
        
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = params
        AF.request(request).responseJSON { [self]
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
                            decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
                            let attendanceList = try! decoder.decode(AttendanceResult.self, from: data)

                            for attendanceNew in attendanceList.insert {
                                self.db.insertAttendance(attendance: attendanceNew)
                            }
                            self.currentItems = self.db.readAttendance()
                            AttendanceListView.reloadData()
                case .failure(let error):
                    self.showToast(message: " Ирцийн мэдээлэл татахад алдаа гарлаа.\(error)", font: .systemFont(ofSize: 12.0))
                }
            }else{
                self.showToast(message: "Серверт холбогдоход алдаа гарлаа.", font: .systemFont(ofSize: 12.0))
            }
        }
    }
}

extension DateFormatter {
  static let iso8601Full: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    formatter.timeZone = TimeZone.init(identifier: "GMT")//(secondsFromGMT: 0)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter
  }()
}

// Table - ийн үзэгдлүүд барих
extension AttendanceListController: UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentItems!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AttendanceListView.dequeueReusableCell(withIdentifier: "cell_attendance_row") as! AttendanceInfoTableViewCell
        let attendance = currentItems![indexPath.row]
        if attendance.id == 0 {
            return cell
        }
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 60 * 60 * 8) as TimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        let attendanceDay = formatter.string(from: attendance.check_in!)
        cell.lblAttendanceDay.text = attendanceDay
        cell.lblCheckinTime.text = attendance.check_in_str
        cell.lblCheckoutTime.text = attendance.check_out_str
        cell.lblCalendarName.text = attendance.calendar_name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func setupSearchBar(){
            sbAttendanceSearch.delegate = self
    }
     
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedAttendance = currentItems![indexPath.row]
        performSegue(withIdentifier: "ShowAttendaceDetail", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if selectedAttendance == nil
        {
            return
        }
        if segue.identifier == "ShowAttendaceDetail"
        {
            let attendanceDetailTVC = segue.destination as! AttendanceDetailController
            attendanceDetailTVC.attendance = selectedAttendance!
            selectedAttendance = nil
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentItems = items
            AttendanceListView.reloadData()
            return
        }
        
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone(forSecondsFromGMT: 60 * 60 * 8) as TimeZone
        formatter.dateFormat = "yyyy-MM-dd"
        currentItems = items!.filter({ item -> Bool in
            formatter.string(from: item.check_in!).lowercased().contains(searchText.lowercased())
        })
        AttendanceListView.reloadData()
    }
}
