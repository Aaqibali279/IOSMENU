//
//  MenuViewController.swift
//  MenuDemo
//
//  Created by Aquib on 17/07/19.
//  Copyright © 2019 Aquib. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell {
    @IBOutlet weak var iv: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var menu:Menu?{
        didSet{
            guard  let menu = menu else {return}
            iv.image = menu.image
            label.text = menu.name
            contentView.backgroundColor = menu.isSelected ? .white : .clear
        }
    }
}


class Menu {
    var name:String?
    var image:UIImage?
    var isSelected:Bool = false
    var vc:UIViewController?
    
    init(name:String?,image:UIImage?,vc:UIViewController?) {
        self.name = name
        self.image = image
        self.vc = vc
    }
}


class MenuController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var delegate: MenuDelegate?
    var menus = [Menu]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "MenuHeader", bundle: Bundle.main)
        collectionView.register(nib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuHeader")
    }

}
extension MenuController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return menus.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as! MenuCell
        cell.menu = menus[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return .init(width: width, height: width * 0.15)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch section {
        case 0:
            let width = collectionView.frame.width
            return .init(width: width, height: width * 0.35)
        default:
            return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "MenuHeader", for: indexPath) as! MenuHeader
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let menu = menus[indexPath.section]
        menu.isSelected = true
        delegate?.selected(menu: menu)
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuCell {
            cell.contentView.backgroundColor = .white
        }
        print("SELECT:",indexPath.section)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        menus[indexPath.section].isSelected = false
        if let cell = collectionView.cellForItem(at: indexPath) as? MenuCell {
            cell.contentView.backgroundColor = .clear
        }
        print("DESELECT:",indexPath.section)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        switch section {
        case menus.count - 1:
            let width = collectionView.frame.width
            let headerHeight = width * 0.35
            let cellsHeight = (width * 0.15) * CGFloat(menus.count)
            let top = (collectionView.frame.height - headerHeight - cellsHeight)
            return .init(top: top, left: 0, bottom: 0, right: 0)
        default:
            return .zero
        }
        
    }
    
}
