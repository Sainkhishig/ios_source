//
//  AttendanceInfoTableViewCell.swift
//  Od10IOSMobile
//
//  Created by Sainkhishig Ariunaa on 1/5/21.
//

import UIKit

class AttendanceInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var lblCalendarName: UILabel!
    @IBOutlet weak var attendance_view: UIView!
    @IBOutlet weak var lblCheckinTime: UILabel!
    @IBOutlet weak var lblCheckoutTime: UILabel!
    @IBOutlet weak var lblAttendanceDay: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
