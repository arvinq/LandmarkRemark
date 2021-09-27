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
    
    // MARK: PersistenceManager Connection And Processes
    
    /**
     * Accesses our Persistence manager to query remarks and passed in a completion handler that will get executed depending on the returned Result from Persistence manager.
     * Retrieved remarks are then assigned into remarksViewModelList for usage within the application.
     */
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
    
    /**
     * Accesses our Persistence manager to add a remark based on the RemarkViewModel object.
     * A Remark object is created from the view model object and subsequently passed into the Persistence Manager for processing
     */
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
    
    /// Returns the Remark ViewModel list populated from retrieving the remarks
    func getAllRemarks() -> [RemarkViewModel] {
        return remarkViewModelList
    }
    
    /// Returns a filtered Remarks View Model List that is populated based on the search string from the Search Controller
    func getFilteredRemarks() -> [RemarkViewModel] {
        return filteredRemarkViewModelList
    }
    
    /// Easy access to Remark's count
    func remarksCount() -> Int {
        return remarkViewModelList.count
    }
    
    /// Get the remarks object based on the coordinate from Map View
    func getRemark(on coordinate: CLLocationCoordinate2D) -> RemarkViewModel? {
        guard self.remarkViewModelList.isEmpty else {
            return remarkViewModelList.filter { $0.coordinate == coordinate }.first
        }
        return nil
    }
    
    /**
     * Process text parameter and filter our title and notes if the text is found.
     *
     * - Parameters:
     *      - text: String that is being searched from our list of Remarks.
     */
    func filterRemark(having text: String) {
        // We filter the title first based on the passed text
        var titleFiltered = remarkViewModelList.filter {
            $0.title.lowercased().contains(text.lowercased())
        }
        
        // we then filter the note based on the text
        let noteFiltered = remarkViewModelList.filter {
            $0.note.lowercased().contains(text.lowercased())
        }
        
        // Anything that is duplicate is removed from our final filtered list to prevent
        // a unique object issue when creating a snapshot of our datasource for display
        titleFiltered.append(contentsOf: noteFiltered.filter({
            !titleFiltered.contains($0)
        }))
        
        filteredRemarkViewModelList =  titleFiltered
    }
    
    /// Make our filtered remark be equal to our main remarks list. For resetting elements in the filtered lists
    func resetFilteredRemarks() {
        filteredRemarkViewModelList = remarkViewModelList
    }
}
