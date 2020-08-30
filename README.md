# owf-infomapper-us

OWF InfoMapper implementation for entire US.
See the deployed latest
[US River Basin Information](http://rivers.openwaterfoundation.org/us/country/latest/)
web application.

The application is similar to the
[owf-infomapper-poudre](https://github.com/OpenWaterFoundation/owf-infomapper-poudre)
repository, but with national-level datasets.
This prototype will be filled out to test large-scale implementation of the InfoMapper.

The following sections are included in this documentation:

* [Repository Contents](#repository-contents)
* [Application Menus and Corresponding Workflow](#application-menus-and-corresponding-workflow)
* [Development Environment](#development-environment)
	+ [Quick Start](#quick-start)
	+ [Development Tools](#development-tools)
	+ [InfoMapper Configuration](#infomapper-configuration)
* [Basin Hierarchy](#basin-hierarchy)
* [Maintainers](#maintainers)

--------------

## Repository Contents ##

The following folder structure is recommended for development.
Top-level folders should be created as necessary.
The following folder structure clearly separates user files (as per operating system),
development area (`owf-dev`), product (`InfoMapper-US`), repositories for product (`git-repos`),
and specific repositories for the product.
Repository folder names should agree with GitHub repository names.
Scripts in repository folders that process data should detect their starting location
and then locate other folders relative to the starting folder based on the following convention.

```
C:\Users\user\                                 User's home folder for Windows.
/c/Users/user/                                 User's home folder for Git Bash.
/cygdrive/C/Users/user/                        User's home folder for Cygwin.
/home/user/                                    User's home folder for Linux.
  owf-dev/                                     Work done on Open Water Foundation projects.
    InfoMapper-US/                             US River Basin Information website, using InfoMapper.
      ---- below here folder names should match exactly ----
      git-repos/                               Git repositories for the Angular portal web application software.
        owf-app-infomapper-ng/                 InfoMapper web application.
        owf-infomapper-us/                     Workflow files to process input for web application.
```

This repository contains the following:

```
owf-infomapper-us/             Files comprising the InfoMapper implementation for US River Basins.
  .git/                        Standard Git software folder for repository (DO NOT TOUCH).
  .gitattributes/              Standard Git configuration file for repository (for portability).
  .gitignore/                  Standard Git configuration file to ignore dynamic working files.
  build-util/                  Scripts to manage repository, as needed.
    git-check-prod.sh          Check whether need to push/pull any product repositories.
  web/                         Location of assembled website files created by workflow steps.
                               Will be copied to InfoMapper 'assets/app' folder.
  workflow/                    Command files and scripts to download and process data into maps
                               and other information products.  Folders match menu organization.
```

## Application Menus and Corresponding Workflow ##

The web application provides menus, which display context-specific maps, as follows.
The README for each product provides information about data sources and workflow processing.

| **Menu** | **README** | **Description** |
| -- | -- | -- |
| ***InfoMapper Basins*** | | List of basins where InfoMapper has been implemented. |
| ***Current Conditions /*** | ===========| ===============================|
| ***Environment - Wildfires*** | [README](workflow/CurrentConditions/Environment-Wildfires/doc/README.md) | Current wildfires. |

## Development Environment ##

This section provides an overview of the development environment.

### Quick Start ###

Do the following to set up a new US River Basins Information development environment,
assuming that development tools are installed.
See the next section for more information about installing necessary tools.
**The following approach copies website content from `owf-infomapper-us` repository
into the the `owf-app-infomapper-ng/infomapper/src/assets/app` folder.
It should be possible to use a symbolic link rather than copy, but this has not worked on Windows.
Linux developers may have more success.  See the
[Poudre Basin Information README](https://github.com/OpenWaterFoundation/owf-infomapper-poudre)
for more information.**

1. On windows, create a folder `C:\Users\user\owf-dev\InfoMapper-US\git-repos`,
as per the [Repository Contents](#repository-contents) section above.
An alternate parent folder is OK as long as the `git-repos` folder exists.
2. Typically, start a Git Bash or Cygwin terminal for development.  Command line scripts are run to process and copy files.
3. In the above folder `git-repos`, clone the repository:  `git clone https://github.com/OpenWaterFoundation/owf-infomapper-us.git`
4. In the resulting `owf-infomapper-us` repository folder, change to `build-util`.
5. Clone other related repositories, including InfoMapper software:  `./git-clone-all-prod.sh`
6. Update the InfoMapper working files:
	1. Change to the `git-repos/owf-app-infomapper-ng/infomapper` folder.
	2. Install needed modules:  `npm install`
	3. **Do not run `npm audit fix`**, which can unexpectedly change Angular packages and cause errors building the software.
	The development team will work to update packages as time allows.
	Options used with `npm audit` may be appropriate but have not been tested.
	4. Test: `ng serve --open`.
	The application should display in a browser with tab title ***InfoMapper***,
	which is the default when content is not available.
7. Create and test the US River Basin Information application content:
	1. Use the GeoProcessor and TSTool programs to run the command files in the
	`git-repos/owf-infomapper-us/workflow` folder
	to create and assemble content in the `web/` folder.
	**Automated execution of all steps together will be implemented at some point but for use the software user interfaces,
	which is also helpful to check for workflow errors.**
	2. Run the `git-repos/owf-infomapper-us/web/copy-to-infomapper.sh` script,
	which copies files in `web/` folder to the InfoMapper application files.
	3. In the `git-repos/owf-app-infomapper-ng/infomapper` folder, run `ng serve --open` to start the application server.
	The application should display in a browser with menu bar title ***US River Basin Information***.
	Additional file updates from repeating above steps will automatically be detected and displayed in the browser.
8. Publish the application to the web:
	1. Run the `owf-infomapper-us/build-util/copy-to-owf-amazon-s3.sh` script to copy the
	InfoMapper application and assets to the cloud.
	A temporary `dist` folder is used to build and package the files.
	A versioned and `latest` folder can be updated, where the version is taken from the application configuration file
	(`web/app-config.json`).
	See the deployed [latest US River Basin Information website](http://rivers.openwaterfoundation.org/us/country/latest/).

### Development Tools ###

The development environment for this repository depends on software tools used to process and view data,
including the following.  Install the software in normal default locations.

* Git client:
	+ For example "Git for Windows" (which provides Git Bash) or Cygwin git.
* InfoMapper - open source web application software to visualize data:
	+ See the [owf-app-infomapper-ng](https://github.com/OpenWaterFoundation/owf-app-infomapper-ng) repository for information.
	+ Currently must be cloned - will create an installer in the future.
	+ See [InfoMapper Configuration](#infomapper-configuration) section.
* GeoProcessor - open source software for spatial data processing:
	+ Automates download and processing of spatial data.
	+ Command files (`*.gp`) in `process` folders indicate how to process spatial data and are
	committed to the repository.
	+ See the [GeoProcessor download page](http://software.openwaterfoundation.org/geoprocessor/).
* QGIS - open source geographic information system:
	+ Install the "Standalone Installation" (rather than OSGeo4W suite)
	corresponding to the GeoProcessor version.
	+ QGIS can be used to review data and create preliminary project files (`*.qgs`) for prototype maps.
	+ See [OWF / Learn QGIS](http://learn.openwaterfoundation.org/owf-learn-qgis/) for information on installing QGIS.
* TSTool - open source software for time series processing:
	+ Automates download and processing of time series data.
	+ Command files (`*.TSTool`) in `process` folders indicate how to process time series data and are
	committed to the repository.
	* See the [TSTool download page](http://software.openwaterfoundation.org/)
	for installation information.
* R - open source statistics software:
	+ May be used for some information products.
* Python - open source scripting:
	+ Currently not used and will be installed automatically if necessary, such as with GeoProcessor.
	+ May be used for some information products in the future.

### InfoMapper Configuration ###

The InfoMapper is an Angular application, which expects run-time configuration and data files to be
located in `owf-app-infomapper-ng/infomapper/src/assets/app` repository working files.
The `assets/app-default/` folder that is distributed with the InfoMapper software will be used if
the `assets/app/` folder is not found or there is a major error initializing the application,
and is used to confirm basic application configuration.

Because the InfoMapper is a general application,
specific configuration and data for this US River Basin Information project cannot live in the InfoMapper repository.
The following approach is recommended to provide custom configuration and data to the InfoMapper.
Symbolic links could be used but has proven to be a challenge on Windows.
Developers working on Linux may be able to use a symbolic link approach
(see the [Poudre Basin Information README](https://github.com/OpenWaterFoundation/owf-infomapper-poudre) for more option).

Copy files from the implementation repository to the InfoMapper `assets/app` folder:
* This is typically be done with the `web/copy-to-infomapper.sh` script,
either using brute force to copy entire folder trees,
or with options for selective copies.
* The downside is that files, perhaps many files, may need to be repeatedly copied as they are modified,
which can be slow and will require additional disk space.
However, experience has shown that file copies are typically fast.
* **This option is currently recommended on Windows because it does not require special configuration
for windows to enable symbolic links, and because symbolic links on Windows do not seem to
work properly with Angular.**  The previous section describes using this approach.

## Basin Hierarchy ##

It is envisioned that InfoMapper applications may be implemented for multiple basins at different scales.
The following is a draft map of basins and corresponding URLs,
where `version` is either a specific version (e.g., `0.1.0`) or `latest`,
which allows for flexibility in updating software and configuration.

| **Basin** | **URL** |
| -- | -- |
| Entire US | `/us/country/version/#/...` |
| Colorado South Platte Basin | `/us/co/southplatte/version/#/...` |
| Colorado Poudre Basin | `/us/co/southplatte/poudre/version/#/...` |

## Maintainers ##

This repository is maintained by Open Water Foundation staff.
