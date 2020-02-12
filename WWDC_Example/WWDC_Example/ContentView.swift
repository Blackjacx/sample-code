//
//  ContentView.swift
//  WWDC_Example
//
//  Created by Stefan Herold on 04.06.19.
//  Copyright © 2019 codingcobra. All rights reserved.
//

import SwiftUI

struct ContentView : View {
    var body: some View {
        Text("Hello World")
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif
