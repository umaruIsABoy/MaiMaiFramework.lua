--MaiMaiFramework.lua============================================
--版本v0.0.7
--2021/9/2
--脚本编写CSOL（网一）巴机斯坦
--巴机斯坦的缔造群:709527645
--=======================================================


--框架结构
Framework=
{
    Version="0.0.7",
    Update={},
    UI={
        Update={}
    },
    Game={
        PlayerUpdate={},
        Update={}
    },
    --Game插件扩展
    GamePlug ={
        OnKilled={},
        OnRoundStart={},
        OnPlayerJoiningSpawn={},
        OnPlayerSignal={},
        OnTakeDamage={},
        OnPlayerKilled={},
        OnPlayerSpawn={},
        OnPlayerConnect={},
        OnPlayerDisconnect={},
        OnGetWeapon={},
        OnGameSave={},
        OnLoadGameSave={},
        OnClearGameSave={},
        OnReload={},
        OnReloadFinished={},
        OnSwitchWeapon={},
        PostFireWeapon={},
        CanBuyWeapon={},
        CanHaveWeaponInHand={},
        --框架扩展方法
        OnUpdate={},
        OnLaterUpdate={},
        OnPlayerTreat={},
        OnPlayerHurt={},
        OnPlayerUpdate={},
        OnPlayerLaterUpdate={},

        OnChat={},
        OnPlayerDeath={},
    },
    --UI插件扩展
    UIPlug = {
        OnRoundStart={},
        OnSpawn={},
        OnKilled={},
        OnChat={},
        OnInput={},
        OnKeyDown={},
        OnKeyUp={},
        OnSignal={},
        OnKeyDown={},
        OnUpdate={},
    },
    GameTools={
        InZone,
        Create={
            EntityBlock
        }
    },
    CommonTools={
        Create={
            Sync,
            PlayerSync,
            AllPlayerSync,
        }
    },
    SignalToGame={CommandEnd=-300,Death=-400},
    MonsterType={}
}



--[[
Description
    延迟指定时间后执行函数

	f：函数

	args:函数参数 类型table

	t:延迟时间

--]]
TimeCount={}    --存储方法
function Invoke(f,t,...)
    if TimeCountIndex==nil then
        TimeCountIndex=1
    else
        TimeCountIndex=TimeCountIndex+1
    end
    TimeCount[TimeCountIndex]={}
    TimeCount[TimeCountIndex].value=0
    if UI then
        TimeCount[TimeCountIndex].endvalue=(t or 0)*100
    else
        TimeCount[TimeCountIndex].endvalue=(t or 0)*10
    end
    TimeCount[TimeCountIndex].f=f
    TimeCount[TimeCountIndex].args={...}
end

--Mathf静态方法
Mathf={
    Lerp,
    Pow,
}
--[[
static float Lerp(float from, float to, float t);

Interpolates a towards b by t. t is clamped between 0 and 1.

基于浮点数t返回a到b之间的插值，t限制在0～1之间。

When t = 0 returns from. When t = 1 return to. When t = 0.5 returns the average of a and b.

当t = 0返回from，当t = 1 返回to。当t = 0.5 返回from和to的平均值。

--]]
function Mathf.Lerp(fromfloat,tofloat,t)
    local temp=tofloat-fromfloat
    return fromfloat+temp*t
end

--[[
返回a的b次方
--]]
function Mathf.Pow(a,b)
    local temp=1
    if(b>=1) then	--大于0次幂
        for i=1,b do
            temp=temp*a
        end
    elseif(b==0)then--0次幂返回1
        temp=1
    end
    return temp
end

