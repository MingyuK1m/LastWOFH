
import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var strXMLData: String = ""
    var item:[String:String] = [:]
    var elements:[[String:String]] = []
    var currentElement = ""
    @IBOutlet weak var mytable: UITableView!
    
    //JDth = 사상자 (주니어 Death)
    //Dth = 사망자 (Death)
    //MDth = 중상자 (Medium)
    //LDth = 경상자 (Light)
    //EA = 발생건수
    //Crash = 사고가난곳
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "보행자 교통사고"
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
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("failure error: ", parseError)
        
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return elements.count
        
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let myCell: CIA = mytable.dequeueReusableCell(withIdentifier:"myCell",for: indexPath) as! CIA
        
        let itme = elements[indexPath.row]
        
        
        myCell.Crash?.text = itme["spotname"]
        myCell.JDth?.text = "사상자 수 : " + itme["dthinj_co"]!
        myCell.EA?.text = "발생건 수 : " + itme["occrrnc_co"]!
        myCell.Dth?.text = "사망자 수 : " + itme["death_co"]!
        myCell.MDth?.text = "중상자 수 : " + itme["serinj_co"]!
        myCell.LDth?.text = "경상자 수 : " + itme["ordnr_co"]!
        
        return myCell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        //del이라는 식별자를 찾아서 알맞게 보낸다
        if segue.identifier == "del2"{
            let detailVC = segue.destination as! MKP
            let selectedPath = mytable.indexPathForSelectedRow
            
            let itme = elements[(selectedPath?.row)!]
            
            //테이블에서 선택된 데이터를 찾아 del에 넣어 보낸다
            let title = itme["spotname"]! as String
            let lat = Double(itme["x_crd"]! as String)
            let long = Double(itme["y_crd"]! as String)
            
            detailVC.tit = title
            detailVC.lat = lat!
            detailVC.long = long!
        }
        
    }
}
