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

extension UIBezierPath {
    
    public convenience init?(quadCurve points: [CGPoint]) {
        guard points.count > 1 else { return nil }
        
        self.init()
        
        var p1 = points[0]
        move(to: p1)
        
        if points.count == 2 {
            addLine(to: points[1])
        }
        
        for i in 0..<points.count {
            let mid = midPoint(p1: p1, p2: points[i])
            
            addQuadCurve(to: mid, controlPoint: controlPoint(p1: mid, p2: p1))
            addQuadCurve(to: points[i], controlPoint: controlPoint(p1: mid, p2: points[i]))
            
            p1 = points[i]
        }
    }
    
    private func midPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        return CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
    }
    
    private func controlPoint(p1: CGPoint, p2: CGPoint) -> CGPoint {
        var controlPoint = midPoint(p1: p1, p2: p2)
        let diffY = abs(p2.y - controlPoint.y)
        
        if p1.y < p2.y {
            controlPoint.y += diffY
        } else if p1.y > p2.y {
            controlPoint.y -= diffY
        }
        return controlPoint
    }
}