--Vector3方法
--[[
    --静态方法
    Vector3={
       Distance,
       Normalized,
       Normalize,
    }
--]]
--三维向量元表
Vector3={
    normalizied={x,y,z},
    zero={x=0,y=0,z=0},
    one={x=1,y=1,z=1},
    x,
    y,
    z,
}
--三维向量相加
Vector3.__add = function(Vector3_1,Vector3_2)
    local tempVector3={}
    tempVector3.x= Vector3_1.x+ Vector3_2.x
    tempVector3.y= Vector3_1.y+ Vector3_2.y
    tempVector3.z= Vector3_1.z+ Vector3_2.z
    tempVector3=Vector3:new(tempVector3)
    tempVector3.normalizied=Vector3.normalizied:new(tempVector3)
    return tempVector3
end
--三维向量相减
Vector3.__sub = function(Vector3_1,Vector3_2)
    local tempVector3={}
    tempVector3.x= Vector3_1.x- Vector3_2.x
    tempVector3.y= Vector3_1.y- Vector3_2.y
    tempVector3.z= Vector3_1.z- Vector3_2.z
    tempVector3=Vector3:new(tempVector3)
    tempVector3.normalizied=Vector3.normalizied:new(tempVector3)
    return tempVector3
end
Vector3.__eq = function(Vector3_1,Vector3_2)
    if Vector3_1.x==Vector3_2.x and Vector3_1.y==Vector3_2.y and Vector3_1.z==Vector3_2.z then
        return true
    end
    return false
end
--三维向量相乘
Vector3.__mul = function(Vector3_1,float)
    local temp
    if type(Vector3_1)~="table" then
        temp=float
        float=Vector3_1
        Vector3_1=temp
    end
    local tempVector3={}
    tempVector3.x= Vector3_1.x*float
    tempVector3.y= Vector3_1.y*float
    tempVector3.z= Vector3_1.z*float

    tempVector3=Vector3:new(tempVector3)
    tempVector3.normalizied=Vector3.normalizied:new(tempVector3)
    return tempVector3
end

--新建三维向量
function Vector3:new(vector3)
    local mvector3= {}
    setmetatable(mvector3,self)
    self.__index=self
    mvector3.x=vector3.x
    mvector3.y=vector3.y
    mvector3.z=vector3.z
    mvector3.normalizied=Vector3.normalizied:new(mvector3)
    return mvector3
end
function Vector3.normalizied:new(vector3)
    local mvector3= {}
    setmetatable(mvector3,self)
    self.__index=self
    mvector3.x=vector3.x
    mvector3.y=vector3.y
    mvector3.z=vector3.z
    self.__mul=Vector3.__mul
    self.__add=Vector3.__add
    self.__sub=Vector3.__sub
    self.__eq=Vector3.__eq
    --计算单位化向量
    Vector3.Normalize(mvector3)
    return mvector3
end

--[[
Description 描述
Returns this vector with a magnitude of 1 (Read Only).

返回向量的长度为1（只读）。

When normalized, a vector keeps the same direction but its length is 1.0.

当归一化后，向量保持同样的方向，但是长度变为1.0。

Note that the current vector is unchanged and a new normalized vector is returned. If you want to normalize the current vector, use Normalize function.

注意，当前向量不能改变，而是返回一个新的归一化的向量。如果你想归一化当前向量，使用Normalize函数。

If the vector is too small to be normalized a zero vector will be returned.

如果这个向量太小而不能被归一化，一个零向量将会被返回。
--]]
function Vector3.Normalized(vector3)
    local mVector3=Vector3:new({x=vector3.x,y=vector3.y,z=vector3.z})
    return Vector3.Normalize(mVector3)
end

--[[
Description
Returns the distance between a and b.
--]]
function Vector3.Distance (formVector3, toVector3)
    local formVector3=Vector3:new(formVector3)
    local toVector3=Vector3:new(toVector3)
    if formVector3==nil or toVector3==nil then return end
    return math.sqrt(Mathf.Pow((toVector3.x-formVector3.x),2)+Mathf.Pow((toVector3.y-formVector3.y),2)+Mathf.Pow((toVector3.z-formVector3.z),2))
end

