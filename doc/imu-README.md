# imu :fire: :pig: :fire:
> A [tup-based][1] skeleton project for building and serving single-page
> applications with [OpenResty][2].

### Overview
| Front-End Languages | Back-End Languages         |
|---------------------|----------------------------|
| [ES2016 (Bublé)][3] | [Lua][5]                   |
| [Sass][4]           |                            |

``` Shell
$ git clone https://github.com/AequoreaVictoria/imu project
$ cd project
$ ./new.sh "project"
$ tup init
$ tup build-debug
```
At this point, anywhere in the project, executing `tup build-debug` agin
after making changes will rebuild only the necessary files. This is fairly
quick. Using `tup monitor` can help make this quicker. Executing `tup` by
itself will build both release and debug builds.

To launch your applications, customize the provided `ngx.conf` for your
project. By then running`./ssl.sh`, you will generate the initial SSL files
needed to launch. You may then launch it with `./web.sh start`.

For release, *imu* builds optimized, compressed, ready-to-deploy applications.

For rapid prototyping, [Vue.js 2.0][6] and [Bulma][7] are provided.

*imu* has a built-in SVG inliner for generating CSS-accessible content.

[OpenResty][2] is used for back-end purposes.

IE10 or earlier will not be considered.

### Requirements
* [OpenResty][2]
* [tup][1]
* [closure-compiler][8]
* `yarn global add rollup buble uglify-js postcss-cli autoprefixer csso node-sass html-minifier`

### Size
*imu*'s main focus is the rapid construction of single-page apps with as
little overhead as possible. This is a work in progress.

In this section, the sizes are estimates taken from optimized and
compressed code.

| Library           | Min Size | Max Size |
|-------------------|----------|----------|
| [Bulma][7]        | 1KB      | 14KB     |
| [Vue.js][6]       | 33KB     | 46KB     |

[Bulma][7] may be omitted in whole from any app by editing the app's SCSS
style. You may also @import just the SCSS modules you need. For example,
to include just [Bulma][7]'s columns:

``` Sass
@import "bulma/sass/utilities/_all";
@import "bulma/sass/grid/columns";
```

The [Vue.js][6] suite is optional and its size depends on the modules included.
By default [Vue.js][6], its router and its HTTP client are included. The sizes
in the above chart include the 5KB~ cost of bundling with [Rollup.js][9] and compiling
with [Buble][3]. For the sake of safety and modularity, this cost is deemed acceptable.

Optional `vue.dev.js` and `vue-router.dev.js` variant libraries are also included for
use with the [Vue.js devtools][10].

### Usage
Please consult [doc/imu-COOKBOOK.md][11] for an in-depth explanation of *imu*.

### Thanks
[h5bp's server-configs-nginx][12] was refenced in part for `ngx.conf`.

### License
*imu* is [public domain | CC0][13], among other things. This is to encourage
full use of the provided Tup files, scripts and documentation, for any reason,
without attribution. (unless you wish to do so)

`doc/license` contains the licenses applying to *imu* and components.

Components will never have licenses more restrictive than [ISC][14],
[MIT][15] or [2-clause BSD][16]. There is a slight preference for [ISC][14].
These licensed works require attribution when distributing them with your work.
This may be accomplished by doing **any** of the following:

* Distributing the `license/` directory available with all copies,
* Displaying the copyright notice and license disclaimer in your documentation,
* Displaying the copyright notice and license disclaimer in an 'About' screen.

No further action is needed. :nail_care:

[1]: http://gittup.org/tup
[2]: http://openresty.org
[3]: https://buble.surge.sh/guide/
[4]: http://sass-lang.com
[5]: http://lua.org
[6]: http://vuejs.org
[7]: http://bulma.io
[8]: https://github.com/google/closure-compiler
[9]: http://rollupjs.org/guide/
[10]: https://github.com/vuejs/vue-devtools
[11]: https://github.com/AequoreaVictoria/imu/blob/master/doc/imu-COOKBOOK.md
[12]: https://github.com/h5bp/server-configs-nginx
[13]: http://creativecommons.org/publicdomain/zero/1.0/
[14]: https://opensource.org/licenses/isc-license
[15]: https://opensource.org/licenses/MIT
[16]: https://opensource.org/licenses/BSD-2-Clause
