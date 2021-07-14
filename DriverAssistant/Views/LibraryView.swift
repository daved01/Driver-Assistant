//
//  LibraryView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-06-06.
//

import SwiftUI

class LibraryViewViewHostingController: UIHostingController<LibraryView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: LibraryView())
    }
}

struct LibraryView: View {
    
    var body: some View {
        List {
            Text("Element 1")
            Text("Element 2")
            Text("Element 3")
        }
        .navigationBarTitle("Library")
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
    }
}

