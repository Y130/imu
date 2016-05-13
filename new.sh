#!/bin/bash
if [ -n "$1" ] ; then
	name=`echo "$1" |sed 's/[^a-zA-Z0-9]/_/g'`
	mkdir -p src/app/"$name"/inline
	echo "$(date +'%F %T') Created src/app/$name."
	cat <<-EOF > src/app/"$name"-meta.html
		<meta charset="utf-8"/>
		<meta http-equiv="X-UA-Compatible" content="IE=edge"/>
		<meta name="viewport" content="width=device-width,initial-scale=1"/>
		<title>$name</title>
	EOF
	echo "$(date +'%F %T') Generated src/app/$name-meta.html."
	read -r -d '' js<<-EOF
		import Vue from './lib/vue/vue.js'
		import VueResource from './lib/vue/vue-resource.js'
		import VueRouter from './lib/vue/vue-router.js'

		Vue.use(VueRouter);
		var router = new VueRouter({
			\tmode: 'history', linkActiveClass: 'is-active', base: '/',
			\troutes: [
				\t\t// {name: 'hello', path: '/', component: hello_vm},
			\t]
		})

		var App = new Vue({
			\trouter: router,
			\tel: '#app',
		});
	EOF
	echo -e "$js" > src/app/"$name".js
	echo "$(date +'%F %T') Generated src/app/$name.js."
	echo -e '@charset "utf-8";\n@import "lib/bulma/bulma";' > src/app/"$name".scss
	echo "$(date +'%F %T') Generated src/app/$name.scss."
	read -r -d '' app<<-EOF
		<div id="app" style="margin-top:1%;" class="container foo">
			\t<div class="columns">
				\t\t<div class="column"></div>
				\t\t<div class="column is-three-quarters">
					\t\t\t<div class="box">
						\t\t\t\t<div class="content has-text-centered"></div>
					\t\t\t</div>
					\t\t\t<p>...</p>
				\t\t</div>
				\t\t<div class="column"></div>
			\t</div>
			\t<footer class="footer">
				\t\t<div class="content has-text-centered">
					\t\t\t<p>.</p>
				\t\t</div>
			\t</footer>
		</div>
	EOF
	echo -e "$app" > src/app/"$name".html
	echo "$(date +'%F %T') Generated src/app/$name.html."
	echo "$(date +'%F %T') Finished $name."
else
	echo 'Usage: ./new.sh "project name"'
	echo ''
	echo 'All non-alphanumeric characters will be substituted with underscores.'
fi
