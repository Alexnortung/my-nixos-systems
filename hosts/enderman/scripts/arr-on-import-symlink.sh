set -e

# If the environment variable is not set, exit
if [ -z "$sonarr_episodefile_path" ]; then
  echo "sonarr_episodefile_path is not set"
  exit 0
fi

if [ -z "$sonarr_episodefile_sourcepath" ]; then
  echo "sonarr_episodefile_sourcepath is not set"
  exit 0
fi

# Delete file in download client
# Make a symlink where the download client expects the file to be to the file in the media library

rm -f "$sonarr_episodefile_sourcepath"
ln -s "$sonarr_episodefile_path" "$sonarr_episodefile_sourcepath"
