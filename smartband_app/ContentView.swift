//
//  ContentView.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            PersonalData()
                .tabItem(){
                    Image(systemName: "house")
                    Text("Home")
                }
            HeartRate()
                .tabItem(){
                    Image(systemName: "heart")
                    Text("Heart Rate")
                }
            Activity()
                .tabItem(){
                    Image(systemName: "figure.run")
                    Text("Activity")
                }
            Respiration()
                .tabItem(){
                    Image(systemName: "lungs")
                    Text("Respiration")
                }
            BloodPressure()
                .tabItem(){
                    Image(systemName: "drop")
                    Text("Blood Pressure")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
