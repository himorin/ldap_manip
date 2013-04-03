ldap_manip
==========

Simple LDAP account web manipulator

Requirements
============

* Perl 5.8 or higher
* Net::LDAP
* Template
* File::Basename
* MIME::Base64

Configuration
=============

Edit Constants.pm with two definitions.

* LDAP_URI     : Target LDAP URI like ldap://localhost/
* LDAP_BASEDN  : Target BASEDN

Test Scripts
============

Execute as ./testscripts/<name>
These scripts are for command line testing.

* t_stat.pl <cn> : display attributes for specified cn
* testChangePass.pl <cn> : Change password (read from stdin)
* testNetLdap_Entry_ReplaceAttr.pl <cn> <bind> : Edit attribute
* testNetLdap_SearchUID.pl <cn> <bind> : Search with binding
* testParseExop.pl <input> : Read input as 'exop' hash
* test_checker.pl : Password strength level check

