import Foundation
import SerializedSwift

public class RawUUIDWithValue: RawUUID {
    @Serialized
    public var newValue: Int
}
