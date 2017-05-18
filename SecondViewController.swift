//
//  SecondViewController.swift
//  bartv1
//
//  Created by sriks on 4/30/17.
//  Copyright © 2017 sriks. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var homeStationLabel: UILabel!
    @IBOutlet weak var destStationLabel: UILabel!
    public var homeStation:String = ""
    public var destStation:String = ""
    var timeEstArray:NSMutableArray = []
    
    
    var stationList = ["12TH", "16TH", "19TH", "24TH", "ASHB", "BALB", "BAYF", "CAST", "CIVC", "COLS", "COLM", "CONC", "DALY", "DBRK", "DUBL", "DELN", "PLZA", "EMBR", "FRMT", "FTVL", "GLEN", "HAYW", "LAFY", "LAKE", "MCAR", "MLBR", "MONT", "NBRK", "NCON", "OAKL", "ORIN", "PITT", "PHIL", "POWL", "RICH", "ROCK", "SBRN", "SFIA", "SANL", "SHAY", "SSAN", "UCTY", "WCRK", "WDUB", "WOAK", "WARM"]
    
    var timeList = ["5", "10", "15", "20"]
    
    
    var routesList:[[String]] = [
        ["PITT", "NCON", "CONC", "PHIL", "WCRK", "LAFY", "ORIN", "ROCK", "MCAR", "19TH", "12TH", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY", "COLM", "SSAN", "SBRN", "SFIA", "MLBR"],
        ["MLBR", "SFIA", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ROCK", "ORIN", "LAFY", "WCRK", "PHIL", "CONC", "NCON", "PITT"],
        ["WARM", "FRMT", "UCTY", "SHAY", "HAYW", "BAYF", "SANL", "COLS", "FTVL", "LAKE", "12TH", "19TH", "MCAR", "ASHB", "DBRK", "NBRK", "PLZA", "DELN", "RICH"],
        ["RICH", "DELN", "PLZA", "NBRK", "DBRK", "ASHB", "MCAR", "19TH", "12TH", "LAKE", "FTVL", "COLS", "SANL", "BAYF", "HAYW", "SHAY", "UCTY", "FRMT", "WARM"],
        ["WARM", "FRMT", "UCTY", "SHAY", "HAYW", "BAYF", "SANL", "COLS", "FTVL", "LAKE", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY"],
        ["DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "LAKE", "FTVL", "COLS", "SANL", "BAYF", "HAYW", "SHAY", "UCTY", "FRMT", "WARM"],
        ["RICH", "DELN", "PLZA", "NBRK", "DBRK", "ASHB", "MCAR", "19TH", "12TH", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY", "COLM", "SSAN", "SBRN", "MLBR"],
        ["MLBR", "SBRN", "SSAN", "COLM", "DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "12TH", "19TH", "MCAR", "ASHB", "DBRK", "NBRK", "PLZA", "DELN", "RICH"],
        ["DUBL", "WDUB", "CAST", "BAYF", "SANL", "COLS", "FTVL", "LAKE", "WOAK", "EMBR", "MONT", "POWL", "CIVC", "16TH", "24TH", "GLEN", "BALB", "DALY"],
        ["DALY", "BALB", "GLEN", "24TH", "16TH", "CIVC", "POWL", "MONT", "EMBR", "WOAK", "LAKE", "FTVL", "COLS", "SANL", "BAYF", "CAST", "WDUB", "DUBL"]
    ]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    @IBOutlet weak var pickerViewD: UIPickerView!
    
    @IBOutlet weak var pickerViewT1: UIPickerView!
    
    @IBOutlet weak var pickerViewT2: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if (pickerView.tag < 3) {
            return stationList.count
        } else {
            return timeList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if (pickerView.tag < 3) {
            return stationList[row]
        } else {
            return timeList[row]
        }
        
    }

    func findTerminal(homeS:String, destS:String) -> [String] {
        //let destS:String = (UserDefaults.standard.object(forKey: "BartDestStation") as! String)
        var destFoundAfterHome:Bool = false
        var homeFound:Bool = false
        var last:String = "Not known"
        var i:Int = 0
        var retStr:[String] = []
        //print("input station \(homeS) dest Station \(destS)")
        
        retStr.removeAll()
        //print("retStr count: \(retStr.count)")
        for items in routesList {
            
            homeFound = false
            let routeInfo:[String] = items
            //print("Route search \(i)")
            destFoundAfterHome = false
            for st in routeInfo {
                //print("St \(st) - HomeS \(homeS) - DestS \(destS)")
                if (st == destS) {
                    if (homeFound) {
                        //print("Dest found after home \(st)")
                        destFoundAfterHome = true
                    }
                }
                if (st == homeS) {
                    //print("Home found \(homeS)")
                    homeFound = true
                }
                last = st
            }
            if (destFoundAfterHome) {
                //print(" Appending retStr \(last)")
                if (retStr.count == 0 && !retStr.contains(last)) {
                    retStr.append(last)
                }
                destFoundAfterHome = false
            }
            i = i + 1
        }
        //print("homeFound: \(homeFound)")
        return retStr
    }
    func findTerminals() {
        let destStation = (UserDefaults.standard.object(forKey: "BartDestStation") as! String)
        let homeStation = (UserDefaults.standard.object(forKey: "BartHomeStation") as! String)
        
        
        //let eveningTerminal:[String] = findTerminal(homeS: homeStation, destS: destStation)
        //let morningTerminal:[String] = findTerminal(homeS: destStation, destS: homeStation)
        let morningTerminal:[String] = findTerminal(homeS: homeStation, destS: destStation)
        let eveningTerminal:[String] = findTerminal(homeS: destStation, destS: homeStation)

        
        UserDefaults.standard.set(morningTerminal, forKey: "MorningTerminal")
        UserDefaults.standard.set(eveningTerminal, forKey: "EveningTerminal")

        //print("Morning terminal: \(morningTerminal)")
        //print("Evening terminal: \(eveningTerminal)")
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch(pickerView.tag) {
            case 1:
                //print("Home \(stationList[row])")
                UserDefaults.standard.set(stationList[row], forKey: "BartHomeStation")
                homeStationLabel.text = stationList[row]
                break
        case 2:
            //print("Dest \(stationList[row])")
            destStation = stationList[row]
            UserDefaults.standard.set(stationList[row], forKey: "BartDestStation")
            destStationLabel.text = stationList[row]
            break
        case 3:
            //print("Home\(timeList[row])")
            UserDefaults.standard.set(timeList[row], forKey: "BartTimeToHome")
            break
        case 4:
            //print("Dest\(timeList[row])")
            UserDefaults.standard.set(timeList[row], forKey: "BartTimeToDest")
            break
        default:
            print("default")
        }
        if(pickerView.tag == 1 || pickerView.tag == 2) {
            findTerminals()
        }
        

    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 1
        
        pickerViewD.dataSource = self
        pickerViewD.delegate = self
        pickerViewD.tag = 2
    
        pickerViewT1.dataSource = self
        pickerViewT1.delegate = self
        pickerViewT1.tag = 3
        
        pickerViewT2.dataSource = self
        pickerViewT2.delegate = self
        pickerViewT2.tag = 4
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    





}

