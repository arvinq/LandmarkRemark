//
//  ViewModelManager.swift
//  LandmarkRemark
//
//  Created by Arvin Quiliza on 9/21/21.
//

import Foundation
import CoreLocation

class ViewModelManager {
    
    // single instance for the whole application
    static let shared = ViewModelManager()
    private init () { }
    
    private var remarkViewModelList: [RemarkViewModel] = []
    private var filteredRemarkViewModelList: [RemarkViewModel] = []
    
    // MARK: PersistenceManager Connection
    
    func getRemarks(completion: @escaping (LRError?) -> Void) {
        PersistenceManager.shared.getRemarks { [weak self] result in
            guard let self = self else { return }
            
            switch result {
                case .success(let remarks):
                    self.remarkViewModelList = remarks.map { RemarkViewModel(remark: $0) }
                    completion(nil)
                
                case .failure(let error):
                    completion(error)
            }
        }
    }
    
    func addRemark(remarkViewModel: RemarkViewModel, completion: @escaping (LRError?) -> Void) {
        
        // create our remark instance from viewModel before passing in the distance to our PersistenceManager for document creation
        let remark = Remark(title: remarkViewModel.title, note: remarkViewModel.note, latitude: remarkViewModel.latitude, longitude: remarkViewModel.longitude)
        
        PersistenceManager.shared.addRemark(remark: remark) { error in
            guard error == nil else {
                completion(error)
                return
            }
        }
        
        completion(nil)
    }
    
    // MARK: ViewModel Access Methods
    
    func getAllRemarks() -> [RemarkViewModel] {
        return remarkViewModelList
    }
    
    func getFilteredRemarks() -> [RemarkViewModel] {
        return filteredRemarkViewModelList
    }
    
    func remarksCount() -> Int {
        return remarkViewModelList.count
    }
    
    func getRemark(on coordinate: CLLocationCoordinate2D) -> RemarkViewModel? {
        guard self.remarkViewModelList.isEmpty else {
            return remarkViewModelList.filter { $0.coordinate == coordinate }.first
        }
        return nil
    }
    
    func filterRemark(having text: String) {
        var titleFiltered = remarkViewModelList.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
        
        let noteFiltered = remarkViewModelList.filter {
            $0.note.lowercased().contains(text.lowercased())
        }
        
        // remove the duplicates
        titleFiltered.append(contentsOf: noteFiltered.filter({
            !titleFiltered.contains($0)
        }))
        
        filteredRemarkViewModelList =  titleFiltered
    }
    
    func resetFilteredRemarks() {
        filteredRemarkViewModelList = remarkViewModelList
    }
}
