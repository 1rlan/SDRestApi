import Vapor

public struct InvalidResponseData {
    public init(with problem: Invalidated, status: UInt = 406) {
        self.status = status
        self.problem = problem
    }
    
    public var status: UInt
    public var problem: Invalidated
    
    public var abort: Abort {
        Abort(
            .custom(
                code: status,
                reasonPhrase: problem.errorMessage
            )
        )
    }
}
