import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Defaults (= expr) as InitializerClauseSyntax

prefix operator ^=
infix operator ^==: AssignmentPrecedence
infix operator ^===: AssignmentPrecedence

@inlinable @inline(__always)
public prefix func ^= (value: ExprSyntax) -> InitializerClauseSyntax {
  InitializerClauseSyntax(equal: .equalToken(), value: value)
}


extension ExprSyntax {

  @inlinable @inline(__always)
  public static func ^=== (this: ExprSyntax,
                          that: ExprSyntax) -> ExprSyntax {
    q.e.assign2(this, that)
  }
}


extension FunctionParameterSyntax {

  @inlinable @inline(__always)
  public static func ^== (param: FunctionParameterSyntax,
                         value: ExprSyntax?) -> FunctionParameterSyntax {
    param.with(
      \.defaultValue,
       value.map { InitializerClauseSyntax(equal: .equalToken(), value: $0) }
    )
  }
}


extension EnumCaseParameterSyntax {

  @inlinable @inline(__always)
  public static func ^== (param: EnumCaseParameterSyntax,
                         value: ExprSyntax?) -> EnumCaseParameterSyntax {
    param.with(
      \.defaultValue,
       value.map { InitializerClauseSyntax(equal: .equalToken(), value: $0) }
    )
  }
}
