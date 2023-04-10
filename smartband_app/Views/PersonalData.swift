//
//  PersonalData.swift
//  smartband_app
//
//  Created by Lesa DiVincenzo on 2023-01-22.
//

import SwiftUI
import UIKit
import iPhoneNumberField
import MessageUI
import Foundation
import CallKit
import Intents

struct PersonalData: View {
    
    @State var first_name = ""
    @State var last_name = ""
    @State private var birthdate = Date()
    @State private var selected_sex = 0
    @State private var sexes = ["Male","Female"]
    @State private var height = 0
    @State private var weight = 0
    @State private var ec_one = ""
    @State var ec_one_num = ""
    @State private var ec_two = ""
    @State var ec_two_num = ""
    @State var change_profile_image = false
    @State var open_camera_roll = false
    @State var image_selected = UIImage()


    func call_emergency_services() {
        if let url = URL(string: "tel://9059238079"), UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url)
        }
    }

    func text_emergency_contacts(phone_number : String){
        let url = "sms://" + phone_number + "&body=EMERGENCY ALERT:\n\(first_name) \(last_name)'s vitals are below an acceptable level and is in need of medical assistance immediately. 911 has been contacted.\n You have been set as an emergency contact."

        let str_url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        UIApplication.shared.open(URL(string: str_url)!, options: [:], completionHandler: nil)
    }
    
    
    var body: some View {
        NavigationView{
            VStack{
                ZStack{
                    Button(action:{
                        change_profile_image = true
                        open_camera_roll = true
                    },label:{
                        if change_profile_image {
                            HStack{
                                Text("Welcome \(first_name)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(uiImage: image_selected)
                                    .resizable()
                                    .frame(width:65, height:65)
                                .clipShape(Circle())}.padding(.all, 30)
                        } else{
                            HStack{
                                Text("Welcome \(first_name)")
                                    .font(.largeTitle)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)
                                Spacer()
                                ZStack(alignment: .bottomTrailing){
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width:65, height:65)
                                    .clipShape(Circle())
                                    .foregroundColor(Color.gray)
                                Image(systemName: "plus")
                                    .frame(width:25, height:25)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                .clipShape(Circle())}
                            }.padding(.all, 30)}
                    })

                }.sheet(isPresented: $open_camera_roll){
                    ImagePicker(selected_image: $image_selected, source_type: .photoLibrary)
                }
                
                Form{
                    Section(header: Text("Personal Data")){
                        TextField("First Name", text: $first_name)
                        TextField("Last Name", text: $last_name)
                        DatePicker("Date of Birth", selection: $birthdate, displayedComponents: .date)
                    }
                    Section(header: Text("Health Data")){
                        Picker("Sex", selection: $selected_sex){
                            ForEach(0 ..< 2){
                                Text(self.sexes[$0])
                            }
                        }
                        Picker("Height", selection: $height){
                            ForEach(0 ..< 275){
                                Text("\($0) cm")
                            }
                        }
                        Picker("Weight", selection: $weight){
                            ForEach(0 ..< 1000){
                                Text("\($0) lbs")
                            }
                        }
                    }
                    Section(header: Text("Emergency Contact One")){
                        TextField("Full Name", text: $ec_one)
                        TextField("Primary Phone Number", text: $ec_one_num)
                        Button(action:{
                            text_emergency_contacts(phone_number: ec_one_num)
                            
                        }, label: {
                            Text("Send Alert")
                                .foregroundColor(.red)
                        })
                    }
                    Section(header: Text("Emergency Contact Two")){
                        TextField("Full Name", text: $ec_two)
                        TextField("Primary Phone Number", text: $ec_two_num)
                        Button(action:{
                            text_emergency_contacts(phone_number: ec_two_num)
                            
                        }, label: {
                            Text("Send Alert")
                                .foregroundColor(.red)
                        })
                    }
                    Section(header: Text("Emergency Services")){
                        Button(action:{
                            call_emergency_services()
                            
                        }, label: {
                            Text("Call EMS")
                                .foregroundColor(.red)
                        })
                    }
                }
            }
        }
    }
}

struct PersonalData_Previews: PreviewProvider {
    static var previews: some View {
        PersonalData()
    }
}
