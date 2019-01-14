Configuration
=============
The configuration file used by `ops` specifies various options and attributes
of code execution, such as files to include, arguments, and environment
variables. This file follow the standard json format.

## Configuration Attributes

### Files
An array of file locations to include into the image

### Dirs
An array of directory locations to include into the image

### Args
The command to execute when running the image. The expected format is an
array. See sample below for an example.

### Env
A dictionary/object of environment variables.


### Sample Configuration File
Below is a sample configuration file for a nodejs application.

```json
{
	"Files": ["ex.js"],
    "Dirs": ["src"],
	"Args": ["node", "ex.js"],
	"Env": {
		"NODE_DEBUG": "*",
		"NODE_DEBUG_NATIVE": "*"
	},
	"RunConfig": {
		"Memory": "2G"
	}
}
```
