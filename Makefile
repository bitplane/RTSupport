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

COMPONENT   = Real Time Support
TARGET      = RTSupport
OBJS        = debug global mess resmess2 scheduler module
RES_AREA    = resmess_ResourcesFiles
CMHGFILE    = modhdr
CMHGDEPENDS = module
CMHGAUTOHDR = ${TARGET}
CMHGFILE_SWIPREFIX = RT
HDRS        =
ASMHDRS     = ${TARGET}
ASMCHDRS    = ${TARGET}
ROMCDEFINES = -DROM_MODULE
CUSTOMRES   = custom

include CModule

CFLAGS     += -We -cpu 3 # <-- cpu 3 to (hopefully temporarily) fix internal compiler error due to __packed
ASFLAGS    += -cpu 4
CDFLAGS    += -DDEBUGLIB

#
# Custom resource recipe
#
resources: resources-${CMDHELP}
	${CP} Resources.Priorities ${RESFSDIR}.Priorities ${CPFLAGS}
	@${ECHO} ${COMPONENT}: resources copied to Messages module

resmess2.o: Resources.Priorities
	${RESGEN} resmess2_ResourcesFiles o.resmess2 Resources.Priorities Resources.${TARGET}.Priorities

# Dynamic dependencies:
