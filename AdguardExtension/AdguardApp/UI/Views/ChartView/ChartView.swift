//
// This file is part of Adguard for iOS (https://github.com/AdguardTeam/AdguardForiOS).
// Copyright © Adguard Software Limited. All rights reserved.
//
// Adguard for iOS is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// Adguard for iOS is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Adguard for iOS. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit
import enum DnsAdGuardSDK.ChartType

final class ChartView: UIView {

    var isEnabled: Bool = true {
        didSet{
            enabledStateChanged()
        }
    }

    var activeChart: ChartType = .requests {
        didSet {
            drawChart()
        }
    }

    var chartPoints: (requests: [CGPoint], encrypted: [CGPoint], blocked: [CGPoint]) = ([], [], []) {
        didSet {
            DispatchQueue.asyncSafeMain { [weak self] in
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

    // Number of maximum requests for specified period
    var maxRequests: Int = 0 {
        didSet {
            self.topBorderLabel.text = "\(maxRequests)"
        }
    }

    private var leftDateLabel = UILabel()
    private var rightDateLabel = UILabel()

    private var bottomBorderLabel = UILabel()
    private var topBorderLabel = UILabel()

    private var requestsLineColor = UIColor.AdGuardColor.lightGreen1
    private var requestsShadowColor = UIColor.AdGuardColor.lightGreen1

    private var blockedLineColor = UIColor.AdGuardColor.lightBlue
    private var blockedShadowColor = UIColor.AdGuardColor.lightBlue

    private var gridColor = UIColor.AdGuardColor.chartGridColor

    private let offColor = UIColor.AdGuardColor.lightGray3

    private var numberOfVerticalSectors = 7
    private var numberOfHorizontalSectors = 2
    private var gridLineWidth: CGFloat = 2.0

    private lazy var theme: ThemeServiceProtocol = { ServiceLocator.shared.getService()! }()

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

    func updateTheme(){
        backgroundColor = theme.backgroundColor

        leftDateLabel.backgroundColor = theme.backgroundColor
        rightDateLabel.backgroundColor = theme.backgroundColor
        bottomBorderLabel.backgroundColor = theme.backgroundColor
        topBorderLabel.backgroundColor = theme.backgroundColor

        leftDateLabel.textColor = theme.chartViewTextColor
        rightDateLabel.textColor = theme.chartViewTextColor
        bottomBorderLabel.textColor = theme.chartViewTextColor
        topBorderLabel.textColor = theme.chartViewTextColor

        enabledStateChanged()
    }

    // MARK: - Private methods -

    // MARK: - Methods for lines

    private func enabledStateChanged() {
        let requestsColor = UIColor.AdGuardColor.logAllowlistedCellColor
        let blockedColor = UIColor.AdGuardColor.orange1

        requestsLineColor = isEnabled ? requestsColor : offColor
        requestsShadowColor = isEnabled ? requestsColor : offColor
        blockedLineColor = isEnabled ? blockedColor : offColor
        blockedShadowColor = isEnabled ? blockedColor : offColor
        drawChart()
    }

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

        let requestPoints = chartPoints.requests
        let blockedPoints = chartPoints.blocked

        guard let requestsPath = UIBezierPath(quadCurve: requestPoints),
            let blockedPath = UIBezierPath(quadCurve: blockedPoints)
            else { return }

        let requestsAlpha: CGFloat = activeChart == .requests ? 1.0 : 0.3
        let blockedAlpha: CGFloat = activeChart == .blocked ? 1.0 : 0.3

        requestLineLayer.path = requestsPath.cgPath
        requestLineLayer.fillColor = UIColor.clear.cgColor
        requestLineLayer.strokeColor = requestsLineColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.lineWidth = 3.0

        requestLineLayer.shadowColor = requestsShadowColor.withAlphaComponent(requestsAlpha).cgColor
        requestLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        requestLineLayer.shadowOpacity = 0.5
        requestLineLayer.shadowRadius = 4.0

        blockedLineLayer.path = blockedPath.cgPath
        blockedLineLayer.fillColor = UIColor.clear.cgColor
        blockedLineLayer.strokeColor = blockedLineColor.withAlphaComponent(blockedAlpha).cgColor
        blockedLineLayer.lineWidth = 3.0

        blockedLineLayer.shadowColor = blockedShadowColor.withAlphaComponent(blockedAlpha).cgColor
        blockedLineLayer.shadowOffset = CGSize(width: 3.0, height: 4.0)
        blockedLineLayer.shadowOpacity = 0.5
        blockedLineLayer.shadowRadius = 4.0

        layer.sublayers?.forEach({ (sublayer) in
            if sublayer.isKind(of: CAShapeLayer.self) {
                sublayer.removeFromSuperlayer()
            }
        })

        if activeChart == .requests {
            layer.addSublayer(blockedLineLayer)
            layer.addSublayer(requestLineLayer)
        } else {
            layer.addSublayer(requestLineLayer)
            layer.addSublayer(blockedLineLayer)
        }
    }
}
