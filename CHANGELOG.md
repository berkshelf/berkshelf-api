# 1.1.0

* Enhancements
  * Added Github cache builder and Github endpoint. You can now add Github organization's as endpoints and the cache builder will crawl each repository looking for repositories which contain SemVer tags and raw cookbook metadata.

# 1.0.0

* Prioritize Cache Builders so their entries do not clobber one another
* An entire config file is checksumed so that when it changes, the cache is rebuilt
