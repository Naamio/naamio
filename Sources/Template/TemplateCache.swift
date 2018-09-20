import Malline

/// Single reference matching a `Stencil` to a `Path` for in-memory caching of 
/// templates.
struct TemplateCache {
    /// Stores the rendered template as a `Stencil`.
    var stencil: Stencil

    /// Stores the path of the original template file.
    var path: Path
}