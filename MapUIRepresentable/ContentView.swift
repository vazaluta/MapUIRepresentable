//
//  ContentView.swift
//  MapUIRepresentable
//
//  Created by Sawada Masato on 2023/12/18.
//
//
//  ContentView.swift
//  Directions
//

import MapKit
import SwiftUI
import UIKit

struct ContentView: View {
    
//    @State private var directions: [String] = []
//    @State private var showDirections = false
    
    var body: some View {
        VStack {
//            MapView(directions: $directions)
            MapView()
            
//            Button(action: {
//                self.showDirections.toggle()
//            }, label: {
//                Text("Show directions")
//            })
//            .disabled(directions.isEmpty)
//            .padding()
        } // .sheet(isPresented: $showDirections, content: {
//            VStack(spacing: 0) {
//                Text("Directions")
//                    .font(.largeTitle)
//                    .bold()
//                    .padding()
//                
//                Divider().background(Color(UIColor.systemBlue))
//                
//                List(0..<self.directions.count, id: \.self) { i in
//                    Text(self.directions[i]).padding()
//                }
//            }
//        })
    }
}

struct MapView: UIViewRepresentable {
    
    typealias UIViewType = MKMapView
    
//    @Binding var directions: [String]
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 40.71, longitude: -74),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        mapView.setRegion(region, animated: true)
        
        //　小茂根
        let p1 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.745047, longitude: 139.676))
        // 横浜
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 35.44564, longitude: 139.5432))
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: p1)
        request.destination = MKMapItem(placemark: p2)
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            // ピンを追加する
            mapView.addAnnotations([p1, p2])
            // ルートを重ねる
            mapView.addOverlay(route.polyline)
            // マップの表示範囲を設定
            mapView.setVisibleMapRect(
                route.polyline.boundingMapRect,
                edgePadding: UIEdgeInsets(top: 50,
                                          left: 50,
                                          bottom: 50,
                                          right: 50),
                animated: true
            )
//            self.directions = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 5
            return renderer
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#Preview {
    ContentView()
}
