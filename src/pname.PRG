**************************************************************************
** Program name: PName.PRG
** Version: 0.0.2
** Create date: 2011-02-13
** Description: Parser for named parameters
** Author: Martina Jindrová
** E-mail: jindra@egservis.cz
** CP: 1250
**************************************************************************

**************************************************************************
** Why use pname.prg.
** - If you need pass to your EXE/APP parameters but
**    you not to be depend to static order
** - If you need pass any parameters
**
**************************************************************************

#INCLUDE "pname.h"

DEFINE CLASS _ParamBuffer AS CUSTOM 
   Name="_ParamBuffer"
   PROTECTED ARRAY aParams(1) && array of parameters
   PROTECTED iCount && Count of parameters
   iCount=0

   DIME aFailed(1) && array of bad/unknown parameters
   iFailed=0 && 

   DIME aWrong(1) && array of wrong parameters's values
   iWrong=0 && Count of wrong parameters's values


   PROCEDURE Add && Add parameter to list
      *
      * _ParamBuffer::Add
      * 
      LPARAMETERS m.lcName, m.lcOut, m.lcType
      * lcName - Parametr name
      * lcOut  - Output variable o object properties
      * lcType - Output Type

      This.iCount=This.iCount+1
      DIMENSION This.aParams(This.iCount, 3)
      This.aParams(This.iCount, 1)=m.lcName
      This.aParams(This.iCount, 2)=m.lcOut
      This.aParams(This.iCount, 3)=m.lcType
   ENDPROC


   PROCEDURE Parse && Parse passed values
      *
      * _ParamBuffer::Parse
      * 
      LPARAM m.luPar1, m.luPar2, m.luPar3, m.luPar4, m.luPar5, m.luPar6, m.luPar7, m.luPar8, m.luPar9, m.luPar10,;
             m.luPar11, m.luPar12, m.luPar13, m.luPar14, m.luPar15, m.luPar16, m.luPar17, m.luPar18, m.luPar19, m.luPar20,;
             m.luPar21, m.luPar22, m.luPar23, m.luPar24, m.luPar25, m.luPar26, m.luPar27

      LOCAL m.liSum, m.lcI, m.lii, m.liy, m.luVal, m.liFailed, m.liID, m.lcPom, m.liOK
      LOCAL ARRAY m.laPom(PCOUNT())

      This.aFailed(1)=.NULL.
      STORE 0 TO m.liSum, m.liFailed
      FOR m.lii=1 TO PCOUNT()
          m.lcI=LTRIM(STR(m.lii, 11))
          STORE EVAL("m.luPar"+m.lcI) TO  m.luVal
          IF TYPE("m.luVal")#"C"
             LOOP
          ENDIF

          FOR m.liy=1 TO This.iCount
              IF LOWER(This.aParams(m.liy, 1))==LOWER(LEFT(m.luVal,LEN(This.aParams(m.liy, 1))))
                 EXIT
              ENDIF
          NEXT
          m.liSum=BITOR(m.liSum, IIF(m.liy<=This.iCount, 2, IIF(EMPTY(m.luVal), 0, 1)))
          IF m.liy>This.iCount && Add bad parameter to list
             m.liFailed=m.liFailed+1
             DIMENSION This.aFailed(m.liFailed)
             This.aFailed(m.liFailed)=EVAL("m.luPar"+m.lcI)
          ELSE
             m.laPom(m.lii)=m.liy
          ENDIF
      NEXT

      IF m.liSum=3 && ...Parameter PANIC
         This.iFailed=m.liFailed
         RETURN __PNAME_PARAM_PANIC
      ENDIF

      m.liOK=__PNAME_PARAM_OK
      FOR m.lii=1 TO PCOUNT()
          m.liID=m.laPom(m.lii)

          IF !EMPTY(m.liID)
             m.lcPom=SUBS(EVAL("m.luPar"+LTRIM(STR(m.lii, 11))), LEN(This.aParams(m.liID, 1))+1)
             IF INLIST(RIGHT(m.lcPom, 1), ["], ['], "[")
                m.lcPom=SUBST(m.lcPom, 2, LEN(m.lcPom)-2)
             ENDIF
             m.luVal=This.Convert(LOWER(This.aParams(m.liID, 1)), m.lcPom, This.aParams(m.liID, 3))
             IF This.CheckValue(LOWER(This.aParams(m.liID, 1)), m.luVal)
                STORE m.luVal TO (This.aParams(m.liID, 2))
             ELSE
                This.AddWrongValue(LOWER(This.aParams(m.liID, 1)), m.luVal)
                m.liOK=__PNAME_PARAM_FAILED
             ENDIF
          ENDIF
      NEXT
      RETURN m.liOK
   ENDPROC


   PROCEDURE Convert && Convert string value to value
      *
      * _ParamBuffer::Convert
      * 
      LPARAMETERS m.lcName, m.lcValue, m.lcType
      * lcName  - Parameter Name
      * lcValue - Base Value
      * lcType  - Output Type
      *   Y,I,B,F,N - Numbers
      *   D         - Date
      *   T         - DateTime
      *   L         - Boolean
      *   E         - Exists, Value is Alwys true

      RETURN IIF(m.lcType$'Y,I,B,F,N', VAL(m.luValue),;
             IIF(m.lcType='D', CTOD(m.luValue),;
             IIF(m.lcType='T', CTOT(m.luValue),;
             IIF(m.lcType='L', m.luValue='.T.',;
             IIF(m.lcType='E', .T., m.lcValue)))))
   ENDPROC


   PROCEDURE CheckValue
      *
      * _ParamBuffer::CheckValue
      * 
      LPARAMETERS m.lcName, m.luValue
      * lcName  - Parameter Name
      * luValue - Base Value
      RETURN .T.
   ENDPROC


   PROCEDURE AddWrongValue && Add wrong parameter to internal list
      *
      * _ParamBuffer::AddWrongValue
      * 
      LPARAMETERS m.lcName, m.luValue
      * lcName  - Parameter Name
      * luValue - Base Value

      This.iWrong=This.iWrong+1
      DIMENSION This.aWrong(This.iWrong, 2)
      This.aWrong(This.iWrong, 1)=m.lcName
      This.aWrong(This.iWrong, 2)=m.luValue
      RETURN
   ENDPROC

ENDDEFINE

