Shell-ShellNS-Types
================================

> [Aeon Digital](http://www.aeondigital.com.br)  
> rianna@aeondigital.com.br

&nbsp;

``ShellNS Types`` brings a systematization to simulate types in a shell
environment. The package has a series of validators and the documentation above
explains its use and basic concepts.  


&nbsp;
&nbsp;

________________________________________________________________________________

## Main

After downloading the repo project, go to its root directory and use one of the 
commands below

``` shell
# Loads the project in the context of the Shell.
# This will download all dependencies if necessary. 
. main.sh "run"



# Installs dependencies (this does not activate them).
. main.sh install

# Update dependencies
. main.sh update

# Removes dependencies
. main.sh uninstall




# Runs unit tests, if they exist.
. main.sh utest

# Runs the unit tests and stops them on the first failure that occurs.
. main.sh utest 1



# Export a new 'package.sh' file for use by the project in standalone mode
. main.sh export


# Exports a new 'package.sh'
# Export the manual files.
# Export the 'ns.sh' file.
. main.sh extract-all
```

&nbsp;
&nbsp;


________________________________________________________________________________

## Standalone

To run the project in standalone mode without having to download the repository 
follow the guidelines below:  

``` shell
# Download with CURL
curl -o "shellns_types_standalone.sh" \
"https://raw.githubusercontent.com/AeonDigital/Shell-ShellNS-Types/refs/heads/main/standalone/package.sh"

# Give execution permissions
chmod +x "shellns_types_standalone.sh"

# Load
. "shellns_types_standalone.sh"
```


&nbsp;
&nbsp;

________________________________________________________________________________

## Documentation

Essentially, Bash variables are character strings, but, depending on context,
Bash permits arithmetic operations and comparisons on variables.
therefore, to simulate different types, follow the guidelines below.

- [Primitive Types](docs/01.1%20Primitive%20Types.md)
- [Date and Time Types](docs/01.2%20Date%20and%20Time%20Types.md)
- [File System Types](docs/01.3%20File%20System%20Types.md)
- [Objects and Codes](docs/01.4%20Objects%20and%20Codes.md)
- [Return Types](docs/02.0%20Return%20Types.md)
- [Special Rules](docs/03.0%20Special%20Rules.md)
- [Expanding Types](docs/04.0%20Expanding%20Types.md)

&nbsp;

The functions of all ShellNS libraries are decorated with information that can 
be used by parsers capable of providing filling hints and other features. 
To learn how to write your own documentation that is compatible with the 
standard you use, read the following section:

- [Shell Docs](docs/05.0%20Shell%20Docs%20Section.md)
- [Parameters Section](docs/05.1%20Parameters%20Section.md)
- [Return Section](docs/05.2%20Return%20Section.md)

&nbsp;
&nbsp;


________________________________________________________________________________

## Licence

This project uses the [MIT License](LICENCE.md).