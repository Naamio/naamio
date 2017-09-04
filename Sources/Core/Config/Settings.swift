public struct Settings {
    /// Mode at which the server is running. Useful for 
    /// development purposes as the server can be used as
    /// an instant feedback agent whilst designing and developing
    /// aspects of an application.
    public var mode: RunMode = .development

    public var logs = "/var/log/naamio.log"

    lazy public var api = APIConfiguration()

    lazy public var web = WebConfiguration()

}