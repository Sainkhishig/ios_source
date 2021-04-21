//
//  AttendanceDetailController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 1/10/21.
//

import Foundation
import UIKit
class AttendanceDetailController: UIViewController{
    @IBOutlet weak var lblEmployeeName: UILabel!
    @IBOutlet weak var lblCalendarName: UILabel!
    @IBOutlet weak var lblWorkHour: UILabel!
    @IBOutlet weak var lblCheckinTime: UILabel!
    @IBOutlet weak var lblWorkStartTime: UILabel!
    @IBOutlet weak var lblWorkEndTime: UILabel!
    @IBOutlet weak var lblCheckoutTime: UILabel!
    @IBOutlet weak var lblEarlyTime: UILabel!
    @IBOutlet weak var lblLateTime: UILabel!
    @IBOutlet weak var lblEarlyCheckoutTime: UILabel!
    @IBOutlet weak var lblTotalAttendance: UILabel!
    var attendance: HrAttendance?
    
    //Цонх нээгдэхэд контролуудад мөрийн утгийг оноож өгнө
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        lblEmployeeName.text = attendance?.employee_name
        lblCalendarName.text = attendance?.calendar_name
        lblWorkHour.text = String((attendance?.work_hour_of_date)!)
        lblWorkStartTime.text = formatter.string(from: (attendance?.work_start_time)!)
        lblWorkEndTime.text = formatter.string(from: (attendance?.work_end_time)!)
        lblCheckinTime.text = attendance?.check_in_str
        lblCheckoutTime.text = attendance?.check_out_str
        lblEarlyTime.text = attendance?.early_leave_minutes_str
        lblLateTime.text = attendance?.total_lag_minutes_str
        lblEarlyCheckoutTime.text = attendance?.minutes_before_work_hour_str
        lblTotalAttendance.text = attendance?.total_worked_hours_of_date_str
    }
}
