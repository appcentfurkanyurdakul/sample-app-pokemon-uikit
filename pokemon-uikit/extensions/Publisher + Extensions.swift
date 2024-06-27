//
//  Publisher + Extensions.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation
import Combine

extension Published.Publisher where Value: Any {
    func observe(
        _ controller: BaseViewController,
        _ block: @escaping (_ result: Value) -> Void
    ) {
        receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { output in
                block(output)
            }.store(in: &controller.anyCancellable)
    }
}