--[[
Description 描述
Makes this vector have a magnitude of 1.

使向量的长度为1。

When normalized, a vector keeps the same direction but its length is 1.0.

当归一化的，一个向量保持相同的方向，但它的长度为1.0。

Note that this function will change the current vector. If you want to keep the current vector unchanged, use normalized variable.

注意，这个函数将改变当前向量，如果你想保持当前的向量不改变，使用normalized变量。

If this vector is too small to be normalized it will be set to zero.

如果这个向量太小而不能被归一化，将返回零向量

--]]

function Vector3.Normalize(Vector3)
    local temp = math.sqrt(Mathf.Pow(Vector3.x,2)+Mathf.Pow(Vector3.y,2)+Mathf.Pow(Vector3.z,2))
    Vector3.x=Vector3.x/temp
    Vector3.y=Vector3.y/temp
    Vector3.z=Vector3.z/temp
    return Vector3
end
--Vector3方法结束


--字符串转换方法
--字符串转换为Byte数组
function StringToByteArray(str)
    local bytes={}
    for i=1,#str do
        result=string.byte(string.sub(str,i,i+1))
        bytes[#bytes+1]=result
    end
    return bytes
end

--Byte数组转换为字符串数组
function ByteArrayToStringArray(byteArray)
    local results={}
    local result
    tempLength =1
    for i=1,#byteArray do
        if byteArray[tempLength]<127 then
            result=string.char(byteArray[tempLength])
            results[#results+1]=result
            tempLength = tempLength +1
        else
            result=string.char(byteArray[tempLength], byteArray[tempLength +1], byteArray[tempLength +2])
            results[#results+1]=result
            tempLength = tempLength +3
            if tempLength >#byteArray then
                break
            end
        end
    end
    return results
end
--Byte数组转换为字符串
function ByteArrayToString(byteArray)
    local result=""
    local tempLength =1
    for i=1,#byteArray do
        if byteArray[tempLength]<127 then
            result=result..string.char(byteArray[tempLength])
            tempLength = tempLength +1
        else
            result=result..string.char(byteArray[tempLength],byteArray[tempLength +1],byteArray[tempLength +2])
            tempLength = tempLength +3
            if tempLength >#byteArray then
                break
            end
        end
    end
    return result
end

--时间方法
Time=
{
    deltaTime,--只读，帧间隔
}


--框架内部使用不允许更改
function Framework.Game.Update.Time()
    if Time.startTime~=nil  then
        Time.endTime=Game.GetTime()-Time.startTime
        if Time.endTime>0 then
            Time.deltaTime=Time.endTime
            --下一帧执行
            OnLaterUpdate()
            Time.startTime=nil
        end
    end
    --当前帧执行
    OnUpdate()
    Time.startTime=Game.GetTime()
end


function Framework.Game.PlayerUpdate.Time(player)
    if player then
        if not player.user.Time then
            player.user.Time={}
        end
        if player.user.Time.startTime~=nil  then
            player.user.Time.endTime=Game.GetTime()-player.user.Time.startTime
            if player.user.Time.endTime>0 then
                --下一帧执行
                OnPlayerLaterUpdate(player)
                Framework.OnPlayerLaterUpdate(player)
                player.user.Time.startTime=nil
            end
        end
        --当前帧执行
        OnPlayerUpdate(player)
        Framework.OnPlayerUpdate(player)
        player.user.Time.startTime=Game.GetTime()
    end
end
--框架内部使用不允许更改
--带player参数的每帧执行
function Framework.OnPlayerUpdate(player)
    player.user.Attribute=player.user.Attribute or {}
    local playerAttribute=player.user.Attribute
    playerAttribute.health=player.health
end

--框架内部使用不允许更改
--在Framework.PlayerOnLaterUpdate后一帧执行
function Framework.OnPlayerLaterUpdate(player)
    player.user.Attribute=player.user.Attribute or {}
    local playerAttribute=player.user.Attribute
    playerAttribute.laterHealth=player.health
    if playerAttribute.laterHealth>playerAttribute.health then
        OnPlayerTreat(player)
    elseif playerAttribute.laterHealth<playerAttribute.health then
        OnPlayerHurt(player)
    end
end

--Invoke函数的依赖函数
function Framework.Update.Invoke()
    for k,v in pairs(TimeCount) do
        v.value=v.value+1
        if v.endvalue and v.value>v.endvalue then

            local args=v.args
            v.f(args[1],args[2],args[3],args[4],args[5],args[6],args[7])
            --重新开始计时
            v.value=0
            TimeCountIndex=TimeCountIndex-1
            TimeCount[k]=nil
        end
    end
end


if UI then
    function UI.Event:OnUpdate(time)
        for k, v in pairs(Framework.UI.Update) do
            v()
        end
        for k, v in pairs(Framework.Update) do
            v()
        end
    end
end

if Game then
    function Game.Rule:OnUpdate(time)
        --每帧执行的函数
        --带有player参数的Update
        for k, v in pairs(Framework.Game.PlayerUpdate) do
            for i=1,24 do
                v(Game.Player:Create(i))
            end
        end
        --不带参数的Update
        for k, v in pairs(Framework.Game.Update) do
            v()
        end
        for k, v in pairs(Framework.Update) do
            v()
        end
    end
end

STRING={
    string,
    gsub,
}

function STRING:new(string)
    local o={}
    setmetatable(o,self)
    self.__index=self
    o.string=string
    return o
end

function STRING:gsub(pattern,repl)
    self.string=string.gsub(self.string,pattern,repl)
end





REGISTER={
    Registry,
}
function REGISTER:new()
    local tab={}
    setmetatable(tab,self)
    self.__index=self
    return tab
end

function REGISTER:Register(fun)
    self.Registry=self.Registry or {}
    if type(fun)=="function" then
        table.insert(self.Registry,fun)
    end
end

function REGISTER:UnRegister(fun)
    for i=1,#self.Registry do
        if self.Registry[i]==fun then
            table.remove(self.Registry,i)
        end
    end
end
function REGISTER:Trigger(...)
    if self.Registry then
        for _,fun in pairs(self.Registry) do
            fun(...)
        end
    end
end

--注册
if Game then
    Game.Rule.enemyfire=false
    Game.Rule.friendlyfire=false
    function Framework.GamePlug.OnKilled:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnKilled:Trigger(victim, killer)
        if self.REGISTER then
            self.REGISTER:Trigger(victim,killer)
        end
    end
    function Framework.GamePlug.OnKilled:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end

    function Framework.GamePlug.OnRoundStart:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnRoundStart:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.GamePlug.OnRoundStart:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end

    function Framework.GamePlug.OnPlayerSignal:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerSignal:Trigger(player, signal)
        if self.REGISTER then
            self.REGISTER:Trigger(player,signal)
        end
    end
    function Framework.GamePlug.OnPlayerSignal:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end

    function Framework.GamePlug.OnTakeDamage:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnTakeDamage:Trigger(victim, attacker, damage, weapontype, hitbox)
        if self.REGISTER then
            self.REGISTER:Trigger(victim,attacker,damage,weapontype,hitbox)
        end
    end
    function Framework.GamePlug.OnTakeDamage:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnTakeDamage:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerKilled:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerKilled:Trigger(victim, killer)
        if self.REGISTER then
            self.REGISTER:Trigger(victim, killer)
        end
    end
    function Framework.GamePlug.OnPlayerKilled:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerSpawn:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerSpawn:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerSpawn:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerJoiningSpawn:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerJoiningSpawn:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerJoiningSpawn:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerConnect:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerConnect:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerConnect:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerDisconnect:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerDisconnect:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerDisconnect:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnGetWeapon:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnGetWeapon:Trigger(player, weaponid, weapon)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weaponid,weapon)
        end
    end
    function Framework.GamePlug.OnGetWeapon:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnGameSave:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnGameSave:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnGameSave:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnLoadGameSave:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnLoadGameSave:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnLoadGameSave:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnClearGameSave:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnClearGameSave:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnClearGameSave:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnReload:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnReload:Trigger(player, weapon, time)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weapon,time)
        end
    end
    function Framework.GamePlug.OnReload:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnReloadFinished:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnReloadFinished:Trigger(player, weapon)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weapon)
        end
    end
    function Framework.GamePlug.OnReloadFinished:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnSwitchWeapon:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnSwitchWeapon:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnSwitchWeapon:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.PostFireWeapon:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.PostFireWeapon:Trigger(player, weapon, time)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weapon,time)
        end
    end
    function Framework.GamePlug.PostFireWeapon:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.CanBuyWeapon:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.CanBuyWeapon:Trigger(player, weapon)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weapon)
        end
    end
    function Framework.GamePlug.CanBuyWeapon:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.CanHaveWeaponInHand:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.CanHaveWeaponInHand:Trigger(player, weaponid, weapon)
        if self.REGISTER then
            self.REGISTER:Trigger(player,weaponid,weapon)
        end
    end
    function Framework.GamePlug.CanHaveWeaponInHand:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --框架扩展方法
    --每帧调用,不带player参数
    function Framework.GamePlug.OnUpdate:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnUpdate:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.GamePlug.OnUpdate:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --在OnUpdate的下一帧调用
    function Framework.GamePlug.OnLaterUpdate:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnLaterUpdate:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.GamePlug.OnLaterUpdate:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --玩家受到任何治疗时调用
    function Framework.GamePlug.OnPlayerTreat:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerTreat:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerTreat:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --玩家受到任何伤害时调用
    function Framework.GamePlug.OnPlayerHurt:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerHurt:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerHurt:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --带player参数的每帧调用
    function Framework.GamePlug.OnPlayerUpdate:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerUpdate:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerUpdate:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --在PlayerOnUpdate的下一帧调用
    function Framework.GamePlug.OnPlayerLaterUpdate:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerLaterUpdate:Trigger(player)
        if self.REGISTER then
            self.REGISTER:Trigger(player)
        end
    end
    function Framework.GamePlug.OnPlayerLaterUpdate:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --聊天框有内容时调用
    function Framework.GamePlug.OnChat:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnChat:Trigger(player,msg)
        if self.REGISTER then
            self.REGISTER:Trigger(player,msg)
        end
    end
    function Framework.GamePlug.OnChat:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.GamePlug.OnPlayerDeath:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.GamePlug.OnPlayerDeath:Trigger(msg, player)
        if self.REGISTER then
            self.REGISTER:Trigger(msg,player)
        end
    end
    function Framework.GamePlug.OnPlayerDeath:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    --官方方法
    function Game.Rule:OnKilled(victim,killer)
        Framework.GamePlug.OnKilled:Trigger(victim,killer)
    end
    function Game.Rule:OnRoundStart()
        Framework.GamePlug.OnRoundStart:Trigger()
    end
    function Game.Rule:OnPlayerJoiningSpawn(player)
        Framework.GamePlug.OnPlayerJoiningSpawn:Trigger(player)
    end
    function Game.Rule:OnPlayerSignal(player,signal)
        Framework.GamePlug.OnPlayerSignal:Trigger(player,signal)
    end
    function Game.Rule:OnTakeDamage(victim,attacker,damage,weapontype,hitbox)
        Framework.GamePlug.OnTakeDamage:Trigger(victim,attacker,damage,weapontype,hitbox)
    end
    function Game.Rule:OnPlayerKilled (victim, killer)
        Framework.GamePlug.OnPlayerKilled:Trigger(victim, killer)
    end
    function Game.Rule:OnPlayerSpawn (player)
        Framework.GamePlug.OnPlayerSpawn:Trigger(player)
    end
    function Game.Rule:OnPlayerConnect(player)
        Framework.GamePlug.OnPlayerConnect:Trigger(player)
    end
    function Game.Rule:OnPlayerDisconnect (player)
        Framework.GamePlug.OnPlayerDisconnect:Trigger(player)
    end
    function Game.Rule:OnGetWeapon(player,weaponid,weapon)
        Framework.GamePlug.OnGetWeapon:Trigger(player,weaponid,weapon)
    end
    function Game.Rule:OnGameSave(player)
        Framework.GamePlug.OnGameSave:Trigger(player)
    end
    function Game.Rule:OnLoadGameSave(player)
        Framework.GamePlug.OnLoadGameSave:Trigger(player)
    end
    function Game.Rule:OnClearGameSave(player)
        Framework.GamePlug.OnClearGameSave:Trigger(player)
    end
    function Game.Rule:OnReload(player,weapon,time)
        Framework.GamePlug.OnReload:Trigger(player,weapon,time)
    end
    function Game.Rule:OnReloadFinished(player,weapon)
        Framework.GamePlug.OnReloadFinished:Trigger(player,weapon)
    end
    function Game.Rule:OnSwitchWeapon(player)
        Framework.GamePlug.OnSwitchWeapon:Trigger(player)
    end
    function Game.Rule:PostFireWeapon(player,weapon,time)
        Framework.GamePlug.PostFireWeapon:Trigger(player,weapon,time)
    end
    function Game.Rule:CanBuyWeapon(player,weapon)
        Framework.GamePlug.CanBuyWeapon:Trigger(player,weapon)
    end
    function Game.Rule:CanHaveWeaponInHand(player,weaponid,weapon)
        Framework.GamePlug.CanHaveWeaponInHand:Trigger(player,weaponid,weapon)
    end
    --框架扩展方法
    function OnUpdate()
        Framework.GamePlug.OnUpdate:Trigger()
    end
    function OnLaterUpdate()
        Framework.GamePlug.OnLaterUpdate:Trigger()
    end
    function OnPlayerTreat(player)
        Framework.GamePlug.OnPlayerTreat:Trigger(player)
    end
    function OnPlayerHurt(player)
        Framework.GamePlug.OnPlayerHurt:Trigger(player)
    end
    function OnPlayerUpdate(player)
        Framework.GamePlug.OnPlayerUpdate:Trigger(player)
    end
    function OnPlayerLaterUpdate(player)
        Framework.GamePlug.OnPlayerLaterUpdate:Trigger(player)
    end
    function OnChat(msg,player)
        Framework.GamePlug.OnChat:Trigger(msg,player)
    end
    function OnPlayerDeath(playerIndex)
        Framework.GamePlug.OnPlayerDeath:Trigger(playerIndex)
    end
