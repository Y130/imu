--[[ 'input' is in the form of '(module).lua'. For each '(module)', generate an
	nginx '.conf'' file that captures path '/(module)' and routes it to
	'$path/(module).lua'. 'srvbin' is a path to the back-end build directory.

	'/bin/echo' avoids problematic shell built-ins.
--]]
function nginx_conf(input, output, srvbin)
	local input = tup.glob(input)
	for _, file in ipairs(input) do
		tup.definerule{
			inputs = {file},
			command =
			[[/bin/echo "location ^~ /%B/ {" >> %o;
			/bin/echo '	set $_url \"\";' >> %o;
			/bin/echo '	content_by_lua_file ]]..srvbin..[[/%B.lua;' >> %o;
			/bin/echo '}' >> %o;
			]],
			outputs = {output}
		}
	end
end
