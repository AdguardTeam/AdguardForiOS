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

import Foundation

protocol StatisticsChartModelProtocol {
    static func points(for records: [DnsStatisticsRecord], _ type: ChartDateType) -> StatisticsChartModel.ChartViewConfig
}

extension StatisticsChartModelProtocol {
    static func points(for records: [DnsStatisticsRecord], _ type: ChartDateType) -> StatisticsChartModel.ChartViewConfig {
        var requestsPoints: [CGPoint] = []
        var encryptedPoints: [CGPoint] = []
        
        let firstDate = records.first?.date ?? Date()
        let lastDate = records.last?.date ?? Date()
        
        let leftBorderText = type.getFormatterString(from: firstDate)
        let rightBorderText = type.getFormatterString(from: lastDate)
        
        if records.count < 2 {
            let points = StatisticsChartModel.Points(requestsPoints: [], encryptedPoints: [])
            return StatisticsChartModel.ChartViewConfig(points: points, leftBorderText: leftBorderText, rightBorderText: rightBorderText)
        }
        
        let firstDateSecondsFromReferenceDate: CGFloat = CGFloat(firstDate.timeIntervalSinceReferenceDate)
        
        for record in records {
            let xPosition = CGFloat(record.date.timeIntervalSinceReferenceDate) - firstDateSecondsFromReferenceDate
            
            let requestPoint = CGPoint(x: xPosition, y: CGFloat(integerLiteral: record.requests))
            requestsPoints.append(requestPoint)
            
            let encryptedPoint = CGPoint(x: xPosition, y: CGFloat(integerLiteral: record.encrypted))
            encryptedPoints.append(encryptedPoint)
        }
        
        let points = StatisticsChartModel.Points(requestsPoints: requestsPoints, encryptedPoints: encryptedPoints)
        return StatisticsChartModel.ChartViewConfig(points: points, leftBorderText: leftBorderText, rightBorderText: rightBorderText)
    }
}

struct StatisticsChartModel: StatisticsChartModelProtocol {
    struct ChartViewConfig {
        let points: Points
        let leftBorderText: String
        let rightBorderText: String
    }
    struct Points {
        let requestsPoints: [CGPoint]
        let encryptedPoints: [CGPoint]
    }
}
