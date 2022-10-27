//
//  GenericView.swift
//  DemoPureCloud
//
//  Created by Slav Sarafski on 15.08.22.
//

import SwiftUI

struct GenericView: View {
    
    @ObservedObject var viewModel: GenericViewModel
    
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
            
            Spacer()
            
            Group {
                field(text: self.$viewModel.smartVideoURL,
                      placeholder: "ve_url".l10n(),
                      icon: "link")
                .disabled(true)
                
                field(text: self.$viewModel.shortUrl,
                      placeholder: "Short URL",
                      icon: "link")
                
            }
            
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
            }
            .padding(.bottom, 20)
            
            Group {
                field(text: self.$viewModel.invitationUrl,
                      placeholder: "Invitation URL",
                      icon: "link")
                
                Button(action: { self.viewModel.invitationCall() }) {
                    Text("Invitation Call")
                        .foregroundColor(.white)
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .background(Color(uiColor: .AppBackgroundColor))
                .cornerRadius(10)
            }
            Spacer()
            
            
        }
        .padding(.horizontal, 25)
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
    }
    
    func field(text: Binding<String>, placeholder: String, icon: String) -> some View {
        TextField(placeholder, text: text)
            .font(.system(size: 14))
            .frame(height: 40)
            .padding(.leading, 40)
            .padding(.trailing, 10)
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
