//
//  KoreaEntryViewController.swift
//  Expo1900
//
//  Created by 수꿍, yeton on 2022/06/15.
//

import UIKit

final class KoreaEntryViewController: UIViewController {
    // MARK: Properties
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var koreaEntry = [Exhibits]()
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        parseKoreaEntryItems()
        navigationItem.title = "한국의 출품작"
        tableView.register(EntryTableViewCell.self, forCellReuseIdentifier: "EntryTableViewCell")
    }
}

// MARK: - UI

extension KoreaEntryViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == NameSpace.transferToDetailsVCId.name else {
            return
        }
        guard let index = tableView.indexPathForSelectedRow?.row else {
            return
        }
        
        let destination = segue.destination as? KoreaEntryDetailsViewController
        let exhibit = koreaEntry[index]
        
        destination?.exhibit = exhibit
    }
}

// MARK: - Parsing

extension KoreaEntryViewController {
    private func parseKoreaEntryItems() {
        guard let parsedItems = JSONData.parse(
            name: NameSpace.expoEntryData.name,
            to: koreaEntry) else {
            return
        }
        
        koreaEntry = parsedItems
    }
}

// MARK: - TableView Data Source

extension KoreaEntryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return koreaEntry.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryTableViewCell", for: indexPath) as? EntryTableViewCell else {
            return UITableViewCell()
        }
        
        let entryImage = UIImage(named: koreaEntry[indexPath.row].imageName)!.withAlignmentRectInsets(UIEdgeInsets(top: -10, left: 0, bottom: -10, right: 0))
        let entryTitle = koreaEntry[indexPath.row].name
        let entryDescription = koreaEntry[indexPath.row].shortDescription
        
        cell.setup(image: entryImage, title: entryTitle, description: entryDescription)
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}

// MARK: - TableView Delegate

extension KoreaEntryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: NameSpace.transferToDetailsVCId.name, sender: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
