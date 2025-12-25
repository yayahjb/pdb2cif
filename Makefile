#
#  Makefile for pdb2cif related files
#  H. J. Bernstein, Bernstein+Sons, 24 August 1996
#  Rev, 25 Feb 97, work with compressed files
#  Rev, 14 Jun 98, fix NDB path
#  Rev, 24 Jun 98, add CSHELL variable
#  Rev, 7 Mar 99, make CHMOD variable, update MANIFEST files
#  Rev, 31 May 2000, add dictionary, update MANIFEST
#
#
#  The valid make calls are:
#
#     make postshar         setup compressed files after unpacking a shar
#     make clean            removes test files
#     make distclean        ensures full rebuilds
#     make perl_pdb2cif     creates perl version and tries it
#     make awk_pdb2cif      creates awk version and tries it
#     make oawk_pdb2cif     creates old-awk version and tries it
#     make tests            tests the pdb2cif under that name
#     make README.html      rebuilds README.html from README.html.m4
#     make MANIFEST.html    rebuilds MANIFEST.html from MANIFEST.html.m4
#     make filename.cif     converts filename.ent to filename.cif
#     make shars            creates pdb2cif.shar.Z, pdb2cif.cshar.Z
#                           (needs special versions of makekit, cshar)
#
#  Some systems have a broken csh.  If that system has a working tcsh,
#  uncomment the next line
#CSHELL		=	tcsh
#
#===============  The following definitions may need to be modified for
#===============  your system
#
#  The locations of any programs used
#  The most common alternatives are given immediately below
A2P	=	a2p
M4	=	m4
PDB2CIF		=	./pdb2cif
AWKPDB2CIF	=	./pdb2cif.awk
OAWKPDB2CIF	=	./pdb2cif.oawk
PERLPDB2CIF	=	./pdb2cif.pl
MKDECOMPLN	=	$(CSHELL) ./mkdecompln
RMDECOMPLN	=	$(CSHELL) ./rmdecompln
EXPAND		=	/var/tmp
#
#  The definition of VPATH must be the httpd virtual path to
#  the directory holding this version of the directory, i.e.
#  containing the pdb2cif_n.n.n directory  MANIFEST.html 
#  and README.html must be rebuilt if VPATH changes.
VPATH		=	NDB/mmcif/software
#VPATH		=	~yaya/software
#VPATH		=	pb/pdb2cif
#
#  The definition of DECOMP must be the httpd virtual path to
#  the cgi-bin script decomp.cgi.  If this script is not available
#  define DECOMP as NODECOMP
DECOMP		=	/cgi-bin/yaya/decomp.cgi
#DECOMP		=	/~yaya/cgi-bin/decomp.cgi
#DECOMP		=	/pb/pdb2cif/cgi-bin/decomp.cgi
#
#
#  If you have a version of CHMOD which provides the -H flag, you
#  will need the first definition given, otherwise, use the alternative
#
#CHMOD		=	chmod -R -H
CHMOD		=	chmod -R
#
#  If you have gnu-awk in, say, /usr/local/bin/gawk, then you might have
#  AWKPDB2CIF	=	/usr/local/bin/gawk -f pdb2cif.awk
#  PDB2CIF	=	/usr/local/bin/gawk -f pdb2cif
#
#  you would edit in those changes above and then
#  you would create and test the awk version with
#
#      make awk_pdb2cif
#      make tests
#
#==============  The rest of this file should not need modification
#==============  if you have either a working version of perl, or
#==============  gnu awk
#
ZPATH		=	$(DECOMP)/$(VPATH)
#
MANIFEST.html:	MANIFEST.html.m4 Makefile
		-@rm MANIFEST.html.BAK
		-@mv MANIFEST.html MANIFEST.html.BAK
		m4 -DZPATH=$(ZPATH) -DDECOMP=$(DECOMP) < MANIFEST.html.m4 \
		> MANIFEST.html

README.html:	README.html.m4 Makefile
		-@rm README.html.BAK
		-@mv README.html README.html.BAK
		m4 -DGRAPHICS=1 \
		-DZPATH=$(ZPATH) -DDECOMP=$(DECOMP) < README.html.m4 \
		> README.html

#  The suffixes for any files to be used or built:
.SUFFIXES:	.m4 .pl .awk .oawk .ent .cif .acif .pcif .oacif .tcif \
		.diff .adiff .oadiff .pdiff .Z .uZ
#  The flags to be used in cif builds
#  And the default header file to be used
#
CIFFLAGS	=
DEFAULTHEAD	=	default.pdbh
#
#  The flags to be used in building an awk script from an m4 document
AWKFLAGS	=	
#
#  The flags to be used in building a perl script from an m4 document
#
PERLFLAGS	=	-DPERL
PERLSED1	=	"s/\&dummytime/localtime/"
PERLSED2	=	"s/OUTPUT_AUTOFLUSH/\|/"
#
#  The flags to be used in building an old awk script from an m4 document
#
OAWKFLAGS	=	-DNOFUNCS -DNOLOWER

