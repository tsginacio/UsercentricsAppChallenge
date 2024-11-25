//
//  ContentView.swift
//  UserCentricsStudyCase
//
//  Created by Tiago Inácio on 25/11/2024.
//

import SwiftUI
import Usercentrics

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack(spacing: 20 ) {
            if viewModel.loading {
                ProgressView()
            }else{
                if let totalCost = viewModel.totalCost {
                    VStack{
                        Text("\(totalCost, specifier: "%.2f")")
                            .font(.system(size: 100.0))
                            .bold(true)
                        Text("Consent Score")
                            .font(.headline)
                    }.frame(maxHeight: .infinity, alignment: .bottom)
                    
                }
                Button(action: viewModel.showConsentBanner) {
                    if viewModel.alreadyCollectConsent {
                        Text("Review Consent Banner")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }else{
                        Text("Show Consent Banner")
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                }.frame(maxHeight: .infinity, alignment: .bottom)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
