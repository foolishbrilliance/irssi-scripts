# Based off of hilightwin.pl... modified by foolishbrilliance
# Instead of printing hilights in a window named 'hilight', this will print
# all public messages to a window named 'm', unless the message was destined
# to the active window (to avoid duplicates of the message showing up).

# Print hilighted messages & private messages to window named "hilight" for
# irssi 0.7.99 by Timo Sirainen
#
# Modded a tiny bit by znx to stop private messages entering the hilighted
# window (can be toggled) and to put up a timestamp.
#

use Irssi;
use POSIX;
use vars qw($VERSION %IRSSI); 

$VERSION = "0.02";
%IRSSI = (
    authors     => "Timo \'cras\' Sirainen, Mark \'znx\' Sangster",
    contact     => "tss\@iki.fi, znxster\@gmail.com", 
    name        => "hilightwin",
    description => "Print hilighted messages to window named \"hilight\"",
    license     => "Public Domain",
    url         => "http://irssi.org/",
    changed     => "Sun May 25 18:59:57 BST 2008"
);

sub sig_printtext {
    my ($dest, $text, $stripped) = @_;

    my $opt = MSGLEVEL_PUBLIC;

    if(
        ($dest->{level} & ($opt)) &&
        ($dest->{level} & MSGLEVEL_NOHILIGHT) == 0
    ) {
        $window = Irssi::window_find_name('m');
        
        if ($dest->{level} & MSGLEVEL_PUBLIC) {
            $text = $dest->{target}.": ".$text;
        }
        $text = strftime(
            Irssi::settings_get_str('timestamp_format')." ",
            localtime
        ).$text;

	if ($dest->{window}->{refnum} ne Irssi::active_win()->{refnum}) {
		$window->print($text, MSGLEVEL_NEVER) if ($window);
	}
    }
}

$window = Irssi::window_find_name('m');
Irssi::print("Create a window named 'm'") if (!$window);

Irssi::signal_add('print text', 'sig_printtext');

# vim:set ts=4 sw=4 et:
