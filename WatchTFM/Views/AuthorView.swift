//
//  SettingsView.swift
//  WatchTFM
//
//  Created by Noe Vila Muñoz on 25/5/23.
//

import SwiftUI

struct AuthorView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Desarrollador App")
                    .font(.title)
                    .fontWeight(.bold)
                
                Image("developer_profile_image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay(RoundedRectangle(cornerRadius: 20).stroke(Color.gray, lineWidth: 3))
                
                Text("Noé Vila Muñoz")
                    .font(.headline)
                
                Text("Estudiante del Máster Universitario en Ingeniería Informática")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Link("LinkedIn", destination: URL(string: "https://www.linkedin.com/in/noe-vila-munoz/")!)
                
                Text("noe.vila@udc.es")
                    .font(.subheadline)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            
            Divider()
            
            VStack {
                Text("Pictogramas")
                    .font(.title)
                    .fontWeight(.bold)
                
                Image("logo_ARASAAC")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                
                Text("Los símbolos pictográficos utilizados son propiedad del Gobierno de Aragón y han sido creados por Sergio Palao para ARASAAC.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                
                Text("Autor pictogramas: Sergio Palao. Origen: ARASAAC (http://www.arasaac.org). Licencia: CC (BY-NC-SA). Propiedad: Gobierno de Aragón (España)")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
        }
        .padding()
    }
}
