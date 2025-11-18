import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension Optional {

  var asSequence: [Wrapped] {
    self.map { [$0] } ?? []
  }

  func filter(_ condition: (Wrapped) -> Bool) -> Self {
    switch self {
    case .some(let wrapped) where condition(wrapped): wrapped
    default: nil
    }
  }

  func getOrElse(_ wrapped: Wrapped) -> Wrapped {
    self ?? wrapped
  }
}
