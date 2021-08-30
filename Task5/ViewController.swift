//
//  ViewController.swift
//  Task5
//
//  Created by neoviso on 8/26/21.
//

import UIKit
import Alamofire

class CountryModel {
    var image: UIImage?
    var countryName: String
    
    init() {
        image = UIImage(systemName: "flag")
        countryName = ""
    }
    
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var countriesList: [CountryModel] = [CountryModel]()
    //let searchUrl =  "https://en.wikipedia.org/w/api.php?action=query&format=json&prop=pageimages&indexpageids&titles="
    let searchUrlStart = "https://www.countryflags.io/"
    let searchUrlEnd = "/flat/24.png"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib(nibName: "CountryCell", bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: "countryCell")
        
        for localeCode in NSLocale.isoCountryCodes {
            let countryNameTemp = getCountryName(countryCode: localeCode)
            //let stringUrl = searchUrl + countryNameTemp.replacingOccurrences(of: " ", with: "_")
            let stringUrl = searchUrlStart + localeCode + searchUrlEnd
            
            let countryTemp = CountryModel()
            countryTemp.countryName = countryNameTemp
            AF.request(stringUrl).response { response in
                switch response.result {
                case .success(let value):
                    countryTemp.image = UIImage(data: value ?? NSData() as Data, scale: 1)
                    self.countriesList.append(countryTemp)
                    self.countriesList.sort(by: { $0.countryName < $1.countryName })
                    self.tableView?.reloadData()
                case .failure(let error):
                    print(error)
                }
            }
            
            /*
            AF.request(stringUrl).responseJSON { response in
             switch response.result {
             case .success(let value):
                 if let resp = value as? [String: Any] {
                     let queryData = resp["query"] as? [String: Any]
                     let pagesData = queryData?["pages"] as? [String: Any]
                     let pageId = pagesData?.keys.first
                     let countryData = pagesData?[pageId!] as? [String: Any]
                     let sourceData = countryData?["thumbnail"] as? [String: Any]
                     let source = (sourceData?["source"] ?? "") as! String
                     let countryTemp = CountryModel()
                     countryTemp.countryName = countryNameTemp
                     countryTemp.imageUrl = source
                     self.countriesList.append(countryTemp)
                     self.countriesList.sort(by: { $0.countryName < $1.countryName })
                     self.tableView?.reloadData()
                 }
             case .failure(let error):
                 print(error)
             }
             */
            //countriesFlagsUrl.append(takeImageUrl(countryUrl: stringUrl))
        }
        self.countriesList.sort(by: { $0.countryName < $1.countryName })
        tableView.reloadData()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func getCountryName(countryCode: String) -> String {
        let current = NSLocale.current as NSLocale
        let countryName = current.displayName(forKey: NSLocale.Key.countryCode, value: countryCode)!
        return countryName
    }
    /*
    func getCountryFlag (countryCode: String) -> String {
        return String(String.UnicodeScalarView(
            countryCode.unicodeScalars.compactMap(
                {   UnicodeScalar(127397 + $0.value)    })))
    }
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countriesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryCell
        
        let countryTemp = countriesList[indexPath.row]
        cell.countryNameLabel.text = countryTemp.countryName
        
        if (countryTemp.image != nil) {
            cell.countryFlagImageView.image = countryTemp.image
        }
        else {
            cell.countryFlagImageView.image = UIImage(systemName: "flag")
        }
        /*
        if (countryTemp.imageUrl != ""){
            //if countryTemp.imageUrl.contains("Flag") {
                let url = URL(string: countryTemp.imageUrl)!
                if let data = try? Data(contentsOf: url) {
                    cell.countryFlagImageView.image = UIImage(data: data)
                }
            //}
        }
        */
        //cell.countryFlagLabel.text = getCountryFlag(countryCode: countriesCodes[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showCountryInfo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CountryInfoViewController {
            let countryTemp = countriesList[(tableView.indexPathForSelectedRow?.row)!]
            destination.countryName = countryTemp.countryName
            tableView.deselectRow(at: tableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
}
