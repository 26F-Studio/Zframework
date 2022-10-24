local scenes={}

local SCN={
    mainTouchID=nil,     -- First touching ID(userdata)
    swapping=false,      -- If Swapping
    state={
        tar=false,       -- Swapping target
        style=false,     -- Swapping style
        changeTime=false,-- Loading point
        time=false,      -- Full swap time
        draw=false,      -- Swap draw  func
    },
    stack={},-- Scene stack
    prev=false,
    args={},-- Arguments from previous scene

    scenes=scenes,

    -- Events
    update=false,
    draw=false,
    mouseClick=false,
    touchClick=false,
    mouseDown=false,
    mouseMove=false,
    mouseUp=false,
    wheelMoved=false,
    touchDown=false,
    touchUp=false,
    touchMove=false,
    keyDown=false,
    keyUp=false,
    gamepadDown=false,
    gamepadUp=false,
    fileDropped=false,
    directoryDropped=false,
    resize=false,
}-- Scene datas, returned

function SCN.add(name,scene)
    scenes[name]=scene
    if scene.widgetList then
        setmetatable(scene.widgetList,WIDGET.indexMeta)
    end
end

function SCN.swapUpdate(dt)
    local S=SCN.state
    S.time=S.time-dt
    if S.time<S.changeTime and S.time+dt>=S.changeTime then
        -- Scene swapped this frame
        SCN.init(S.tar)
        SCN.mainTouchID=nil
    end
    if S.time<0 then
        SCN.swapping=false
    end
end
function SCN.init(s)
    love.keyboard.setTextInput(false)

    local S=scenes[s]

    WIDGET.setScrollHeight(S.widgetScrollHeight)
    WIDGET.setWidgetList(S.widgetList)
    SCN.sceneInit=S.sceneInit
    SCN.sceneBack=S.sceneBack
    SCN.mouseDown=S.mouseDown
    SCN.mouseMove=S.mouseMove
    SCN.mouseUp=S.mouseUp
    SCN.mouseClick=S.mouseClick
    SCN.wheelMoved=S.wheelMoved
    SCN.touchDown=S.touchDown
    SCN.touchUp=S.touchUp
    SCN.touchMove=S.touchMove
    SCN.touchClick=S.touchClick
    SCN.keyDown=S.keyDown
    SCN.keyUp=S.keyUp
    SCN.gamepadDown=S.gamepadDown
    SCN.gamepadUp=S.gamepadUp
    SCN.fileDropped=S.fileDropped
    SCN.directoryDropped=S.directoryDropped
    SCN.resize=S.resize
    SCN.update=S.update
    SCN.draw=S.draw
    if S.sceneInit then
        S.sceneInit()
    end
end
function SCN.push(tar,style)
    table.insert(SCN.stack,tar or SCN.stack[#SCN.stack-1])
    table.insert(SCN.stack,style or 'fade')
    -- print("-------") for i=1,#SCN.stack,2 do print(SCN.stack[i]) end
end
function SCN.pop()
    table.remove(SCN.stack)
    table.remove(SCN.stack)
    -- print("-------") for i=1,#SCN.stack,2 do print(SCN.stack[i]) end
end

local swap={
    none={
        duration=0,changeTime=0,
        draw=function() end
    },
    flash={
        duration=.16,changeTime=.08,
        draw=function() GC.clear(1,1,1) end
    },
    fade={
        duration=.5,changeTime=.25,
        draw=function(t)
            t=t>.25 and 2-t*4 or t*4
            GC.setColor(0,0,0,t)
            GC.rectangle('fill',0,0,SCR.w,SCR.h)
        end
    },
    fade_togame={
        duration=2,changeTime=.5,
        draw=function(t)
            t=t>.5 and (2-t)/1.5 or t*.5
            GC.setColor(0,0,0,t)
            GC.rectangle('fill',0,0,SCR.w,SCR.h)
        end
    },
    slowFade={
        duration=3,changeTime=1.5,
        draw=function(t)
            t=t>1.5 and (3-t)/1.5 or t/1.5
            GC.setColor(0,0,0,t)
            GC.rectangle('fill',0,0,SCR.w,SCR.h)
        end
    },
    swipeL={
        duration=.5,changeTime=.25,
        draw=function(t)
        t=t*2
            GC.setColor(.1,.1,.1,1-math.abs(t-.5))
            t=t*t*(3-2*t)*2-1
            GC.rectangle('fill',t*SCR.w,0,SCR.w,SCR.h)
        end
    },
    swipeR={
        duration=.5,changeTime=.25,
        draw=function(t)
            t=t*2
            GC.setColor(.1,.1,.1,1-math.abs(t-.5))
            t=t*t*(2*t-3)*2+1
            GC.rectangle('fill',t*SCR.w,0,SCR.w,SCR.h)
        end
    },
    swipeD={
        duration=.5,changeTime=.25,
        draw=function(t)
            t=t*2
            GC.setColor(.1,.1,.1,1-math.abs(t-.5))
            t=t*t*(2*t-3)*2+1
            GC.rectangle('fill',0,t*SCR.h,SCR.w,SCR.h)
        end
    },
}-- Scene swapping animations
function SCN.swapTo(tar,style,...)-- Parallel scene swapping, cannot back
    if scenes[tar] then
        if not SCN.swapping and tar~=SCN.stack[#SCN.stack-3] then
            style=style or 'fade'
            SCN.prev=SCN.stack[#SCN.stack-1]
            SCN.stack[#SCN.stack-1],SCN.stack[#SCN.stack]=tar,style
            SCN.swapping=true
            SCN.args={...}
            local S=SCN.state
            S.tar,S.style=tar,style
            S.time=swap[style].duration
            S.changeTime=swap[style].changeTime
            S.draw=swap[style].draw
        end
    else
        MES.new('warn',"No Scene: "..tar)
    end
end
function SCN.go(tar,style,...)-- Normal scene swapping, can back
    if scenes[tar] then
        if not SCN.swapping and tar~=SCN.stack[#SCN.stack-3] then
            local prev=SCN.stack[#SCN.stack-1]
            SCN.push(tar,style)
            SCN.swapTo(tar,style,...)
            SCN.prev=prev
        end
    else
        MES.new('warn',"No Scene: "..tar)
    end
end
function SCN.back(...)
    if SCN.swapping then return end

    -- Leave scene
    if SCN.sceneBack then
        SCN.sceneBack()
    end

    -- Poll&Back to previous Scene
    if #SCN.stack>2 then
        SCN.pop()
        SCN.swapTo(SCN.stack[#SCN.stack-1],SCN.stack[#SCN.stack],...)
    else
        SCN.swapTo('quit','slowFade')
    end
end
function SCN.backTo(name,...)
    if SCN.swapping then return end

    -- Leave scene
    if SCN.sceneBack then
        SCN.sceneBack()
    end

    -- Poll&Back to previous Scene
    while SCN.stack[#SCN.stack-1]~=name and #SCN.stack>2 do
        SCN.pop()
    end
    SCN.swapTo(SCN.stack[#SCN.stack-1],SCN.stack[#SCN.stack],...)
end
return SCN
