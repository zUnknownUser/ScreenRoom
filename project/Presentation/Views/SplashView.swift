//
//  SplashView.swift
//  project
//
//  Created by user279102 on 11/3/25.
//

import SwiftUI


struct SplashView: View {
var body: some View {
ZStack {
SRColors.bgDark.ignoresSafeArea()
VStack(spacing: 32) {
Image("ScreenroomSplash") // coloque sua arte (1920x1080 de preferência)
.resizable()
.scaledToFit()
.shadow(radius: 20)
Text("Screenroom")
.font(.system(size: 44, weight: .heavy, design: .rounded))
.foregroundStyle(LinearGradient(colors: [SRColors.neonPink, SRColors.neonBlue], startPoint: .leading, endPoint: .trailing))
}
.padding(32)
}
}
}
