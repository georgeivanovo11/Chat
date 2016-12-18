//
//  TranslationCell.swift
//  Chat
//
//  Created by george on 18/12/2016.
//  Copyright © 2016 george. All rights reserved.
//
import UIKit

class TranslationCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{
    public var message: Message? = nil
    
    public var memory = [Segment]()
    {
        didSet
        {
            DispatchQueue.main.async(execute:
                {self.collection.reloadData()})
        }
    }
    
    let cellId3 = "cellId3"
    
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        setupView()
        
    }
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    let collection: UICollectionView =
    {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.translatesAutoresizingMaskIntoConstraints = false
        
        return cv
    }()
    
    func setupView()
    {
        backgroundColor = UIColor.white
        addSubview(collection)
        
        collection.dataSource = self
        collection.delegate = self
        collection.register(CellOfCell.self, forCellWithReuseIdentifier: cellId3)
        
        
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[v0]-10-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collection]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":collection]))
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return memory.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId3, for: indexPath) as! CellOfCell
        cell.setupView()
        cell.originTextField.text = memory[indexPath.row].eng
        cell.renderTextField.text = memory[indexPath.row].rus
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width:200, height: frame.height)
    }
}

