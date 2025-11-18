import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Trailing-closure literals

extension q {

  /// `{ (p1, p2, ...) in ... }`
  @inlinable @inline(__always)
  public static func closure(captures: [ClosureCaptureSyntax] = [],
                             params: [String],
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    closure(
      captures: captures,
      params: params.map { q.tok.id($0) },
      body: body
    )
  }

  /// `{ (p1, p2, ...) in ... }`
  @inlinable @inline(__always)
  public static func closure(captures: [ClosureCaptureSyntax] = [],
                             params: String...,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    closure(
      captures: captures,
      params: params.map { q.tok.id($0) },
      body: body
    )
  }

  /// `{ (p1, p2, ...) in ... }`
  @inlinable @inline(__always)
  public static func closure(captures: [ClosureCaptureSyntax] = [],
                             params: [TokenSyntax],
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    ClosureExprSyntax(
      signature: (captures.isEmpty && params.isEmpty) ? nil :
        ClosureSignatureSyntax(
          leadingTrivia: .space,
          capture: captures.isEmpty ? nil : .init(items: .init(
            captures.enumerated().map {
              $1.with(\.trailingComma, captures.trailingComma(forIndex: $0))
            }
          )),
          parameterClause: params.isEmpty ? nil : .parameterClause(
            ClosureParameterClauseSyntax(
              parameters: ClosureParameterListSyntax(
                params.enumerated().map { i, name in
                  ClosureParameterSyntax(
                    firstName: name,
                    colon: nil,
                    trailingComma: params.trailingComma(forIndex: i)
                  )
                }
              )
            )
          ).with(\.trailingTrivia, .space),
          inKeyword: .keyword(.in),
          trailingTrivia: .newline
        ),
      statements: CodeBlockItemListSyntax(body()).with(\.trailingTrivia, .newline)
    )
  }

  /// `{ (p1, p2, ...) in ... }`
  @inlinable @inline(__always)
  public static func closure(captures: [ClosureCaptureSyntax] = [],
                             params: TokenSyntax...,
                             @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
    closure(captures: captures, params: params, body: body)
  }
}

@inlinable @inline(__always)
public func _captured(_ specifier: ClosureCaptureSpecifierSyntax? = nil,
                                 _ name: TokenSyntax) -> ClosureCaptureSyntax {
  .init(
    specifier: specifier,
    name: name
  )
}

public enum c {

  public static let weak = fromKeyword(.weak)
  public static let unowned = fromKeyword(.unowned)

  private static func fromKeyword(_ keyword: Keyword) -> ClosureCaptureSpecifierSyntax {
    .init(specifier: .keyword(keyword), trailingTrivia: .space)
  }
}

/// `{ (p1, p2, ...) in ... }`
@inlinable @inline(__always)
public func _closure(captures: [ClosureCaptureSyntax] = [],
                                params: String...,
                                @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
  q.closure(captures: captures, params: params, body: body)
}


@inlinable @inline(__always)
public func _closure(captures: [ClosureCaptureSyntax] = [],
                                params: TokenSyntax...,
                                @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
  q.closure(captures: captures, params: params, body: body)
}


@inlinable @inline(__always)
public func _closure(captures: [ClosureCaptureSyntax] = [],
                                @qstmts body: () -> [CodeBlockItemSyntax]) -> ClosureExprSyntax {
  q.closure(captures: captures, params: [String](), body: body)
}