XNAMES	=	5hvp 1ace 2ace 1crn 1cro 4ins 1hyh 1cwp 4hir 1ctj 1ji0

ENTS	= 5hvp.ent 1ace.ent 2ace.ent 1crn.ent 1cro.ent 4ins.ent 1hyh.ent \
		1cwp.ent 4hir.ent 1ctj.ent 1ji0.ent


ENTZS	= 5hvp.ent.Z 1ace.ent.Z 2ace.ent.Z 1crn.ent.Z 1cro.ent.Z 4ins.ent.Z \
		1hyh.ent.Z 1cwp.ent.Z 4hir.ent.Z 1ctj.ent.Z 1ji0.ent.Z

CIFS	= 5hvp.cif 1ace.cif 2ace.cif 1crn.cif 1cro.cif 4ins.cif 1hyh.cif \
		1cwp.cif 4hir.cif 1ctj.cif 1ji0.cif

CIFZS	= 5hvp.cif.Z 1ace.cif.Z 2ace.cif.Z 1crn.cif.Z 1cro.cif.Z 4ins.cif.Z \
		1hyh.cif.Z 1cwp.cif.Z 4hir.cif.Z 1ctj.cif.Z 1ji0.cif.Z

TCIFS	= 5hvp.tcif 1ace.tcif 2ace.tcif 1crn.tcif 1cro.tcif 4ins.tcif \
		1hyh.tcif 1cwp.tcif 4hir.tcif 1ctj.tcif 1ji0.tcif

TCIFZS	= 5hvp.tcif.Z 1ace.tcif.Z 2ace.tcif.Z 1crn.tcif.Z 1cro.tcif.Z \
		4ins.tcif.Z 1hyh.tcif.Z 1cwp.tcif.Z 4hir.tcif.Z 1ctj.tcif.Z \
		1ji0.tcif.Z

ACIFS	= 5hvp.acif 1ace.acif 2ace.acif 1crn.acif 1cro.acif 4ins.acif \
		1hyh.acif 1cwp.acif 4hir.acif 1ctj.acif 1ji0.acif

ACIFZS	= 5hvp.acif.Z 1ace.acif.Z 2ace.acif.Z 1crn.acif.Z 1cro.acif.Z \
		4ins.acif.Z 1hyh.acif.Z 1cwp.acif.Z 4hir.acif.Z 1ctj.acif.Z \
		1ji0.acif.Z

OACIFS	= 5hvp.oacif 1ace.oacif 2ace.oacif 1crn.oacif \
		1cro.oacif 4ins.oacif 1hyh.oacif 1cwp.oacif 4hir.oacif \
		1ctj.oacif 1ji0.oacif

OACIFZS	= 5hvp.oacif.Z 1ace.oacif.Z 2ace.oacif.Z 1crn.oacif.Z 1cro.oacif.Z \
		4ins.oacif.Z 1hyh.oacif.Z 1cwp.oacif.Z 4hir.oacif.Z \
		1ctj.oacif.Z 1ji0.oacif.Z

PCIFS	= 5hvp.pcif 1ace.pcif 2ace.pcif 1crn.pcif 1cro.pcif 4ins.pcif \
		1hyh.pcif 1cwp.pcif 4hir.pcif 1ctj.pcif 1ji0.pcif

PCIFZS	= 5hvp.pcif.Z 1ace.pcif.Z 2ace.pcif.Z 1crn.pcif.Z 1cro.pcif.Z \
		4ins.pcif.Z 1hyh.pcif.Z 1cwp.pcif.Z 4hir.pcif.Z 1ctj.pcif.Z \
		1ji0.pcif.Z

DIFFS	= 5hvp.diff 1ace.diff 2ace.diff 1crn.diff \
		1cro.diff 4ins.diff 1hyh.diff 1cwp.diff 4hir.diff 1ctj.diff \
		1ji0.diff

ADIFFS	= 5hvp.adiff 1ace.adiff 2ace.adiff 1crn.adiff \
		1cro.adiff 4ins.adiff 1hyh.adiff 1cwp.adiff 4hir.adiff \
		1ctj.adiff 1ji0.adiff

OADIFFS	= 5hvp.oadiff 1ace.oadiff 2ace.oadiff 1crn.oadiff \
		1cro.oadiff 4ins.oadiff 1hyh.oadiff 1cwp.oadiff 4hir.oadiff \
		1ctj.oadiff 1ji0.oadiff

PDIFFS	= 5hvp.pdiff 1ace.pdiff 2ace.pdiff 1crn.pdiff \
		1cro.pdiff 4ins.pdiff 1hyh.pdiff 1cwp.pdiff 4hir.pdiff \
		1ctj.pdiff 1ji0.pdiff
