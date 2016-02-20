# 2.1.3
* Dependency updates

# 2.1.2
* Dependency updates

# 2.1.1

* Bug Fixes
  * Calling berks_dependency/2 rspec support function no longer results in a runtime crash
  * Failures when calling Supermarket.universe/0 will now return a hash instead of a boolean
  * Cookbook name, not repo name, will be used when caching Github cookbooks
  * Group/User will be created in proper order during cookbook converge

# 2.1.0

* Enhancements
  * Added --version flag for displaying version (alias -v)
  * Build interval for cache builder is now configurable

* Bug Fixes
  * Supermarket location_path was not correctly set

* Backwards incompatible changes
  * --verbose alias is now -V. Previously -v.

# 2.0.0

* Enhancements
  * Opscode Cache builder is now the Supermarket cache builder

* Bug fixes
  * API server will now be configured to run as API user instead of root
  * Fix issue where Berkshelf API user's home directory was not created

* Backwards incompatible changes
  * The Opscode cache builder was removed - the old community site is no longer a valid endpoint to cache

# 1.4.0

* Enhancements
  * Always return JSON to native HTTP clients
  * Listen host can now be passed to cli with the `-h` flag
  * berkshelf-api user will now be created as a system user
  * Update many dependent gems

* Bug fixes
  * Fix race condition when creating the user's home directory in cookbook
  * Gracefully handle results from the community site which are empty

* Backwards incompatible changes
  * Renamed cookbook from `berkshelf-api` to `berkshelf-api-server`

# 1.3.1

* Enhancements
  * Fix cookbook issue when installing on `> Ubuntu 12.04`

# 1.3.0

* Enhancements
  * Added warning messages to startup when using github/file_store endpoints
  * Bump Octokit dependency to ~> 3.0

* Bug Fix
  * Fixed issue with GH indexing where there were a high number of repositories in an organization

# 1.2.2

* Enhancements
  * Bump to Reel 0.5
  * Set Celluloid log level to ERROR

* Bug Fixes
  * Include full URL to Github location in items cached by Github builder

# 1.2.0

* Enhancements
  * Loosen constraints and bump versions of various gems

* Bug Fixes
  * Fix issue with default configuration where home path was not being set

# 1.1.1

* Enhancements
  * Added /status endpoint to REST API

* Bug Fixes
  * Github cache builder will autopaginate to get all repos
  * Fix dependency issues with Faraday

# 1.1.0

* Enhancements
  * Added Github cache builder and Github endpoint. You can now add Github organization's as endpoints and the cache builder will crawl each repository looking for repositories which contain SemVer tags and raw cookbook metadata.

* Bug Fixes
  * Fix cache builder crashes when builder encounters a cookbook with invalid or missing metadata.
  * Invalid cookbooks won't be added to cache.

# 1.0.0

* Prioritize Cache Builders so their entries do not clobber one another
* An entire config file is checksumed so that when it changes, the cache is rebuilt
