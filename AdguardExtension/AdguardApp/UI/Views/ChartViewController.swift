//
//  ChartViewController.swift
//  Adguard
//
//  Created by Илья Ковальчук on 05.11.2019.
//  Copyright © 2019 Performiks. All rights reserved.
//

import UIKit

class ChartViewController: UIViewController {

    @IBOutlet weak var chartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var points = [Point]()
        
        points.append(Point(x: 10.0, y: 24.0))
        points.append(Point(x: 22.0, y: 68.0))
        points.append(Point(x: 1.0, y: 8.0))
        points.append(Point(x: 130.0, y: 2.0))
        points.append(Point(x: 88.0, y: 10.0))
        points.append(Point(x: 9.0, y: 89.0))
        points.append(Point(x: 53.0, y: 2.0))
        points.append(Point(x: 49.0, y: 120.0))
        
        chartView.chartPoints = points
    }

}
