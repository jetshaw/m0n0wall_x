# $FreeBSD: head/Mk/bsd.port.post.mk 300895 2012-07-14 12:56:14Z beat $

AFTERPORTMK=	yes

.include "bsd.port.mk"

.undef AFTERPORTMK
