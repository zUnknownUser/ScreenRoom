//
//  View+If.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI


extension View {
@ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
if condition { transform(self) } else { self }
}
}
