//
//  ViewController.swift
//  FInalExam _Janasi2026
//
//  Created by Janasi Rajput on 2026-04-05.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        // Allows you to manually connect 'Exit' proxies back to this Home View Controller
    }
    
    @IBAction func showAnalyticsTapped(_ sender: Any) {
        let dashboardView = AnalyticsDashboardView()
        let hostingController = UIHostingController(rootView: dashboardView)
        hostingController.modalPresentationStyle = .formSheet 
        self.present(hostingController, animated: true)
    }
}

