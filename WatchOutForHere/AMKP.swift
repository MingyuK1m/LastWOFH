//
//  AMKP.swift
//  WatchOutForHere
//
//  Created by D7702_10 on 2017. 11. 6..
//  Copyright © 2017년 DoubleK. All rights reserved.
//

import UIKit
import MapKit

class AMKP: UIViewController, XMLParserDelegate, MKMapViewDelegate {

    var strXMLData: String = ""
    var item:[String:String] = [:]
    var elements:[[String:String]] = []
    var currentElement = ""
    
    @IBOutlet weak var map: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let path = Bundle.main.url(forResource: "busan", withExtension: "xml") {
            
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                
                if parser.parse() {
                    print("parsing success!")
                    
                } else {
                    print("parsing failed!!")
                }
            }
        } else {
            print("xml file not found!!")
        }
        
        all()
    }

    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        
        currentElement = elementName
        
        if elementName == "frequentzone" {
            item = [:]
        } else if elementName == "searchResult" {
            elements = []
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        let data = string.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        if !data.isEmpty {
            item[currentElement] = data
            strXMLData = strXMLData + "\n\n" + item[currentElement]!
            
        }
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "frequentzone" {
            elements.append(item)
        }
        
    }
    
    
    func all(){
        for i in elements{
            let itme = i
            
            let tit = itme["spotname"]
            let lat = Double(itme["x_crd"]! as String)
            let long = Double(itme["y_crd"]! as String)
            let shows = CLLocationCoordinate2DMake(long!,lat!)
            
            let span = MKCoordinateSpanMake(0.25, 0.25)
            let region = MKCoordinateRegionMake(shows, span)
            
            map.setRegion(region, animated: true)
            
            let anno = MKPointAnnotation()
            anno.coordinate = shows
            anno.title = tit
            
            map.addAnnotation(anno)
            
            //델리게이트 연결
            map.delegate = self
        }
    }
}
