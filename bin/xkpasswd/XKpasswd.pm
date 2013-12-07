package XKpasswd;

use strict;
use warnings;
use Carp;

#################################################################
# Utility for generating XKCD/Password Haystacks-like passwords #
#################################################################

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

#
# Constructor
#
# Arguments:
# 1) REQUIRED - a hashref with the config varialbes to set up this instance
#    The hashref should be index by one or more of the keys below:
#    REQUIRED keys:
#       dictionary_file => The path to the text file to load the dictionary from.
#                          The dictionary file should contain one word per line
#                          without leading spaces. Lines starting with a # are
#                          ignored and can be used to insert credits/copyright
#                          and other comments into a dictionary file.
#       min_word_length => The minimum lenght of words to be loaded from the
#                          dictionary file and used for generating passwords.
#       max_word_length => The maximum length of words to be loaded from the
#                          dictionary file and used for generating passwords.
#    OPTIONAL Keys:
#       num_words => the number of words to include in generated passwords
#                    (defaults to 3).
#       l33t_substitutions => a hashref of hashrefs indexed by the characters to
#                             be replaced, andcontaining the replacement strings.
#                             The substitutions are applied only to the words in
#                             the password, not the separators, padding, or
#                             numbers. If not set, no substitutions will be
#                             applied. Default is not to have any subtitutions.
#       case_transform => a value of 'NONE' (leave the case as it came from the
#                         dictionary), 'UPPER' (convert all words to all upper
#                         case), 'LOWER' (convert all words to all lower case),
#                         'CAPITAL' (capitalise the first letter of the work
#                         convert all others to lower case), 'RANDOM' (have
#                         each words randomly all upper or lower case), or
#                         'ALTERNATE' (succeeding words alternate case).
#                         Defaults to 'NONE'.
#       custom_separator => A Custom separator to override default list. The
#                           special value of 'NONE' can be set to have no
#                           separating character between words. A value of
#                           'RANDOM' will see a random separator used, this is
#                           the default.
#       prepend_numbers => The number of digits to pre-pend the list of words.
#                          Defaults to 3.
#       append_numbers => The number of digits to append to the end of the list
#                         of words. Defauls to 3;
#       pad_char => the character to use for padding the front and back of the
#                   password. Valid values are any single character, or the
#                   special values 'SEPARATOR' (which specifies that the 
#                   separator character should be used for padding the password),
#                   or 'RANDOM' (which specifies that a random character should
#                   be used). The Default value is 'RANDOM'.
#       pre_pad => The number of characters to pad the start of the password
#                  with. Defaults to 3.
#       post_pad => The number of characters to pad the end of the password
#                   with. Defaults to 3.
#       adaptive_padding => An option to change the padding behaviour from
#                           padding the password with a fixed number of
#                           characters at the start and end of the password to
#                           adding padding only to the end of the password, and
#                           to continue adding padding until the total password
#                           length is equal to the value of this option. To
#                           disable this bahaviour the value of this option
#                           should be set to 0. The default value of this option
#                           is 0, i.e. by default fixed-length padding, as set
#                           by the pre_pad and post_pad options is used.
#       random_source => Select which source of randome numbers to use. At the
#                        moment only two sources of randomness are supported:
#                        i) 'PERL' - use Perl's built-in rand function
#                        ii) 'RANDOM_ORG' - make a HTTP request to the
#                            free random.org random number service. If this
#                            option us used you MUST also set the option
#                            http_command to the commandline to use to shell
#                            out to get a url. e.g. /usr/bin/curl.
#                            NOTE: if using curl, it's recommended to add the
#                                  -f and -s flags to supress error messages.
#                                  e.g. the following works on OS X:
#                                       '/usr/bin/curl -f -s'
#                        The default value is 'PERL'.
#       debug => if set to 1 then the library is put in debug mode, and a lot
#                of info is prited out. Defaults to 0.
# Returns: an XKpasswd instance configured according to the config passed
# Croaks on error
sub new{
    my $class = shift;
    my $config = shift;
    
    # check we got a config at all
    unless($config){
        croak("Failed to instantiate $class object, no config passed to constructor");
    }
    
    # create a blank object so it can be populated before being returned
    my $instance;
    
    # add some default values to the new object
    $instance->{MIN_DICTIONARY_SIZE} = 100; # the minimum size of dictionary that can be loaded.
                                            # if a smaller dictinoary results from trying to load
                                            # the given file with the given word length contstraints
                                            # the function to load the dictionary will croak.
    $instance->{SEPARATORS} = [q{.}, q{*}, q{-}, q{_}, q{,}, q{#}, q{|}, q{%}, q{^}, q{&}, q{$}, q{=}, q{+}]; # the default set of separators
    
    # deal with debugging
    $instance->{debug} = 0;
    if($config->{debug}){
        $instance->{debug} = 1;
    }
    
    # bless the object
    bless $instance, $class;
    
    # check required config keys (dictionary related)
    unless($config->{dictionary_file}  && -f $config->{dictionary_file}){
        croak(q{Required config option dictionary_file is invalid - failed to find a file at '}.$config->{dictionary_file}.q{'});
    }
    $instance->{dictionary_file} = $config->{dictionary_file};
    unless($config->{min_word_length} && $config->{min_word_length} =~ m/^\d+$/sx){
        croak('Required config option min_word_length is invalid - not a posituve integer');
    }
    $instance->{min_word_length} = $config->{min_word_length};
    unless($config->{max_word_length} && $config->{max_word_length} =~ m/^\d+$/sx && $config->{max_word_length} >= $config->{min_word_length}){
        croak('Required config option max_word_length is invalid - not a posituve integer greater than or equal to the config option min_word_length');
    }
    $instance->{max_word_length} = $config->{max_word_length};
    
    # try load the dictionary file into the object - this line could croak
    $instance->_load_dictionary();
    
    # load the optional config options into this instance, and if none are passed, load the default values
    $instance->_load_optional_config($config);
    
    return $instance;
}

# A 'private' instance function to load the dictionary file into an object.
# This private function assumes the keys dictionary_file, min_word_length and max_word_length have been set.
# Arguments: NONE
# Returns: 1 always
# Croaks on error
sub _load_dictionary{
    my $this = shift;
    
    print 'DEBUG - Loading dictionary' if $this->{debug};
    
    # try read the raw dictionary data from the dictionary file
    open my $DICT_FILE_R, '<', $this->{dictionary_file} || croak('Failed to open the dictionary file ('.$this->{dictionary_file}.') for reading');
    my $raw_dictionary = do{local $/ = q{}; <$DICT_FILE_R>};
    close $DICT_FILE_R;
    #print "DEBUG - Raw dictionary file:\n$raw_dictionary\n" if $this->{debug};
    unless($raw_dictionary){
        croak('Failed to read the contents of the dictionary file ('.$this->{dictonary_file}.')');
    }
    
    # loop through the raw file and load the words matching the criteria defined by word_min_lenght and word_max_length
    # into this instance's dictionary property.
    $this->{dictionary} = [];
    my @dictionary_lines = split /\n/sx, $raw_dictionary;
    foreach my $line (@dictionary_lines){
        chomp $line;
        
        print "DEBUG - Processing Dictionary Line '$line' ... " if $this->{debug};
        
        # skip 'comment' lines in the dictionary file (lines starting with a #)
        if($line =~ m/^[#]/sx){
            print "skipping (comment)\n" if $this->{debug};
            next;
        }
        
        if(length($line) >= $this->{'min_word_length'} && length($line) <= $this->{'max_word_length'}){
            push @{$this->{'dictionary'}}, $line;
            print "ADDED\n" if $this->{debug};
        }else{
            print "skipped (length)\n" if $this->{debug};
        }
    }
    
    # ensure we got enough from the dictionary file to continue
    my $dictionary_size = scalar @{$this->{dictionary}};
    print "\nDEBUG - Loaded $dictionary_size words into the dictionary\n" if $this->{debug};
    unless($dictionary_size >= $this->{MIN_DICTIONARY_SIZE}){
        croak('Dictionary file '.$this->{dictionary_file}.' did not contain enough words (>= '.$this->{MIN_DICTIONARY_SIZE}.') of lenght '.$this->{min_word_length}.' to '.$this->{max_word_length}.' letters');
    }
    
    # avoid implicit return values
    return 1;
}

#
# PRIVATE Instance Functions
#

# A PRIVATE instance function to load the optional config arguments into an object
# and populate any missing values with the defauly values.
# Aruments: a hashref indexed by the config keys (detailed in the comment for the constructor)
# Returns: 1 always
## no critic (ProhibitExcessComplexity);
sub _load_optional_config{
    my $this = shift;
    my $config = shift;
    
    # set the number of words
    $this->{num_words} = 3;
    if($config->{num_words} && $config->{num_words} =~ m/^\d+$/sx && $config->{num_words} >= 1){
        $this->{num_words} = $config->{num_words};
    }
    
    # set the leet substitutions, if any were passed in the config
    if($config->{l33t_substitutions}){
        $this->{l33t_substitutions} = $config->{l33t_substitutions};
    }
    
    # set the case transform
    $this->{case_transform} = 'NONE';
    if($config->{case_transform} eq 'NONE' || $config->{case_transform} eq 'UPPER' || $config->{case_transform} eq 'LOWER' || $config->{case_transform} eq 'CAPITAL' || $config->{case_transform} eq 'RANDOM' || $config->{case_transform} eq 'ALTERNATE'){
        $this->{case_transform} = $config->{case_transform};
    }
    
    # set the custom separator, if one was passed
    if(defined $config->{custom_separator}){
        $this->{custom_separator} = $config->{custom_separator};
    }
    
    # set the number of digits to prepend & append
    $this->{prepend_numbers} = 3;
    if((defined $config->{prepend_numbers}) && $config->{prepend_numbers} =~ m/^\d+$/sx && $config->{prepend_numbers} >= 0){
        $this->{prepend_numbers} = $config->{prepend_numbers};
    }
    $this->{append_numbers} = 3;
    if((defined $config->{append_numbers}) && $config->{append_numbers} =~ m/^\d+$/sx && $config->{append_numbers} >= 0){
        $this->{append_numbers} = $config->{append_numbers};
    }
    
    # set the padding parameters
    $this->{pad_char} = 'RANDOM';
    if((defined $config->{pad_char}) && (length $config->{pad_char} == 1 || $config->{pad_char} eq 'SEPARATOR' || $config->{pad_char} eq 'RANDOM')){
        $this->{pad_char} = $config->{pad_char};
    }
    $this->{pre_pad} = 3;
    if((defined $config->{pre_pad}) && $config->{pre_pad} =~ m/^\d+$/sx && $config->{pre_pad} >= 0){
        $this->{pre_pad} = $config->{pre_pad};
    }
    $this->{post_pad} = 3;
    if((defined $config->{post_pad}) && $config->{post_pad} =~ m/^\d+$/sx && $config->{post_pad} >= 0){
        $this->{post_pad} = $config->{post_pad};
    }
    $this->{adaptive_padding} = 0;
    if($config->{adaptive_padding} && $config->{adaptive_padding} =~ m/^\d+$/sx && $config->{adaptive_padding} > 0){
        $this->{adaptive_padding} = $config->{adaptive_padding};
    }
    
    # ensure we have a source of randomnes set
    $this->{random_source} = 'PERL';
    if($config->{random_source} && ($config->{random_source} eq 'PERL' || $config->{random_source} eq 'RANDOM_ORG' )){
        if($config->{random_source} eq 'RANDOM_ORG'){
            # if we are to use random.org, ensure we also got a http_command option
            if($config->{http_command}){
                $this->{random_source} = $config->{random_source};
                $this->{http_command} = $config->{http_command};
            }
        }else{
            $this->{random_source} = $config->{random_source};
        }
    }
    
    # avoid implicit return values
    return 1;
}
## use critic

# a PRIVATE instance function to return a number of random positive integers within a given range.
# Arguments:
# 1) the number of random numbers to generate
# 2) the lowest allowed  positive integer value
# 3) the highest allowed positive integer value
# Returns: an array of random integers
# Croaks on error
sub _get_random_integers{
    my $this = shift;
    my $num = shift;
    my $min = shift;
    my $max = shift;
    
    # ensure our arguments are valid
    unless((defined $num) && (defined $min) && (defined $max) && $num =~ m/^\d+$/sx && $num > 0 && $min =~ m/^\d+$/sx && $max =~ m/^\d+$/sx){
        croak("invalid arguments passed to _get_random_integers() - num=$num,min=$min,max=$max");
    }
    
    # if max and min are the wrong way around, don't croak, just swap 'em
    if($min > $max){
        my $temp = $min;
        $min = $max;
        $max = $temp;
    }
    
    if($this->{random_source} eq 'PERL'){
        return $this->_get_random_integers_perl($num, $min, $max);
    }elsif($this->{random_source} eq 'RANDOM_ORG'){
        # this line could croak
        return $this->_get_random_integers_randomorg($num, $min, $max);
    }else{
        croak 'Invalid source of randomness specified ('.$this->{random_source}.')';
    }
    
    return (); # to prevent implicit returns
}

# a PRIVATE instance function to get an array of random numbers within a given
# range using Perl's built-in random functions.
# Arguments:
# 1) the number of random numbers to generate
# 2) the lowest allowed  positive integer value
# 3) the highest allowed positive integer value
# Returns: an array of random integers
# Croaks on error
sub _get_random_integers_perl{
    my $this = shift;
    my $num = shift;
    my $min = shift;
    my $max = shift;
    
    # ensure our arguments are valid
    unless((defined $num) && (defined $min) && (defined $max) && $num =~ m/^\d+$/sx && $num > 0 && $min =~ m/^\d+$/sx && $max =~ m/^\d+$/sx){
        croak("invalid arguments passed to _get_random_integers_perl() - num=$num,min=$min,max=$max");
    }
    
    # if max and min are the wrong way around, don't croak, just swap 'em
    if($min > $max){
        my $temp = $min;
        $min = $max;
        $max = $temp;
    }
    
    my @ans = ();
    
    for my $n (1..$num){
        push @ans, (int rand ($max - $min + 1)) + $min;
    }
    
    return @ans;
}

# a PRIVATE instance function to get an array of random numbers within a given
# range using the random.org web service.
# Arguments:
# 1) the number of random numbers to generate
# 2) the lowest allowed  positive integer value
# 3) the highest allowed positive integer value
# Returns: an array of random integers
# Croaks on error
sub _get_random_integers_randomorg{
    my $this = shift;
    my $num = shift;
    my $min = shift;
    my $max = shift;
    
    # ensure our arguments are valid
    unless((defined $num) && (defined $min) && (defined $max) && $num =~ m/^\d+$/sx && $num > 0 && $min =~ m/^\d+$/sx && $max =~ m/^\d+$/sx){
        croak("invalid arguments passed to _get_random_integers_randomorg() - num=$num,min=$min,max=$max");
    }
    
    # if max and min are the wrong way around, don't croak, just swap 'em
    if($min > $max){
        my $temp = $min;
        $min = $max;
        $max = $temp;
    }
    
    # Get all the random numbers with one call to random.org (as requested in the TOS)
    my $command = $this->{http_command}.' "http://www.random.org/integers/?num='.$num.'&min='.$min.'&max='.$max.'&col=1&base=10&format=plain&rnd=new"';
    my $raw_random_numbers = `$command`;
    my @random_number_lines = split /\n/sx, $raw_random_numbers;
    my @random_numbers = ();
    foreach my $line (@random_number_lines){
        chomp $line;
        if($line =~ m/^\d+$/sx){
            push @random_numbers, $line;
        }
    }
    
    #if we're sure the output was OK, return the numbers
    unless(scalar @random_numbers == $num){
        croak('Did not receive valid random numbers from the random.org web service');
    }
    return @random_numbers;
}

# a PRIVATE instance function to return the needed number of random words from the dictionary.
# This function also applies any needed case and l33t transformations to the words.
# Arguments: NONE
# Returns: an array of random words
# Croaks on error
sub _get_words{
    my $this = shift;
    
    my @ans = ();
    my $dictionary_length = scalar @{$this->{dictionary}};
    
    # get an array of random numbers - this line could croak
    my @random_numbers = $this->_get_random_integers($this->{num_words}, 0, $dictionary_length -1);
    
    # assemble the words
    foreach my $random_number (@random_numbers){
        my $word = $this->{dictionary}->[$random_number];
        
        # apply any needed l33t substitutions to the word
        $word = $this->_apply_l33tsubs($word);
        
        push @ans, $word;
    }
    
    # apply the case transformations (needs to be done after all the words are assembled)
    @ans = $this->_apply_casetransforms(@ans);
    
    # return the list of words
    return @ans;
}

# a PRIVATE instance function to apply the l33t substitutions specified in this instance's
# config to a given word.
# Arguments:
# 1) the word to apply the substitutions to
# Returns: a string
sub _apply_l33tsubs{
    my $this = shift;
    my $word = shift;
    
    # if there are any substitutions, apply them
    if($this->{l33t_substitutions}){
        foreach my $key (keys %{$this->{l33t_substitutions}}){
            my $sub = $this->{l33t_substitutions}->{$key};
            if(defined $sub){
                $word =~ s/$key/$sub/gisx;
            }
        }
    }
    
    # return the word
    return $word;
}

# a PRIVATE instance function to apply the required case transforms specified in
# this instance's config to a given set of words.
# Arguments:
# 1..n) the words to apply the transforms to
# Returns: an array of strings
sub _apply_casetransforms{
    my $this = shift;
    my @words = ();
    while(my $word = shift){
        push @words, $word;
    }
    
    my @ans = ();
    
    # loop through the set of words and apply the needed transforms
    for my $n (0..((scalar @words) -1)){
        my $word = $words[$n];
        
        # capitalise the first letter only
        if($this->{case_transform} eq 'CAPITAL'){
            $word = lc $word;
            $word = ucfirst $word;
            push @ans, $word;
            next;
        }
        
        # upper-case the entire word
        if($this->{case_transform} eq 'UPPER'){
            push @ans, uc $word;
            next;
        }
        
        # lower-case the entire word
        if($this->{case_transform} eq 'LOWER'){
            push @ans, lc $word;
            next;
        }
        
        # randomly upper or lower the case
        if($this->{case_transform} eq 'RANDOM'){
            if(int rand 1000 % 2 == 0){
                $word = lc $word;
            }else{
                $word = uc $word;
            }
            push @ans, $word;
            next;
        }
        
        # alternate the case of each word
        if($this->{case_transform} eq 'ALTERNATE'){
            if($n % 2 ==0){
                $word = lc $word;
            }else{
                $word = uc $word;
            }
            push @ans, $word;
            next;
        }
        
        # if we've gotten this far, the transform was either NONE
        # or invalid, either way, apply no transform
        push @ans, $word;
    }
    
    # return the transformed list of words
    return @ans;
}

# a PRIVATE instance method to calculate the separator to use for this instance.
# Arguments: NONE
# Returns a string (though it could be an empty string)
sub _get_separator{
    my $this = shift;
    
    # if a custom separator is defined, but not set to random, return it
    if((defined $this->{custom_separator}) && $this->{custom_separator} ne 'RANDOM' && $this->{custom_separator} ne q{}){
        # if the special value is set to 'NONE', return an empty string
        if($this->{custom_separator} eq 'NONE'){
            return q{};
        }
        
        #otherwise, return the string set in the config
        return $this->{custom_separator};
    }
    
    # otherwise, return a random separator
    return $this->{SEPARATORS}->[rand scalar @{$this->{SEPARATORS}}];
}

# a PRIVATE instance method to calcualte the padding character to use for this
# instance.
# Arguments: NONE
# Returns a string
sub _get_pad_char{
    my $this = shift;
    
    # check each of the special cases
    if($this->{pad_char} eq 'SEPARATOR'){
        return $this->_get_separator();
    }
    if($this->{pad_char} eq 'RANDOM'){
        return $this->{SEPARATORS}->[rand scalar @{$this->{SEPARATORS}}];
    }
    
    # if none of those matched, return the the content of the config variable
    return $this->{pad_char};
}

#
# PUBLIC Instance Functions
#

# An instance function to generate a password
# Arguments: NONE
# Returns: a randomly generated password
# Croaks on error
sub generate_password{
    my $this = shift;
    
    #
    # Gather some needed info
    #
    
    # gather the random words
    my @random_words = $this->_get_words();
    
    # get the separator
    my $separator = $this->_get_separator();
    
    # get the padding character
    my $pad_char;
    if($this->{pad_char} eq 'SEPARATOR'){
        $pad_char = $separator;
    }else{
        $pad_char = $this->_get_pad_char();
    }
    
    #
    # assemble the password
    #
    
    my $password = q{}; # empty string
    
    # prepend a number if required
    for my $n (1..$this->{prepend_numbers}){
        if($n == 1){
            $password .= (int rand 9) + 1;
        }else{
            $password .= int rand 10;
        }
    }
    $password .= $separator if $this->{prepend_numbers};
    
    # add the words
    $password .= join $separator, @random_words;
    
    # append a number if required
    $password .= $separator if $this->{append_numbers};
    for my $n (1..$this->{append_numbers}){
        if($n == 1){
            $password .= (int rand 9)+1;
        }else{
            $password .= int rand 10;
        }
    }
    
    # deal with the padding
    if($this->{adaptive_padding}){
        # adaptive padding
        
        if(length $password > $this->{adaptive_padding}){
            # trim back to adaptive padding length
            $password = substr $password, 0, $this->{adaptive_padding};
        }elsif(length $password < $this->{adaptive_padding}){
            # pad the back of the password
            while(length $password < $this->{adaptive_padding}){
                $password .= $pad_char;
            }
        }
    }else{
        # regular padding
        for my $n (1..$this->{pre_pad}){
            $password = $pad_char.$password;
        }
        for my $n (1..$this->{post_pad}){
            $password .= $pad_char;
        }
    }
    
    return $password;
}

1; # Perl is dumb!