.ent.cif:
		touch $*.pdbh
		$(PDB2CIF) $(CIFFLAGS) $(DEFAULTHEAD) $*.pdbh $< | \
		compress > $*.cif.Z
		$(MKDECOMPLN) $*.cif $(EXPAND)
.ent.tcif:
		touch $*.pdbh
		$(PDB2CIF) $(CIFFLAGS) $(DEFAULTHEAD) $*.pdbh $< | \
		compress > $*.tcif.Z
		$(MKDECOMPLN) $*.tcif $(EXPAND)
.ent.acif:
		touch $*.pdbh
		time $(AWKPDB2CIF) $(CIFFLAGS) $(DEFAULTHEAD) $*.pdbh $< | \
		compress  > $*.acif.Z
		$(MKDECOMPLN) $*.acif $(EXPAND)
.ent.oacif:
		touch $*.pdbh
		time $(OAWKPDB2CIF) $(CIFFLAGS) $(DEFAULTHEAD) $*.pdbh $< | \
		compress > $*.oacif.Z
		$(MKDECOMPLN) $*.oacif $(EXPAND) 
.ent.pcif:
		touch $*.pdbh
		time $(PERLPDB2CIF) $(CIFFLAGS) $(DEFAULTHEAD) $*.pdbh $< | \
		compress > $*.pcif.Z
		$(MKDECOMPLN) $*.pcif $(EXPAND) 
.Z.uZ:
		$(MKDECOMPLN) $* $(EXPAND)
.cif.diff:
		-@/bin/rm -f $*.diff
		-uncompress < $*.tcif.Z |diff -  $*.cif > $*.diff
.acif.adiff:
		-@/bin/rm -f $*.adiff
		-uncompress < $*.tcif.Z |diff -  $*.acif > $*.adiff
.oacif.oadiff:
		-@/bin/rm -f $*.oadiff
		-uncompress < $*.tcif.Z |diff -  $*.oacif > $*.oadiff
.pcif.pdiff:
		-@/bin/rm -f $*.pdiff
		-uncompress < $*.tcif.Z |diff -  $*.pcif > $*.pdiff


postshar:
		compress pdb2cif.m4
		$(MKDECOMPLN) pdb2cif.m4 .
		compress *.ent
		compress *.tcif
		$(CHMOD) 755 mkdecompln
		$(CHMOD) 755 rmdecompln
		$(CHMOD) 755 pdb2cif.pl
		$(CHMOD) 755 pdb2cif.awk
		$(CHMOD) 755 pdb2cif.oawk
		compress pdb2cif.pl
		compress pdb2cif.awk
		compress pdb2cif.oawk
		$(MKDECOMPLN) pdb2cif.pl .
		$(CHMOD) 755 pdb2cif.pl
		ln -s -f pdb2cif.pl pdb2cif
		touch pdb2cif.pl
		touch perl_pdb2cif

all:		pdb2cif.m4.Z $(ENTZS)
		@echo "First make perl_pdb2cif or"
		@echo "      make awk_pdb2cif or"
		@echo "      make oawk_pdb2cif"
		@echo "Then make tests and look at the diffs"

clean:		pdb2cif.m4.Z $(ENTZS)
		-@/bin/rm -f *diff
		-@$(RMDECOMPLN) *.cif
		-@/bin/rm -f *.cif.Z
		-@$(RMDECOMPLN) *.acif
		-@/bin/rm -f *.acif.Z
		-@$(RMDECOMPLN) *.oacif
		-@/bin/rm -f *.oacif.Z
		-@$(RMDECOMPLN) *.pcif
		-@/bin/rm -f *.pcif.Z

distclean:	clean
		touch pdb2cif.m4.Z
		-@$(RMDECOMPLN) pdb2cif.pl
		-@$(RMDECOMPLN) pdb2cif.awk
		-@$(RMDECOMPLN) pdb2cif.oawk
		-@$(RMDECOMPLN) *.uZ
		-@/bin/rm -f pdb2cif
		-@/bin/rm -f perl_pdb2cif
		-@/bin/rm -f awk_pdb2cif
		-@/bin/rm -f oawk_pdb2cif

pdb2cif.m4:	pdb2cif.m4.Z
		$(MKDECOMPLN) pdb2cif.m4 $(EXPAND)

