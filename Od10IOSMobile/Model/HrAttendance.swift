//
//  HrAttendance.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/3/20.
//

import Foundation

struct HrAttendance: Decodable{
    var id: Int = 0
    var check_in_str: String?
    var check_out_str: String?
    var calendar_name: String?
    var employee_name: String?
    
    var employee_id: Int = 0
    var work_start_time: Date?
    var work_end_time: Date?
    var work_hour_of_date: Float?
    var check_in: Date?
    var check_out: Date?
    
    var total_attendance_hours: Float?
//    var total_worked_hours_of_date: String
    var minutes_before_work_hour: Float?
    var total_lag_minutes: Float?
    var early_leave_minutes: Float?
    var total_attendance_hours_str: String?
    var total_worked_hours_of_date_str: String?
    var minutes_before_work_hour_str: String?
    var total_lag_minutes_str: String?
    var early_leave_minutes_str: String?
    var write_date: Date?
    var attendance_day: String?
    
    enum CodingKeys: String, CodingKey {
        case id, check_in_str, check_out_str, calendar_name, employee_name, employee_id, work_start_time, work_end_time, work_hour_of_date, check_in, check_out, total_attendance_hours, minutes_before_work_hour, total_lag_minutes, early_leave_minutes, total_attendance_hours_str, total_worked_hours_of_date_str, minutes_before_work_hour_str, total_lag_minutes_str, early_leave_minutes_str, write_date
    }
}

struct AttendanceResult: Decodable {
    let insert: [HrAttendance]
    let update: [HrAttendance]
    
    enum CodingKeys: String, CodingKey {
        case insert, update
        
    }
}
    
