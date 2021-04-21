//
//  ConfigurationViewController.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 1/21/21.
//

import Foundation
import UIKit
//import PopupDialog
class ConfigurationViewController: UIViewController{
    @IBOutlet var viewSyncInterval: UIView!
    @IBOutlet var viewSyncDataLimit: UIView!
    @IBOutlet weak var lblSyncInterval: UILabel!
    @IBOutlet weak var lblSyncDataLimit: UILabel!
    @IBOutlet var effectBlur: UIVisualEffectView!
    
    @IBAction func intervaltouchDown(_ sender: Any) {
        isDataInterval = true
    }
    @IBOutlet weak var tableViewDataIntervalSelection: UITableView!
    @IBOutlet weak var tableViewSyncDataLimitSelection: UITableView!
    //    @IBOutlet weak var tableConfiguration: UITableView!
//    var selection = ["5 минут тутам", "10 минут тутам", "20 минут тутам", "40 минут тутам", "60 минут тутам", "Өдөрт 1 удаа"]
//    var selectionSyncDataLimit = ["1 хоног", "3 хоног", "7 хоног","15 хоног", "1 сар", "2 сар","3 сар", "6 сар", "12 сар"]
    var isDataInterval: Bool = true
    var cellIdentifier: String = ""
    var dataIntervalSelection: Array<Configuration> = []
    var dataLimitSelection: Array<Configuration> = []
    var selectedLimitConfiguration: Configuration?
    var selectedIntervalConfiguration: Configuration?
    
    struct Configuration {
        var value: Int
        var displayValue: String
    }
    
    func setListDataLimitConf(){
        dataLimitSelection = [Configuration]() //alternatively (does the same): var array = Array<Country>()
        dataLimitSelection.append(Configuration(value: 1, displayValue: "1 хоног"))
        dataLimitSelection.append(Configuration(value: 3, displayValue: "3 хоног"))
        dataLimitSelection.append(Configuration(value: 7, displayValue: "7 хоног"))
        dataLimitSelection.append(Configuration(value: 15, displayValue: "15 хоног"))
        dataLimitSelection.append(Configuration(value: 30, displayValue: "1 сар"))
        dataLimitSelection.append(Configuration(value: 60, displayValue: "2 сар"))
        dataLimitSelection.append(Configuration(value: 90, displayValue: "3 сар"))
        dataLimitSelection.append(Configuration(value: 180, displayValue: "6 сар"))
        dataLimitSelection.append(Configuration(value: 360, displayValue: "12 сар"))
    }
    
    func setListDataIntervalConf(){
        dataIntervalSelection = [Configuration]() //alternatively (does the same): var array = Array<Country>()
        dataIntervalSelection.append(Configuration(value: 5, displayValue: "5 минут тутам"))
        dataIntervalSelection.append(Configuration(value: 10, displayValue: "10 минут тутам"))
        dataIntervalSelection.append(Configuration(value: 20, displayValue: "20 минут тутам"))
        dataIntervalSelection.append(Configuration(value: 40, displayValue: "40 минут тутам"))
        dataIntervalSelection.append(Configuration(value: 60, displayValue: "60 минут тутам"))
        dataIntervalSelection.append(Configuration(value: 1, displayValue: "Өдөрт 1 удаа"))
    }
    
    @IBAction func btnShowSyncDataLimit_click(_ sender: Any) {
        isDataInterval = false
        animateIn(desiredView: effectBlur)
        animateIn(desiredView: viewSyncDataLimit)
    }
    @IBAction func btnSaveSyncDataLimit_click(_ sender: Any) {
        isDataInterval = false
        animationOut(desiredView: effectBlur)
        animationOut(desiredView: viewSyncDataLimit)
        
        //Sync data тохиргоо хадгалах
        let defaults = UserDefaults.standard
        defaults.set(selectedLimitConfiguration?.value, forKey: "SyncDataLimit")
    }
    @IBAction func btnShowSyncInterval_click(_ sender: Any) {
        isDataInterval = true
        animateIn(desiredView: effectBlur)
        animateIn(desiredView: viewSyncInterval)
        
    }
    @IBAction func btnSaveInterval_click(_ sender: Any) {
        animationOut(desiredView: effectBlur)
        animationOut(desiredView: viewSyncInterval)
        
        //Sync interval тохиргоо хадгалах
        let defaults = UserDefaults.standard
        defaults.set(selectedIntervalConfiguration?.value, forKey: "SyncInterval")
    }
    
    @IBAction func btnDataSyncLimit_click(_ sender: Any) {
        
    }
    @IBAction func btnAbout(_ sender: Any) {
//            let navController = UIApplication.shared.keyWindow?.rootViewController as? NavigationTabController {
//            self.present(conVC, animated:true, completion:nil)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setListDataLimitConf()
        setListDataIntervalConf()
        tableViewDataIntervalSelection.delegate = self
        tableViewDataIntervalSelection.dataSource = self
        tableViewDataIntervalSelection.separatorStyle = .none
        tableViewDataIntervalSelection.showsVerticalScrollIndicator = false
        
        tableViewSyncDataLimitSelection.delegate = self
        tableViewSyncDataLimitSelection.dataSource = self
        tableViewSyncDataLimitSelection.separatorStyle = .none
        tableViewSyncDataLimitSelection.showsVerticalScrollIndicator = false
        
        effectBlur.bounds = self.view.bounds
        viewSyncInterval.bounds = CGRect(x: 0, y: 0, width: self.view.bounds.width * 0.9, height: self.view.bounds.height * 0.4)
    }
    
    func animateIn(desiredView: UIView){
        let backgroudView = self.view!
        
        backgroudView.addSubview(desiredView)
        desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        desiredView.alpha = 0
        desiredView.center = backgroudView.center
        
        UIView.animate(withDuration: 0.3, animations:{ desiredView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            desiredView.alpha = 1
        })
    }
    
    func animationOut(desiredView: UIView){
        UIView.animate(withDuration: 0.3, animations:{
            desiredView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            desiredView.alpha = 0
        }, completion: { _ in
            desiredView.removeFromSuperview()
        } )
    }
}


extension ConfigurationViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isDataInterval
        {
            return "Sync Interval"
        }else
        {
            return "Data Sync Limit"
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor(named: "odoo_purple")
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDataInterval
        {
            return dataIntervalSelection.count
        }
        else{
            return dataLimitSelection.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDataInterval == true
        {
            let cell = tableViewDataIntervalSelection.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = dataIntervalSelection[indexPath.row].displayValue
            return cell
        }
        else
        {
            let cell = tableViewSyncDataLimitSelection.dequeueReusableCell(withIdentifier: "cellSyncData", for: indexPath)
            cell.textLabel?.text = dataLimitSelection[indexPath.row].displayValue
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isDataInterval == true{
            selectedIntervalConfiguration = dataIntervalSelection[indexPath.row]
        }else{
            selectedLimitConfiguration = dataLimitSelection[indexPath.row]
        }
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
        }
        else{
            tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.checkmark
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.accessoryType = UITableViewCell.AccessoryType.none
    }
    
}