end



if UI then
    --官方方法
    function UI.Event:OnRoundStart()
        Framework.UIPlug.OnRoundStart:Trigger()
    end
    function UI.Event:OnSpawn()
        Framework.UIPlug.OnSpawn:Trigger()
    end
    function UI.Event:OnKilled()
        Framework.UIPlug.OnKilled:Trigger()
    end
    function UI.Event:OnChat(msg)
        Framework.UIPlug.OnChat:Trigger(msg)
    end
    function UI.Event:OnInput(inputs)
        Framework.UIPlug.OnInput:Trigger(inputs)
    end
    function UI.Event:OnKeyDown(inputs)
        Framework.UIPlug.OnKeyDown:Trigger(inputs)
    end
    function UI.Event:OnKeyUp(inputs)
        Framework.UIPlug.OnKeyUp:Trigger(inputs)
    end
    function UI.Event:OnSignal(signal)
        Framework.UIPlug.OnSignal:Trigger(signal)
    end
    function UI.Event:OnKeyDown(inputs)
        Framework.UIPlug.OnKeyDown:Trigger(inputs)
    end

    function Framework.UI.Update:OnUpdate(time)
        Framework.UIPlug.OnUpdate:Trigger(time)
    end

    function Framework.UIPlug.OnRoundStart:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnRoundStart:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.UIPlug.OnRoundStart:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnSpawn:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnSpawn:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.UIPlug.OnSpawn:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnKilled:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnKilled:Trigger()
        if self.REGISTER then
            self.REGISTER:Trigger()
        end
    end
    function Framework.UIPlug.OnKilled:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnChat:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnChat:Trigger(msg)
        if self.REGISTER then
            self.REGISTER:Trigger(msg)
        end
    end
    function Framework.UIPlug.OnChat:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnInput:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnInput:Trigger(inputs)
        if self.REGISTER then
            self.REGISTER:Trigger(inputs)
        end
    end
    function Framework.UIPlug.OnInput:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnKeyDown:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnKeyDown:Trigger(inputs)
        if self.REGISTER then
            self.REGISTER:Trigger(inputs)
        end
    end
    function Framework.UIPlug.OnKeyDown:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnKeyUp:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnKeyUp:Trigger(inputs)
        if self.REGISTER then
            self.REGISTER:Trigger(inputs)
        end
    end
    function Framework.UIPlug.OnKeyUp:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnSignal:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnSignal:Trigger(inputs)
        if self.REGISTER then
            self.REGISTER:Trigger(inputs)
        end
    end
    function Framework.UIPlug.OnSignal:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
    function Framework.UIPlug.OnUpdate:Register(fun)
        if not self.REGISTER then
            self.REGISTER=REGISTER:new()
        end
        self.REGISTER:Register(fun)
    end
    function Framework.UIPlug.OnUpdate:Trigger(time)
        if self.REGISTER then
            self.REGISTER:Trigger(time)
        end
    end
    function Framework.UIPlug.OnUpdate:UnRegister(fun)
        self.REGISTER:UnRegister(fun)
    end
