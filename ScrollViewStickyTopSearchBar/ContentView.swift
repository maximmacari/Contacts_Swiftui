//
//  ContentView.swift
//  ScrollViewStickyTopSearchBar
//
//  Created by Maxim Macari on 19/3/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        Home()
            .environmentObject(JSONService())
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
