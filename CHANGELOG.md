# Change Log

## [Unreleased](https://github.com/berkshelf/berkshelf-api/tree/HEAD)

[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v2.2.0...HEAD)

**Merged pull requests:**

- Fix badges [\#219](https://github.com/berkshelf/berkshelf-api/pull/219) ([tas50](https://github.com/tas50))

## [v2.2.0](https://github.com/berkshelf/berkshelf-api/tree/v2.2.0) (2016-08-03)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/2.1.3...v2.2.0)

**Fixed bugs:**

- Ugly crash is build\_interval is string [\#184](https://github.com/berkshelf/berkshelf-api/issues/184)
- libarchive dependency  [\#167](https://github.com/berkshelf/berkshelf-api/issues/167)
- Can't process certain cookbooks [\#112](https://github.com/berkshelf/berkshelf-api/issues/112)

**Closed issues:**

- Need TK tests around the cookbook in this gem [\#215](https://github.com/berkshelf/berkshelf-api/issues/215)
- uninitialized constant Grape::Formatter::Base \(NameError\) [\#210](https://github.com/berkshelf/berkshelf-api/issues/210)
- gem install berkshelf-api fails [\#209](https://github.com/berkshelf/berkshelf-api/issues/209)
- NameError: uninitialized constant HTTP::Response::STATUS\_CODES [\#206](https://github.com/berkshelf/berkshelf-api/issues/206)
- Doesn't play nice with ChefDK 0.11.0 [\#205](https://github.com/berkshelf/berkshelf-api/issues/205)
- error retrieving universe  [\#203](https://github.com/berkshelf/berkshelf-api/issues/203)
- Cookbook fails to run. [\#198](https://github.com/berkshelf/berkshelf-api/issues/198)
- berkshelf api and chef server on same instance [\#197](https://github.com/berkshelf/berkshelf-api/issues/197)
- stack level too deep \(SystemStackError\) [\#196](https://github.com/berkshelf/berkshelf-api/issues/196)
- Unable to Install [\#193](https://github.com/berkshelf/berkshelf-api/issues/193)
- testsuit hangs with rspec 3.3 [\#192](https://github.com/berkshelf/berkshelf-api/issues/192)
- Memory leak  [\#191](https://github.com/berkshelf/berkshelf-api/issues/191)
- berkshelf-api-server cookbook does not work with latest libarchive 0.5 on Chef 11 [\#187](https://github.com/berkshelf/berkshelf-api/issues/187)
- Difficulty installing on CentOS \(Amazon AMI\) [\#186](https://github.com/berkshelf/berkshelf-api/issues/186)
- Cannot deploy berkshelf-api-server cookbook on Oracle Linux [\#185](https://github.com/berkshelf/berkshelf-api/issues/185)
- berks-api bails on start - NoMethodError: `new\_link' for nil:NilClass [\#169](https://github.com/berkshelf/berkshelf-api/issues/169)
- berkshelf-api breaks with ruby 2.x.x include in chefdk [\#163](https://github.com/berkshelf/berkshelf-api/issues/163)
- BerkshelfAPI setup fails if FQDN is not set [\#143](https://github.com/berkshelf/berkshelf-api/issues/143)

**Merged pull requests:**

- add some test-kitchen testing [\#218](https://github.com/berkshelf/berkshelf-api/pull/218) ([lamont-granquist](https://github.com/lamont-granquist))
- just force the default encoding [\#217](https://github.com/berkshelf/berkshelf-api/pull/217) ([lamont-granquist](https://github.com/lamont-granquist))
- fallback if fqdn is nil [\#216](https://github.com/berkshelf/berkshelf-api/pull/216) ([lamont-granquist](https://github.com/lamont-granquist))
- bump to rspec 3.5 [\#214](https://github.com/berkshelf/berkshelf-api/pull/214) ([lamont-granquist](https://github.com/lamont-granquist))
- bump all the deps [\#213](https://github.com/berkshelf/berkshelf-api/pull/213) ([lamont-granquist](https://github.com/lamont-granquist))
- Lock grape to the newest version that works with grape-msgpack [\#211](https://github.com/berkshelf/berkshelf-api/pull/211) ([danielsdeleo](https://github.com/danielsdeleo))

## [2.1.3](https://github.com/berkshelf/berkshelf-api/tree/2.1.3) (2016-02-20)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/2.1.1...2.1.3)

**Closed issues:**

- berks-api server fails to start [\#202](https://github.com/berkshelf/berkshelf-api/issues/202)
- Berkshelf Api keeps on resolving to cookbook with lower version [\#201](https://github.com/berkshelf/berkshelf-api/issues/201)
- berkshelf-api doesn't trust the system SSL CA bundle after 1.2.1 [\#194](https://github.com/berkshelf/berkshelf-api/issues/194)
- Awesome project [\#175](https://github.com/berkshelf/berkshelf-api/issues/175)

**Merged pull requests:**

- Loosening Octokit version constraint so it doesn't conflict with 4.0.1 of Berkshelf [\#200](https://github.com/berkshelf/berkshelf-api/pull/200) ([tyler-ball](https://github.com/tyler-ball))
- Bump octokit to 4.0 [\#199](https://github.com/berkshelf/berkshelf-api/pull/199) ([jkeiser](https://github.com/jkeiser))
- Update http gem verion [\#180](https://github.com/berkshelf/berkshelf-api/pull/180) ([MurgaNikolay](https://github.com/MurgaNikolay))
- Fix incorrect fetching cookbok's metadata [\#179](https://github.com/berkshelf/berkshelf-api/pull/179) ([gueux](https://github.com/gueux))
- Attribute for optional github token [\#178](https://github.com/berkshelf/berkshelf-api/pull/178) ([SIGUSR2](https://github.com/SIGUSR2))
- Modified chpst to su in init file [\#176](https://github.com/berkshelf/berkshelf-api/pull/176) ([BackSlasher](https://github.com/BackSlasher))

## [2.1.1](https://github.com/berkshelf/berkshelf-api/tree/2.1.1) (2015-01-14)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v2.1.1...2.1.1)

## [v2.1.1](https://github.com/berkshelf/berkshelf-api/tree/v2.1.1) (2015-01-14)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v2.1.0...v2.1.1)

**Fixed bugs:**

- Github worker uses repository name vs cookbook name [\#164](https://github.com/berkshelf/berkshelf-api/issues/164)

**Closed issues:**

- blacklist [\#173](https://github.com/berkshelf/berkshelf-api/issues/173)
- Empty cerch file after Failed to get `https://supermarket.getchef.com/universe.json' in 15 seconds! [\#170](https://github.com/berkshelf/berkshelf-api/issues/170)
- Can't upload cookbook with knife [\#162](https://github.com/berkshelf/berkshelf-api/issues/162)
- Berkshelf API won't build from cookbook [\#161](https://github.com/berkshelf/berkshelf-api/issues/161)

**Merged pull requests:**

- Fixes 170 [\#174](https://github.com/berkshelf/berkshelf-api/pull/174) ([reset](https://github.com/reset))
- Update github.rb [\#166](https://github.com/berkshelf/berkshelf-api/pull/166) ([berniedurfee](https://github.com/berniedurfee))
- Use provided group when creating user [\#160](https://github.com/berkshelf/berkshelf-api/pull/160) ([jossy](https://github.com/jossy))

## [v2.1.0](https://github.com/berkshelf/berkshelf-api/tree/v2.1.0) (2014-08-01)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v2.0.0...v2.1.0)

**Closed issues:**

- Machine sizing [\#156](https://github.com/berkshelf/berkshelf-api/issues/156)
- Optional Interval parameters for sleep amounts [\#155](https://github.com/berkshelf/berkshelf-api/issues/155)

**Merged pull requests:**

- Build cache Interval paremeterized  [\#158](https://github.com/berkshelf/berkshelf-api/pull/158) ([carpnick](https://github.com/carpnick))
- Add -V/--version to srv\_ctl. [\#153](https://github.com/berkshelf/berkshelf-api/pull/153) ([thorduri](https://github.com/thorduri))

## [v2.0.0](https://github.com/berkshelf/berkshelf-api/tree/v2.0.0) (2014-07-10)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.4.0...v2.0.0)

**Closed issues:**

- type: file\_store does not work [\#152](https://github.com/berkshelf/berkshelf-api/issues/152)
- berkshelf api and chef server on same instance [\#147](https://github.com/berkshelf/berkshelf-api/issues/147)
- Berks install from Berkshelf API causes NoMethodError: undefined method `cookbook' for nil:NilClass [\#146](https://github.com/berkshelf/berkshelf-api/issues/146)
- You have to install development tools first [\#145](https://github.com/berkshelf/berkshelf-api/issues/145)
- Why is the cookbook for berkshelf-api located inside of the berkshelf-api code and not maintained in its own repo? [\#144](https://github.com/berkshelf/berkshelf-api/issues/144)
- Can't install cookbooks from file\_store [\#141](https://github.com/berkshelf/berkshelf-api/issues/141)
- berkshelf-api-server 1.4.0 cookbook fails on multi\_json gem [\#139](https://github.com/berkshelf/berkshelf-api/issues/139)
- v1.4.0 cookbook asset is named incompatible to cookbook recipe [\#138](https://github.com/berkshelf/berkshelf-api/issues/138)
- Can't wrap the cookbook? [\#134](https://github.com/berkshelf/berkshelf-api/issues/134)
- Publish cookbook to Community site [\#127](https://github.com/berkshelf/berkshelf-api/issues/127)

**Merged pull requests:**

- Completely move to Supermarket [\#151](https://github.com/berkshelf/berkshelf-api/pull/151) ([sethvargo](https://github.com/sethvargo))
- switch default of "opscode" to use supermarket [\#150](https://github.com/berkshelf/berkshelf-api/pull/150) ([jtimberman](https://github.com/jtimberman))
- Make it possible to run it out the box as the berkshelf user. [\#149](https://github.com/berkshelf/berkshelf-api/pull/149) ([thorduri](https://github.com/thorduri))
- Bump to github 0.3 which fixes proxy install issue [\#148](https://github.com/berkshelf/berkshelf-api/pull/148) ([amaltson](https://github.com/amaltson))
- Tyop in warning output [\#142](https://github.com/berkshelf/berkshelf-api/pull/142) ([thorduri](https://github.com/thorduri))
- Added installation of libgecode-dev to fix build error [\#140](https://github.com/berkshelf/berkshelf-api/pull/140) ([jossy](https://github.com/jossy))

## [v1.4.0](https://github.com/berkshelf/berkshelf-api/tree/v1.4.0) (2014-06-06)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.3.1...v1.4.0)

**Implemented enhancements:**

- One-Click installer [\#65](https://github.com/berkshelf/berkshelf-api/issues/65)

**Fixed bugs:**

- cookbook artifact problems on rhel [\#130](https://github.com/berkshelf/berkshelf-api/issues/130)

**Closed issues:**

- No release for 1.4.0? [\#137](https://github.com/berkshelf/berkshelf-api/issues/137)
- Can't seem to connect to my berkshelf-api server [\#133](https://github.com/berkshelf/berkshelf-api/issues/133)
- Unable to include berkshelf-api using Berkshelf's `rel` functionality [\#126](https://github.com/berkshelf/berkshelf-api/issues/126)
- Question: Endpoints and single chef repo [\#123](https://github.com/berkshelf/berkshelf-api/issues/123)
- berkshelf-api can't build universe behind a proxy [\#120](https://github.com/berkshelf/berkshelf-api/issues/120)
- Celluloid::TaskFiber backtrace unavailable [\#117](https://github.com/berkshelf/berkshelf-api/issues/117)
- How does the API handle conflicts between endpoints? [\#116](https://github.com/berkshelf/berkshelf-api/issues/116)
- Using environment cookbook from another fails [\#115](https://github.com/berkshelf/berkshelf-api/issues/115)
- What updates the index [\#113](https://github.com/berkshelf/berkshelf-api/issues/113)
- berkshelf-api cookbook fails to execute on Ubuntu 13 or greater [\#111](https://github.com/berkshelf/berkshelf-api/issues/111)
- berkshelf-api cookbook fails on multi\_json gem [\#110](https://github.com/berkshelf/berkshelf-api/issues/110)

**Merged pull requests:**

- rename berkshelf-api cookbook to berkshelf-api-server [\#135](https://github.com/berkshelf/berkshelf-api/pull/135) ([reset](https://github.com/reset))
- Try to be defensive about failed community site calls [\#132](https://github.com/berkshelf/berkshelf-api/pull/132) ([ivey](https://github.com/ivey))
- Fixed host attribute documentation in README.md [\#131](https://github.com/berkshelf/berkshelf-api/pull/131) ([jossy](https://github.com/jossy))
- Updated the call to the user provider so it creates a system user [\#128](https://github.com/berkshelf/berkshelf-api/pull/128) ([svanharmelen](https://github.com/svanharmelen))
- Update srv\_ctl.rb [\#124](https://github.com/berkshelf/berkshelf-api/pull/124) ([maniac4](https://github.com/maniac4))
- Example config is not valid JSON [\#122](https://github.com/berkshelf/berkshelf-api/pull/122) ([gavinheavyside](https://github.com/gavinheavyside))
- Fixing logic error in app recipe [\#118](https://github.com/berkshelf/berkshelf-api/pull/118) ([svanharmelen](https://github.com/svanharmelen))
- Return JSON to naive HTTP clients like browsers or curl. [\#114](https://github.com/berkshelf/berkshelf-api/pull/114) ([coderanger](https://github.com/coderanger))
- Updated readme  [\#109](https://github.com/berkshelf/berkshelf-api/pull/109) ([mindlace](https://github.com/mindlace))

## [v1.3.1](https://github.com/berkshelf/berkshelf-api/tree/v1.3.1) (2014-04-23)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.3.0...v1.3.1)

**Closed issues:**

- Berkshelf-api cookbook uses Ubuntu only resource [\#107](https://github.com/berkshelf/berkshelf-api/issues/107)
- github\_asset fails behind a web proxy [\#106](https://github.com/berkshelf/berkshelf-api/issues/106)
- Upgrade to octokit 3 [\#105](https://github.com/berkshelf/berkshelf-api/issues/105)

## [v1.3.0](https://github.com/berkshelf/berkshelf-api/tree/v1.3.0) (2014-04-19)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.2.2...v1.3.0)

**Merged pull requests:**

- add warning messages when a github or file\_store cache builder is started [\#104](https://github.com/berkshelf/berkshelf-api/pull/104) ([reset](https://github.com/reset))
- add attribute documentation to cookbook README [\#103](https://github.com/berkshelf/berkshelf-api/pull/103) ([reset](https://github.com/reset))

## [v1.2.2](https://github.com/berkshelf/berkshelf-api/tree/v1.2.2) (2014-04-17)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.2.1...v1.2.2)

**Merged pull requests:**

- LoadError: cannot load such file -- http/headers [\#102](https://github.com/berkshelf/berkshelf-api/pull/102) ([benlemasurier](https://github.com/benlemasurier))
- Changed the location\_path so it contains the full repo URL [\#88](https://github.com/berkshelf/berkshelf-api/pull/88) ([svanharmelen](https://github.com/svanharmelen))

## [v1.2.1](https://github.com/berkshelf/berkshelf-api/tree/v1.2.1) (2014-04-12)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.2.0...v1.2.1)

## [v1.2.0](https://github.com/berkshelf/berkshelf-api/tree/v1.2.0) (2014-04-11)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.2.0.rc2...v1.2.0)

**Merged pull requests:**

- Distribute as Github release [\#99](https://github.com/berkshelf/berkshelf-api/pull/99) ([reset](https://github.com/reset))

## [v1.2.0.rc2](https://github.com/berkshelf/berkshelf-api/tree/v1.2.0.rc2) (2014-04-10)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.2.0.rc1...v1.2.0.rc2)

**Closed issues:**

- Provide Gemfile.lock [\#98](https://github.com/berkshelf/berkshelf-api/issues/98)
- multiple chef servers [\#96](https://github.com/berkshelf/berkshelf-api/issues/96)

## [v1.2.0.rc1](https://github.com/berkshelf/berkshelf-api/tree/v1.2.0.rc1) (2014-04-03)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.1.1...v1.2.0.rc1)

**Closed issues:**

- github worker "cookbook\_metadata.instance\_eval\(metadata\_content\)" Errno::ENOENT exception [\#94](https://github.com/berkshelf/berkshelf-api/issues/94)
- API requests hanging [\#93](https://github.com/berkshelf/berkshelf-api/issues/93)
- Return 503 Service Unavailable until cache is warmed. [\#83](https://github.com/berkshelf/berkshelf-api/issues/83)
- The GitHub worker should be configurable so you can also use a GitHub Enterprise server [\#79](https://github.com/berkshelf/berkshelf-api/issues/79)
- Github Endpoint Does not Accept Custom URLs [\#74](https://github.com/berkshelf/berkshelf-api/issues/74)
- Binary format with MsgPack [\#55](https://github.com/berkshelf/berkshelf-api/issues/55)
- Add cache builder for FileStore [\#26](https://github.com/berkshelf/berkshelf-api/issues/26)

**Merged pull requests:**

- Switch to HOME environment variable instead of ~ for populating default home\_path [\#92](https://github.com/berkshelf/berkshelf-api/pull/92) ([eherot](https://github.com/eherot))
- gitignore: ctags files [\#87](https://github.com/berkshelf/berkshelf-api/pull/87) ([docwhat](https://github.com/docwhat))
- Gemfile: only list 'rspec' once [\#86](https://github.com/berkshelf/berkshelf-api/pull/86) ([docwhat](https://github.com/docwhat))
- Github Enterprise fix \#79 [\#80](https://github.com/berkshelf/berkshelf-api/pull/80) ([svanharmelen](https://github.com/svanharmelen))
- Friendlier logging [\#78](https://github.com/berkshelf/berkshelf-api/pull/78) ([justincampbell](https://github.com/justincampbell))
- Add Ruby 2.1 to Travis [\#77](https://github.com/berkshelf/berkshelf-api/pull/77) ([justincampbell](https://github.com/justincampbell))
- Add cache builder for local file store [\#71](https://github.com/berkshelf/berkshelf-api/pull/71) ([whiteley](https://github.com/whiteley))
- Add MessagePack support [\#66](https://github.com/berkshelf/berkshelf-api/pull/66) ([whiteley](https://github.com/whiteley))

## [v1.1.1](https://github.com/berkshelf/berkshelf-api/tree/v1.1.1) (2014-02-06)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.1.0...v1.1.1)

**Closed issues:**

- Should GitHub cache builder use master if no tags exist? [\#72](https://github.com/berkshelf/berkshelf-api/issues/72)

**Merged pull requests:**

- Auto paginate repository list from Octokit [\#70](https://github.com/berkshelf/berkshelf-api/pull/70) ([whiteley](https://github.com/whiteley))
- Stick to faraday-0.8.8 version   [\#69](https://github.com/berkshelf/berkshelf-api/pull/69) ([alambike](https://github.com/alambike))
- Add uptime to status endpoint [\#68](https://github.com/berkshelf/berkshelf-api/pull/68) ([coderanger](https://github.com/coderanger))
- Status end point [\#67](https://github.com/berkshelf/berkshelf-api/pull/67) ([coderanger](https://github.com/coderanger))

## [v1.1.0](https://github.com/berkshelf/berkshelf-api/tree/v1.1.0) (2013-12-26)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v1.0.0...v1.1.0)

**Closed issues:**

- Add cache builder for Github [\#27](https://github.com/berkshelf/berkshelf-api/issues/27)

**Merged pull requests:**

- adds a github cache builder worker [\#63](https://github.com/berkshelf/berkshelf-api/pull/63) ([punkle](https://github.com/punkle))
- update organization for repository [\#62](https://github.com/berkshelf/berkshelf-api/pull/62) ([reset](https://github.com/reset))

## [v1.0.0](https://github.com/berkshelf/berkshelf-api/tree/v1.0.0) (2013-10-15)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v0.2.0...v1.0.0)

**Closed issues:**

- CacheManager\#process\_workers swallows exceptions [\#52](https://github.com/berkshelf/berkshelf-api/issues/52)
- SSL [\#40](https://github.com/berkshelf/berkshelf-api/issues/40)
- Cache Builders remove each others additions [\#23](https://github.com/berkshelf/berkshelf-api/issues/23)
- Response is inconsistent if CacheBuilder has not finished [\#16](https://github.com/berkshelf/berkshelf-api/issues/16)
- Is JSON good enough? [\#5](https://github.com/berkshelf/berkshelf-api/issues/5)

**Merged pull requests:**

- only output endpoint\_checksum when saving [\#57](https://github.com/berkshelf/berkshelf-api/pull/57) ([KAllan357](https://github.com/KAllan357))
- Avoid thread exhaustion with large numbers of cookbooks [\#56](https://github.com/berkshelf/berkshelf-api/pull/56) ([ivey](https://github.com/ivey))
- Problem with chunked responses on Heroku [\#54](https://github.com/berkshelf/berkshelf-api/pull/54) ([reset](https://github.com/reset))
- fix broken berks\_dependency rspec helper [\#53](https://github.com/berkshelf/berkshelf-api/pull/53) ([reset](https://github.com/reset))
- Refactor cache builder [\#51](https://github.com/berkshelf/berkshelf-api/pull/51) ([andrewGarson](https://github.com/andrewGarson))
- RemoteCookbooks are compared using set notation, this requires you to [\#50](https://github.com/berkshelf/berkshelf-api/pull/50) ([andrewGarson](https://github.com/andrewGarson))
- call CacheBuilder\#build when starting rspec server for first time [\#47](https://github.com/berkshelf/berkshelf-api/pull/47) ([reset](https://github.com/reset))
- Don't return data until the cache has been warmed [\#46](https://github.com/berkshelf/berkshelf-api/pull/46) ([andrewGarson](https://github.com/andrewGarson))
- build interval ignored in favor of constant default [\#45](https://github.com/berkshelf/berkshelf-api/pull/45) ([andrewGarson](https://github.com/andrewGarson))
- call our parents shutdown function in RESTGateway [\#44](https://github.com/berkshelf/berkshelf-api/pull/44) ([reset](https://github.com/reset))
- application will shutdown cleanly [\#43](https://github.com/berkshelf/berkshelf-api/pull/43) ([reset](https://github.com/reset))
- relax constraint on ridley to ~\> 1.5 [\#42](https://github.com/berkshelf/berkshelf-api/pull/42) ([reset](https://github.com/reset))
- Bump required Ridley to '~\> 1.4.0' [\#41](https://github.com/berkshelf/berkshelf-api/pull/41) ([sethvargo](https://github.com/sethvargo))
- Prioritize items added by specific builders [\#24](https://github.com/berkshelf/berkshelf-api/pull/24) ([reset](https://github.com/reset))

## [v0.2.0](https://github.com/berkshelf/berkshelf-api/tree/v0.2.0) (2013-07-17)
[Full Changelog](https://github.com/berkshelf/berkshelf-api/compare/v0.1.0...v0.2.0)

**Merged pull requests:**

- Crashed cache builder workers do not automatically rebuild [\#39](https://github.com/berkshelf/berkshelf-api/pull/39) ([reset](https://github.com/reset))
- allow for a configurable api-server home directory [\#38](https://github.com/berkshelf/berkshelf-api/pull/38) ([reset](https://github.com/reset))
- bin/berks-api will now access -c for a configuration file [\#37](https://github.com/berkshelf/berkshelf-api/pull/37) ([reset](https://github.com/reset))

## [v0.1.0](https://github.com/berkshelf/berkshelf-api/tree/v0.1.0) (2013-07-12)
**Closed issues:**

- Use of Archive gem prevents deployment to Heroku [\#15](https://github.com/berkshelf/berkshelf-api/issues/15)
- Periodically persist json cache [\#6](https://github.com/berkshelf/berkshelf-api/issues/6)
- Maintain source in the cache [\#4](https://github.com/berkshelf/berkshelf-api/issues/4)
- Chef API cache\_builder [\#3](https://github.com/berkshelf/berkshelf-api/issues/3)

**Merged pull requests:**

- Cucumber helpers [\#36](https://github.com/berkshelf/berkshelf-api/pull/36) ([reset](https://github.com/reset))
- cache builder will now schedule builds for workers [\#35](https://github.com/berkshelf/berkshelf-api/pull/35) ([reset](https://github.com/reset))
- add first pass at rspec helpers [\#34](https://github.com/berkshelf/berkshelf-api/pull/34) ([reset](https://github.com/reset))
- Exclusive cache manager [\#33](https://github.com/berkshelf/berkshelf-api/pull/33) ([reset](https://github.com/reset))
- add jruby to test matrix [\#32](https://github.com/berkshelf/berkshelf-api/pull/32) ([reset](https://github.com/reset))
- Only load RESTGateway when required [\#31](https://github.com/berkshelf/berkshelf-api/pull/31) ([reset](https://github.com/reset))
- tag all cache items with the location path [\#30](https://github.com/berkshelf/berkshelf-api/pull/30) ([reset](https://github.com/reset))
- items added to the cache are now tagged with a location type [\#29](https://github.com/berkshelf/berkshelf-api/pull/29) ([reset](https://github.com/reset))
- drop ruby 1.9.2 support [\#28](https://github.com/berkshelf/berkshelf-api/pull/28) ([reset](https://github.com/reset))
- add endpoint to cache manager for clearing cache [\#25](https://github.com/berkshelf/berkshelf-api/pull/25) ([reset](https://github.com/reset))
- Implement chef server cache builder [\#22](https://github.com/berkshelf/berkshelf-api/pull/22) ([reset](https://github.com/reset))
- load config if it's present [\#21](https://github.com/berkshelf/berkshelf-api/pull/21) ([reset](https://github.com/reset))
- load mixin's before remainder of code [\#20](https://github.com/berkshelf/berkshelf-api/pull/20) ([reset](https://github.com/reset))
- Add ability to configure which cache builders are started and how [\#19](https://github.com/berkshelf/berkshelf-api/pull/19) ([reset](https://github.com/reset))
- remove autoload to make everything threadsafe [\#18](https://github.com/berkshelf/berkshelf-api/pull/18) ([reset](https://github.com/reset))
- option parsing for berks-api binary moved to Berkshelf::API::SrvCtl [\#17](https://github.com/berkshelf/berkshelf-api/pull/17) ([reset](https://github.com/reset))
- add option parsing to binary and application supervisor [\#14](https://github.com/berkshelf/berkshelf-api/pull/14) ([reset](https://github.com/reset))
- cache manager will save cache every\(X\) seconds [\#13](https://github.com/berkshelf/berkshelf-api/pull/13) ([reset](https://github.com/reset))
- greatly improve speed of building opscode cache [\#12](https://github.com/berkshelf/berkshelf-api/pull/12) ([reset](https://github.com/reset))
- SiteConnector::Opscode improvements / refactors [\#11](https://github.com/berkshelf/berkshelf-api/pull/11) ([reset](https://github.com/reset))
- Setup supervision tree for cache builders [\#10](https://github.com/berkshelf/berkshelf-api/pull/10) ([reset](https://github.com/reset))
- Remove JSON and MultiJson as dependencies [\#9](https://github.com/berkshelf/berkshelf-api/pull/9) ([sethvargo](https://github.com/sethvargo))
- Fix application's shutdown sequence [\#8](https://github.com/berkshelf/berkshelf-api/pull/8) ([reset](https://github.com/reset))
- improve support for logging [\#7](https://github.com/berkshelf/berkshelf-api/pull/7) ([reset](https://github.com/reset))
- Opscode Cache builder [\#2](https://github.com/berkshelf/berkshelf-api/pull/2) ([andrewGarson](https://github.com/andrewGarson))
- upgrade to Celluloid 0.14.0 [\#1](https://github.com/berkshelf/berkshelf-api/pull/1) ([reset](https://github.com/reset))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*