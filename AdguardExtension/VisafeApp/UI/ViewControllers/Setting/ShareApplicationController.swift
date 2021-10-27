//
//  ShareApplicationController.swift
//  visafe_ios
//
//  Created by NCSC P5 on 5/5/21.
//

import UIKit
class ShareApplicationController : UITableViewController
{
    @IBOutlet weak var table: UITableView!
    @IBAction func btn_android(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [URL(string: "https://play.google.com/store/apps/details?id=vn.ncsc.visafe")!],applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    @IBAction func btn_mac(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [URL(string: "https://apps.apple.com/vn/app/visafe/id1564635388")!],applicationActivities: nil)
        present(activity, animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 1.0 : 32
    }
    override func viewDidLoad() {
        tableView.contentInset = UIEdgeInsets(top: -1, left: 0, bottom: 0, right: 0)
        super.viewDidLoad()
    }
}
