//
//  SMSViewController.swift
//  PINViewExample
//
//  Created by 高松幸平 on 2019/12/07.
//  Copyright © 2019 gaopin1534. All rights reserved.
//

import UIKit

class SMSViewController: UIViewController {
    @IBOutlet weak var smsView: SMSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        smsView.configure(with: 4)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
