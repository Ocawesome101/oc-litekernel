local a,b,c=component.invoke,component.list,component.proxy;local d=b("eeprom")()local e=a(d,"getData")local f=c(e)local g={[e]=c(e)}for e in component.list("filesystem")do g[e]=c(e)end;local h=b("gpu")()if not h then error("GPU required")end;h=c(h)local i=b("screen")()if not i then error("Screen required")end;h.bind(i)h.setResolution(h.maxResolution())local j,k=1,1;local l,m=h.getResolution()local function n()computer.pullSignal(0)end;local function o(p,q)if p<=l and q<=m then j,k=p,q end end;local function r(color)h.setForeground(color)end;local function s()return h.getForeground(color)end;local function t(color)h.setBackground(color)end;local function u(color)return h.getBackground(color)end;local function v(w)h.set(j,k,w)j=j+#w end;local function x()h.copy(1,2,l,m-1,0,-1)h.fill(1,m,l,1," ")end;local function y()h.fill(1,1,l,m," ")end;local z={black=0x000000,red=0xFF0000,green=0x00FF00,blue=0x0000FF,yellow=0xFFFF00,purple=0xFF00FF,aqua=0x00FFFF,white=0xFFFFFF}function write(w)for A in w:gmatch(".")do if A=="\n"then if k==m then x()o(1,k)else o(1,k+1)end else if j==l and k+1==m then x()o(1,k)elseif j==l then o(1,k+1)end;v(A)end end end;function print(...)local B={...}for C=1,#B,1 do if type(B[C])=="table"then print(table.unpack(B[C]))else write(tostring(B[C]))end;if C<#B then write(" ")end end;write("\n")end;y()o(1,1)print("Lite Kernel 0.1")print("Initializing signal processing")local D=computer.pullSignal;sig={}function sig.pull(E,F)local G={}repeat G={D(F)}until G[1]==E or E==nil;return table.unpack(G)end;computer.pullSignal=sig.pull;print("Initializing read()")function read(H)local I=""local J={}for K,L in pairs(H)do J[K]=L end;table.insert(J,"")local M=#J;local N,O=j,k;local function P(Q)o(N,O)write(" ":rep(l-N))o(N,O)write(I..(Q or""))end;P("|")while true do local R,S,T,U=sig.pull()if R=="key_down"then if T==8 then I=I:sub(1,-2)elseif T==13 then P("")write("\n")return I elseif T==0 then if U==208 then if M<#J then M=M+1;I=J[M]end elseif U==200 then if M>1 then M=M-1;I=J[M]end end else if T>=32 and T<=126 then I=I..string.char(T)end end end;P("|")end end;function printError(V)local W=s()r(z.red)print(V)r(W)end;local J={""}setmetatable(J,{__index=table})local X={["free"]=function()print("Used: "..tostring(math.floor((computer.totalMemory()-computer.freeMemory())/1024)).."k / "..tostring(math.floor(computer.totalMemory()/1024)).."k")end,["shutdown"]=function()computer.shutdown()end,["reboot"]=function()computer.shutdown(true)end,["ls"]=function(Y)local Z=f.list(Y or"/")print(Z)end,["cat"]=function(_)local a0=f.open(_)local a1=""repeat local G=f.read(a0,0xFFFF)a1=a1 ..(G or"")until not G;f.close(a0)print(a1)end,["clear"]=function()y()o(1,1)end,["mkdir"]=function(Y)f.makeDirectory(Y)end,["rm"]=function(_)f.remove(_)end}local function a2(I,a3)local a4={}local a5=""for A in I:gmatch(".")do if A==a3 then if a5~=""then table.insert(a4,a5)a5=""end else a5=a5 ..A end end;if a5~=""then table.insert(a4,a5)end;return a4 end;while true do write("litekernel: ")local a6=read(J)J:insert(a6)a6=a2(a6," ")local B={table.unpack(a6,2,a6.n)}a6=a6[1]for K,L in pairs(X)do if K==a6 then local a7,R=pcall(function()L(table.unpack(B))end)if not a7 and R then printError(R)end end end end;computer.shutdown()
