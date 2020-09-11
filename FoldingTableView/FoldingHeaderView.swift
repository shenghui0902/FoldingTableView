//
//  FoldingHeaderView.swift
//  FoldingTableView
//
//  Created by lishenghui on 2020/9/10.
//  Copyright © 2020 JackLi. All rights reserved.
//

import UIKit

class FoldingHeaderView: UITableViewHeaderFooterView {

    public var foldClosure: ((_ isFold: Bool) -> Void)?
    let margin: CGFloat = 12.0
    public var carSeries: CarSeries? {
        didSet {
            if let series = carSeries {
                titleLabel.text = series.name
                let imageName = series.folding ? "arrow_up_icon" : "arrow_down_icon"
                let image = UIImage.init(named: imageName)
                foldingBtn.setImage(image, for: .normal)
                isFold = series.folding
            }
        }
    }
    var isFold: Bool = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel.init()
        label.font = UIFont.boldSystemFont(ofSize: 15.0)
        label.textColor = UIColor.black
        label.textAlignment = .left
        return label
    }()
    
    lazy var foldingBtn: UIButton = {
        let btn = UIButton.init(type: .custom)
        let image = UIImage.init(named: "arrow_down_icon")
        btn.setImage(image, for: .normal)
        btn.contentMode = .scaleAspectFit
        btn.addTarget(self, action: #selector(foldingSwip(sender:)), for: .touchUpInside)
        return btn
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupUI() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor, constant: margin).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: margin).isActive = true
        titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -margin).isActive = true
    
        contentView.addSubview(foldingBtn)
        foldingBtn.translatesAutoresizingMaskIntoConstraints = false
        foldingBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: margin).isActive = true
        foldingBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        foldingBtn.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -margin).isActive = true
    }

}

extension FoldingHeaderView {
    @objc func foldingSwip(sender: UIButton) {
        isFold = !isFold
        UIView.animate(withDuration: 0.3, animations: {[weak self] in
            self!.foldingBtn.imageView?.transform = CGAffineTransform.init(rotationAngle: .pi)
        })
        if let closure = foldClosure {
            closure(isFold)
        }
    }
}
