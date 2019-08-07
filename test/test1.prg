PARAMETERS m.puPar1, m.puPar2, m.puPar3

* How to run:
* do test1 with  "--inc:\","--outd:\",""
* do test1 with  "--inc:\","--outd:\","--nogui"

LOCAL m.loObj, m.lcPath, m.liOK
CLEAR
m.lcPath=SYS(16)
m.lcPath=IIF(RAT("\", m.lcPath)>0, LEFT(m.lcPath, RAT("\", m.lcPath)), m.lcPath)
SET PROCEDURE TO (m.lcPath+"..\src\pname.prg")

* If no problemo :-)
PUBLIC m.plNoGUI, m.pcIn, m.pcOut

m.loObj=CREATEOBJECT("_ParamBuffer")
m.loObj.Add("--nogui", "plNoGUI", "E")
m.loObj.Add("--in", "pcIn", "C")
m.loObj.Add("--out", "pcOut", "C")
m.loObj.Parse(m.puPar1, m.puPar2, m.puPar3)

?"plNoGUI:",m.plNoGUI
?"pcIn:",m.pcIn
?"pcOut:",m.pcOut
RELE m.plNoGUI, m.pcIn, m.pcOut
SET PROCEDURE TO