pdb2cif.pl:     pdb2cif.m4
		-@$(RMDECOMPLN) pdb2cif.pl
		-@/bin/rm -f pdb2cif.pl.Z
		-@/bin/rm -f pdb2cif.a2p.tmp
		-@/bin/rm -f pdb2cif.pl.tmp
		-@rm -f pdb2cif.pl.tmp2
		$(M4) $(PERLFLAGS) pdb2cif.m4 > pdb2cif.a2p.tmp
		$(A2P) pdb2cif*.a2p.tmp > pdb2cif.pl.tmp
		sed $(PERLSED1) pdb2cif.pl.tmp > pdb2cif.pl.tmp2
		sed $(PERLSED2) pdb2cif.pl.tmp2 > pdb2cif.pl
		-/bin/rm -f pdb2cif.a2p.tmp
		-/bin/rm -f pdb2cif.pl.tmp
		-/bin/rm -f pdb2cif.pl.tmp2
		$(CHMOD) 755 pdb2cif.pl
		compress pdb2cif.pl
		$(MKDECOMPLN) pdb2cif.pl $(EXPAND)
		$(CHMOD) 755 pdb2cif.pl

pdb2cif.awk:	pdb2cif.m4
		-@$(RMDECOMPLN) pdb2cif.awk 
		-@/bin/rm -f pdb2cif.awk.Z
		$(M4) $(AWKFLAGS) pdb2cif.m4  > pdb2cif.awk
		$(CHMOD) 755 pdb2cif.awk
		compress pdb2cif.awk
		$(MKDECOMPLN) pdb2cif.awk $(EXPAND)
		$(CHMOD) 755 pdb2cif.awk

pdb2cif.oawk:	pdb2cif.m4
		-@$(RMDECOMPLN) pdb2cif.oawk
		-@/bin/rm -f pdb2cif.oawk.Z
		$(M4) $(OAWKFLAGS) pdb2cif.m4  > pdb2cif.oawk
		$(CHMOD) 755 pdb2cif.oawk
		compress pdb2cif.oawk
		$(MKDECOMPLN) pdb2cif.oawk
		$(CHMOD) 755 pdb2cif.oawk

awk_pdb2cif:	pdb2cif.m4 pdb2cif.awk $(ACIFZS) $(ADIFFS)
		-@/bin/rm -f pdb2cif
		ln -s -f pdb2cif.awk pdb2cif
		$(CHMOD) 755 pdb2cif
		touch awk_pdb2cif

oawk_pdb2cif:	pdb2cif.m4 pdb2cif.oawk $(OACIFZS) $(OADIFFS)
		-@/bin/rm -f pdb2cif
		ln -s -f pdb2cif.oawk pdb2cif
		$(CHMOD) 755 pdb2cif
		touch oawk_pdb2cif

perl_pdb2cif:	pdb2cif.m4 pdb2cif.pl $(PCIFZS) $(PDIFFS)
		ln -s -f pdb2cif.pl pdb2cif
		$(CHMOD) 755 pdb2cif
		touch perl_pdb2cif

tests:		pdb2cif \
		$(ENTZS) $(TCIFZS) $(CIFZS)\
		$(DIFFS)

$(ENTS):	$(ENTZS)
		$(MKDECOMPLN) $@ $(EXPAND)
$(CIFS):	pdb2cif $(ENTS)
$(ACIFS):	pdb2cif.awk $(ENTS)
$(OACIFS):	pdb2cif.oawk $(ENTS)
$(PCIFS):	pdb2cif.pl $(ENTS)
$(CIFZS):	$(CIFS)
$(ACIFZS):	$(ACIFS)
$(OACIFZS):	$(OACIFS)
$(PCIFZS):	$(PCIFS)
$(DIFFS):	$(CIFS) $(TIFCZS)
$(ADIFFS):	$(ACIFS) $(TCIFZS)
$(OADIFFS):	$(OACIFS) $(TCIFZS)
$(PDIFFS):	$(PCIFS) $(TCIFZS)

shars:		pdb2cif.m4 pdb2cif.awk pdb2cif.oawk pdb2cif.pl \
		IUCR_POLICY.html NOTICE.html \
		MANIFEST MANIFEST.html README README.html \
		CHANGES CHANGES.html pdb2cif_cif_mm_0.0.05.dic \
		Makefile default.pdbh concord.txt concord.html \
		mkdecompln rmdecompln \
		README.html.m4 MANIFEST.html.m4 \
		$(ENTZS) $(TCIFZS) $(XNAMES)
		-@/bin/rm -f pdb2cif.cshar.Z
		-@/bin/rm -f pdb2cif.shar.Z
		makekit -p -c -s15000k -m
		mv Part01 pdb2cif.cshar
		compress pdb2cif.cshar
		makekit -p -s15000k -m
		mv Part01 pdb2cif.shar
		compress pdb2cif.shar
$(XNAMES):
		$(MKDECOMPLN) $@.ent $(EXPAND)
		$(MKDECOMPLN) $@.tcif $(EXPAND)
		touch $@.ent
		touch $@.tcif

current:	$(XNAMES)
		touch pdb2cif.awk
		touch pdb2cif.oawk
		touch pdb2cif.pl
		touch pdb2cif
