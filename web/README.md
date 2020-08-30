# web #

This folder contains files to publish the US River Basins Information web application.
The website is implemented using the general OWF InfoMapper application,
which is a web application that provides access to maps and other content.

```
git-repos/
  owf-app-infomapper-ng/
    infomapper/
      src/
        assets/
          app/
  owf-infomapper-us/
    web/
      app-config.json             Application configuration file.
      content-pages/              Content pages that are referenced in the app-config.json.
      copy-to-infomapper.sh       Script to copy 'web' files to InfoMapper infomapper/src/assets.
      data-maps/                  Map configurations and supporting layers and time series files.
      img/                        Images for the application, such as used for map markers.
```

An attempt was made to use symbolic links to/from InfoMapper, but did not work on Windows.
Therefore a copy strategy is now being used.
menus and corresponding content.

Workflow commands in the main 'workflow' folder automate creation of map configuration files,
time series, and other content so that Info Mapper can display the content.

Content that is dynamically regenerated should be listed in `.gitgnore`.
Snapshots of published content can be saved in versioned website folders,
using the `version` defined in the `app-config.json` file.
For example, published websites on Amazon S3 have a complete list of data files.

**Because published content in the `dist` folder exist in the InfoMapper repository,
appropriate `.gitignore` settings must be are defined in both repositories to avoid committing dynamic content.**
