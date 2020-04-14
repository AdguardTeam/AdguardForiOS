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
            let requestsColor = UIColor(hexString: "67b279")
            let encryptedColor = UIColor(hexString: "#677bb2")
            
            requestsLineColor = isEnabled ? requestsColor : offColor
            requestsShadowColor = isEnabled ? requestsColor : offColor
            encryptedLineColor = isEnabled ? encryptedColor : offColor
            encryptedShadowColor = isEnabled ? encryptedColor : offColor
            drawChart()
        }
    }
    
    var activeChart: ChartRequestType = .requests {
        didSet {
            drawChart()
        }
    }
    
    var chartPoints: (requests: [Point], encrypted: [Point]) = ([], []) {
        didSet {
            chartPoints.requests.sort(by: { $0.x < $1.x })
            chartPoints.encrypted.sort(by: { $0.x < $1.x })
            
            let maxXrequests = chartPoints.requests.map({ $0.x }).max() ?? 0.0
            let maxYrequests = chartPoints.requests.map({ $0.y }).max() ?? 0.0
            
            let maxXblocked = chartPoints.encrypted.map({ $0.x }).max() ?? 0.0
            let maxYblocked = chartPoints.encrypted.map({ $0.y }).max() ?? 0.0
            
            maxXelement = max(maxXrequests, maxXblocked)
            maxYelement = max(maxYrequests, maxYblocked)
            
            DispatchQueue.main.async {[weak self] in
                self?.topBorderLabel.text = "\(Int(self?.maxYelement ?? 0))"
                self?.drawChart()
            }
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
    
    private var requestsLineColor = UIColor(hexString: "67b279")
    private var requestsShadowColor = UIColor(hexString: "67b279")
    
    private var encryptedLineColor = UIColor(hexString: "#677bb2")
    private var encryptedShadowColor = UIColor(hexString: "677bb2")
    
    private var gridColor = UIColor(displayP3Red: 0.53, green: 0.53, blue: 0.53, alpha: 0.3)
    
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
        let encryptedLineLayer = CAShapeLayer()
        
        var requestPoints = convertPoints(points: chartPoints.requests)
        var encryptedPoints = convertPoints(points: chartPoints.encrypted)
        
        if requestPoints.count < 3 {
            maxXelement = 10.0
            requestPoints = convertPoints(points: [Point(x: 0.0, y: 0.0), Point(x: 10.0, y: 0.0)])
        }
        
        if encryptedPoints.count < 3 {
            maxXelement = 10.0
            encryptedPoints = convertPoints(points: [Point(x: 0.0, y: 0.0), Point(x: 10.0, y: 0.0)])
        }
        
        guard let requestsPath = UIBezierPath(quadCurve: requestPoints),
            let blockedPath = UIBezierPath(quadCurve: encryptedPoints)
            else { return }
        
        let requestsAlpha: CGFloat = activeChart == .requests ? 1.0 : 0.3
        let encryptedAlpha: CGFloat = activeChart == .encrypted ? 1.0 : 0.3
                    
        requestLineLayer.path = requestsPath.cgPath
        requestLineLayer.fillColor = UIColor.clear.cgColor
        requestLineLayer.strokeColor = requestsLineColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.lineWidth = 3.0
            
        requestLineLayer.shadowColor = requestsShadowColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        requestLineLayer.shadowOpacity = 0.5
        requestLineLayer.shadowRadius = 4.0
        
        encryptedLineLayer.path = blockedPath.cgPath
        encryptedLineLayer.fillColor = UIColor.clear.cgColor
        encryptedLineLayer.strokeColor = encryptedLineColor.withAlphaComponent(encryptedAlpha).cgColor
        encryptedLineLayer.lineWidth = 3.0
            
        encryptedLineLayer.shadowColor = encryptedShadowColor.withAlphaComponent(encryptedAlpha).cgColor
        encryptedLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        encryptedLineLayer.shadowOpacity = 0.5
        encryptedLineLayer.shadowRadius = 4.0
        
        layer.sublayers?.forEach({ (sublayer) in
            if sublayer.isKind(of: CAShapeLayer.self) {
                sublayer.removeFromSuperlayer()
            }
        })
        
        layer.addSublayer(requestLineLayer)
        layer.addSublayer(encryptedLineLayer)
    }
    
    private func convertPoints(points: [Point]) -> [CGPoint] {
        let preparedPoints = preparePoints(points: points)
        var newPoints = [CGPoint]()
                
        for point in preparedPoints {
            var ratioY: CGFloat = (point.y / maxYelement) * 0.7
            
            // There is a devision by zero, when initializing this variables
            ratioY = ratioY.isNaN ? 0.0 : ratioY

            let newY = (frame.height - frame.height * ratioY) - frame.height * 0.15
            //newPoints.append(CGPoint(x: newX, y: newY))
            
            let newPoint = CGPoint(x: point.x, y: newY)
            newPoints.append(newPoint)
        }
        return newPoints
    }
    
    /* This function is needed to avoid points overlay */
    private func preparePoints(points: [Point]) -> [Point] {
        let minimumSpacing: CGFloat = 5.0
        var newPoints = [Point]()
        
        for point in points {
            var ratioX: CGFloat = point.x / maxXelement
            
            // There is a devision by zero, when initializing this variables
            ratioX = ratioX.isNaN ? 0.0 : ratioX
            let newX = (frame.width * ratioX).rounded(.up)
            
            var lastPoint = newPoints.last ?? Point(x: 0.0, y: 0.0)
            if  newX - lastPoint.x <= minimumSpacing {
                newPoints = newPoints.dropLast()
                if lastPoint.x != 0.0 {
                    lastPoint.x += ((newX - lastPoint.x) / 2).rounded(.up)
                }
                lastPoint.y = lastPoint.y + point.y
                newPoints.append(lastPoint)
                if lastPoint.y > maxYelement {
                    maxYelement = lastPoint.y
                }
            } else {
                newPoints.append(Point(x: newX, y: point.y))
            }
        }
        
        return newPoints
    }
}