end







--临时创建一个装置方块
--pos  {x,y,z}
--返回  Game.EntityBlock
Framework.GameTools.Create.EntityBlock=function(pos)
    local box
    box=Game.EntityBlock.Create(pos)
    return box
end
--判断玩家是否在区域内
--pos1 {x,y,z}
--pos2 {x,y,z}
--playerPos {x,y,z} 玩家坐标
--返回 bool是否在区域内
Framework.GameTools.InZone=function(pos1,pos2,playerPos)
    --整理坐标
    local  ChangePos=function(x1,y1,z1,x2,y2,z2)
        local a
        if x1>x2 then a=x1 x1=x2 x2=a end
        if y1>y2 then a=y1 y1=y2 y2=a end
        if z1>z2 then a=z1 z1=z2 z2=a end
        return x1,y1,z1,x2,y2,z2
    end
    local x1,y1,z1,x2,y2,z2=ChangePos(pos1.x,pos1.y,pos1.z,pos2.x,pos2.y,pos2.z)
    if playerPos.x>=x1 and  playerPos.x<=x2 and  playerPos.y>=y1 and  playerPos.y<=y2 and  playerPos.z>=z1 and  playerPos.z<=z2 then
        return true
    end
    return false
end


--框架同步变量扩展方法
GameSyncString="if Game then Name=Game.SyncValue:Create('Name')return Name end"
UISyncString="if UI then Name=UI.SyncValue:Create('Name')return Name end"

