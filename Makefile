# Copyright 2005 Castle Technology Ltd
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Makefile for RTSupport
#
# ***********************************
# ***    C h a n g e   L i s t    ***
# ***********************************
# Date       Name    Description
# ----       ----    -----------
# 18-Oct-04  BJGA    Created

COMPONENT   = Real Time Support
TARGET      = RTSupport
HEADER1     = ${TARGET}
ASMCHEADER1 = ${TARGET}
CMHGCHEADER = modhdr
CMHGCHEADER_SWIPREFIX = RT
CFLAGS      = -ffah -We
ASFLAGS     = -cpu 4
CDEFINES    =
CINCLUDES   =
COMMON_OBJS =  o.debug  o.global  o.mess o.resmess2 o.scheduler
DBG_OBJS    = do.debug do.global do.mess o.resmess2 o.scheduler
PP_OBJS     =  i.debug  i.global  i.mess
LIBS        =

RESOURCES   = custom

resources: resources-${CMDHELP}
	${CP} Resources.Priorities ${RESFSDIR}.Priorities ${CPFLAGS}
	@${ECHO} ${COMPONENT}: resources copied to Messages module

o.resmess2: Resources.Priorities
	${RESGEN} resmess2_ResourcesFiles o.resmess2 Resources.Priorities Resources.${TARGET}.Priorities

# The rest of this could be used as a basis for shared makefile fragment(s)

CFLAGS     += -zM -zps1
DIRS        = o._dirs
MERGEDMDIR  = o._Messages_
MERGEDMSGS  = ${MERGEDMDIR}.${TARGET}
RAM_OBJS    = ${COMMON_OBJS} o.module o.resmess o.modhdr
ROM_OBJS    = ${COMMON_OBJS} o.modulerom o.modhdr
PP_OBJS    += i.module
DBG_LIBS    = ${RAM_LIBS} ${DEBUGLIBS} TCPIPLibs:o.socklib5zm TCPIPLibs:o.inetlibzm
DBG_MODULE  = drm.${TARGET}
RESFSDIR   ?= ${RESDIR}.${TARGET}
EXP_HDR    ?= <Export$Dir>
C_EXP_HDR  ?= <CExport$Dir>.Interface.h
LIBDIR      = <Lib$Dir>
CMHGCHEADER_SWIPREFIX ?= ${TARGET}

include Makefiles:StdTools
include Makefiles:ModuleLibs
include Makefiles:ModStdRule
include Makefiles:RAMCModule
include Makefiles:ROMCModule

.SUFFIXES: .do .i
.c.do:; ${CC} ${CFLAGS} -DDEBUGLIB -o $@ $<
.c.i:;  ${CC} ${CFLAGS} -E -C $< > $@

${DIRS}:
	${MKDIR} aof
	${MKDIR} do
	${MKDIR} drm
	${MKDIR} i
	${MKDIR} linked
	${MKDIR} o
	${MKDIR} rm
	${TOUCH} ${DIRS}

clean::
	@IfThere h.modhdr Then ${ECHO} ${RM} h.modhdr
	@IfThere h.modhdr Then ${RM} h.modhdr
	@IfThere aof Then ${ECHO} ${WIPE} aof ${WFLAGS}
	@IfThere aof Then ${WIPE} aof ${WFLAGS}
	@IfThere do Then ${ECHO} ${WIPE} do ${WFLAGS}
	@IfThere do Then ${WIPE} do ${WFLAGS}
	@IfThere drm Then ${ECHO} ${WIPE} drm ${WFLAGS}
	@IfThere drm Then ${WIPE} drm ${WFLAGS}
	@IfThere i Then ${ECHO} ${WIPE} i ${WFLAGS}
	@IfThere i Then ${WIPE} i ${WFLAGS}
	@IfThere linked Then ${ECHO} ${WIPE} linked ${WFLAGS}
	@IfThere linked Then ${WIPE} linked ${WFLAGS}
	@IfThere o Then ${ECHO} ${WIPE} o ${WFLAGS}
	@IfThere o Then ${WIPE} o ${WFLAGS}
	@IfThere rm Then ${ECHO} ${WIPE} rm ${WFLAGS}
	@IfThere rm Then ${WIPE} rm ${WFLAGS}
	@${ECHO} ${COMPONENT}: cleaned

prepro: ${PP_OBJS} ${DIRS}
	@${ECHO} ${COMPONENT}: preprocessed files generated

export${EXPORT}: export${EXPORT}_${PHASE}
	@|

export${EXPORT}_: export${EXPORT}_libs export${EXPORT}_hdrs
	@|

export${EXPORT}_hdrs :: ${EXPORTS}
	@|
	@${ECHO} ${COMPONENT}: header export complete

ifdef CHEADER3
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${CHEADER3}
	@|
${C_EXP_HDR}.${CHEADER3} :: h.${CHEADER3}
	${CP} h.${CHEADER3} $@ ${CPFLAGS}
endif

ifdef CHEADER2
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${CHEADER2}
	@|
${C_EXP_HDR}.${CHEADER2} :: h.${CHEADER2}
	${CP} h.${CHEADER2} $@ ${CPFLAGS}
