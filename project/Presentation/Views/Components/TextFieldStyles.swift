//
//  TextFieldStyles.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI


struct NeonFieldStyle: TextFieldStyle {
func _body(configuration: TextField<_Label>) -> some View {
configuration
.padding(.horizontal, 16)
.padding(.vertical, 14)
.background(
RoundedRectangle(cornerRadius: 14).strokeBorder(
LinearGradient(colors: [SRColors.neonPink, SRColors.neonBlue], startPoint: .leading, endPoint: .trailing), lineWidth: 1.2
)
)
.foregroundStyle(.white)
}
}
