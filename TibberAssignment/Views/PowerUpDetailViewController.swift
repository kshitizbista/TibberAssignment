//
//  PowerUpDetailViewController.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit

class PowerUpDetailViewController: UIViewController {
    
    // MARK: - Properties
    let powerUp: PowerUps

    // MARK: - LifeCyle
    init(powerUp: PowerUps) {
        self.powerUp = powerUp
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
    }

}