endif

ifdef CHEADER1
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${CHEADER1}
	@|
ifdef CMHGCHEADER
${C_EXP_HDR}.${CHEADER1} :: h.${CHEADER1} o._h_${TARGET}
	FAppend $@ h.${CHEADER1} o._h_${TARGET}
else
${C_EXP_HDR}.${CHEADER1} :: h.${CHEADER1}
	${CP} h.${CHEADER1} $@ ${CPFLAGS}
endif
endif

ifdef ASMCHEADER3
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${ASMCHEADER3}
	@|
${C_EXP_HDR}.${ASMCHEADER3} :: hdr.${ASMCHEADER3}
	${HDR2H} hdr.${ASMCHEADER3} $@
endif

ifdef ASMCHEADER2
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${ASMCHEADER2}
	@|
${C_EXP_HDR}.${ASMCHEADER2} :: hdr.${ASMCHEADER2}
	${HDR2H} hdr.${ASMCHEADER2} $@
endif

ifdef ASMCHEADER1
export${EXPORT}_hdrs :: ${C_EXP_HDR}.${ASMCHEADER1}
	@|
ifdef CMHGCHEADER
${C_EXP_HDR}.${ASMCHEADER1} :: hdr.${ASMCHEADER1} o._h_${TARGET}
	${HDR2H} hdr.${ASMCHEADER1} $@
	FAppend $@ $@ o._h_${TARGET}
else
${C_EXP_HDR}.${ASMCHEADER1} :: hdr.${ASMCHEADER1}
	${HDR2H} hdr.${ASMCHEADER1} $@
endif
endif

ifdef HEADER3
export${EXPORT}_hdrs :: ${EXP_HDR}.${HEADER3}
	@|
${EXP_HDR}.${HEADER3} :: hdr.${HEADER3}
	${CP} hdr.${HEADER3} ${EXP_HDR}.${HEADER3} ${CPFLAGS}
endif

ifdef HEADER2
export${EXPORT}_hdrs :: ${EXP_HDR}.${HEADER2}
	@|
${EXP_HDR}.${HEADER2} :: hdr.${HEADER2}
	${CP} hdr.${HEADER2} ${EXP_HDR}.${HEADER2} ${CPFLAGS}
endif

ifdef HEADER1
export${EXPORT}_hdrs :: ${EXP_HDR}.${HEADER1}
	@|
${EXP_HDR}.${HEADER1} :: hdr.${HEADER1}
	${CP} hdr.${HEADER1} ${EXP_HDR}.${HEADER1} ${CPFLAGS}
endif

ifdef CMHGCHEADER
o._h_${TARGET}: h.${CMHGCHEADER} ${DIRS}
	Do ${AWK} -- "/.ifndef ${CMHGCHEADER_SWIPREFIX}/,/endif/" h.${CMHGCHEADER} > o._h_${TARGET}
endif

export${EXPORT}_libs:
	@${ECHO} ${COMPONENT}: no exported libraries

resources${RESOURCES}: resources-${CMDHELP}
	@${ECHO} ${COMPONENT}: resources copied to Messages module

resources_common:
	${MKDIR} ${RESFSDIR}
	${TOKENCHECK} LocalRes:Messages
	${CP} LocalRes:Messages ${RESFSDIR}.Messages ${CPFLAGS}

resources-None: resources_common
	${CP} LocalRes:Messages ${RESFSDIR}.Messages ${CPFLAGS}

resources-: resources_common
	IfThere LocalRes:CmdHelp Then ${TOKENCHECK} LocalRes:CmdHelp
	IfThere LocalRes:CmdHelp Then FAppend ${RESFSDIR}.Messages LocalRes:Messages LocalRes:CmdHelp

${MERGEDMSGS}: LocalRes:Messages
	${MKDIR} ${MERGEDMDIR}
	${TOKENCHECK} LocalRes:Messages
	IfThere LocalRes:CmdHelp Then ${TOKENCHECK} LocalRes:CmdHelp
	IfThere LocalRes:CmdHelp Then FAppend $@ LocalRes:Messages LocalRes:CmdHelp Else ${CP} LocalRes:Messages $@ ${CPFLAGS}

o.resmess${RESMESS}: ${MERGEDMSGS}
	${RESGEN} resmess_ResourcesFiles o.resmess ${MERGEDMSGS} Resources.${TARGET}.Messages

o.module: modhdr.h
do.module: modhdr.h
i.module: modhdr.h

o.modulerom: module.c modhdr.h
	${CC} ${CFLAGS} -DROM_MODULE -o modulerom.o module.c

debug: ${DBG_MODULE}
	@${ECHO} ${COMPONENT}: debug module built

${DBG_MODULE}: ${DBG_OBJS} ${DBG_LIBS} ${CLIB} ${DIRS} ${RAM_DEPEND}
	${MKDIR} drm
	${LD} ${LDFLAGS} -o $@ -rmf ${DBG_OBJS} ${DBG_LIBS} ${CLIB}
	${CHMOD} -R a+rx drm

# Dynamic dependencies:
