//
//  PlatformView.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI
import SmartVideoSDK

enum PlatformType {
    case none
    case generic
    case cloud
    case engage
    
    var title: String {
        switch self {
        case .none:
            return ""
        case .cloud:
             return "Genesys"
        case .generic:
             return "Generic"
        case .engage:
             return "Genesys Engage"
        }
    }
}

struct GenesysCloudView: View {
    
    @ObservedObject var viewModel: GenesysCloudViewModel
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Button(action: self.viewModel.back) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.black)
                Spacer()
            }
            .overlay {
                Text(self.viewModel.type.title)
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
            }
            .padding(.bottom, 20)
            .padding(.horizontal, 25)
            
            ScrollView {
                Toggle("Enter custom parameters", isOn: self.$viewModel.customParams)
                    .foregroundColor(.black)
//                Toggle("Connect to production", isOn: self.$viewModel.environmentBool)
//                    .disabled(self.viewModel.customParams)
//                    .padding(.bottom, 20)
                
//                Spacer()
            
                VStack {
                    field(text: self.$viewModel.smartVideoURL,
                          placeholder: "ve_url".l10n(),
                          icon: "link")
                    
                    field(text: self.$viewModel.environmentURL,
                          placeholder: "Environment URL",
                          icon: "link")
                    
                    field(text: self.$viewModel.organizationID,
                          placeholder: "org_id".l10n(),
                          icon: "i.circle")
                    
                    field(text: self.$viewModel.deploymentID,
                          placeholder: "deployment_id".l10n(),
                          icon: "i.circle")
                    
                    field(text: self.$viewModel.queue,
                          placeholder: "genesys_cloud_queue".l10n(),
                          icon: "line.3.horizontal")
                    
                    field(text: self.$viewModel.tenant,
                          placeholder: "tenant_id".l10n(),
                          icon: "i.circle")
                    
                    field(text: self.$viewModel.customerFirstName,
                          placeholder: "first_name".l10n(),
                          icon: "person")
                    field(text: self.$viewModel.customerLastName,
                          placeholder: "last_name".l10n(),
                          icon: "person")
                    
                }
                .padding(.bottom, 20)
                
                Group {
                    Button(action: { self.viewModel.call(isVideo: false) }) {
                        Text("start_audio_button".l10n())
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .AppBackgroundColor))
                    .cornerRadius(10)
                    
                    Button(action: { self.viewModel.call(isVideo: true) }) {
                        Text("start_video_button".l10n())
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .AppBackgroundColor))
                    .cornerRadius(10)
                    
                    Button(action: { self.viewModel.chat() }) {
                        Text("Start Chat")
                            .foregroundColor(.white)
                    }
                    .frame(height: 50)
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: .AppBackgroundColor))
                    .cornerRadius(10)
                }
            }
            .padding(.horizontal, 25)
        }
        .background(Color.white)
        .overlay {
            if self.viewModel.showLoading {
                ZStack {
                    Color.white.opacity(0.5)
                        .blur(radius: 1)
                    ProgressView()
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear(perform: self.viewModel.readParameters)
        .onChange(of: self.viewModel.environment) { _ in
            self.viewModel.readParameters()
        }
    }
    
    func field(text: Binding<String>, placeholder: String, icon: String) -> some View {
        TextField(placeholder, text: text)
            .font(.system(size: 14))
            .foregroundColor(self.viewModel.customParams ? .black : .gray)
            .frame(height: 40)
            .padding(.leading, 40)
            .padding(.trailing, 10)
            .disabled(!self.viewModel.customParams)
            .overlay(alignment: .leading) {
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .offset(x: 5, y: 0)
                    .foregroundColor(.gray)
            }
            .overlay(RoundedRectangle(cornerRadius: 10)
                .stroke(Color(uiColor: .AppBackgroundColor)))
    }
}

struct GenesysCloudView_Previews: PreviewProvider {
    static var previews: some View {
        GenesysCloudView(viewModel: GenesysCloudViewModel(type: .constant(.cloud)))
    }
}
