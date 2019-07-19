//
//  ViewController1.swift
//  MenuDemo
//
//  Created by Aquib on 17/07/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import UIKit

class ViewController1: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func next(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController6") as! ViewController6
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

class ViewController3: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
    }
    
}

class ViewController4: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
        
    }
    
}

class ViewController5: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .purple
        
    }
    
}

class ViewController6: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
}
