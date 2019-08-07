PARAMETERS m.puPar1, m.puPar2, m.puPar3

* How to run:
* do test2 with  "--nogui","--XXXd:\"

LOCAL m.loObj, m.lcPath, m.liOK
CLEAR
m.lcPath=SYS(16)
m.lcPath=IIF(RAT("\", m.lcPath)>0, LEFT(m.lcPath, RAT("\", m.lcPath)), m.lcPath)
SET PROCEDURE TO (m.lcPath+"..\src\pname.prg")
#INCLUDE "..\src\pname.h"

* If any parameter is unknow
* hand conversion paramneter --nogui
*  see method _MyParamBuffer::Convert()

PUBLIC m.plNoGUI, m.pcIn, m.pcOut
m.loObj=CREATEOBJECT("_MyParamBuffer")
m.loObj.Add("--nogui", "plNoGUI")
m.loObj.Add("--in", "pcIn", "C")
m.loObj.Add("--out", "pcOut", "C")

m.liOK=m.loObj.Parse(m.puPar1, m.puPar2, m.puPar3)

IF m.liOK=__PNAME_PARAM_PANIC
   ?"Bad parameters... panic mode"
   FOR m.lii=1 TO m.loObj.iFailed
       ?m.loObj.aFailed(m.lii)
   NEXT
ENDIF

?"plNoGUI:", m.plNoGUI
?"pcIn:", m.pcIn
?"pcOut:", m.pcOut
RELE m.plNoGUI, m.pcIn, m.pcOut

SET PROCEDURE TO

DEFINE CLASS _myParamBuffer AS _ParamBuffer
   Name="_myParamBuffer"
   
   PROCEDURE Convert
      *
      * _myParamBuffer::Convert
      * 
      LPARAMETERS m.lcName, m.lcValue, m.lcType
      IF m.lcName=='--nogui'
         RETURN .T.
      ELSE
         RETURN DODEFAULT(m.lcName, m.lcValue, m.lcType)
      ENDIF
   ENDPROC
ENDDEFINE
