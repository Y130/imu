-- Sets <html> language code.
lang = "en"
-- Front-end build path.
appbin = "bin/app"
appsrc = "src/app"

-- Back-end build path.
srvbin = "bin/srv"
srvsrc = "src/srv"

local RELEASE = tup.getconfig("RELEASE") == "y"

-- Include all libraries.
local libs = tup.glob("tup/*.lua")
for _, file in ipairs(libs) do
	tup.include(file)
end

-- Compile each app into .html.gz files.
local files = tup.glob(appsrc.."/*.js")
for _, file in ipairs(files) do
	local app = tup.base(file)
	local dest = "tmp/"..app

	-- Stage <head> metadata.
	install(appsrc.."/"..app.."-meta.html", dest.."/html/meta.html")

	-- Inline images inside HTML.
	inline_img(appsrc.."/"..app, dest.."/html/svg.html")

	-- Build app-provided Sass.
	sass(appsrc.."/"..app..".scss", dest.."/css/main.css")

	-- Autoprefix and minimize CSS.
	autoprefix(dest.."/css/main.css",
		dest.."/css/prefixed.css")
	if RELEASE then
		csso(dest.."/css/prefixed.css",
			dest.."/css/min.css")
	end

	-- Combine <head>+CSS+SVG.
	local cssfile
	if RELEASE then cssfile = dest.."/css/min.css"
	else cssfile = dest.."/css/prefixed.css" end

	tup.definerule{
		inputs = {
			dest.."/html/meta.html",
			dest.."/html/svg.html",
			cssfile
		},
		command =
		[[/bin/echo '<!DOCTYPE html><html lang="]]..lang..[["><head>' > %o;
		cat ]]..dest..[[/html/meta.html >> %o;
		/bin/echo '<style>' >> %o;
		cat ]]..cssfile..[[ >> %o;
		/bin/echo '</style></head><body>' >> %o
		cat ]]..dest..[[/html/svg.html >> %o;
		]],
		outputs = {dest.."/html/head.html"}
	}

	-- Stage main component template.
	install(appsrc.."/"..app..".html", dest.."/html/main.html")

	-- Join all component templates together.
	join(tup.glob(appsrc.."/"..app.."/*.html"), dest.."/html/components.html")

	-- Glue body together from all components.
	glue(dest.."/html/main.html", dest.."/html/components.html", dest.."/html/body.html")

	-- Compile JavaScript, minify it.
	rollup(appsrc.."/"..app, dest.."/js/bundle.js")
	buble(dest.."/js/bundle.js", dest.."/js/es5.js")
	if RELEASE then
		closurecc(dest.."/js/es5.js",
			dest.."/js/opt.js")
		uglifyjs(dest.."/js/opt.js",
			dest.."/js/min.js")
	end

	-- Combine <head>, <body> and JS.
	local jsfile
	if RELEASE then jsfile = dest.."/js/min.js"
	else jsfile = dest.."/js/es5.js" end

	tup.definerule{
		inputs = {
			dest.."/html/head.html",
			dest.."/html/body.html", jsfile
		},
		command =
		[[cat ]]..dest..[[/html/head.html > %o;
			cat ]]..dest..[[/html/body.html >> %o;
			/bin/echo '<script>' >> %o;
			cat ]]..jsfile..[[ >> %o;
			/bin/echo '</script>' >> %o
			/bin/echo '</body></html>' >> %o
		]],
		outputs = {dest.."/html/"..app.."-bin.html"}
	}

	-- Minify HTML, install and gzip it.
	if RELEASE then
		htmlminifier(dest.."/html/"..app.."-bin.html",
			dest.."/html/"..app.."-min.html")
	end

	local htmlfile
	if RELEASE then htmlfile = dest.."/html/"..app.."-min.html"
	else htmlfile = dest.."/html/"..app.."-bin.html" end

	install(htmlfile, appbin.."/"..app..".html")
	gz(appbin.."/"..app..".html", appbin.."/"..app..".html.gz")
end

-- Install static assets.
install(appsrc.."/static/*", appbin.."/static/%b")

-- Build nginx confs for main Lua modules.
-- nginx_conf(srvsrc.."/api.lua", srvbin.."/%B.conf", "run/srv")
-- nginx_conf(srvsrc.."/web.lua", srvbin.."/%B.conf", "run/srv")

-- Install nginx backend into place.
install(srvsrc.."/*.lua", srvbin.."/%b")
install(srvsrc.."/*.conf", srvbin.."/%b")
