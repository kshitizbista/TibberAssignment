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
    private lazy var dataSource = makeDataSource()
    private var subscriptions = Set<AnyCancellable>()
    private var powerUps = [PowerUps]()
    let viewModal = PowerUpsViewModel()
    
    // MARK: - Views
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: configureLayout())
        collectionView.backgroundColor = UIColor(named: K.BrandColor.backgroundGrey)
        return collectionView
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator =  UIActivityIndicatorView(style: .large)
        return activityIndicator
    }()
    
    private let noPowerUpsLabel: UILabel = {
        let label = UILabel()
        label.text = "You have not setup any PowerUps"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16)
        label.textColor = UIColor(named: K.BrandColor.titleSmall)
        return label
    }()
    
    // MARK: - Types
    enum Section {
        case active
        case inactive
    }
    typealias DataSource = UICollectionViewDiffableDataSource<Section, PowerUps>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, PowerUps>
    
    // MARK: - Life Cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "PowerUps"
        addSubviews()
        collectionView.delegate = self
        cellRegistration()
        subscribePowerUpsAPI()
    }
    
    // MARK: - Functions
    private func addSubviews() {
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        view.addSubview(noPowerUpsLabel)
        collectionView.frame = view.bounds
        activityIndicator.center = view.center
        noPowerUpsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noPowerUpsLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    private func applySnapshot(animatingDifferences: Bool = false, data: [PowerUps]) {
        var snapshot = Snapshot()
        let activePowerUps = data.filter({ $0.connected })
        let inactivePowerUps = data.filter({ !$0.connected })
        if !activePowerUps.isEmpty {
            snapshot.appendSections([.active])
            snapshot.appendItems(activePowerUps, toSection: .active)
        }
        if !inactivePowerUps.isEmpty {
            snapshot.appendSections([.inactive])
            snapshot.appendItems(inactivePowerUps, toSection: .inactive)
        }
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
    
    private func subscribePowerUpsAPI() {
        viewModal.fetchData()
            .handleEvents(receiveSubscription: { [weak self] _ in
                self?.activityIndicator.startAnimating()
            })
            .receive(on: DispatchQueue.main)
            .replaceError(with: [])
            .sink { [weak self] data in
                guard let self = self else {
                    return
                }
                self.activityIndicator.removeFromSuperview()
                if data.count > 0 {
                    self.powerUps = data
                    self.applySnapshot(data: self.viewModal.sort(self.powerUps))
                } else {
                    self.noPowerUpsLabel.isHidden = false
                }
            }
            .store(in: &subscriptions)
    }
    
    private func cellRegistration() {
        collectionView.register(PowerUpsCollectionViewCell.self,
                                forCellWithReuseIdentifier: PowerUpsCollectionViewCell.identifier)
        collectionView.register(SectionHeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: SectionHeaderReusableView.identifier)
        collectionView.register(DisclosureAccessoryReusableView.self,
                                forSupplementaryViewOfKind: DisclosureAccessoryReusableView.identifier,
                                withReuseIdentifier: DisclosureAccessoryReusableView.identifier)
    }
}

// MARK: - Layout Handling
extension PowerUpsViewController {
    private static func configureLayout() -> UICollectionViewCompositionalLayout {
        
        let size = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(100))
        let itemCount = 1
        
        let disclosureAccessoryAnchor = NSCollectionLayoutAnchor(edges: [.trailing])
        let disclosureAccessorySize = NSCollectionLayoutSize(
            widthDimension: .estimated(18),
            heightDimension: .estimated(18))
        let disclosureAccessory = NSCollectionLayoutSupplementaryItem(
            layoutSize: disclosureAccessorySize,
            elementKind: DisclosureAccessoryReusableView.identifier,
            containerAnchor: disclosureAccessoryAnchor)
        
        let item = NSCollectionLayoutItem(layoutSize: size, supplementaryItems: [disclosureAccessory])
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: size,
            subitem: item,
            count: itemCount)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 14.5, bottom: 0, trailing: 14.5)
        section.interGroupSpacing = 10
        
        let headerFooterSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerFooterSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

// MARK: - DataSource
extension PowerUpsViewController {
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, powerUps in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PowerUpsCollectionViewCell.identifier, for: indexPath) as? PowerUpsCollectionViewCell
            cell?.configure(model: powerUps)
            return cell
        }
        dataSource.supplementaryViewProvider = { collectionView, kind, indexPath in
            switch kind {
            case DisclosureAccessoryReusableView.identifier:
                let disclosureAccessory = collectionView.dequeueReusableSupplementaryView(ofKind: DisclosureAccessoryReusableView.identifier, withReuseIdentifier: DisclosureAccessoryReusableView.identifier, for: indexPath) as! DisclosureAccessoryReusableView
                return disclosureAccessory
                
            case UICollectionView.elementKindSectionHeader:
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
            default:
                assertionFailure("Handle new kind")
                return nil
            }
        }
        return dataSource
    }
}

// MARK: - UICollectionViewDelegate
extension PowerUpsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let powerUp = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        subscriptions.removeAll()
        let vc = PowerUpDetailViewController(powerUp: powerUp)
        vc.title = powerUp.title
        navigationController?.pushViewController(vc, animated: true)
        vc.didConnectButtonTap
            .sink { [unowned self] selectedPowerUp in
                if let index = self.powerUps.firstIndex( where: {$0.id == selectedPowerUp.id}) {
                    powerUps[index] = selectedPowerUp
                    applySnapshot(data: viewModal.sort(powerUps))
                }
            }
            .store(in: &subscriptions)
    }
}