PlayerGameSyncString="return function(playerIndex) if Game then Name=Name or {} Name[playerIndex]=Game.SyncValue:Create('Name'..playerIndex) return Name end end"
PlayerUISyncString="if UI then Name=UI.SyncValue:Create('Name'..UI.PlayerIndex())return Name end"


--同时在Game和UI中创建同步变量

function Framework.CommonTools.Create.Sync(name)
    if Game then
        local tempGameString=STRING:new(GameSyncString)
        tempGameString:gsub("Name",name)
        load(tempGameString.string)()
    end
    if UI then
        local tempUIString=STRING:new(UISyncString)
        tempUIString:gsub("Name",name)
        load(tempUIString.string)()
    end
end

function Framework.CommonTools.Create.PlayerSync(name,playerIndex)
    if Game then
        local tempGameString=STRING:new(PlayerGameSyncString)
        tempGameString:gsub("Name",name)
        load(tempGameString.string)()(playerIndex)
    end
    if UI then
        local tempUIString=STRING:new(PlayerUISyncString)
        tempUIString:gsub("Name",name)
        load(tempUIString.string)()
    end
end

function Framework.CommonTools.Create.AllPlayerSync(name)
    for i=1,24 do
        Framework.CommonTools.Create.PlayerSync(name,i)
    end
