import Foundation
import Fluent

extension Order {
    func startProcessing(database: Database) {
        Task.detached {
            let group = DispatchGroup()
            
            group.enter()
            self.switchProgress(database: database, on: .inProgress)
            group.leave()
            self.switchProgress(database: database, on: .ready)
        }
    }
    
    private func switchProgress(database: Database, on state: Status) {
        DispatchQueue.main.asyncAfter(
            deadline: .now() + DispatchTimeInterval.seconds(state.interval)
        ) { [self] in
            Task {
                status = state
                try await save(on: database)
            }
        }
    }
}
