/**
   This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
   Copyright © Adguard Software Limited. All rights reserved.

   Adguard for iOS is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   Adguard for iOS is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with Adguard for iOS.  If not, see <http://www.gnu.org/licenses/>.
*/

import UIKit

struct Point {
    var x: CGFloat
    var y: CGFloat
}

class ChartView: UIView {
    
    var chartPoints: [Point] = [] {
        didSet {
            chartPoints.sort(by: { $0.x < $1.x })
            maxXelement = chartPoints.map({ $0.x }).max() ?? 0.0
            maxYelement = chartPoints.map({ $0.y }).max() ?? 0.0
            
            drawChart()
        }
    }
    
    var lineColor: UIColor = UIColor(hexString: "ff67b279") {
        didSet{
            drawChart()
        }
    }
    
    var shadowColor: UIColor = UIColor(hexString: "67b279") {
        didSet{
            drawChart()
        }
    }
    
    var gridColor: UIColor = UIColor(displayP3Red: 0.53, green: 0.53, blue: 0.53, alpha: 0.2) {
        didSet{
            drawChart()
        }
    }
    
    private var numberOfVerticalSectors = 7
    private var numberOfHorizontalSectors = 2
    private var gridLineWidth: CGFloat = 2.0
    
    private var maxXelement: CGFloat = 0.0
    private var maxYelement: CGFloat = 0.0
    
    private let lineLayer = CAShapeLayer()
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawVerticalGridLines()
        drawHorizontalGridLines()
    }
    
    override func layoutSubviews() {
        drawChart()
    }
    
    // MARK: - Private methods -
    
    // MARK: - Methods for lines
    
    private func drawVerticalGridLines(){
        let sectorWidth = (frame.width - CGFloat(integerLiteral: numberOfVerticalSectors) * gridLineWidth) / CGFloat(integerLiteral: numberOfVerticalSectors)
        
        let startX: CGFloat = sectorWidth / 2
        
        for i in 0...numberOfVerticalSectors - 1 {
            let x = startX + (gridLineWidth + sectorWidth) * CGFloat(integerLiteral: i)
            let startPoint = CGPoint(x: x, y: 0.0)
            let endPoint = CGPoint(x: x, y: frame.height)
            
            drawLine(from: startPoint, to: endPoint)
        }
    }
    
    private func drawHorizontalGridLines(){
        let sectorHeight = (frame.height - CGFloat(integerLiteral: numberOfHorizontalSectors) * gridLineWidth) / CGFloat(integerLiteral: numberOfHorizontalSectors)
        
        let startY: CGFloat = 0.0
        
        for i in 1...numberOfHorizontalSectors - 1 {
            let y = startY + (gridLineWidth + sectorHeight) * CGFloat(integerLiteral: i)
            let startPoint = CGPoint(x: 0.0, y: y)
            let endPoint = CGPoint(x: frame.width, y: y)
            
            drawLine(from: startPoint, to: endPoint)
        }
    }
    
    private func drawLine(from: CGPoint, to: CGPoint){
    
        let gridPath = UIBezierPath()
    
        gridPath.lineWidth = gridLineWidth
        
        gridPath.move(to: from)
        gridPath.addLine(to: to)
        gridPath.close()
        
        gridColor.set()
        gridPath.stroke()
        gridPath.fill()
    }
    
    // MARK: - Methods for points
    
    private func drawChart(){
        lineLayer.removeFromSuperlayer()
        
        var points = convertPoints()
        
        if points.isEmpty {
            let minPoint = CGPoint(x: 0.0, y: frame.height / 2)
            let maxPoint = CGPoint(x: frame.width, y: frame.height / 2)
            
            points.append(minPoint)
            points.append(maxPoint)
        } else if points.count == 1 {
            let minPoint = CGPoint(x: 0.0, y: frame.height)
            let maxPoint = CGPoint(x: frame.width, y: frame.height)
            
            points.append(minPoint)
            points.append(maxPoint)
            
            points.sort(by: { $0.x < $1.x })
        }
        
        let cubicCurveAlgorithm = CubicBezierCurveAlgorithm()
        
        let controlPoints = cubicCurveAlgorithm.controlPointsFromPoints(dataPoints: points)

        let linePath = UIBezierPath()
            
        for i in 0..<points.count {
            let point = points[i];
            
            if i==0 {
                linePath.move(to: point)
            } else {
                let segment = controlPoints[i-1]
                linePath.addCurve(to: point, controlPoint1: segment.controlPoint1, controlPoint2: segment.controlPoint2)
            }
        }
            
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = 3.0
            
        lineLayer.shadowColor = shadowColor.cgColor
        lineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        lineLayer.shadowOpacity = 0.5
        lineLayer.shadowRadius = 4.0
            
        layer.addSublayer(lineLayer)
    }
    
    private func convertPoints() -> [CGPoint] {
        var points = [CGPoint]()
                
        for point in chartPoints {
            var ratioX: CGFloat = point.x / maxXelement
            var ratioY: CGFloat = (point.y / maxYelement) * 0.7
            
            // There is a devision by zero, when initializing this variables
            ratioX = ratioX.isNaN ? 0.0 : ratioX
            ratioY = ratioY.isNaN ? 0.0 : ratioY
            
            let newX = frame.width * ratioX
            let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15
            points.append(CGPoint(x: newX, y: newY))
        }
        return points
    }
}
