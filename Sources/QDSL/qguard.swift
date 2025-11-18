import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - guard

extension q {

  /// `guard <conditions> else { body }`
  public static func `guard`(_ conditions: ConditionElementSyntax...,
                             @qstmts else body: () -> [CodeBlockItemSyntax]) -> StmtSyntax {
    StmtSyntax(
      GuardStmtSyntax(
        guardKeyword: .keyword(.guard),
        conditions: ConditionElementListSyntax(conditions),
        elseKeyword: .keyword(.else),
        body: CodeBlockSyntax(statements: CodeBlockItemListSyntax(body()))
      )
    )
  }
}


extension q {
  
  public enum condition {

    /// `guard let name = value else { ... }`
    /// `if let name = value { ... }`
    @inlinable @inline(__always)
    public static func letBind(_ name: String,
                               _ value: ExprSyntax? = nil) -> ConditionElementSyntax {
      letBind(_token(name), value)
    }

    /// `guard let name = value else { ... }`
    /// `if let name = value { ... }`
    @inlinable @inline(__always)
    public static func letBind(_ name: TokenSyntax,
                               _ value: ExprSyntax? = nil) -> ConditionElementSyntax {
      ConditionElementSyntax(
        condition: .optionalBinding(
          OptionalBindingConditionSyntax(
            bindingSpecifier: .keyword(.let),
            pattern: PatternSyntax(IdentifierPatternSyntax(identifier: name)),
            initializer: value.map { ^=$0 }
          )
        )
      )
    }

    /// `guard condition else { ... }`
    /// `if condition { ... }`
    @inlinable @inline(__always)
    public static func boolean(_ expr: ExprSyntax) -> ConditionElementSyntax {
      ConditionElementSyntax(condition: .expression(expr))
    }
  }
}
