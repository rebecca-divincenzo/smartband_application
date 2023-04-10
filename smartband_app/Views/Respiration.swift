//
//  Respiration.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI
import SwiftUICharts
struct Respiration: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View {
        VStack{
            LineView(data: bluetoothViewModel.oxygen_data, title: "Respiration Rate", legend: "Today")
                .padding([.bottom, .trailing], 20)
            BarChartView(data: ChartData(points: bluetoothViewModel.oxygen_data), title: "Weekly")
                .padding([.bottom, .trailing], 20)
            
        }
        .padding(20)
    }
}

struct Respiration_Previews: PreviewProvider {
    static var previews: some View {
        Respiration()
    }
}
