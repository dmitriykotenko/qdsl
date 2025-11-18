import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Enum cases

extension q {
  
  /// `case name`
  @inlinable @inline(__always)
  public static func `case`(_ name: String) -> DeclSyntax {
    DeclSyntax(case2(name))
  }

  @inlinable @inline(__always)
  public static func case2(_ name: String) -> EnumCaseDeclSyntax {
    EnumCaseDeclSyntax(
      caseKeyword: .keyword(.case),
      elements: EnumCaseElementListSyntax([
        EnumCaseElementSyntax(name: q.tok.id(name))
      ])
    )
  }

  /// `case name1, name2, ...`
  @inlinable @inline(__always)
  public static func cases(_ names: String...) -> DeclSyntax {
    DeclSyntax(
      EnumCaseDeclSyntax(
        caseKeyword: .keyword(.case),
        elements: EnumCaseElementListSyntax(
          names.enumerated().map { index, name in
            EnumCaseElementSyntax(
              name: q.tok.id(name),
              trailingComma: index < names.count - 1 ? .commaToken(trailingTrivia: .space) : nil
            )
          }
        )
      )
    )
  }

  /// `case name(AssociatedType, ...)`
  @inlinable @inline(__always)
  public static func `case`(_ name: String,
                            parameterTypes: [TypeSyntax]) -> DeclSyntax {
    self.case(
      name,
      parameters: parameterTypes.map { EnumCaseParameterSyntax(firstName: nil, type: $0) }
    )
  }

  /// `case name(AssociatedType, ...)`
  @inlinable @inline(__always)
  public static func `case`(_ name: String,
                            parameters: [EnumCaseParameterSyntax]) -> DeclSyntax {
    DeclSyntax(
      case2(name, parameters: parameters)
    )
  }

  /// `case name(AssociatedType, ...)`
  @inlinable @inline(__always)
  public static func case2(_ name: String,
                           parameters: [EnumCaseParameterSyntax] = []) -> EnumCaseDeclSyntax {
    case2(_token(name), parameters: parameters)
  }

  /// `case name(AssociatedType, ...)`
  @inlinable @inline(__always)
  public static func case2(_ name: TokenSyntax,
                           parameters: [EnumCaseParameterSyntax] = []) -> EnumCaseDeclSyntax {
    EnumCaseDeclSyntax(
      caseKeyword: .keyword(.case),
      elements: EnumCaseElementListSyntax([
        EnumCaseElementSyntax(
          name: name,
          parameterClause: parameters.isEmpty ? nil : EnumCaseParameterClauseSyntax(
            leftParen: .leftParenToken(),
            parameters: EnumCaseParameterListSyntax(
              parameters.enumerated().map { index, parameter in
                parameter.with(
                  \.trailingComma, parameters.trailingComma(forIndex: index)
                )
              }
            ),
            rightParen: .rightParenToken()
          )
        )
      ])
    )
  }
}
