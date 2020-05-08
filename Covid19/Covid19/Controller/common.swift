//
//  common.swift
//  Covid19
//
//  Created by msuzuki on 5/7/20.
//  Copyright © 2020 msuzuki. All rights reserved.
//

import Foundation

class Common {
    static func formatNum(_ num: Int) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        numberFormatter.groupingSeparator = ","
        let formattedNumber = numberFormatter.string(from: NSNumber(value: num))
        return formattedNumber!
    }
    
}
