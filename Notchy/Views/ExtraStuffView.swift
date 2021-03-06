//
//  ExtraStuffView.swift
//  Notchy
//
//  Created by Daniel Loewenherz on 11/15/17.
//  Copyright © 2017 Lionheart Software LLC. All rights reserved.
//
//    This file is part of Notchy.
//
//    Notchy is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    Notchy is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with Notchy.  If not, see <https://www.gnu.org/licenses/>.

import UIKit
import SuperLayout
import SwiftyUserDefaults

@objc protocol ExtraStuffViewDelegate: class {
    @objc func getStuffButtonDidTouchUpInside(_ sender: Any)
    @objc func restoreButtonDidTouchUpInside(_ sender: Any)
    @objc func thanksButtonDidTouchUpInside(_ sender: Any)
}

enum ExtraStuffInfo {
    case addPhone
    case removeWatermark
    case icons

    var imageName: String {
        switch self {
        case .addPhone: return "IAPFrame"
        case .removeWatermark: return "IAPSticker"
        case .icons: return "IAPIcons"
        }
    }

    var title: String {
        switch self {
        case .addPhone: return "Add iPhone X"
        case .removeWatermark: return "Remove Watermark"
        case .icons: return "8 Icon Options"
        }
    }
}

final class ExtraStuffItemView: UIStackView {
    init(info: ExtraStuffInfo) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        spacing = 10

        let imageView = UIImageView(image: UIImage(named: info.imageName))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit

        let imageContainer = UIView()
        imageContainer.addSubview(imageView)

        imageView.leadingAnchor ~~ imageContainer.leadingAnchor
        imageView.trailingAnchor ≤≤ imageContainer.trailingAnchor
        imageView.topAnchor ~~ imageContainer.topAnchor
        imageView.bottomAnchor ~~ imageContainer.bottomAnchor

        if info == .removeWatermark {
            imageView.heightAnchor ~~ 71
        } else {
            imageView.heightAnchor ~~ 75
        }

        let label = UILabel()
        label.text = info.title
        label.font = NotchyTheme.systemFont(ofSize: 15, weight: .medium)

        addArrangedSubview(imageContainer)
        addArrangedSubview(label)

        imageContainer.widthAnchor ~~ 40
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class ExtraStuffView: UIView {
    enum TransactionStatus {
        case success
        case failure
    }
    
    /// Setting this updates the title of the `getStuffButton` button
    var productPrice: String? {
        didSet {
            let title: String
            if let price = productPrice {
                title = "Add Extra Stuff - \(price)"
            } else {
                title = "Add Extra Stuff"
            }
            
            getStuffButton.setTitle2(title, for: .normal, size: 14)
        }
    }

    weak var delegate: ExtraStuffViewDelegate!

    private var getStuffButton: PlainButton!
    private var thanksButton: PlainButton!
    private var restorePurchasesButton: UIButton!

    private var activity: UIActivityIndicatorView?

    init(delegate: ExtraStuffViewDelegate) {
        super.init(frame: .zero)

        self.delegate = delegate

        backgroundColor = .white
        translatesAutoresizingMaskIntoConstraints = false

        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 0.5

        let topLabel = UILabel()
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        topLabel.text = "EXTRA STUFF"
        topLabel.font = NotchyTheme.systemFont(ofSize: 24, weight: .medium)

        let item1 = ExtraStuffItemView(info: .addPhone)
        let item2 = ExtraStuffItemView(info: .removeWatermark)
        let item3 = ExtraStuffItemView(info: .icons)
        item3.isHidden = true

        let optionsStackView = UIStackView(arrangedSubviews: [item1, item2, item3])
        optionsStackView.translatesAutoresizingMaskIntoConstraints = false
        optionsStackView.axis = .vertical
        optionsStackView.alignment = .leading
        optionsStackView.spacing = 0

        item2.heightAnchor ~~ 50

        getStuffButton = PlainButton()
        getStuffButton.addTarget(self, action: #selector(getStuffButtonDidTouchUpInside(_:)), for: .touchUpInside)
        getStuffButton.setTitle2("Add Extra Stuff", for: .normal, size: 14)
        getStuffButton.setTitle2(nil, for: .selected, size: 14)

        restorePurchasesButton = UIButton(type: .system)
        restorePurchasesButton.addTarget(self, action: #selector(restoreButtonDidTouchUpInside(_:)), for: .touchUpInside)
        restorePurchasesButton.translatesAutoresizingMaskIntoConstraints = false
        restorePurchasesButton.titleLabel?.font = NotchyTheme.systemFont(ofSize: 12, weight: .medium)
        restorePurchasesButton.setTitle("Restore Purchase", for: .normal)

        thanksButton = PlainButton()
        thanksButton.isHidden = true
        thanksButton.setTitle2("Thanks!", for: .normal, size: 14)
        thanksButton.addTarget(self, action: #selector(thanksButtonDidTouchUpInside(_:)), for: .touchUpInside)

        let stackView = UIStackView(arrangedSubviews: [topLabel, optionsStackView, getStuffButton, restorePurchasesButton, thanksButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        stackView.distribution = .equalSpacing

        stackView.setCustomSpacing(15, after: optionsStackView)

        addSubview(stackView)

        let margin: CGFloat = 15
        stackView.leadingAnchor ~~ leadingAnchor + margin
        stackView.trailingAnchor ~~ trailingAnchor - margin
        stackView.topAnchor ~~ topAnchor + margin
        stackView.bottomAnchor ~~ bottomAnchor - margin
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -

    @objc func thanksButtonDidTouchUpInside(_ sender: Any) {
        delegate.thanksButtonDidTouchUpInside(sender)
    }
    
    @objc func getStuffButtonDidTouchUpInside(_ sender: Any) {
        transactionStarted()
        delegate.getStuffButtonDidTouchUpInside(sender)
    }
    
    @objc func restoreButtonDidTouchUpInside(_ sender: Any) {
        transactionStarted()
        delegate.restoreButtonDidTouchUpInside(sender)
    }
    
    // MARK: -

    func transactionCompleted(status: TransactionStatus) {
        switch status {
        case .success:
            break

        case .failure:
            activity?.removeFromSuperview()
            getStuffButton.isEnabled = true
            restorePurchasesButton.isEnabled = true
            getStuffButton.isSelected = false
        }
    }

    private func transactionStarted() {
        getStuffButton.isSelected = true
        getStuffButton.isEnabled = false
        restorePurchasesButton.isEnabled = false

        activity = UIActivityIndicatorView(style: .white)
        guard let activity = activity else {
            return
        }

        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.startAnimating()

        getStuffButton.addSubview(activity)

        activity.centerXAnchor ~~ getStuffButton.centerXAnchor
        activity.centerYAnchor ~~ getStuffButton.centerYAnchor
    }
}
