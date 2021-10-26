//
//  StatisticsFormatter.swift
//  KTTC Lite
//
//  Created by Ярослав Стрельников on 26.10.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//
//  This file was generated by the 🐍 VIPER generator
//

import UIKit

struct NeedCalculateData {
    var battles: Double = 0
    var averageLevel: Double = 0
    var wn6: WN6 = 0
    var wn7: WN7 = 0
    var wn8: WN8 = 0
    var eff: EFF = 0
    
    var xp: Double = 0
    var damage: Double = 0
    var spotted: Double = 0
    var frags: Double = 0
    var wins: Double = 0
    var maxFrags: Double = 0
    var def: Double = 0
    var cap: Double = 0
    
    var assist: Double = 0
    var hits: Double = 0
    
    var maxDamage: Double = 0
    
    var avgDamage: Double {
        (damage / battles).round(to: 2)
    }
    
    var avgSpotted: Double {
        (spotted / battles).round(to: 2)
    }
    
    var avgFrags: Double {
        (frags / battles).round(to: 2)
    }
    
    var avgDef: Double {
        (def / battles).round(to: 2)
    }
    
    var avgXP: Double {
        (xp / battles).round(to: 2)
    }
    
    var avgCap: Double {
        (cap / battles).round(to: 2)
    }

    var winrate: Double {
        (wins / (battles / 100)).round(to: 2)
    }
    
    mutating func erase() {
        battles = 0
        averageLevel = 0
        wn8 = 0
        wn7 = 0
        wn6 = 0
        eff = 0
        xp = 0
        damage = 0
        spotted = 0
        frags = 0
        wins = 0
        maxDamage = 0
        maxFrags = 0
        def = 0
        cap = 0
        assist = 0
        hits = 0
    }
}

struct DataValue: Hashable {
    var key: String
    var value: Any
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
    
    static func == (lhs: DataValue, rhs: DataValue) -> Bool {
        return lhs.key == rhs.key
    }
}

enum Section {
    case ratings
    case firstDivider
    case winrate
    case secondDivider
    case shoots
    case thirdDivider
    case frags
    case fourtDivider
    case good
    case average
    case bad
}

enum Item: Hashable {
    static func == (lhs: Item, rhs: Item) -> Bool {
        switch lhs {
        case .key(let string1):
            switch rhs {
            case .key(let string):
                return string1 == string
            default:
                return false
            }
        case .value(let dictionary1):
            switch rhs {
            case .value(let dictionary):
                return dictionary1 == dictionary
            default:
                return false
            }
        case .level(let dictionary2):
            switch rhs {
            case .level(let dictionary):
                return dictionary2 == dictionary
            default:
                return false
            }
        }
    }
    
    case key(String)
    case value([String: Double])
    
    case level([String: String])
}

typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>

struct TankModel {
    var name: String
    var level: String
    var id: Int
}

final class StatisticsFormatter {
    weak var presenter: StatisticsPresenterInterface?
    var needCalculateData: NeedCalculateData = NeedCalculateData()
}

// MARK: - Extensions -

extension StatisticsFormatter: StatisticsFormatterInterface {
    func makeDataSource(collectionView: UICollectionView) -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, object in
            guard let self = self else { abort() }
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ParameterCell", for: indexPath) as? ParameterCell else { abort() }
            
            let section = self.presenter?.view.snapshot.sectionIdentifiers[indexPath.section]
            
