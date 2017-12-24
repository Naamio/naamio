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

## Command-line Configuration

To run Naamio with a single invocation, whilst still using the environment
variable method of configuration, it is recommended you run the following:

```
    $ env NAAMIO_PORT='8090' \
    $     bash -c 'Naamio'  
    # The environment variable NAAMIO_PORT will be set to 8090, at the time
    # of invocation via bash. 
```

## Configuration File

# Docker

We prefer to invoke **Naamio** via **Docker**. In fact, this is how we run 
**Naamio** in development, test, staging, and live environments, and have 
[our own **Docker** image](https://hub.docker.com/r/naamio/naamio/) for this 
very purpose. You can either use our image as-is, or you can extend it and 
customize it as you see fit.

## Kubernetes

```
    $ naamio --theme <theme-path>
    # Naamio will load with a specific theme from the <theme-path> folder.

    $ naamio --source <source>
    # The <source> folder will be loaded rather than the relative folder. 

    $ naamio --watch
    # The current site will load, but will continuously look for changes and 
    # hot load them for immediate testing.
```
