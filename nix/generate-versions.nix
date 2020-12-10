{ channels ? [ "20.09" "20.03" ] # "19.09" "19.03" "18.03" ] # "17.03" "16.03" "15.09" "14.12" "14.04" ]
, nixpkgs
, system
, args ? { inherit system; }
}: let
  pkgs = import nixpkgs args;
  lib = pkgs.lib;

  # pkgInfo = channel: attrName: pkg:
  #   if (builtins.hasAttr attrName pkgs) && (pkg ? name)
  #   then
  #     let
  #       parsedName = builtins.parseDrvName pkg.name;
  #     in {
  #       inherit channel attrName;
  #       pkgName = parsedName.name;
  #       version = parsedName.version;
  #     }
  #   else null;

  # pkgInfosForChannel = channel:
  #   let
  #     channelPkgs = (import (builtins.fetchTarball "channel:nixos-${builtins.toString channel}") args).pkgs;
  #   in
  #     builtins.filter
  #       (x: x != null)
  #       (
  #         lib.mapAttrsToList
  #         (pkgInfo channel)
  #         channelPkgs
  #       );

  pkgMeta = channel: attrName: pkg:
    let
      evName = builtins.tryEval pkg.name or null;
      parsedName = builtins.parseDrvName evName.value;
    in
      if evName.success && evName.value != null
      then {
        pkgName = parsedName.name;
        version = parsedName.version;
        inherit channel attrName;
      }
      else null;

  channelPkgs = channel:
    (import (builtins.fetchTarball "channel:nixos-${builtins.toString channel}") args).pkgs;

  channelPkgMetas = channel:
    builtins.filter
      (x: x != null)
      (lib.mapAttrsToList (pkgMeta channel) (channelPkgs channel));

  allPkgMetas =
    lib.lists.concatMap channelPkgMetas channels;

  # allPkgNames = lib.list.unique (lib.lists.concatMap channelPkgNames channels);


  # channelPkgInfos = channel:
  #   let
  #     channelPkgs = (import (builtins.fetchTarball "channel:nixos-${builtins.toString channel}") args).pkgs;
  #   in
  #     builtins.filter
  #       (x: x != null)
  #       (
  #         lib.mapAttrsToList
  #         (pkgInfo channel)
  #         channelPkgs
  #       );

  # allPkgs = lib.lists.concatMap channelPkgInfos channels;
in
  #lib.groupBy (x: x.pkgName) allPkgs
  # (builtins.listToAttrs (channelPkgInfos "20.09")).php-with-extensions
  # builtins.listToAttrs pkgInfoForAllChannels allPkgNames
  # channelPkgMetas "20.09"



  # lib.mapAttrs
  #   (key: map (x: x.value))
  #   (
  #     lib.groupBy (x: x.key) (
  #       (map (x: { key = x.pkgName; value = x; }) allPkgMetas) ++
  #       (map (x: { key = x.attrName; value = x; }) allPkgMetas)
  #     )
  #   )

  lib.mapAttrs (name: value: (builtins.tryEval value.name or false).value) (channelPkgs "20.09")

#   getPkg = name: channel: let
#     pkgs = getSet channel;
#     pkg = pkgs.${name};
#     version = (builtins.parseDrvName pkg.name).version;
#   in if builtins.hasAttr name pkgs && pkg ? name then {
#     inherit version channel;
#     pkgName = lib.getName pkg;
#     attrName = name;
#   } else null;

# in builtins.listToAttrs (map (name: {
#   inherit name;
#   value = (
#     builtins.filter (x: x != null)
#       (map (getPkg name) channels)
#   );
# }) attrs)
