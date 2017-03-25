//
//  selectBankAccountViewController.swift
//  Mung
//
//  Created by Chike Chiejine on 05/03/2017.
//  Copyright © 2017 Color & Space. All rights reserved.
//

import UIKit


//class bankAccount {
//
//    let accounts : String?
//    let bankLogos : UIImage?
//    let accountBalance: Double?
//    let lasstFourDigits: Int?
//
//
//

//Asign bank account vairbale to goal class

//}

class selectBankAccountViewController: UITableViewController {
    
    var goalObject = goalsClass(goal: nil)
    var progress = UIView()
    
    //    var accounttype = ["Bank of America Premier Checking"]
    //    var accounts = ["Chase", "Bank Of America","Wells Fargo"]
    //    var bankLogos = ["chase","bofa","wellsfargo" ]
    //    var accountBalance: [Double] = [3000.50, 600.23, 568.33 ]
    //    var lastFourDigits: [Int] = [2634, 8173, 9102]
    
    
    // TODO 1: Need to pair logo up with institution name (set aside until we can test with actual bank accounts)
    // TODO 2: Add account type (ie, savings / Checking account)
    
    var accounttype = ["Bank of America Premier Checking"]
    var accounts = [String]()
    //var bankLogos = String()
    var bankLogos = ["chase","bofa","wellsfargo" ]
    var accountBalance = [Double] ()
    var lastFourDigits = [String] ()
    
    var plaid_access_tokens_list = [String] ()
    var plaid_bank_ids_list = [String] ()
    var plaid_access_token = String ()
    var weeklySaveAmount = Double ()
    
    var indexRow = Int()
    
    @IBOutlet weak var nextButton: UIBarButtonItem!
    
    
    
    
    @IBAction func nextAction(_ sender: Any) {
        
        
        helperFuns().getSaveAmount(plaidAccessToken: self.plaid_access_tokens_list[self.indexRow], bankID: self.plaid_bank_ids_list[self.indexRow], completion: { saveAmount, error in
            
            print("test123.ab")
            
            self.weeklySaveAmount = saveAmount!
            self.performSegue(withIdentifier: "chooseAccountStep4", sender: self)
            
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        helpers().tableFooter(sender: self.tableView)
        self.tableView.allowsMultipleSelection = false
        
        print("we are in view did load!")
        
        helperFuns().getBankMetaData { (AccessTokensList, BankIDsList, metaDataObj, error) in
            print("metaDataObj1.a")
            print(metaDataObj)
            
            self.plaid_access_tokens_list = AccessTokensList!
            self.plaid_bank_ids_list = BankIDsList!
            
            if metaDataObj != nil {
                let obj = metaDataObj
                
                if let string = obj as? String, let data = string.data(using: .utf8) {
                    let parsedData = try! JSONSerialization.jsonObject(with: data, options: []) as? [[String:Any]]
                    
                    print("parsedData1.a")
                    print(parsedData)
                    print("parsedData2.a")
                    
                    for item_ in parsedData! {
                        self.accounts.append(item_["institution_type"] as! String)
                        let balanceArr = item_["balance"] as? [String:Any]
                        self.accountBalance.append(balanceArr?["available"] as! Double)
                        let accountinfo = item_["meta"] as? [String:Any]
                        self.lastFourDigits.append(accountinfo?["number"] as! String)
                        self.accounttype.append(accountinfo?["name"] as! String)
                        
                    }
                    print("self.accounts")
                    print(self.accounts)
                    print("self.accountBalance")
                    print(self.accountBalance)
                    
                }
            }
            //self.reloadData()
            self.tableView.reloadData()
            
        }
        
        print("self.accountsuniversal")
        
        print(self.accounts)
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (accounts.count + 1)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)  as! bankAccountCell
        
        if indexPath.row != 0 {
            
            self.indexRow = indexPath.row - 1
            
            cell.isSelected = true
            if cell.isSelected == true {
                
                cell.selectedTick.isHidden = false
                
                self.nextButton.isEnabled = true
                
            }
        } else {
            
            self.performSegue(withIdentifier: "chooseAccountBankConnect", sender: self)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath)  as! bankAccountCell
        
        if indexPath.row != 0 {
            
            self.indexRow = indexPath.row - 1
            cell.isSelected = false
            if cell.isSelected == false {
                
                cell.selectedTick.isHidden = true
            }
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
        cell.isSelected = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.indentationWidth = 0
        cell.layoutMargins = UIEdgeInsets.zero
        tableView.separatorStyle = .singleLine
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsMultipleSelection = false
        
        print("indexpath.row1.a")
        print(indexPath.row)
        print("indexpath.row2.a")
        
        
        if indexPath.row == 0 {
            
            var cellOne = tableView.dequeueReusableCell(withIdentifier: "addNewAccount", for: indexPath) as! UITableViewCell
            
            
            
            
            
            return cellOne
            
        } else {
            
            var cellTwo = tableView.dequeueReusableCell(withIdentifier: "bankAccount", for: indexPath) as! bankAccountCell
            
            print("self.accounts2")
            print(self.accounts)
            print("self.accountBalance2")
            print(self.accountBalance)
            
            
            
            
            
            cellTwo.bankName.text = self.accounts[indexPath.row - 1] as String
            cellTwo.bankLogo.image = UIImage(named: self.bankLogos[indexPath.row - 1])
            cellTwo.lastFourDigits.text = self.lastFourDigits[indexPath.row - 1]
            cellTwo.bankBalance.text = String(self.accountBalance[indexPath.row - 1])
            
            if cellTwo.isSelected == false {
                
                cellTwo.selectedTick.isHidden = true
                
            }
            
            
            return cellTwo
            
        }
        
        
        
    }
    
    
    @IBAction func unwindToRootViewController(segue: UIStoryboardSegue) {
        print("Unwind to Root View Controller")
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let step3 = segue.destination as? goalsSetup3ViewController {
            step3.progress = helpers().progressBar(view: self, currentStep: 4, progressBar:self.progress, next: true)
            step3.goalObject = self.goalObject
            step3.plaidAccessToken = self.plaid_access_tokens_list[self.indexRow]
            step3.weeklySaveAmount = self.weeklySaveAmount
            
            
        } else if let bankSetup = segue.destination as? BankSetupViewController {
            bankSetup.progress = helpers().progressBar(view: self, currentStep: 3, progressBar:self.progress, next: true)
            bankSetup.goalObject = self.goalObject
        } else if let stepTwo = segue.destination as? goalsSetup2ViewController {
            stepTwo.progress = helpers().progressBar(view: self, currentStep: 3, progressBar:self.progress, next: false)
            stepTwo.goalObject = self.goalObject
        }
    }
    
    
    
}
