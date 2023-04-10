//
//  HeartRate.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI
import SwiftUICharts

struct HeartRate: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()
    var body: some View {
        VStack{
            LineView(data: bluetoothViewModel.heart_data, title: "Heart Rate", legend: "Today")
                .padding([.bottom, .trailing], 20)
            BarChartView(data: ChartData(points: bluetoothViewModel.heart_data), title: "Weekly")
                .padding([.bottom, .trailing], 20)
            
        }
        .padding(20)
    }
}

struct HeartRate_Previews: PreviewProvider {
    static var previews: some View {
        HeartRate()
    }
}