            switch object {
            case .level(let dictionary):
                if let key = dictionary.keys.first, indexPath.section > 7 {
                    cell.backgroundColor = .systemBackground
                    cell.parameterLabel.textAlignment = .center
                    cell.parameterLabel.text = key
                    cell.parameterLabel.font = .systemFont(ofSize: 13, weight: .bold)

                    switch key {
                    case "Уникум":
                        cell.parameterLabel.textColor = .color(from: 0xb14cc2)
                    case "Великолепный игрок":
                        cell.parameterLabel.textColor = .color(from: 0x06a7a7)
                    case "Хороший игрок":
                        cell.parameterLabel.textColor = .color(from: 0x59e500)
                    case "Средний игрок":
                        cell.parameterLabel.textColor = .color(from: 0xffe704)
                    case "Игрок ниже среднего":
                        cell.parameterLabel.textColor = .color(from: 0xff8e00)
                    case "Плохой игрок":
                        cell.parameterLabel.textColor = .color(from: 0xff2901)
                    default:
                        cell.parameterLabel.textColor = .label
                    }
                }
            case .key(let key):
                cell.parameterLabel.textAlignment = .natural
                cell.parameterLabel.text = key
                cell.parameterLabel.textColor = .label
                cell.parameterLabel.font = .systemFont(ofSize: 14, weight: .medium)
            case .value(let dictionary):
                cell.parameterLabel.textAlignment = .natural
                cell.parameterLabel.text = "\((dictionary[dictionary.keys.first ?? ""] ?? 0))"
                cell.parameterLabel.font = .systemFont(ofSize: 14, weight: .medium)

                if let key = dictionary.keys.first {
                    let value = dictionary[key]?.checkToNaN()
                    
                    if indexPath.item % 2 != 0 && indexPath.section < 8 {
                        switch key {
                        case "avgDamage":
                            cell.parameterLabel.textColor = .xwmColor(from: .damage, with: Int(value ?? 0))
                        case "wn6":
                            cell.parameterLabel.textColor = .xwmColor(from: .wn6, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\((dictionary[dictionary.keys.first ?? ""] ?? 0).round(to: 2))"
                        case "wn7":
                            cell.parameterLabel.textColor = .xwmColor(from: .wn7, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\((dictionary[dictionary.keys.first ?? ""] ?? 0).round(to: 2))"
                        case "wn8":
                            cell.parameterLabel.textColor = .xwmColor(from: .wn8, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\((dictionary[dictionary.keys.first ?? ""] ?? 0).round(to: 2))"
                            self.presenter?.view.setXVMTitle(withColor: .xwmColor(from: .wn8, with: Int(value ?? 0)))
                        case "winrate":
                            cell.parameterLabel.textColor = .xwmColor(from: .winrate, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\(dictionary[dictionary.keys.first ?? ""] ?? 0)%"
                        case "battles":
                            cell.parameterLabel.textColor = .label
                            cell.parameterLabel.text = "\(Int(dictionary[dictionary.keys.first ?? ""] ?? 0))"
                        case "maxFrags":
                            cell.parameterLabel.textColor = .xwmColor(from: .frags, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\(Int(dictionary[dictionary.keys.first ?? ""] ?? 0))"
                        case "eff":
                            cell.parameterLabel.textColor = .xwmColor(from: .eff, with: Int(value ?? 0))
                            cell.parameterLabel.text = "\((dictionary[dictionary.keys.first ?? ""] ?? 0).round(to: 2))"
                        case "spotted", "frags":
                            cell.parameterLabel.textColor = .label
                            cell.parameterLabel.text = "\(Int(dictionary[dictionary.keys.first ?? ""] ?? 0))"
                        default:
                            cell.parameterLabel.textColor = .label
                        }
                    }
                }
            }
            
            switch section {
            case .firstDivider, .secondDivider, .thirdDivider, .fourtDivider:
                cell.parameterLabel.textAlignment = .natural
                cell.backgroundColor = .dividerColor
                cell.parameterLabel.text = nil
            default:
                cell.backgroundColor = .systemBackground
            }
            
            return cell
        }
        
        return dataSource
    }
    
    func makeSnapshot() -> Snapshot {
        return Snapshot()
    }
    
    func finish() {
        DispatchQueue.main.sync { [weak self] in
            self?.presenter?.view.stopLoading()
            self?.updateDataSource()
        }
    }
    
    private func updateDataSource() {
        presenter?.view.snapshot.appendSections([.winrate, .firstDivider, .ratings, .secondDivider, .frags, .thirdDivider, .shoots, .fourtDivider, .good, .average, .bad])
        presenter?.view.dataSource.apply(presenter?.view.snapshot ?? makeSnapshot())
        
        presenter?.view.snapshot.appendItems([.key("Количество боёв:"), .value(["battles": needCalculateData.battles])], toSection: .winrate)
        presenter?.view.snapshot.appendItems([.key("Процент побед:"), .value(["winrate": needCalculateData.winrate])], toSection: .winrate)
        presenter?.view.snapshot.appendItems([.key("Средний уровень:"), .value(["averageLevel": needCalculateData.averageLevel.round(to: 1)])], toSection: .winrate)
        
        presenter?.view.snapshot.appendItems([.value(["d1": 0])], toSection: .firstDivider)
        
        presenter?.view.snapshot.appendItems([.key("Рейтинг WN6:"), .value(["wn6": needCalculateData.wn6])], toSection: .ratings)
        presenter?.view.snapshot.appendItems([.key("Рейтинг WN7:"), .value(["wn7" : needCalculateData.wn7])], toSection: .ratings)
        presenter?.view.snapshot.appendItems([.key("Рейтинг WN8:"), .value(["wn8" : needCalculateData.wn8])], toSection: .ratings)
        presenter?.view.snapshot.appendItems([.key("Рейтинг РЭ:"), .value(["eff": needCalculateData.eff])], toSection: .ratings)
        
        presenter?.view.snapshot.appendItems([.value(["d2": 0])], toSection: .secondDivider)
        
        presenter?.view.snapshot.appendItems([.key("Средний урон:"), .value(["avgDamage": needCalculateData.avgDamage])], toSection: .frags)
        presenter?.view.snapshot.appendItems([.key("Максимально уничтожил:"), .value(["maxFrags": needCalculateData.maxFrags])], toSection: .frags)
        if !(presenter?.view.isBlitz ?? false) {
            presenter?.view.snapshot.appendItems([.key("Ассист урон:"), .value(["assist": needCalculateData.assist])], toSection: .frags)
            presenter?.view.snapshot.appendItems([.key("Максимальный урон:"), .value(["maxDamage": needCalculateData.maxDamage])], toSection: .frags)
            presenter?.view.snapshot.appendItems([.key("Процент попаданий:"), .value(["hits": needCalculateData.hits])], toSection: .frags)
        }
        
        presenter?.view.snapshot.appendItems([.value(["d3": 0])], toSection: .thirdDivider)
        
        presenter?.view.snapshot.appendItems([.key("Обнаружено врагов (всего):"), .value(["spotted": needCalculateData.spotted])], toSection: .shoots)
        presenter?.view.snapshot.appendItems([.key("Обнаружено врагов (cредний):"), .value(["avgSpotted": needCalculateData.avgSpotted])], toSection: .shoots)
        presenter?.view.snapshot.appendItems([.key("Уничтожено врагов (всего):"), .value(["frags": needCalculateData.frags])], toSection: .shoots)
        presenter?.view.snapshot.appendItems([.key("Уничтожено врагов (cредний):"), .value(["avgFrags": needCalculateData.avgFrags])], toSection: .shoots)
        
        presenter?.view.snapshot.appendItems([.value(["d4": 0])], toSection: .fourtDivider)
        
        presenter?.view.snapshot.appendItems([.level(["Уникум": "6"]), .level(["Средний игрок": "5"])], toSection: .good)
        presenter?.view.snapshot.appendItems([.level(["Великолепный игрок": "4"]), .level(["Игрок ниже среднего": "3"])], toSection: .average)
        presenter?.view.snapshot.appendItems([.level(["Хороший игрок": "2"]), .level(["Плохой игрок": "1"])], toSection: .bad)
        
        presenter?.view.dataSource.apply(presenter?.view.snapshot ?? makeSnapshot())
    }
}