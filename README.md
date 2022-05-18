# ff-vdr-elec build system providing VDR for CoreELEC
This is the build system providing a **F**ull-**F**eatured VDR for CoreELEC.

This VDR distribution is based on the idea of using Kodi as a package manager for installation and automatic software update distribution since the CoreELEC does not include a full package manager.

## How to build the addons

- First install the CoreELEC build system according to [CoreELEC build-system](https://wiki.coreelec.org/coreelec:build_ce). \
Follow the description until including step `Switching between versions`. \
Select a git tag that corresponds to a offical CoreELEC image e.g. `git checkout 19.4-Matrix`

- Clone this repository using a directory outside the CoreELEC build system directory.

- To configure the build create a options file in your home directory `~/.ff-vdr-elec-options`. \
Look into  `ff-vdr-elec/config.sh` file for the available configuration variables and default values. \
Define all variables in your options file which should have different values.

- The file `ff-vdr-elec/addon_build_list` contains all the available addons that could be build. \
If you want to have your own collection of addons make a copy of this file and apply your desired changes using the copy. \
Set variable `FF_VDR_ADDON_BUILD_LIST` to the path of your new addon build list file.

- Execute `ff-vdr-elec/prepare_build_env.sh` script. \
This script apply's nessesary patches to the CoreELEC build system. \
If you want to update the CoreELEC build system or switch to different git tag do a `git reset --hard` inside the CoreELEC build system directory before you apply your desired changes. \
Then execute the `ff-vdr-elec/prepare_build_env.sh` script again.

- Execute `ff-vdr-elec/build.sh` script. \
Without argument it build's all the addons according to the addon build list. \
You can build a single addon providing the id of the addon as an argument. \
After a successful build you will find the resulting installable addon zip files in den CoreELEC build directory under `target/` directory.

## How to populate a kodi addon repository

The Ingredients for a Kodi Repository see [Kdoi Add-on repositories](https://kodi.wiki/view/Add-on_repositories). \
You can use a `github` project with `ghpages` enabled as infrastructur for your own repository.

You can populate and maintain your own kodi addon repository by using the provided `ff-vdr-elec/update_repository.sh` script. \
It has support for deploying a repository to a `github` project allmost automatically.

