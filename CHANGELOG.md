# master

* Enhancements
  *

* Bug Fixes
  *

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