end

Framework.MonsterType={
    A101AR=1477,
    RUNNER0=247,
    NORMAL3=202,
    NORMAL5=204,
    RUNNER4=209,
    NONE=0,
    HEAVY1=244,
    A104RL=1478,
    RUNNER=5210,
    NORMAL0=246,
    RUNNER2=207,
    NORMAL6=205,
    HEAVY2=245,
    RUNNER1=206,
    PUMPKIN_HEAD=1286,
    PUMPKIN=1285,
    RUNNER3=208,
    NORMAL1=200,
    NORMAL2=201,
    GHOST=1284,
    NORMAL4=203,
    RUNNER6=211,
    ALIEN_BEAST=1289,				--异形斗兽
    SOLDIER=688,					--黄巾士兵
    GENERAL=689,					--黄巾将领
    SNOWMAN=763,					--圣诞雪人
    MUSHROOM_KING=248,				--蘑菇王
    ORANGE_MUSHROOM=249,			--橙色蘑菇
    RED_MUSHROOM=250,				--红刺蘑菇王
    WATER_KING=251,					--水灵王
    GREEN_WATER=687,				--绿水灵
    RED_ROBOT=940,					--斗魂红色机
    BLUE_ROBOT=941,					--斗魂蓝色机
    GREEN_FANS=1097,				--绿衣狂热球迷
    RED_FANS=1098,					--红衣狂热球迷
    THROWING_ZOMBIES=1520,			--投掷僵尸
    EXPLODING_ZOMBIES=1521,			--自爆僵尸
    BATTERY=1509,					--生化炮塔
    DEAD_KING=1650,					--异域尸王
    DEAD_MAN1=1651,					--异域男僵尸1
    DEAD_MAN2=1652,					--异域男僵尸2
    DEAD_WOMAN=1653,				--异域女僵尸
}




