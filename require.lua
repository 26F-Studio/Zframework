package.cpath=package.cpath..';'..love.filesystem.getSaveDirectory()..'/lib/?.so;'..'?.dylib'
local loaded={}
return function(libName)
    local require=require
    local arch='unknown'
    local success,res
    if SYSTEM=='Web' then
        return
    end
    if SYSTEM=='OS X' then
        require=package.loadlib(libName..'.dylib','luaopen_'..libName)
        success,res=pcall(require)
    else
        if SYSTEM=='Android' and not loaded[libName] then
            local platform=(function()
                local p=io.popen('uname -m')
                arch=p:read('*a'):lower()
                p:close()
                if arch:find('v8') and not arch:find('v8l') or arch:find('64') then
                    return 'arm64-v8a'
                else
                    return 'armeabi-v7a'
                end
            end)()
            love.filesystem.write(
                'lib/'..libName..'.so',
                love.filesystem.read('data','libAndroid/'..platform..'/'..libName..'.so')
            )
            loaded[libName]=true
        end
        success,res=pcall(require,libName)
    end
    if success and res then
        return res
    else
        MES.new('error',"Cannot load "..libName..": "..tostring(res):gsub('[\128-\255]+','??'))
        MES.new('info',"Architecture: "..arch)
    end
end
