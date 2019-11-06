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
            chartPoints.append(Point(x: 0.0, y: 0.0))
            chartPoints.sort(by: { $0.x < $1.x })
            maxXelement = chartPoints.map({ $0.x }).max() ?? 0.0
            maxYelement = chartPoints.map({ $0.y }).max() ?? 0.0
            setNeedsDisplay()
        }
    }
    
    var lineColor: UIColor = UIColor(hexString: "ff67b279") {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var shadowColor: UIColor = UIColor(hexString: "8f67b279") {
        didSet{
            setNeedsDisplay()
        }
    }
    
    var gridColor: UIColor = UIColor(displayP3Red: 0.53, green: 0.53, blue: 0.53, alpha: 0.2) {
        didSet{
            setNeedsDisplay()
        }
    }

    var themeService: ThemeServiceProtocol? {
        didSet{
            backgroundColor = themeService?.backgroundColor
            setNeedsDisplay()
        }
    }
    
    private var numberOfVerticalSectors = 7
    private var numberOfHorizontalSectors = 2
    private var gridLineWidth: CGFloat = 2.0
    
    private var maxXelement: CGFloat = 0.0
    private var maxYelement: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        drawVerticalGridLines()
        drawHorizontalGridLines()
        drawGraphic()
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
        let path = UIBezierPath()
    
        path.lineWidth = gridLineWidth
        
        path.move(to: from)
        path.addLine(to: to)
        path.close()
        
        gridColor.set()
        path.stroke()
        path.fill()
    }
    
    // MARK: - Methods for points
    
    private func drawGraphic(){
        
        let points = convertPoints()
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
            
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.lineWidth = 2.0
            
        lineLayer.shadowColor = shadowColor.cgColor
        lineLayer.shadowOffset = CGSize(width: 0, height: 8)
        lineLayer.shadowOpacity = 0.5
        lineLayer.shadowRadius = 4.0
            
        layer.addSublayer(lineLayer)
    }
    
    private func convertPoints() -> [CGPoint] {
        var points = [CGPoint]()
                
        for point in chartPoints {
            let ratioX: CGFloat = point.x / maxXelement
            let ratioY: CGFloat = (point.y / maxYelement) * 0.7
            
            let newX = frame.width * ratioX
            let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15
            points.append(CGPoint(x: newX, y: newY))
        }
        return points
    }
}
