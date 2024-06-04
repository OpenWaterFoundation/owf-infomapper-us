#!/bin/bash

# Copy  files to 'infomapper/src/assets/app' folder.
# Brute force way to provide content to InfoMapper and version control.
# A better way would be to symbolically link InfoMapper 'app' to this `web` folder,
# but that does not seem to work.
# Folder for this script is similar to:
#   /c/Users/user/owf-dev/InfoMapper-CO-Clear/git-repos/owf-infomapper-co-clear/web

# Supporting functions, alphabetized.

# Run the watcher for each major folder:
# - only include folders and files that should be copied
runWatcher() {
  # Wait time between file modification time checks.
  waitSeconds=60
  cd ${scriptFolder}
  while [ "1" = "1" ]; do
    # Find all files in the development folder:
    # - include folders that need to be copied
    # - exclude folders and files that don't need to be copied
    # - exclude time series for now because there are many and it takes a long time to check
    #   (time series will soon be in a dataset and not in assets so this will get better)
    # The output of find will start with:  ./
    find . -type f | grep -v "/ts/" | grep -v ".swp" | grep -v ".log" | grep -v "/downloads/" | grep -E "./app-config.json|./content-pages/|./dashboards/|./data-maps/|./img/|./system/" | while read devFilePath; do
      #echo "Checking dev file: ${devFilePath}"
      # Get the modification time for the development file.
      devFileTime=$(date -r ${devFilePath} "+%s")
      if [ -z "${devFileTime}" ]; then
        # For some reason, the process sometimes does not return a result on Git Bash (process died?).
        echo "Could not get time for dev file: ${devFilePath}"
        continue
      fi
      # Get the modification time for the asset file.
      assetFilePath="${appFolder}/${devFilePath}"
      # Default is not to copy.
      doCopy="false"
      if [ -f "${assetFilePath}" ]; then
        # Asset file does exist so compare the modification times.
        assetFileTime=$(date -r ${assetFilePath} "+%s")
        if [ -z "${assetFileTime}" ]; then
          # For some reason, the process sometimes does not return a result on Git Bash (process died?).
          echo "Could not get time for asset file: ${assetFilePath}"
          continue
        fi
        #echo "devFileTime=${devFileTime} assetFileTime=${assetFileTime}"
        if [ ${devFileTime} -gt ${assetFileTime} ]; then
          doCopy="true"
        fi
      else
        # Asset file does not exist so need to copy.
        doCopy="true"
      fi
      if [ "${doCopy}" = "true" ]; then
        echo "Updating asset file: ${assetFilePath}"
        cp "${devFilePath}" "${assetFilePath}"
      fi
      #echo "Done checking dev file: ${devFilePath}"
    done
    # Sleep until the next check.
    echo "Sleeping ${waitSeconds} seconds before next check.  Use Ctrl-c to kill the program."
    sleep ${waitSeconds}
  done
}

# Entry point into script.

scriptFolder=$(cd $(dirname "$0") && pwd)
repoFolder=$(dirname ${scriptFolder})
gitReposFolder=$(dirname ${repoFolder})
infoMapperRepoFolder=${gitReposFolder}/owf-app-infomapper-ng
infoMapperFolder=${infoMapperRepoFolder}/infomapper
appFolder=${infoMapperFolder}/src/assets/app

echo "Folders for the application:"
echo "  scriptFolder=${scriptFolder}"
echo "  repoFolder=${repoFolder}"
echo "  gitReposFolder=${gitReposFolder}"
echo "  infoMapperRepoFolder=${infoMapperRepoFolder}"
echo "  infoMapperFolder=${infoMapperRepoFolder}"
echo "  appFolder=${appFolder}"

# Run the watcher.
runWatcher

exit 0
