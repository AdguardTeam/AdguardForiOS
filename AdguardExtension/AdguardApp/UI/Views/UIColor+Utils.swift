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

extension UIColor {
    struct AdGuardColor {
        static let lightGreen1: UIColor = #colorLiteral(red: 0.4039215686, green: 0.6980392157, blue: 0.4745098039, alpha: 1)     //hex = #67b279
        static let lightGreen2: UIColor = #colorLiteral(red: 0.4117647059, green: 0.6980392157, blue: 0.4745098039, alpha: 1)     //hex = #69b279
        static let green: UIColor = #colorLiteral(red: 0.3019607843, green: 0.6, blue: 0.3725490196, alpha: 1)           //hex = #4d995f
        static let darkGreen: UIColor = #colorLiteral(red: 0.2235294118, green: 0.4666666667, blue: 0.2980392157, alpha: 1)       //hex = #39774c
        static let vpnLightGreen: UIColor = #colorLiteral(red: 0.4549019608, green: 0.6392156863, blue: 0.3215686275, alpha: 1)   //hex = #74a352
        static let vpnGreen: UIColor = #colorLiteral(red: 0.337254902, green: 0.5019607843, blue: 0.2509803922, alpha: 1)        //hex = #568040
        static let vpnDarkGreen: UIColor = #colorLiteral(red: 0.2431372549, green: 0.3607843137, blue: 0.1803921569, alpha: 1)    //hex = 3e5c2e
        
        static let black1: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)           //hex = 000000
        static let black2: UIColor = #colorLiteral(red: 0.1333333333, green: 0.1333333333, blue: 0.1333333333, alpha: 1)           //hex = 222222
        static let black3: UIColor = #colorLiteral(red: 0.1568627451, green: 0.1529411765, blue: 0.1607843137, alpha: 1)           //hex = 282729
        static let darkBackground: UIColor = #colorLiteral(red: 0.07450980392, green: 0.07450980392, blue: 0.07450980392, alpha: 1) //hex = #131313
        static let lightGray1: UIColor = #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)      //hex = #2a2a2a
        static let lightGray2: UIColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)      //hex = #4d4d4d
        static let lightGray3: UIColor = #colorLiteral(red: 0.5333333333, green: 0.5333333333, blue: 0.5333333333, alpha: 1)      //hex = #888888
        static let lightGray4: UIColor = #colorLiteral(red: 0.6431372549, green: 0.6431372549, blue: 0.6431372549, alpha: 1)      //hex = #a4a4a4
        static let lightGray5: UIColor = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)      //hex = #d8d8d8
        static let lightGray6: UIColor = #colorLiteral(red: 0.9529411765, green: 0.9529411765, blue: 0.9529411765, alpha: 1)      //hex = #f3f3f3
        static let lightGray7: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)      //hex = #ffffff
        static let lightGray8: UIColor = #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)      //hex = #4a4a4a
        
        static let orange1: UIColor = #colorLiteral(red: 0.7490196078, green: 0.2823529412, blue: 0.1607843137, alpha: 1)         //hex = #bf4829
        static let orange2: UIColor = #colorLiteral(red: 0.5568627451, green: 0.1725490196, blue: 0.07450980392, alpha: 1)         //hex = #8e2c13
        static let orange3: UIColor = #colorLiteral(red: 0.4509803922, green: 0.1490196078, blue: 0.07450980392, alpha: 1)         //hex = #732613
        static let yellow1: UIColor = #colorLiteral(red: 0.8352941176, green: 0.5215686275, blue: 0, alpha: 1)         //hex = #d58500
        static let yellow2: UIColor = #colorLiteral(red: 0.9215686275, green: 0.5764705882, blue: 0, alpha: 1)         //hex = #eb9300
        static let yellow3: UIColor = #colorLiteral(red: 0.7058823529, green: 0.3725490196, blue: 0, alpha: 1)         //hex = #b45f00
        static let yellow4: UIColor = #colorLiteral(red: 0.6078431373, green: 0.262745098, blue: 0, alpha: 1)         //hex = #9b4300
        
        static let lightBlue: UIColor = #colorLiteral(red: 0.4039215686, green: 0.4823529412, blue: 0.6980392157, alpha: 1)       //hex = #677bb2
        static let blue: UIColor = #colorLiteral(red: 0.3019607843, green: 0.3803921569, blue: 0.6, alpha: 1)            //hex = #4d6199
        
        static let lightPink: UIColor = #colorLiteral(red: 0.6980392157, green: 0.4039215686, blue: 0.6274509804, alpha: 1)       //hex = #b267a0
        static let pink: UIColor = #colorLiteral(red: 0.6, green: 0.3019607843, blue: 0.5294117647, alpha: 1)            //hex = #994d87
        
        static let violet: UIColor = #colorLiteral(red: 0.3411764706, green: 0.3411764706, blue: 0.4392156863, alpha: 1)          //hex = #575770
        static let darkViolet: UIColor = #colorLiteral(red: 0.2745098039, green: 0.2705882353, blue: 0.3450980392, alpha: 1)      //hex = #464558
        
        static let red: UIColor = #colorLiteral(red: 0.8745098039, green: 0.2196078431, blue: 0.07058823529, alpha: 1)             //hex = #df3812
        static let errorRedColor: UIColor = #colorLiteral(red: 0.7607843137, green: 0.2196078431, blue: 0.07843137255, alpha: 1)   //hex = #c23814
        
        static let logBlockedCellColor: UIColor = #colorLiteral(red: 0.2, green: 0.8745098039, blue: 0.2196078431, alpha: 0.12) //hex = #33df38 alpha: 12
        static let logSelectedCellColor: UIColor = #colorLiteral(red: 0.3019607843, green: 0.8745098039, blue: 0.2196078431, alpha: 0.12) //hex = #4ddf38 alpha: 12
        
    }
}
