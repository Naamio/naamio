import Foundation

/// Errors which occur during rendering of the templates.
public enum NaamioTemplateEngineError: Error {
    /// Thrown if the `rootPath` property is empty.
    case rootPathsEmpty

    /// Thrown if the template is not valid.
    case notValidTemplate

    /// Thrown if the serialized JSON cannot be converted into a `Dictionary`.
    case unableToSerializeToDictionary

    /// Thrown if there's not key available for the type.
    case noKeyProvidedForType(value: Encodable)

    /// Thrown if the value cannot be encoded.
    case unableToEncodeValue(value: Encodable)
}