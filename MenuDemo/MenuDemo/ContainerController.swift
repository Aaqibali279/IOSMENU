//
//  ViewController.swift
//  Menu
//
//  Created by Aqib Ali on 21/01/19.
//  Copyright © 2019 osx. All rights reserved.
//

import UIKit

class ContainerController: UIViewController,UIGestureRecognizerDelegate {

    // MARK: - Properties
    var currentViewController:UIViewController?
    var menuController: MenuController!
    var menuImage = #imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate)
    var backImage = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
    private var isOpen = false
    private let kDuration = 0.35
    
    private var button = { () -> UIButton in
        let btn = UIButton()
        btn.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        btn.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureMenuController()
        configureNavigationController()
        addGestures()
    }
    
    private func addGestures(){
        let leftGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftSwipe))
        leftGesture.edges = .left
        view.addGestureRecognizer(leftGesture)

    }
    
    @objc func leftSwipe(gesture:UIScreenEdgePanGestureRecognizer){
        switch gesture.state {
        case .began:
            if !isOpen{
                menuAction()
            }
        default:
            break
        }
    }
    
    
    
    private func configureNavigationController(){
        view.insertSubview(nvc.view, at: 0)
        addChild(nvc)
        nvc.didMove(toParent: self)
    }
    
    private var nvc = { () -> UINavigationController in
        let nvc = UINavigationController()
        nvc.navigationBar.isTranslucent = true
        nvc.navigationBar.tintColor = .white
        nvc.navigationBar.barTintColor = .clear
        nvc.navigationBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        nvc.navigationBar.shadowImage = UIImage()
        nvc.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        return nvc
    }()
    
    private func configureMenuController() {
        if menuController == nil {
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            menuController = storyboard.instantiateViewController(withIdentifier: "MenuController") as? MenuController
            let vc1 = storyboard.instantiateViewController(withIdentifier: "ViewController1") as! ViewController1
            let vc2 = storyboard.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
            
            
            let menus:[Menu] = [
                Menu(name: "Home", image: #imageLiteral(resourceName: "back"), vc: vc1),
                Menu(name: "Notifications", image: #imageLiteral(resourceName: "back"), vc: vc2),
                Menu(name: "Home", image: #imageLiteral(resourceName: "back"), vc: ViewController3()),
                Menu(name: "Notifications", image: #imageLiteral(resourceName: "back"), vc: ViewController4()),
                Menu(name: "Home", image: #imageLiteral(resourceName: "back"), vc: ViewController5()),
                Menu(name: "Logout", image: #imageLiteral(resourceName: "back"), vc: UIViewController())
            ]
            
            menuController.delegate  = self
            menuController.menus = menus
            let width = nvc.view.frame.width - 80
            
            menuController.view.frame = .init(origin: .zero, size: .init(width: width, height: view.frame.height))
            menuController.view.layer.shadowOpacity = 0.6
            menuController.view.layer.shadowRadius = 5
            menuController.view.layer.shadowOffset = CGSize(width: -1, height: 1)
            
            menuController.view.frame.origin.x =  -width
            
            view.insertSubview(menuController.view, at: 1)
            addChild(menuController)
            menuController.didMove(toParent: self)
            
            if let menu = menus.first{
                set(menu: menu)
            }
        }
    }
    
    private func animatePanel() {

        isOpen = !isOpen
        let width = nvc.view.frame.width - 80
        let expanded = isOpen
        
        if isOpen{
            button.frame = nvc.view.frame
            nvc.view.addSubview(button)
        }else{
            button.removeFromSuperview()
        }
        
        UIView.animate(withDuration: kDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.nvc.view.frame.origin.x = expanded ? width : 0
            self.menuController.view.frame.origin.x = expanded ? 0 : -width
        })
        
        guard let leftItem = currentViewController?.navigationItem.leftBarButtonItem?.customView as? UIButton else { return }
        
        UIView.transition(with: leftItem, duration: kDuration, options: .curveEaseInOut, animations: {
            leftItem.setImage( expanded ? self.backImage : self.menuImage, for: .normal)
        })
    }
    
    @objc func menuAction(){
        animatePanel()
    }
}

protocol MenuDelegate{
    func selected(menu: Menu?)
}
extension ContainerController : MenuDelegate{
    func selected(menu: Menu?) {
        guard let menu = menu else { return }
        set(menu: menu)
        animatePanel()
        
    }
    
    private func set(menu:Menu){
        guard let vc = menu.vc else {return}
        currentViewController = vc
        nvc.viewControllers = [vc]
        let barItem = UIButton()
        barItem.tintColor = .white
        barItem.setImage(menuImage, for: .normal)
        barItem.addTarget(self, action: #selector(menuAction), for: .touchUpInside)
        barItem.frame = CGRect.init(x: 0, y: 0, width: 44, height: 44)
        let item = UIBarButtonItem(customView: barItem)
        vc.navigationItem.leftBarButtonItem = item
        vc.navigationItem.title = menu.name
    }
    
}