--框架自带命令插件UI
CommandPlug=true--开启命令插件
if CommandPlug then
    if UI then
       function Command(msg)
            bytes=StringToByteArray(msg)
            for i=1,#bytes do
                UI.Signal(bytes[i])
            end
            UI.Signal(Framework.SignalToGame.CommandEnd)
        end
        --注册命令插件
        Framework.UIPlug.OnChat:Register(Command)
    end
    if Game then
         COMMAND={}
         function SignalToChinese(player,signal)
            if signal>0 then
                COMMAND[player.name]= COMMAND[player.name] or {}
                table.insert(COMMAND[player.name],signal)
            elseif signal==Framework.SignalToGame.CommandEnd then
                OnChat(player,ByteArrayToString(COMMAND[player.name]))
                COMMAND[player.name]={}
            end
        end
        --注册命令插件
        Framework.GamePlug.OnPlayerSignal:Register(SignalToChinese)
    end
end

--死亡检查扩展
DeathFlag={}
if Game then
    function PlayerDeathCheck(player)
        DeathFlag[player.name]=DeathFlag[player.name] or false
        if player.health<=0 then
            if DeathFlag[player.name]==false then
                OnPlayerDeath(player)
                DeathFlag[player.name]=true
            end
        end
    end
    function OnPlayerSpawn(player)
        if DeathFlag[player.name]==true then
            DeathFlag[player.name]=false
        end
    end
    Framework.GamePlug.OnPlayerUpdate:Register(PlayerDeathCheck)
    Framework.GamePlug.OnPlayerSpawn:Register(OnPlayerSpawn)
end





