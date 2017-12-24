# Basic Usage
The `Naamio` executable is immediately available in your Terminal window.
It is preferable to set the configuration either in-file, or via 
environment variables. 

As Naamio attempts to establish a sensible configuration based on its 
environment, minimal settings should need to be configured manually, 
however, for more complex or unique installations, a configuration
file may be preferred.

Command-line parameters are not supported at length as it is generally
considered bad practice to pass settings into the executable at the time
of invocation.

```
    $ naamio --theme <theme-path>
    # Naamio will load with a specific theme from the <theme-path> folder.

    $ naamio --source <source>
    # The <source> folder will be loaded rather than the relative folder. 

    $ naamio --watch
    # The current site will load, but will continuously look for changes and 
    # hot load them for immediate testing.
```
