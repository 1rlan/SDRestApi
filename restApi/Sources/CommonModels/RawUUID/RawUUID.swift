import Vapor
import SerializedSwift

import DataValidation

public class RawUUID: Serializable {
    public required init() {}
    
    internal init(id: UUID) {
        self.id = id
    }
    
    @Serialized
    public var id: UUID
    
    public func abort(with problem: RawUUIDInvalid) -> Abort {
        InvalidResponseData(with: problem).abort
    }
}
