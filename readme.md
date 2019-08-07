# Named Parameters
The Named parameters servers for processing and checking input EXE/APP parameters.

## VFP Compatibility
VFP 5, VFP 6, VFP 7, VFP 8, VFP 9, VFP Advanced, VFP Advanced 64 bit

## Files
- scr\pname.h - header file
- src\pname.PRG - main program

## Notice
Parameters's value which contain character SPACE must be enclose '', "" or []

## Examples

### Example 1 
```foxpro
* How to run:
* do test1 with  "--inc:\","--outd:\",""
* do test1 with  "--inc:\","--outd:\","--nogui"

PARAMETERS m.puPar1, m.puPar2, m.puPar3

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
```

### Example 2
```foxpro
* How to run:
* do test2 with  "--nogui","--XXXd:\"

PARAMETERS m.puPar1, m.puPar2, m.puPar3

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
```

### Example 3
```foxpro
* How to run:
* do test3 with  "--nogui","--oute:\"

PARAMETERS m.puPar1, m.puPar2, m.puPar3

LOCAL m.loObj, m.lcPath, m.liOK
CLEAR
m.lcPath=SYS(16)
m.lcPath=IIF(RAT("\", m.lcPath)>0, LEFT(m.lcPath, RAT("\", m.lcPath)), m.lcPath)
SET PROCEDURE TO (m.lcPath+"..\src\pname.prg")
#INCLUDE "..\src\pname.h"

* If value of any parameter are not allowed
*  see method _MyParamBuffer::CheckValue()
PUBLIC m.plNoGUI, m.pcIn, m.pcOut

m.loObj=CREATEOBJECT("_MyParamBuffer")
m.loObj.Add("--nogui", "plNoGUI")
m.loObj.Add("--in", "pcIn", "C")
m.loObj.Add("--out", "pcOut", "C")

m.liOK=m.loObj.Parse(m.puPar1, m.puPar2, m.puPar3)

IF m.liOK=__PNAME_PARAM_FAILED
   ?"Wrong parameters's value"
   FOR m.lii=1 TO m.loObj.iWrong
       ?m.loObj.aWrong(m.lii, 1), m.loObj.aWrong(m.lii, 2)
   NEXT
ENDIF

?"plNoGUI:", m.plNoGUI
?"pcIn:", m.pcIn
?"pcOut:", m.pcOut
RELE m.plNoGUI, m.pcIn, m.pcOut


SET PROCEDURE TO



DEFINE CLASS _myParamBuffer AS _ParamBuffer


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


   PROCEDURE CheckValue
      *
      * _myParamBuffer::CheckValue
      * 
      LPARAMETERS m.lcName, m.luValue
      * lcName  - Parameter Name
      * luValue - Base Value

      IF m.lcName=='--out' AND m.luValue<>'d:\'
         RETURN .F.
      ENDIF
      RETURN .T.
   ENDPROC

ENDDEFINE
```