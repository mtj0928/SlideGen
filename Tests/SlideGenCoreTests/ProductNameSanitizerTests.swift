import Testing
import SlideGenCore

@Suite
struct ProductNameSanitizerTests {

    @Test
    func makeIdentifierReplacesInvalidCharactersWithUnderscore() {
        #expect(ProductNameSanitizer.makeIdentifier(from: "foo-bar") == "foo_bar")
        #expect(ProductNameSanitizer.makeIdentifier(from: "Slide Deck") == "Slide_Deck")
    }

    @Test
    func makeIdentifierPrefixesLeadingDigits() {
        #expect(ProductNameSanitizer.makeIdentifier(from: "123Deck") == "_123Deck")
    }

    @Test
    func makeIdentifierHandlesEmptyResult() {
        #expect(ProductNameSanitizer.makeIdentifier(from: "") == "_")
    }
}
