//
//  Activity.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI
import SwiftUICharts

struct Activity: View {
    @ObservedObject private var bluetoothViewModel = BluetoothViewModel()

    var body: some View {
        VStack{
            LineView(data: bluetoothViewModel.activity_data, title: "Activity Rate", legend: "Today")
                .padding([.bottom, .trailing], 20)
            BarChartView(data: ChartData(points: bluetoothViewModel.activity_data), title: "Weekly")
                .padding([.bottom, .trailing], 20)
        }
        .padding(20)
    }
}

struct Activity_Previews: PreviewProvider {
    static var previews: some View {
        Activity()
    }
}
