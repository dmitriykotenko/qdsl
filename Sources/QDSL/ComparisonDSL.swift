import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


infix operator ^>: AssignmentPrecedence

extension ExprSyntax {

  @inlinable @inline(__always)
  public static func ^> (this: ExprSyntax,
                          that: ExprSyntax) -> ExprSyntax {
    ExprSyntax(
      SequenceExprSyntax {
        this
        ExprSyntax(BinaryOperatorExprSyntax(
          leadingTrivia: .space,
          operator: .rightAngleToken(),
          trailingTrivia: .space
        ))
        that
      }
    )
  }
}
