#!/bin/bash

baseName="bestretail"

inputDir=     # required
outputDir=    # required
inputManifest= #required 
versionFile=  # optional

while [ $# -gt 0 ]; do
  case $1 in
    -i | --input-dir )
      inputDir=$2
      shift
      ;;
    -o | --output-dir )
      outputDir=$2
      shift
      ;;
    -v | --version-file )
      versionFile=$2
      shift
      ;;
    * )
      echo "Unrecognized option: $1" 1>&2
      exit 1
      ;;
  esac
  shift
done

if [ ! -d "$inputDir" ]; then
  echo "missing input directory!"
  exit 1
fi

if [ ! -d "$outputDir" ]; then
  echo "missing output directory!"
  exit 1
fi

if [ -f "$versionFile" ]; then
  version=`cat $versionFile`
  baseName="${baseName}-${version}"
fi

inputWar=`find $inputDir -name '*.war'`
outputWar="${outputDir}/${baseName}.war"

echo "Renaming ${inputWar} to ${outputWar}"

cp ${inputWar} ${outputWar}

# copy the manifest to the output directory and process it
outputManifest=$outputDir/manifest.yml

cp $inputManifest $outputManifest

# the path in the manifest is always relative to the manifest itself
sed -i -- "s|path: .*$|path: $artifactName|g" $outputManifest

if [ ! -z "$hostname" ]; then
  sed -i "s|host: .*$|host: ${hostname}|g" $outputManifest
fi

cat $outputManifest
