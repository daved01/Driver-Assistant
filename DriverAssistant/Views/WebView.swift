//
//  WebView.swift
//  DriverAssistant
//
//  Created by David Kirchhoff on 2021-07-15.
//


import SwiftUI


struct WebView: View {
    @ObservedObject var webViewModel = WebViewModel(url: Constants.urlObjectDetection)

        var body: some View {
                ZStack {
                    WebViewContainer(webViewModel: webViewModel)
                    if webViewModel.isLoading {
                        //Spinner()
                        //    .frame(height: 30)
                        Text("Loading...")
                    }
                }
                .ignoresSafeArea()
                .navigationBarTitle(Text(webViewModel.title), displayMode: .inline)
                .navigationBarItems(leading: Button(action: {
                    webViewModel.shouldGoBack.toggle()
                }, label: {
                    if webViewModel.canGoBack {
                        Image(systemName: "arrow.left")
                            .frame(width: 44, height: 44, alignment: .center)
                            .foregroundColor(.black)
                    } else {
                        EmptyView()
                            .frame(width: 0, height: 0, alignment: .center)
                    }
                })
                )
        }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        WebView()
    }
}

