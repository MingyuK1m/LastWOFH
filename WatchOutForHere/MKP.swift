
import UIKit
import MapKit

class MKP: UIViewController, MKMapViewDelegate{
    
    @IBOutlet weak var map: MKMapView!
    
    //segue 에서 받아오기 위한 변수들을 선언한다
    var tit = ""
    var lat : Double = 0.0
    var long : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = CLLocationCoordinate2DMake(long, lat)
        
        let span = MKCoordinateSpanMake(0.04, 0.04)
        let region = MKCoordinateRegionMake(center, span)
        
        map.setRegion(region, animated: true)
       
        let anno = MKPointAnnotation()
        anno.coordinate = center
        anno.title = tit
        
        map.addAnnotation(anno)
        
        
        //델리게이트 연결
        map.delegate = self
        
    }
    
    
    //pin 딜리게이트
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        
        //pin의 재활용
        
        
        let iden = "mypin"
        var anno = map.dequeueReusableAnnotationView(withIdentifier: iden) as? MKPinAnnotationView
        
        
        if anno == nil { //처음이면 실행
            
            
            anno = MKPinAnnotationView(annotation: annotation, reuseIdentifier: iden)
            
            
            anno?.canShowCallout = true
            
            anno?.animatesDrop = true
            
            
        } else {
            // 제활용
            anno?.annotation = annotation
        }
        return anno
    }
    
    
}
