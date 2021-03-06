# New ports collection makefile for:   sixxs-aiccu
# Date created:                2004-09-07
# Whom:                        Meno Abels <meno.abels@adviser.com>
#
# $FreeBSD: head/net/sixxs-aiccu/Makefile 300897 2012-07-14 14:29:18Z beat $
#

PORTNAME=	aiccu
PORTVERSION=	20070115
PORTREVISION=	2
CATEGORIES=	net ipv6
MASTER_SITES=	http://www.sixxs.net/archive/sixxs/aiccu/unix/
PKGNAMEPREFIX=	sixxs-
DISTNAME=	aiccu_20070115

MAINTAINER=	dinoex@FreeBSD.org
COMMENT=	SixXS IPv6 TIC+ tunnel broker heartbeat client

LIB_DEPENDS=	gnutls-openssl.27:${PORTSDIR}/security/gnutls

LICENSE=	BSD
LICENSE_FILE=	${WRKSRC}/doc/LICENSE

USE_RC_SUBR=	sixxs-aiccu
USE_GMAKE=	yes

CFLAGS+=	${PTHREAD_CFLAGS} -D_REENTRANT -DAICCU_GNUTLS -I${LOCALBASE}/include
LDFLAGS+=	${PTHREAD_LIBS} -L${LOCALBASE}/lib -lgnutls
MAKE_ARGS+=	CC="${CC}" LDFLAGS="${LDFLAGS}"
WRKSRC=		${WRKDIR}/aiccu
BUILD_WRKSRC=	${WRKDIR}/aiccu/unix-console
PORTDOCS=	README

post-patch:
	@${REINPLACE_CMD} \
		-e 's:verbose true:verbose false:' \
		-e 's:daemonize false:daemonize true:' \
		-e 's:automatic false:automatic true:' \
		-e 's:tunnel_id T2995:#tunnel_id TXXXX:' \
		-e 's:ipv4_interface eth0:ipv4_interface sis0:' \
		-e 's:ipv6_interface sixxs:ipv6_interface gif0:' \
		${WRKSRC}/doc/aiccu.conf

.include <bsd.port.pre.mk>

.if defined(WITH_LOG_DAEMON)
do-configure:
	@${REINPLACE_CMD} \
		-e 's:LOG_LOCAL7:LOG_DAEMON:' \
		${WRKSRC}/common/common.c
.endif

do-install:
	${INSTALL_PROGRAM} ${WRKSRC}/unix-console/aiccu ${PREFIX}/sbin/sixxs-aiccu
.ifndef(NOPORTDOCS)
	${MKDIR} ${DOCSDIR}
	${INSTALL_DATA} ${WRKSRC}/doc/README ${DOCSDIR}
.endif
	${INSTALL_DATA} ${WRKSRC}/doc/aiccu.conf ${PREFIX}/etc/aiccu.conf.sample
.if !exists(${PREFIX}/etc/aiccu.conf)
	${INSTALL_DATA} -m 0644 ${WRKSRC}/doc/aiccu.conf ${PREFIX}/etc/aiccu.conf
.endif

.include <bsd.port.post.mk>
