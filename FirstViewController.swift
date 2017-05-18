//
//  FirstViewController.swift
//  bartv1
//
//  Created by sriks on 4/30/17.
//  Copyright © 2017 sriks. All rights reserved.
//

import UIKit

struct TrainDetails {
    var time:Int = 0
    var bound:String = ""
    var length:Int = 10
}

class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var destButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var StatusLabel: UILabel!
    var timeEstArray:[String] = []
    var trainDetSortedArray:[TrainDetails] = []
    
    var homeStation:String = ""
    var destStation:String = ""
    var morningTerminal:[String] = []
    var eveningTerminal:[String] = []
    var timeToHomeSt:Int = 5
    var timeToDestSt:Int = 5
    
    @IBOutlet weak var table: UITableView!

    //This is how number of rows on the table view is given.
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (trainDetSortedArray.count == 0) {
            return 1
        }
        if (trainDetSortedArray.count > 4) {
            return 4
        }
        return trainDetSortedArray.count
        //return timeEstArray.count
    }
    
    
    //This is where content of the table
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        if (trainDetSortedArray.count == 0) {
            cell.textLabel?.text = "No direct train available now"
            return cell
        }
        let cVal:TrainDetails = self.trainDetSortedArray[indexPath.row]

        //cell.textLabel?.text = timeEstArray[indexPath.row]
        cell.textLabel?.text = (String(cVal.length) + " car in " + String(cVal.time) + " minutes (" + cVal.bound + ")")
        
        //cell.backgroundColor = UIColor.green
        return cell
    }
    

    func getTime() -> String{
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)

        //print("updated at: \(hour):\(minutes):\(seconds)")
        return("Updated at: \(hour):\(minutes):\(seconds)")
    }
    
    
    //swift 3

    
    @IBAction func morningTrainCheck(_ sender: Any) {
        checkTrainTiming(morning: true)
    }
    
    @IBAction func eveningTrainCheck(_ sender: Any) {
        checkTrainTiming(morning: false)
    }

    //Core logic.
    func checkTrainTiming(morning:Bool) {
        

        var locTrainDetArray:[TrainDetails] = []
        
        var startStationName:String = ""
        var endStationName:String = ""
        var terminals:[String] = []
        
        if (morning) {
            //if morning, we take homeStation as Start Station
            startStationName = self.homeStation
            endStationName = self.destStation
            terminals = self.morningTerminal
        } else {
            //if morning, we take destStation as Start Station
            startStationName = self.destStation
            endStationName = self.homeStation
            terminals = self.eveningTerminal
        }
        //Creating the URL link with start station name
        let urlStr:String = "http://api.bart.gov/api/etd.aspx?cmd=etd&orig=" + startStationName + "&key=ZVZD-PBT8-9G6T-DWE9&json=y"
        let url = URL(string:urlStr)!
        
        StatusLabel.text = "Train to " + endStationName
        timeLabel.text = getTime()
        
        //print(url)
        //this is iOS specific.
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if (error != nil) {
                print("Printing..error..")
                print(error ?? "Error unknown")
            } else {
                if let urlContent = data {
                    do {
                        
                        let jsonResult = try JSONSerialization.jsonObject(with: urlContent, options: JSONSerialization.ReadingOptions.mutableContainers)
                        
                        //Parsing of JSON (not done efficiently but works)
                        let dict1:NSDictionary = (jsonResult as! NSDictionary)["root"] as! NSDictionary
                        let dict2:Any = dict1["station"]!
                        let dict3:NSDictionary = ((dict2 as! NSArray)[0]) as! NSDictionary
                        let dict4:NSArray = dict3["etd"] as! NSArray

                        
                        //Removing Array elements to avoid past information
                        self.timeEstArray.removeAll()
                        
                        var localTrainDet:TrainDetails = TrainDetails()
                        //print(jsonResult)
                        
                        //There can be multiple trains you can take so this is covering
                        //that scenario - not common but found it in few stations at least
                        for locTerminal in terminals {
                            
                            
                            //walking through JSON response
                            for items in dict4 {
                                let curInfo:NSDictionary = items as! NSDictionary
                                let destStr = curInfo["abbreviation"] as! NSString
                                //print("\(destStr) check \(locTerminal)")
                                
                                
                                if (destStr as String == locTerminal) {
                                    
                                    let estArray:NSArray = curInfo["estimate"] as! NSArray
                                    for estItem in estArray {
                                        let est:NSDictionary = estItem as! NSDictionary
                                        var estVal:String = est["minutes"] as! String
                                        let length:String = est["length"] as! String
                                        
                                        //usually this field has number only and that can be 
                                        //converted to Int. But in one case, it says 'leaving'
                                        //then Int() function crashes. So I am setting 0 in that case.

                                        if (estVal == "Leaving") {
                                            estVal = "0"
                                        }
                                        //estimated time - important data
                                        localTrainDet.time = Int(estVal)!
                                        localTrainDet.bound = locTerminal
                                        localTrainDet.length = Int(length)!
                                        locTrainDetArray.append(localTrainDet)
                                
                                    }
                                }
                                
                                
                            }
                            
                        }
                        
                        //Sorting the array
                        self.trainDetSortedArray = locTrainDetArray.sorted {
                            $0.time < $1.time
                        }
                        
                        //This in iOS will call table refresh

                        DispatchQueue.main.async{
                            self.table.reloadData()
                        }
                        if (self.timeEstArray.count == 0) {
                            self.timeEstArray.append("No direct train available now")
                            DispatchQueue.main.async{
                                self.table.reloadData()
                            }
                        }
                        
                        
                    } catch {
                        print ("JSON processing failed")
                    }
                    
                }
            }
            
        }
        
        task.resume()
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        loadConfig()
        //timeBasedStatusCheck()

    }
    
    func loadConfig() {
        var lStr1:String = "5"
        var lStr2:String = "5"
        
        if (UserDefaults.standard.object(forKey: "BartHomeStation")) == nil {
            self.homeStation = "FRMT"
            UserDefaults.standard.set("FRMT", forKey: "BartHomeStation")

        } else {
            self.homeStation = UserDefaults.standard.object(forKey: "BartHomeStation") as! String
        }
        if (UserDefaults.standard.object(forKey: "BartDestStation")) == nil {
            self.destStation = "CIVC"
            UserDefaults.standard.set(self.destStation, forKey: "BartDestStation")
        } else {
            self.destStation = UserDefaults.standard.object(forKey: "BartDestStation") as! String
        }
        if (UserDefaults.standard.object(forKey: "BartTimeToHome")) == nil {
            lStr1 = "5"
            UserDefaults.standard.set(lStr1, forKey: "BartTimeHome")
        } else {
            lStr1 = UserDefaults.standard.object(forKey: "BartTimeToHome") as! String
        }
        if (UserDefaults.standard.object(forKey: "BartTimeToDest")) == nil {
            lStr2 = "5"
            UserDefaults.standard.set(lStr2, forKey: "BartTimeDest")
        } else {
            lStr2 = UserDefaults.standard.object(forKey: "BartTimeToDest") as! String
        }
        
        
        self.timeToHomeSt = Int(lStr1)!
        self.timeToDestSt = Int(lStr2)!
    
        if UserDefaults.standard.object(forKey: "MorningTerminal") == nil {
            self.morningTerminal = ["DALY"]
            UserDefaults.standard.set(self.morningTerminal, forKey: "MorningTerminal")
        } else {
            self.morningTerminal = UserDefaults.standard.object(forKey: "MorningTerminal") as! [String]
        }
        
        if UserDefaults.standard.object(forKey: "EveningTerminal") == nil {
            self.eveningTerminal = ["WARM"]
            UserDefaults.standard.set(self.eveningTerminal, forKey: "EveningTerminal")
        } else {
            self.eveningTerminal = UserDefaults.standard.object(forKey: "EveningTerminal") as! [String]
        }
        //morningTerminal = UserDefaults.standard.object(forKey: "MorningTerminal") as! [String]
        //eveningTerminal = UserDefaults.standard.object(forKey: "EveningTerminal") as! [String]

        homeButton.setTitle("Next trains to " + self.homeStation, for:UIControlState.normal)
        destButton.setTitle("Next trains to " + self.destStation, for:UIControlState.normal)
        
        //print("End term for home")
        //print(morningTerminal)
        //print("End term for dest")
        //print(eveningTerminal)
    }
    
    func timeBasedStatusCheck() {
        let date = Date()
        let calendar = Calendar.current
        
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        if (hour < 12) {
            checkTrainTiming(morning: true)
        } else {
            checkTrainTiming(morning: false)
        }
        
    }

    
    override func viewDidAppear(_ animated: Bool) {
        loadConfig()
        timeBasedStatusCheck()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

