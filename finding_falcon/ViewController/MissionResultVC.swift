//
//  MissionResultVC.swift
//  finding_falcon
//
//  Created by Kiran on 15/07/22.
//

import UIKit

class MissionResultVC: UIViewController {

    //MARK: - Outlets
    
    @IBOutlet weak var successView: UIView!
    @IBOutlet weak var failureView: UIView!
    @IBOutlet weak var timeTakenLbl: UILabel!
    @IBOutlet weak var planetLbl: UILabel!
    @IBOutlet weak var successLbl: UILabel!
    
    //MARK: - Local Variables
    
    var isSuccess = Bool()
    var planet = String()
    var timeTaken = Double()
    var delegate : Reset!

    override func viewDidLoad() {
        super.viewDidLoad()
        successView.isHidden = isSuccess ? false : true
        failureView.isHidden = !successView.isHidden
        successLbl.text = "Success ! Congratulations on Finding Falcone. King Shan is mightly pleased"
        planetLbl.text = "Planet found : "+planet
        timeTakenLbl.text = "Time taken : \(timeTaken)"
    }
    
    @IBAction func startAgain(_ sender: Any) {
        self.delegate.reset()
        self.navigationController?.popViewController(animated: true)
    }
}
