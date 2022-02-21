//
//  ViewController.swift
//  TibberAssignment
//
//  Created by Kshitiz Bista on 2022-02-21.
//

import UIKit
import Combine

class PowerUpsViewController: UIViewController {
    
    // MARK: - Properties
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor =  UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        return collectionView
    }()
    
    private lazy var dataSource = makeDataSource()
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: - Types
    enum Section: CaseIterable {
        case active
        case inactive
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PowerUps>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PowerUps>
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PowerUps"
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.frame = view.bounds
        collectionView.register(PowerUpsCollectionViewCell.self,
                                forCellWithReuseIdentifier: PowerUpsCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.identifier)
        subscribeToAPICall()
    }
    
    // MARK: - Functions
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, powerUps in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PowerUpsCollectionViewCell.identifier, for: indexPath) as? PowerUpsCollectionViewCell
            cell?.configure(model: powerUps)
            return cell
        }
        
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            guard kind == UICollectionView.elementKindSectionHeader else {
                return nil
            }
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderReusableView.identifier,
                for: indexPath) as? SectionHeaderReusableView
            let section = self.dataSource.snapshot().sectionIdentifiers[indexPath.section]
            switch section {
            case .active:
                header?.titleLabel.text = "Active power-ups"
            case .inactive:
                header?.titleLabel.text = "Available power-ups"
            }
            return header
        }
        
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = false, data: [PowerUps]) {
        var snapshot = Snapshot()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(data.filter({ $0.connected }), toSection: .active)
        snapshot.appendItems(data.filter({ !$0.connected }), toSection: .inactive)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    func subscribeToAPICall() {
        PowerUpsAPI.fetchData(payload: PowerUps.payload)
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [unowned self] data in
                applySnapshot(data: data)
            }
            .store(in: &subscriptions)
    }
}

// MARK: - Layout Handling
extension PowerUpsViewController {
    private static func configureLayout() -> UICollectionViewCompositionalLayout {
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        let itemCount = 1
        let item = NSCollectionLayoutItem(layoutSize: size)
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: itemCount)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - UICollectionViewDelegate
extension PowerUpsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let powerUp = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        let vc = PowerUpDetailViewController(powerUp: powerUp)
        vc.title = powerUp.title
        navigationController?.pushViewController(vc, animated: true)
    }
}
