import SwiftSyntax
#if canImport(SwiftSyntaxBuilder)
import SwiftSyntaxBuilder
#endif


// MARK: - Arguments + labeled-arg operator

@inlinable @inline(__always)
public func qarg(_ expr: some ExprSyntaxProtocol,
                 comma: Bool = false) -> LabeledExprSyntax {
  LabeledExprSyntax(
    expression: expr,
    trailingComma: comma ? .commaToken(trailingTrivia: .space) : nil
  )
}

@inlinable @inline(__always)
public func qarg(_ label: String?,
                 _ expr: some ExprSyntaxProtocol,
                 comma: Bool = false) -> LabeledExprSyntax {
  qarg(
    label.map { q.tok.id($0) },
    expr,
    comma: comma
  )
}

@inlinable @inline(__always)
public func qarg(_ label: TokenSyntax?,
                 _ expr: some ExprSyntaxProtocol,
                 comma: Bool = false) -> LabeledExprSyntax {
  LabeledExprSyntax(
    label: label,
    colon: label == nil ? nil : .colonToken(trailingTrivia: .space),
    expression: expr,
    trailingComma: comma ? .commaToken(trailingTrivia: .space) : nil
  )
}

/// `"from" <- expr` → a labeled argument.
precedencegroup qLabelPrecedence { higherThan: AssignmentPrecedence }
infix operator <- : qLabelPrecedence
prefix operator <--

@discardableResult
@inlinable @inline(__always)
public func <- (label: String?,
                expr: some ExprSyntaxProtocol) -> LabeledExprSyntax { qarg(label, expr) }

@discardableResult
@inlinable @inline(__always)
public func <- (label: TokenSyntax?,
                expr: some ExprSyntaxProtocol) -> LabeledExprSyntax { qarg(label, expr) }

@discardableResult
@inlinable @inline(__always)
public prefix func <-- (expr: some ExprSyntaxProtocol) -> LabeledExprSyntax { qarg( expr) }

@discardableResult
@inlinable @inline(__always)
public func <- (label: TokenSyntax,
                type: TypeSyntax) -> FunctionParameterSyntax {
  q.funcParam(label, type)
}

@discardableResult
@inlinable @inline(__always)
public func <- (labels: (TokenSyntax, TokenSyntax),
                type: TypeSyntax) -> FunctionParameterSyntax {
  q.funcParam(labels.0, secondName: labels.1, type)
}

@discardableResult
@inlinable @inline(__always)
public func <- (label: TokenSyntax?,
                 type: TypeSyntax) -> EnumCaseParameterSyntax {
  q.enumParam(label, type)
}



@discardableResult
@inlinable @inline(__always)
public func <- (key: ExprSyntax,
                value: some ExprSyntaxProtocol) -> DictionaryElementSyntax {
  qdictionary_elements.element(key, value)
}
