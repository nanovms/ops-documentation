Configuration
=============
The configuration file used by `ops` specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follow the standard json format.

### Configuration Attributes

#### Files {#files}
An array of file locations to include into the image

```json
{
    "Files": ["ex.js"]
}
```

#### Dirs {#dirs}
An array of directory locations to include into the image

```json
{
    "Dirs": ["src"]
}
```

#### Args {#args}
The command to execute when running the image. The expected format is an
array. See sample below for an example.

```json
{
    "Args": ["ex.js"]
}
```

#### Env {#env}
A dictionary/object of environment variables.

```json
{
    "Env": {
        "Environment": "development",
        "NODE_DEBUG": "*"
    }
}
```

### Sample Configuration File {#sample}
Below is a sample configuration file for a nodejs application.

```json
{
	"Files": ["ex.js"],
    "Dirs": ["src"],
	"Args": [""ex.js"],
	"Env": {
		"NODE_DEBUG": "*",
		"NODE_DEBUG_NATIVE": "*"
	},
	"RunConfig": {
		"Memory": "2G"
	}
}
```
