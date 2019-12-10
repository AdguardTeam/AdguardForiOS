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


struct CubicBezierCurveSegment {
    let controlPoint1: CGPoint
    let controlPoint2: CGPoint
}

class CubicBezierCurveAlgorithm {
    
    private var firstControlPoints: [CGPoint?] = []
    private var secondControlPoints: [CGPoint?] = []
    
    func controlPointsFromPoints(dataPoints: [CGPoint]) -> [CubicBezierCurveSegment] {
        
        // Number of sectors which the graph is devided into
        let count = dataPoints.count - 1
        
        /*
         K0, C1, C2, K3 are the points for each sector, where K0 & K3 are the knots and C1, C2 are the control points.
         K - stands for Knots
         C - stands for Control point
         **/
        if count == 1 {
            
            let K0 = dataPoints[0]
            let K3 = dataPoints[1]
            
            /*
             Calculate First Control Point
             3 * C1 = 2K0 + K3
             **/
            let C1x = (2*K0.x + K3.x)/3
            let C1y = (2*K0.y + K3.y)/3
            
            firstControlPoints.append(CGPoint(x: C1x, y: C1y))
            
            /*
             Calculate second Control Point
             C2 = 2*C1 - K0
             **/
            let C2x = (2*C1x - K0.x)
            let C2y = (2*C1y - K0.y)
            
            secondControlPoints.append(CGPoint(x: C2x, y: C2y))
            
        } else {
            
            firstControlPoints = Array(repeating: nil, count: count)

            var rhsArray = [CGPoint]()
            
            //Array of Coefficients
            var a = [Double]()
            var b = [Double]()
            var c = [Double]()
            
            for i in 0..<count {
                var rhsValueX: CGFloat = 0
                var rhsValueY: CGFloat = 0
                
                let K0 = dataPoints[i];
                let K3 = dataPoints[i+1];
                
                if i == 0 {
                    
                    a.append(0)
                    b.append(2)
                    c.append(1)
                    
                    //rhs for first segment
                    rhsValueX = K0.x + 2*K3.x;
                    rhsValueY = K0.y + 2*K3.y;
                    
                } else if i == count-1 {
                    a.append(2)
                    b.append(7)
                    c.append(0)
                    
                    //rhs for last segment
                    rhsValueX = 8*K0.x + K3.x;
                    rhsValueY = 8*K0.y + K3.y;
                } else {
                    a.append(1)
                    b.append(4)
                    c.append(1)
                    
                    rhsValueX = 4*K0.x + 2*K3.x;
                    rhsValueY = 4*K0.y + 2*K3.y;
                }
                
                rhsArray.append(CGPoint(x: rhsValueX, y: rhsValueY))
            }
            
            //Solve Ax = B. Using Tridiagonal matrix algorithm or Thomas Algorithm
            for i in 1..<count {
                
                let rhsValueX = rhsArray[i].x
                let rhsValueY = rhsArray[i].y
                
                let prevRhsValueX = rhsArray[i-1].x
                let prevRhsValueY = rhsArray[i-1].y
                
                let m = a[i]/b[i-1]
                
                let b1 = b[i] - m * c[i-1];
                b[i] = b1
                
                let r2x = Double(rhsValueX) - m * Double(prevRhsValueX)
                let r2y = Double(rhsValueY) - m * Double(prevRhsValueY)
                
                rhsArray[i] = CGPoint(x: r2x, y: r2y)
            }
            
            //Last control Point
            let lastControlPointX = Double(rhsArray[count-1].x)/b[count-1]
            let lastControlPointY = Double(rhsArray[count-1].y)/b[count-1]
            
            firstControlPoints[count-1] = CGPoint(x: lastControlPointX, y: lastControlPointY)
            
            for i in (0 ..< count - 1).reversed() {
                if let nextControlPoint = firstControlPoints[i+1] {
                    let controlPointX = (Double(rhsArray[i].x) - c[i] * Double(nextControlPoint.x))/b[i]
                    let controlPointY = (Double(rhsArray[i].y) - c[i] * Double(nextControlPoint.y))/b[i]
                    
                    firstControlPoints[i] = CGPoint(x: controlPointX, y: controlPointY)
                }
            }
        
            //Compute second Control Points from first
            for i in 0..<count {
                
                if i == count-1 {
                    let K3 = dataPoints[i+1]
                    
                    guard let C1 = firstControlPoints[i] else{
                        continue
                    }
                    
                    let controlPointX = (K3.x + C1.x)/2
                    let controlPointY = (K3.y + C1.y)/2
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                    
                } else {
                    let K3 = dataPoints[i+1]
                    
                    guard let nextC1 = firstControlPoints[i+1] else {
                        continue
                    }
                    
                    let controlPointX = 2*K3.x - nextC1.x
                    let controlPointY = 2*K3.y - nextC1.y
                    
                    secondControlPoints.append(CGPoint(x: controlPointX, y: controlPointY))
                }
            }
        }
        
        var controlPoints = [CubicBezierCurveSegment]()
        
        for i in 0..<count {
            if let firstControlPoint = firstControlPoints[i],
                let secondControlPoint = secondControlPoints[i] {
                let segment = CubicBezierCurveSegment(controlPoint1: firstControlPoint, controlPoint2: secondControlPoint)
                controlPoints.append(segment)
            }
        }
        
        return controlPoints
    }
}
