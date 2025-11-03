//
//  PrimaryButton.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI


struct PrimaryButton: View {
let title: String
let action: () -> Void
var disabled: Bool = false


var body: some View {
Button(action: action) {
Text(title)
.font(.headline)
.frame(maxWidth: .infinity)
.padding()
.background(LinearGradient(colors: [SRColors.neonPink, SRColors.neonBlue], startPoint: .leading, endPoint: .trailing))
.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
.foregroundColor(.white)
.shadow(color: SRColors.neonBlue.opacity(0.4), radius: 12, x: 0, y: 6)
}
.disabled(disabled)
.opacity(disabled ? 0.6 : 1)
}
}
