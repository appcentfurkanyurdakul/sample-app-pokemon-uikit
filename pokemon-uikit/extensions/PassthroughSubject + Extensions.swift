//
//  PassthroughSubject + Extensions.swift
//  pokemon-uikit
//
//  Created by Furkan Yurdakul on 24.06.2024.
//

import Foundation
import Combine

extension PassthroughSubject where Output: Any {
    func observe(
        _ controller: BaseViewController,
        _ block: @escaping (_ result: Output) -> Void
    ) {
        receive(on: DispatchQueue.main)
            .sink { _ in
                
            } receiveValue: { output in
                block(output)
            }.store(in: &controller.anyCancellable)
    }
}
