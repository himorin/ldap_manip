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
* Digest::SHA

Configuration
=============

Edit LMConfig.pm with definitions.

* LDAP_URI     : Target LDAP URI like ldap://localhost/
* LDAP_BASEDN  : Target BASEDN
* URL_BASE     : Assumed to be used for template, not used as for now
* PASS_DEGREE  : Threshold for password strength
* MAX_PHOTO_BYTE : Max photo size in byte
* HASH_HISTORY : If not empty, save and match password hash on change

HASH_HISTORY
============

If not empty, use file $path_data/HASH_HISTORY for password hash history. 
Use complex string for this file. ($pash_data should be readable from http 
daemon, so no restriction...)

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

