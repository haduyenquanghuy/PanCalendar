//
//  CalendarTableViewHeader.swift
//  PanCalendar
//
//  Created by Ha Duyen Quang Huy on 14/05/2022.
//

import UIKit

protocol CalendarTableViewHeaderDelegate {
    
    func showSection()
    func hideSection()
}

class CalendarTableViewHeader: UITableViewHeaderFooterView {
    
    let showButton = UIButton(type: .custom)
    let title = UILabel()
    var delegate: CalendarTableViewHeaderDelegate?
    private var isShow = true
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureContents() {
        showButton.translatesAutoresizingMaskIntoConstraints = false
        showButton.tintColor = UIColor.init(rgb: 0x39393A)
        showButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        showButton.addTarget(self, action:#selector(handleTap), for: .touchUpInside)
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.textColor = UIColor.init(rgb: 0x39393A, a: 0.75)
        title.font = UIFont(name: "Gill Sans", size: 20.0)
        title.textAlignment = .left
        
        contentView.addSubview(showButton)
        contentView.addSubview(title)
        
        // Center the image vertically and place it near the leading
        // edge of the view. Constrain its width and height to 50 points.
        NSLayoutConstraint.activate([
            showButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            showButton.widthAnchor.constraint(equalToConstant: 50),
            showButton.heightAnchor.constraint(equalToConstant: 50),
            showButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            // Center the label vertically, and use it to fill the remaining
            // space in the header view.
            title.heightAnchor.constraint(equalToConstant: 30),
            title.leadingAnchor.constraint(equalTo: showButton.trailingAnchor,
                                           constant: 0),
            title.trailingAnchor.constraint(equalTo:
                                                contentView.layoutMarginsGuide.trailingAnchor),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func handleTap() {
        isShow = !isShow
        let imageName = isShow ? "chevron.down" : "chevron.right"
        showButton.setImage(UIImage(systemName: imageName), for: .normal)
        guard let delegate = delegate else {
            return
        }
        if isShow {
            title.font = UIFont(name: "Gill Sans", size: 20.0)
            delegate.showSection()
        } else {
            title.font = UIFont(name: "Gill Sans SemiBold", size: 20.0)
            delegate.hideSection()
        }
    }
    
}
