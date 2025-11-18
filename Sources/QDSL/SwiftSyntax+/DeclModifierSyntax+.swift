import SwiftCompilerPlugin
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


extension DeclModifierSyntax {

  var asMemberwiseInitVisibilityModifier: Self? {
    switch name.tokenKind {
    case .keyword(.open), .keyword(.public): .init(name: .keyword(.public))
    case .keyword(.internal), .keyword(.fileprivate): self
    case .keyword(.private): nil
    default: nil
    }
  }
}
