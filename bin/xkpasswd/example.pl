#!/usr/bin/perl

use strict;
use warnings;

###########################################################
# Sample file showing the use of the xkpasswd Perl module #
###########################################################

# Copyright 2012 Bart Busschots T/A Bartificer Web Solutions. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without modification, are
# permitted provided that the following conditions are met:
#
#   1. Redistributions of source code must retain the above copyright notice, this list of
#      conditions and the following disclaimer.
#
#   2. Redistributions in binary form must reproduce the above copyright notice, this list
#      of conditions and the following disclaimer in the documentation and/or other materials
#      provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY BART BUSSCHOTS T/A BARTIFICER WEB SOLUTIONS ''AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL
# BART BUSSCHOTS T/A BARTIFICER WEB SOLUTIONS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
# INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
# BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
# STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# import the library
use XKpasswd;

# create a hashref with the REQUIRED config details for the xkpasswd object
my $config = {
    dictionary_file => 'sample_dict.txt',
    min_word_length => 4,
    max_word_length => 8,
};

# Add any of the optional config details desired
$config->{num_words} = 3;                # number of words to use in the password

$config->{case_transform} = 'CAPITAL';     # case transformations to apply to the words
                                         # in the password. Valid values are 'NONE',
                                         # 'UPPER' (all caps), 'LOWER' (no caps), 
                                         # 'CAPITAL' (capitalise first letter), or
                                         # 'ALTERNATE' (alternate between all caps
                                         # and no caps on each successive word).

$config->{custom_separator} = 'RANDOM';  # the character to use to separate the
                                         # words in the generated password (if
                                         # not set, or a specialvalue of 'RANDOM'
                                         # is set, a random character is used).
                                         # For no separator at all use the
                                         # special value 'NONE'.

$config->{prepend_numbers} = 1;          # the number of random digits to include befor the
                                         # words in the password

$config->{append_numbers} = 1;           # the number of random digits to include after the
                                         # words in the password

$config->{pad_char} = 'RANDOM';          # the character to use when padding the front and back
                                         # of the password. If none is specified the separator
                                         # character is used. A special value of 'RANDOM' can
                                         # be passed to randomly pick a padding character

$config->{pre_pad} = 0;                  # the number of characters to pad the front of the
                                         # password with.

$config->{post_pad} = 0;                 # the number of characters to padd the end of the
                                         # password with.

$config->{random_source} = 'PERL';       # the source of randomness to use. Valid
                                         # values are 'PERL' and 'RANDOM_ORG' (if the
                                         # value is set to 'RANDOM_ORG' then the
                                         # option http_command has to be set too, and
                                         # it has to give the commandline for getting
                                         # a URL, e.g. /usr/bin/curl)

# the commented out lines below are an example of how to use random.org as the random number generator
#$config->{random_source} = 'RANDOM_ORG';
#$config->{http_command} = '/usr/bin/curl  -f -s';
# NOTE - when using curl, use the -f and -s options to prevent erros being printed to STDERR
#        (the module will still sense that there was an error). If using another commandling
#        tool for loading a web page be sure to set what ever options are needed to supress
#        unwanted metadata, progress indicators, and error messages being sent to STDERR,
#        and be sure the page returned by the web server is sent to STDOUT (wget does not
#        do this by default).

# should you want 133+ substitutions to be applied to the words in the password,
# they can be added as show in the 5 lines commented out below:
#$config->{l33t_substitutions} = {
#    e => '3',
#    s => '$',
#    a => '4',
#};

# should you want to put the module into debug mode uncomment the line below
#$config->{debug} = 1;

# instantiate an XKpasswd object
my $xkpasswd = XKpasswd->new($config);

# generate a password and print it out
print "\n".$xkpasswd->generate_password()."\n\n";
