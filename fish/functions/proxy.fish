# Defined in - @ line 1
function proxy --description 'alias proxy export http_proxy=socks5://127.0.0.1:1080'
	export http_proxy=socks5://127.0.0.1:1080 $argv;
end
