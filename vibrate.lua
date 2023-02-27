local level={
    Android={0,  0,.01,.016,.023,.03,.04,.05,.06,.07,.08,.09,.12,.15,.18,.21,.24,.27,.30,.33,.36},
        iOS={0,.05,.10,.15, .20, .25,.30,.35,.40,.45,.50,.55,.60,.65,.70,.75,.80,.85,.90,.95,1  },
}
local vib=love.system.vibrate
return love.system.getOS()=='iOS' and
    function(t, type)
        t=level["iOS"][t]
        if t then vib(t, type) end
    end
or
    function(t)
        t=level["Android"][t]
        if t then vib(t) end
    end