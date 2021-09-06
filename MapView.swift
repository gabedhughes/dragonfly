//
//  MapView.swift
//  Dragonfly for ACL
//
//  Created by Gabe Hughes on 10/1/19.
//  Copyright © 2019 Gabe Hughes. All rights reserved.
//

import SwiftUI
import UIKit
import MapKit
import CoreGraphics

struct MapView: UIViewRepresentable {
    var park = Park()
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var control: MapView
        
        init(_ control: MapView) {
            self.control = control
        }
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let latDelta = park.overlayTopLeftCoordinate.latitude - park.overlayBottomRightCoordinate.latitude
        let span = MKCoordinateSpan(latitudeDelta: fabs(latDelta), longitudeDelta: 0.0)
        let region = MKCoordinateRegion(center: park.midCoordinate, span: span)
        let overlay = ParkMapOverlay(park: park)
        
        uiView.setRegion(region, animated: true)
        uiView.addOverlay(overlay)
    }
}

class Park {
    var boundary: [CLLocationCoordinate2D] = []
    
    var midCoordinate = CLLocationCoordinate2DMake(30.266557, -97.769386)
    var overlayTopLeftCoordinate = CLLocationCoordinate2DMake(30.264436, -97.771550)
    var overlayTopRightCoordinate = CLLocationCoordinate2DMake(30.264436, -97.761411)
    var overlayBottomLeftCoordinate = CLLocationCoordinate2DMake(30.269611, -97.771549)
    var overlayBottomRightCoordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(overlayBottomLeftCoordinate.latitude, overlayTopRightCoordinate.longitude)
        }
    }
    
    var overlayBoundingMapRect: MKMapRect {
        get {
            let topLeft = MKMapPoint.init(overlayTopLeftCoordinate)
            let topRight = MKMapPoint.init(overlayTopRightCoordinate)
            let bottomLeft = MKMapPoint.init(overlayBottomLeftCoordinate)
            
            return MKMapRect.init(
                x: topLeft.x,
                y: topLeft.y,
                width: fabs(topLeft.x - topRight.x),
                height: fabs(topLeft.y - bottomLeft.y))
        }
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is ParkMapOverlay {
            return ParkMapOverlayView(overlay: overlay, overlayImage: #imageLiteral(resourceName: "overlay_park"))
        }
        
        return MKOverlayRenderer()
    }
}

class ParkMapOverlay: NSObject, MKOverlay {
    var coordinate: CLLocationCoordinate2D
    var boundingMapRect: MKMapRect
    
    init(park: Park) {
        boundingMapRect = park.overlayBoundingMapRect
        coordinate = park.midCoordinate
    }
}

class ParkMapOverlayView: MKOverlayRenderer {
    var overlayImage: UIImage
    
    init(overlay:MKOverlay, overlayImage:UIImage) {
        self.overlayImage = overlayImage
        super.init(overlay: overlay)
    }
    
    override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {
        guard let imageReference = overlayImage.cgImage else { return }
        
        let rect = self.rect(for: overlay.boundingMapRect)
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -rect.size.height)
        context.draw(imageReference, in: rect)
    }
}
