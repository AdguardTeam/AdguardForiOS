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
    
    var isEnabled: Bool = true {
        didSet{
            let color = isEnabled ? onColor : offColor
            lineColor = color
            shadowColor = color
            drawChart()
        }
    }
    
    var activeChart: ChartRequestType = .requests {
        didSet {
            drawChart()
        }
    }
    
    var chartPoints: (requests: [Point], blocked: [Point]) = ([], []) {
        didSet {
            chartPoints.requests.sort(by: { $0.x < $1.x })
            chartPoints.blocked.sort(by: { $0.x < $1.x })
            
            let maxXrequests = chartPoints.requests.map({ $0.x }).max() ?? 0.0
            let maxYrequests = chartPoints.requests.map({ $0.y }).max() ?? 0.0
            
            let maxXblocked = chartPoints.blocked.map({ $0.x }).max() ?? 0.0
            let maxYblocked = chartPoints.blocked.map({ $0.y }).max() ?? 0.0
            
            maxXelement = max(maxXrequests, maxXblocked)
            maxYelement = max(maxYrequests, maxYblocked)
            
            topBorderLabel.text = "\(Int(maxYelement))"
            
            drawChart()
        }
    }
    
    var leftDateLabelText: String? = "" {
        didSet{
            leftDateLabel.text = leftDateLabelText
        }
    }
    
    var rightDateLabelText: String? = "" {
        didSet{
            rightDateLabel.text = rightDateLabelText
        }
    }
    
    private var leftDateLabel = UILabel()
    private var rightDateLabel = UILabel()
    
    private var bottomBorderLabel = UILabel()
    private var topBorderLabel = UILabel()
    
    private var lineColor: UIColor = UIColor(hexString: "67b279")
    private var shadowColor: UIColor = UIColor(hexString: "67b279")
    private var gridColor: UIColor = UIColor(displayP3Red: 0.53, green: 0.53, blue: 0.53, alpha: 0.3)
    
    private let onColor = UIColor(hexString: "67b279")
    private let offColor = UIColor(hexString: "#888888")
    
    private var numberOfVerticalSectors = 7
    private var numberOfHorizontalSectors = 2
    private var gridLineWidth: CGFloat = 2.0
    
    private var maxXelement: CGFloat = 0.0
    private var maxYelement: CGFloat = 0.0
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        drawVerticalGridLines()
        drawHorizontalGridLines()
        drawChart()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLabels()
    }
    
    func updateTheme(theme: ThemeServiceProtocol){
        backgroundColor = theme.backgroundColor
        
        leftDateLabel.backgroundColor = theme.backgroundColor
        rightDateLabel.backgroundColor = theme.backgroundColor
        bottomBorderLabel.backgroundColor = theme.backgroundColor
        topBorderLabel.backgroundColor = theme.backgroundColor
        
        leftDateLabel.textColor = theme.chartViewTextColor
        rightDateLabel.textColor = theme.chartViewTextColor
        bottomBorderLabel.textColor = theme.chartViewTextColor
        topBorderLabel.textColor = theme.chartViewTextColor
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
    
    private func setupLabels(){
        addSubview(leftDateLabel)
        addSubview(rightDateLabel)
        addSubview(bottomBorderLabel)
        addSubview(topBorderLabel)
        
        leftDateLabel.translatesAutoresizingMaskIntoConstraints = false
        rightDateLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomBorderLabel.translatesAutoresizingMaskIntoConstraints = false
        topBorderLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftDateLabel.textAlignment = .left
        rightDateLabel.textAlignment = .right
        bottomBorderLabel.textAlignment = .center
        topBorderLabel.textAlignment = .center
        
        leftDateLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        rightDateLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        bottomBorderLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        topBorderLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        
        leftDateLabel.textColor = gridColor
        rightDateLabel.textColor = gridColor
        bottomBorderLabel.textColor = gridColor
        topBorderLabel.textColor = gridColor
        
        bottomBorderLabel.text = "0"
        topBorderLabel.text = "0"
        
        leftDateLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0).isActive = true
        leftDateLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        leftDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        rightDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0).isActive = true
        rightDateLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        rightDateLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        bottomBorderLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomBorderLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        bottomBorderLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -1.0).isActive = true
        
        topBorderLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topBorderLabel.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        topBorderLabel.centerXAnchor.constraint(equalTo: centerXAnchor, constant: -1.0).isActive = true
    }
    
    // MARK: - Methods for points
    
    private func drawChart(){
        let requestLineLayer = CAShapeLayer()
        let blockedLineLayer = CAShapeLayer()
        
        var requestPoints = convertPoints(points: chartPoints.requests)
        var blockedPoints = convertPoints(points: chartPoints.blocked)
        
        let requestsPath = getLinePath(from: &requestPoints)
        let blockedPath = getLinePath(from: &blockedPoints)
        
        let requestsAlpha: CGFloat = activeChart == .requests ? 1.0 : 0.3
        let blockedAlpha: CGFloat = activeChart == .blocked ? 1.0 : 0.3
                    
        requestLineLayer.path = requestsPath.cgPath
        requestLineLayer.fillColor = UIColor.clear.cgColor
        requestLineLayer.strokeColor = lineColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.lineWidth = 3.0
            
        requestLineLayer.shadowColor = shadowColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        requestLineLayer.shadowOpacity = 0.5
        requestLineLayer.shadowRadius = 4.0
        
        blockedLineLayer.path = blockedPath.cgPath
        blockedLineLayer.fillColor = UIColor.clear.cgColor
        blockedLineLayer.strokeColor = lineColor.withAlphaComponent(blockedAlpha).cgColor
        blockedLineLayer.lineWidth = 3.0
            
        blockedLineLayer.shadowColor = shadowColor.withAlphaComponent(blockedAlpha).cgColor
        blockedLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        blockedLineLayer.shadowOpacity = 0.5
        blockedLineLayer.shadowRadius = 4.0
        
        layer.sublayers?.forEach({ (sublayer) in
            if sublayer.isKind(of: CAShapeLayer.self) {
                sublayer.removeFromSuperlayer()
            }
        })
        
        layer.addSublayer(requestLineLayer)
        layer.addSublayer(blockedLineLayer)
    }
    
    private func convertPoints(points: [Point]) -> [CGPoint] {
        var newPoints = [CGPoint]()
                
        for point in points {
            var ratioX: CGFloat = point.x / maxXelement
            var ratioY: CGFloat = (point.y / maxYelement) * 0.7
            
            // There is a devision by zero, when initializing this variables
            ratioX = ratioX.isNaN ? 0.0 : ratioX
            ratioY = ratioY.isNaN ? 0.0 : ratioY
            
            let newX = frame.width * ratioX
            let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15
            newPoints.append(CGPoint(x: newX, y: newY))
        }
        return newPoints
    }
    
    private func getLinePath(from points: inout [CGPoint]) -> UIBezierPath {
        
        let lowestYpoint = frame.height * 0.85
        
        if points.isEmpty {
            let minPoint = CGPoint(x: 0.0, y: lowestYpoint)
            let maxPoint = CGPoint(x: frame.width, y: lowestYpoint)
            
            points.append(minPoint)
            points.append(maxPoint)
        } else if points.count == 1 {
            let minPoint = CGPoint(x: 0.0, y: lowestYpoint)
            let maxPoint = CGPoint(x: frame.width, y: lowestYpoint)
            
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
        
        return linePath
    }
    
}
