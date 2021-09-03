

</font>




<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">


# 前言

<font color=#999AAA >CSOL缔造者LUA的脚本多种多样。但是往往地图作者不会使用LUA，而LUA的编写者又不会做地图。或者当你需要移植其他作者的脚本却无从下手。为了建立起作者与脚本编写者的桥梁，为了能够让脚本能够模块化，更高的移植性，能够让不会编写LUA的作者们也能够轻易的使用，扩展，移植别人的插件，MaiMaiFramework诞生了</font>

<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">

<font color=#999AAA >注意：这个LUA框架只能在CSOL缔造者游戏模式环境下使用
# 一、MaiMaiFramework是什么？


<font color=#999AAA >MaiMaiFramework是基于事件的隐式调用的CSOL缔造者框架。为了能够让不会LUA的作者也能够快速掌握使用、扩展、移植其他LUA脚本编写者的脚本。为了实现这一目标，脚本编写者必须按照一定的规则来编写脚本。这些脚本将作为插件通过注册的方式静态或者动态的载入到框架中。



# 二、插件使用者看这里
</font></font>


## 1.下载MaiMaiFramework.lua

链接: [点击下载](https://github.com/umaruIsABoy/MaiMaiFramework.lua/blob/main/MaiMaiFramework.lua).

## 2.更改project.json内容
```c
{
    "game": ["MaiMaiFramework.lua"], 
    "ui": ["MaiMaiFramework.lua"]
}
```
<font color=#999AAA >现在还没有插件，如果有，就像这样添加新的插件</font>
```c
{
    "game": ["MaiMaiFramework.lua", "ExamplePlug.lua"], 
    "ui": ["MaiMaiFramework.lua", "ExamplePlug.lua"]
}
```
<hr style=" border:solid; width:100px; height:1px;" color=#000000 size=1">
</font></font>

</font></font>

# 三、插件开发者看这里
</font></font>

## 1.新建一个插件
<font color=#999AAA >这个文件会同时装载到服务端Game和客户端UI中</font>

## 2.编写插件和注册方法
<font color=#999AAA >例如：文件名为PrintPlug.lua</font>
```lua

--编写插件
if Game then
	function MyGameFunc(player,msg)
		print("玩家"..player.name.."说："..msg)
	end
end
if UI then
	function MyGameFunc(time)
		print("每帧执行:".."当前时间"..time)
	end
end
--如果需要的话，注册插件方法到某个框架方法中
if Game then
    Framework.GamePlug.OnChat:Register(MyGameFunc)
end
--每帧执行一次MyUIFunc
if UI then
    Framework.UIPlug.OnUpdate:Register(MyUIFunc)
end
```
<font color=#999AAA >一个并没有什么用的打印插件就这样开发完成了</font>
## 3.测试你的插件
<font color=#999AAA >[下载MaiMaiFramework.lua](https://github.com/umaruIsABoy/MaiMaiFramework.lua/blob/main/MaiMaiFramework.lua)并且添加你的插件</font>
```c
{
    "game": ["MaiMaiFramework.lua", "PrintPlug.lua"], 
    "ui": ["MaiMaiFramework.lua", "PrintPlug.lua"]
}
```
<font color=#999AAA >在CSOL缔造者游戏模式中测试脚本查看效果</font>
# 四、开发文档
## 1、注册方法
<font color=#999AAA >例：服务端插件注册</font>

```lua
Framework.GamePlug.OnUpdate:Register()
Framework.GamePlug.OnUpdate:UnRegister()
```
<font color=#999AAA >例：客户端插件注册</font>
```lua
Framework.UIPlug.OnUpdate:Register()
Framework.UIPlug.OnUpdate:UnRegister()
```


</font></font>

</font></font>

<font color=#999AAA >服务端（Game）中能够注册的方法</font>   
 		
        OnKilled
        OnRoundStart
        OnPlayerJoiningSpawn
        OnPlayerSignal
        OnTakeDamage
        OnPlayerKilled
        OnPlayerSpawn
        OnPlayerConnect
        OnPlayerDisconnect
        OnGetWeapon
        OnGameSave
        OnLoadGameSave
        OnClearGameSave
        OnReload
        OnReloadFinished
        OnSwitchWeapon
        PostFireWeapon
        CanBuyWeapon
        CanHaveWeaponInHand
        OnUpdate
        OnLaterUpdate
        OnPlayerTreat
        OnPlayerHurt
        OnPlayerUpdate
        OnPlayerLaterUpdate
        OnChat
        OnPlayerDeath




<font color=#999AAA >客户端（UI）中能够注册的方法</font>    

        OnRoundStart
        OnSpawn
        OnKilled
        OnChat
        OnInput
        OnKeyDown
        OnKeyUp
        OnSignal
        OnKeyDown
        OnUpdate
        
## 2、参数说明
</font></font>
### 1）官方方法
<font color=#999AAA >官方方法注册的方法参数看：[官方文档](https://tw.beanfun.com/cso/STUDIO/api/index.html)
</font>  
### 2）扩展方法参数说明
<font color=#999AAA>服务端（Game）扩展方法</font>

      OnLaterUpdate
      OnPlayerTreat
      OnPlayerHurt
      OnPlayerUpdate
      OnPlayerLaterUpdate
      OnChat
      OnPlayerDeath
**OnLaterUpdate（）**
<font color=#999AAA>会在OnUpdate的下一帧执行</font>
```lua
function MyOnLaterUpdate()

end
--注册你的方法
Framework.GamePlug.OnLaterUpdate:Register(MyOnLaterUpdate)
```

**OnPlayerTreat（player）**
<font color=#999AAA>在玩家受到治疗的下一帧执行</font>
```lua
function MyOnPlayerTreat(player)

end
--注册你的方法
Framework.GamePlug.OnPlayerTreat:Register(MyOnPlayerTreat)
```
**OnPlayerHurt（player）**
<font color=#999AAA>在玩家受到伤害的下一帧调用</font>
```lua
function MyOnPlayerHurt(player)

end
--注册你的方法
Framework.GamePlug.OnPlayerTreat:Register(MyOnPlayerHurt)
```
                                              
**OnPlayerUpdate（player）**
<font color=#999AAA>带有player参数的每帧调用</font>
```lua
function MyOnPlayerUpdate(player)

end
--注册你的方法
Framework.GamePlug.OnPlayerUpdate:Register(MyOnPlayerUpdate)
```                                   
**OnPlayerLaterUpdate（player）**
<font color=#999AAA>在OnPlayerUpdate下一帧调用</font>
```lua
function MyOnPlayerLaterUpdate(player)

end
--注册你的方法
Framework.GamePlug.OnPlayerLaterUpdate:Register(MyOnPlayerLaterUpdate)
```                                                 
**OnChat（player,msg）**
<font color=#999AAA>玩家发送消息时调用</font>       
<font color=#999AAA>msg：消息内容</font>
```lua
function MyOnChat(player,msg)

end
--注册你的方法
Framework.GamePlug.OnChat:Register(MyOnChat)
```                                           
**OnPlayerDeath（player）**
<font color=#999AAA>玩家死亡时调用</font>
```lua
function MyOnPlayerDeath(player,msg)

end
--注册你的方法
Framework.GamePlug.OnPlayerDeath:Register(MyOnPlayerDeath)
```    
