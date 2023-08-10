//
//  PrefrenceKeys.swift
//  Auth_SwiftUi
//
//  Created by Milad Khalighi on 2023-07-31.
//

import SwiftUI

struct scrollPref: PreferenceKey {
    static var defaultValue: CGFloat = 0.0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        defaultValue = nextValue()
    }
}


