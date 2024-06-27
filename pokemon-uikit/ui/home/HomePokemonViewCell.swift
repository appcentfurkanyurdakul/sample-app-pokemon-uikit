//
//  HomePokemonViewCell.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 25.06.2024.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class HomePokemonViewCell: UICollectionViewCell {
    
    static let identifier = "HomePokemonViewCell"
    
    private lazy var pokemonNameLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 3
        l.adjustsFontSizeToFitWidth = true
        l.font = .systemFont(ofSize: 13)
        l.textColor = .darkGray
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .none
        self.contentView.backgroundColor = .none
        self.contentView.addSubview(pokemonNameLabel)
        self.pokemonNameLabel.backgroundColor = .green.withAlphaComponent(0.3)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: PokemonHomePageItem) {
        self.pokemonNameLabel.text = data.name
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        self.pokemonNameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(6)
            make.right.equalToSuperview().offset(-6)
            make.top.equalToSuperview().offset(6)
            make.bottom.equalToSuperview().offset(-6)
        }
    }
}
