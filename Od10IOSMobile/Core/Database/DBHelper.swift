//
//  DBHelper.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 12/06/20.
//

import Foundation
import SQLite3
class DBHelper{
    init()
    {
        db = openDatabase()
        createUserInfoTable()
        createHrEmployeeTable()
        createHrAttendanceTable()
        createIrModuleTable()
    }

    //DB
    let dbPath: String = "myDb.sqlite"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer?
    {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK
        {
            print("error opening database")
            return nil
        }
        else
        {
            print("Successfully opened connection to database at \(dbPath)")
            return db
        }
    }
       
    //Table create
    //Нэвтэрсэн хэрэглэгчийн мэдээлэл хадгалах table үүсгэх
    func createUserInfoTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user_info(uid INTEGER PRIMARY KEY, company_id INTEGER, db TEXT, name TEXT, username TEXT, web TEXT );"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("user info table created.")
            } else {
                print("user info table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //Нэвтэрсэн хэрэглэгчийн мэдээлэл хадгалах
    func insertUserInfo(userInfo: UserInfo)
        {
            let employees = readUserInfo()
            if employees.uid == userInfo.uid
            {
                return
            }
        
            let insertStatementString = "INSERT INTO user_info (uid, username , company_id, web, db ) VALUES (?, ?, ?, ?, ?);"
            var insertStatement: OpaquePointer? = nil
        
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(userInfo.uid!))
                sqlite3_bind_text(insertStatement, 2, (userInfo.username! as NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 3, Int32(userInfo.company_id!))
                sqlite3_bind_text(insertStatement, 4, (userInfo.web! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (userInfo.db! as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    
    //Нэвтэрсэн хэрэглэгчийн мэдээлэл авах
    func readUserInfo() -> UserInfo {
        var userInfo: UserInfo = UserInfo()
        
        let queryStatementString = "SELECT uid, company_id, username, web, db FROM user_info;"
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let uid = sqlite3_column_int(queryStatement, 0)
                let company_id = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let username = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let web = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                let db = String(describing: String(cString: sqlite3_column_text(queryStatement, 4)))
                userInfo = UserInfo(uid: Int(uid), username: username, company_id: Int(company_id)!, web: web, db: db)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return userInfo
    }

    // Table IrModule >
    //create IrModule
    func createIrModuleTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS ir_module(id INTEGER PRIMARY KEY, name TEXT, state TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("ir.module table created.")
            } else {
                print("ir.module table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //insert IrModule
    func insertIrModule(id:Int, name:String, state: String)
    {
        let employees = readIrModule()
        for p in employees
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO ir_module (Id, name, state) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (state as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }
    
    //read IrModule
    func readIrModule() -> [IrModule] {
        let queryStatementString = "SELECT * FROM ir_module;"
        var queryStatement: OpaquePointer? = nil
        var psns : [IrModule] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let state = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                psns.append(IrModule(id: Int(id), name: name, state: state))
                print("Query Result:")
                print("\(id) | \(name) | \(state)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    //install хийсэн модулиудын жагсаалт
    func readIrModuleInstalled() -> [IrModule] {
        let queryStatementString = "SELECT * FROM ir_module where state = 'installed';"
        var queryStatement: OpaquePointer? = nil
        var psns : [IrModule] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let state = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                
                psns.append(IrModule(id: Int(id), name: name, state: state))
                print("Query Result:")
                print("\(id) | \(name) | \(state)")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    // Table: Employee
    //create Employee table
    func createHrEmployeeTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS hr_employee(Id INTEGER PRIMARY KEY,name TEXT, display_name TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("hr_employee table created.")
            } else {
                print("hr_employee table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
        
    func insertEmployee(id:Int, name:String, display_name: String)
    {
        let employees = readEmployee()
        for p in employees
        {
            if p.id == id
            {
                return
            }
        }
        let insertStatementString = "INSERT INTO hr_employee (Id, name, display_name) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(id))
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("Successfully inserted row.")
            } else {
                print("Could not insert row.")
            }
        } else {
            print("INSERT statement could not be prepared.")
        }
        sqlite3_finalize(insertStatement)
    }

    func readEmployee() -> [HrEmployee] {
        let queryStatementString = "SELECT * FROM hr_employee;"
        var queryStatement: OpaquePointer? = nil
        var psns : [HrEmployee] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let display_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                
                psns.append(HrEmployee(id: Int(id), name: name, display_name: display_name))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }
    
    func deleteEmployeeByID(id:Int) {
        let deleteStatementStirng = "DELETE FROM hr_employee WHERE Id = ?;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(deleteStatement, 1, Int32(id))
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
    
    // Ирц бүртгэх table үүсгэх
    func createHrAttendanceTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS hr_attendance(Id INTEGER PRIMARY KEY,calendar_name TEXT, employee_name TEXT, employee_id INTEGER, work_start_time NUMERIC, work_end_time NUMERIC, work_hour_of_date REAL, check_in NUMERIC, check_out NUMERIC, check_in_str TEXT, check_out_str TEXT, total_attendance_hours REAL, total_worked_hours_of_date REAL, minutes_before_work_hour REAL, total_lag_minutes REAL, early_leave_minutes REAL, total_attendance_hours_str TEXT, total_worked_hours_of_date_str TEXT, minutes_before_work_hour_str TEXT, total_lag_minutes_str TEXT, early_leave_minutes_str TEXT, write_date NUMERIC, attendance_day TEXT, checkin_time TEXT, checkout_time TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK
        {
            if sqlite3_step(createTableStatement) == SQLITE_DONE
            {
                print("hr_attendance table created.")
            } else {
                print("hr_attendance table could not be created.")
            }
        } else {
            print("CREATE TABLE statement could not be prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    //Ирцийн мэдээлэл хадгалах
    func insertAttendance(attendance: HrAttendance)
        {
            let employees = readAttendance()
            for p in employees
            {
                if p.id == attendance.id
                {
                    return
                }
            }
            let insertStatementString = "INSERT INTO hr_attendance (Id, check_in_str , check_out_str, calendar_name, attendance_day , check_in, work_hour_of_date, work_start_time, work_end_time, employee_id, employee_name, early_leave_minutes_str, minutes_before_work_hour_str, total_lag_minutes_str, total_attendance_hours_str, total_worked_hours_of_date_str) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);"
    
            var insertStatement: OpaquePointer? = nil
            let formatter = DateFormatter()
            formatter.timeZone = NSTimeZone(forSecondsFromGMT: 60 * 60 * 8) as TimeZone
            formatter.dateFormat = "yyyy-MM-dd"
            let attendanceDay = formatter.string(from: attendance.check_in!)
        
            if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_int(insertStatement, 1, Int32(attendance.id))
                sqlite3_bind_text(insertStatement, 2, (attendance.check_in_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (attendance.check_out_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (attendance.calendar_name! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (attendanceDay as NSString).utf8String, -1, nil)
                if let check_in_Day = attendance.check_in {
                    sqlite3_bind_double(insertStatement, 6, check_in_Day.timeIntervalSinceReferenceDate)
                } else {
                    sqlite3_bind_null(insertStatement, 6)
                }
                
                sqlite3_bind_double(insertStatement, 7, Double(Float(attendance.work_hour_of_date!)))
                
                if let work_start_time = attendance.work_start_time {
                    sqlite3_bind_double(insertStatement, 8, work_start_time.timeIntervalSinceReferenceDate)
                } else {
                    sqlite3_bind_null(insertStatement, 8)
                }
                
                if let work_end_time = attendance.work_end_time {
                    sqlite3_bind_double(insertStatement, 9, work_end_time.timeIntervalSinceReferenceDate)
                } else {
                    sqlite3_bind_null(insertStatement, 9)
                }
                
                sqlite3_bind_int(insertStatement, 10, Int32(attendance.employee_id))
                sqlite3_bind_text(insertStatement, 11, (attendance.employee_name! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 12, (attendance.early_leave_minutes_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 13, (attendance.minutes_before_work_hour_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 14, (attendance.total_lag_minutes_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 15, (attendance.total_attendance_hours_str! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 16, (attendance.total_worked_hours_of_date_str! as NSString).utf8String, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
            } else {
                print("INSERT statement could not be prepared.")
            }
            sqlite3_finalize(insertStatement)
        }
    
    // Ирцийн мэдээлэл унших
    func readAttendance() -> [HrAttendance] {
        var queryStatementCount: OpaquePointer? = nil
        let query = "select count(*) from hr_attendance;"
        var count: Int32 = 0
        if sqlite3_prepare_v2(db, query, -1, &queryStatementCount, nil) == SQLITE_OK {
              while(sqlite3_step(queryStatementCount) == SQLITE_ROW){
                   count = sqlite3_column_int(queryStatementCount, 0)
                   print("\(count)")
              }
        }
        if count == 0
        {
            return [HrAttendance()]
            
        }
        
        let queryStatementString = "SELECT Id, check_in_str, check_out_str, calendar_name, check_in, attendance_day, work_hour_of_date, work_start_time, work_end_time, employee_id, employee_name, early_leave_minutes_str, minutes_before_work_hour_str, total_lag_minutes_str, total_attendance_hours_str, total_worked_hours_of_date_str FROM hr_attendance;"
        var queryStatement: OpaquePointer? = nil
        var psns : [HrAttendance] = []
        
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let check_in_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let check_out_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let calendar_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                var check_in = Date()
                if sqlite3_column_type(queryStatement, 4) != SQLITE_NULL {
                    check_in = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStatement, 4))
                }
                let attendance_day = String(describing: String(cString: sqlite3_column_text(queryStatement, 5)))
                
                let work_hour_of_date = sqlite3_column_double(queryStatement, 6)
                
                var work_start_time = Date()
                if sqlite3_column_type(queryStatement, 7) != SQLITE_NULL {
                    work_start_time = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStatement, 7))
                }
                var work_end_time = Date()
                if sqlite3_column_type(queryStatement, 8) != SQLITE_NULL {
                    work_end_time = Date(timeIntervalSinceReferenceDate: sqlite3_column_double(queryStatement, 8))
                }
                let employee_id = sqlite3_column_int(queryStatement, 9)
                let employee_name = String(describing: String(cString: sqlite3_column_text(queryStatement, 10)))
                let early_leave_minutes_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 11)))
                let minutes_before_work_hour_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 12)))
                let total_lag_minutes_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 13)))
                let total_attendance_hours_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 14)))
                let total_worked_hours_of_date_str = String(describing: String(cString: sqlite3_column_text(queryStatement, 15)))
                
                psns.append(HrAttendance(id: Int(id), check_in_str: check_in_str, check_out_str: check_out_str, calendar_name: calendar_name,employee_name:employee_name, employee_id: Int(employee_id), work_start_time: work_start_time, work_end_time: work_end_time,  work_hour_of_date: Float(work_hour_of_date), check_in: check_in, total_attendance_hours_str: total_attendance_hours_str, total_worked_hours_of_date_str:total_worked_hours_of_date_str, minutes_before_work_hour_str: minutes_before_work_hour_str, total_lag_minutes_str: total_lag_minutes_str, early_leave_minutes_str: early_leave_minutes_str, attendance_day: attendance_day))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        sqlite3_finalize(queryStatement)
        return psns
    }

    //Ирцийн мэдээлэл устгах
    func deleteAttendance() {
        let deleteStatementStirng = "DELETE FROM hr_attendance;"
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}

