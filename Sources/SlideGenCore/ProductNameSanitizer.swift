import Foundation

public enum ProductNameSanitizer {
    public static func makeIdentifier(from productName: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "_"))
        var identifier = String(productName.unicodeScalars.map { scalar -> Character in
            allowedCharacters.contains(scalar) ? Character(scalar) : "_"
        })

        if let first = identifier.first, first.isNumber {
            identifier = "_" + identifier
        }

        if identifier.isEmpty {
            identifier = "_"
        }

        return identifier
    }
}
