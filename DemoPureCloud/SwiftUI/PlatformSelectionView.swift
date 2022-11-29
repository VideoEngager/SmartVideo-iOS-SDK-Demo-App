//
//  PlatformSelectionView.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI
import AVFoundation
import SmartVideoSDK

struct PlatformSelectionView: View {
    
    @State var platformType = PlatformType.none
    
    var body: some View {
        ZStack {
            VStack(spacing: 100) {
                
                Spacer()
                Button(action: { self.show(type: .generic) } ) {
                    Image("generic")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100, alignment: .center)
                }
                Button(action: { self.show(type: .cloud) } ) {
                    Image("genesys-cloud")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100, alignment: .center)
                }
                Button(action: { self.show(type: .engage) } ) {
                    Image("genesys-engage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200, height: 100, alignment: .center)
                }
                
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                            Text("app_version".l10n() + " " + appVersion)
                        }
                        Text("sdk_version".l10n() + " " + SmartVideo.version)
                    }
                    .font(.system(size: 14))
                    .foregroundColor(Color(uiColor: .AppBackgroundColor))
                }
                .padding(.bottom, 100)
                .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
            
            switch self.platformType {
            case .none:
                EmptyView()
                
            case .generic:
                GenericView(viewModel: GenericViewModel(type: self.$platformType))
                    .transition(.slide)
                    .zIndex(1)
                
            case .cloud:
                GenesysCloudView(viewModel: GenesysCloudViewModel(type: self.$platformType))
                    .transition(.slide)
                    .zIndex(1)
                
            case .engage:
                GenesysEngageView(viewModel: GenesysEngageViewModel(type: self.$platformType))
            }
        }
        .preferredColorScheme(.light)
        .onAppear {
            AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                        // Handle granted
                    })
            
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                    if response {
                        //access granted
                    } else {

                    }
                }
        }
    }
    
    func show(type: PlatformType) {
        withAnimation {
            self.platformType = type
        }
    }
}

struct PlatformSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        PlatformSelectionView()
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in APIs instead")
extension View {
    func background<T: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> T
    ) -> some View {
        background(Group(content: content), alignment: alignment)
    }

    func overlay<T: View>(
        alignment: Alignment = .center,
        @ViewBuilder content: () -> T
    ) -> some View {
        overlay(Group(content: content), alignment: alignment)
    }
}

@available(iOS, deprecated: 15.0, message: "Use the built-in APIs instead")
extension Color {
    init(uiColor: UIColor) {
        self.init(uiColor)
    }
}
