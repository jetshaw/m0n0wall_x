# -*- tab-width: 4; -*-
# ex: ts=4
#
# bsd.local.mk - Sandbox for local modification to ports framework.
#
# Created by: Mark Linimon <linimon@FreeBSD.org>
#
# $FreeBSD: head/Mk/bsd.local.mk 300895 2012-07-14 12:56:14Z beat $
#

.if !defined(_POSTMKINCLUDED) && !defined(Local_Pre_Include)

Local_Pre_Include=		bsd.local.mk

#
# Here is where any code that needs to run at bsd.port.pre.mk inclusion
# time should live.
#

.endif # !defined(_POSTMKINCLUDED) && !defined(Local_Pre_Include)

.if defined(_POSTMKINCLUDED) && !defined(Local_Post_Include)

Local_Post_Include=	bsd.local.mk

#
# here is where any code that needs to run at bsd.port.post.mk inclusion
# time should live.
#

.endif # defined(_POSTMKINCLUDED) && !defined(Local_Post_Include)
