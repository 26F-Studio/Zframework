package.cpath=package.cpath..';'..love.filesystem.getSaveDirectory()..'/lib/lib?.so;'..'?.dylib'
local loaded={}
return function(libName)
    local require=require
    local arch='unknown'
    if love.system.getOS()=='OS X' then
        require=package.loadlib(libName..'.dylib','luaopen_'..libName)
        libName=nil
    elseif love.system.getOS()=='Android' then
        if not loaded[libName] then
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
                'lib/libCCloader.so',
                love.filesystem.read('data','libAndroid/'..platform..'/libCCloader.so')
            )
            loaded[libName]=true
        end
    end
    local success,res=pcall(require,libName)
    if success and res then
        return res
    else
        print(res)
        MES.new('error',"Cannot load "..libName..": "..tostring(res):gsub('[\128-\255]+','??'))
        MES.new('info',"Architecture: "..arch)
    end
end
