//
//  BloodPressure.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI
import SwiftUICharts
struct BloodPressure: View {
    var body: some View {
        VStack{
            LineView(data: [85,83,84,85,84,82,81,83,85], title: "Blood Pressure", legend: "Today")
                .padding([.bottom, .trailing], 20)
            BarChartView(data: ChartData(points: [80,83,94,82,82,87,87]), title: "Weekly")
                .padding(20)
            
        }    }
}

struct BloodPressure_Previews: PreviewProvider {
    static var previews: some View {
        BloodPressure()
    }
}
