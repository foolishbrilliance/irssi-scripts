use strict;
use warnings;

#####################################################################
# Latest version: https://github.com/foolishbrilliance/irssi-scripts/blob/master/boxcarirssi.pl
# Modified from https://git.eth0.info/sniker/boxcarirssi/blob/ab959500632d1272161801282ae9b38c6f8f2ebf/boxcarirssi.pl
#
# This script sends notifications to your iPhone using boxcar-growl.py:
# https://gist.github.com/foolishbrilliance/1b3d394ceb8b776f06d7
#
# By default, this script will only send notifications when you are away
#
# Commands:
# /set boxcarirssi_general_hilight on/off
# /set boxcarirssi_nonaway on/off     # enable when not away
# /set boxcar_ignore_nettag NETWORKS  # Networks in this case is a
#                                      comma separated list of
#                                      network tags that should
#                                      be ignored.
#
# "General hilight" basically referrs to ALL the hilights you have
# added manually in irssi, if many, it can get really bloated if
# turned on. Default is Off.
#
# You will need the following packages:
# LWP::UserAgent (You can install this using cpan -i LWP::UserAgent)
# Crypt::SSLeay  (You can install this using cpan -i Crypt::SSLeay)
# 
# Or if you're using Debian GNU/Linux:
# apt-get update;apt-get install libwww-perl libcrypt-ssleay-perl
#####################################################################


use Irssi;
use Irssi::Irc;
use vars qw($VERSION %IRSSI);
use LWP::UserAgent;
use HTTP::Request::Common;

$VERSION = "0.2";

%IRSSI = (
    authors     => "Caesar 'sniker' Ahlenhed",
    contact     => "sniker\@codebase.nu",
    name        => "boxcarirssi",
    description => "Sends notifcations when away",
    license     => "GPLv2",
    url         => "http://sniker.codebase.nu",
    changed     => "Sat Jun 23 18:06:26 CESTT 2014",
);

# Configuration settings and default values.
Irssi::settings_add_bool("boxcarirssi", "boxcarirssi_nonaway", 0);
Irssi::settings_add_bool("boxcarirssi", "boxcarirssi_general_hilight", 0);
Irssi::settings_add_str("boxcarirssi", "boxcarirssi_ignore_nettag", "");

sub send_noti {
    my ($title, $text) = @_;

    my %options = ();
    system("boxcar-growl \"irssi: $title\" --sound beep-soft \"".$text."\"");
}

sub pubmsg {
    my ($server, $data, $nick, $nick_addr, $target) = @_;
    if(!Irssi::settings_get_bool("boxcarirssi_general_hilight")){
        if( (Irssi::settings_get_bool("boxcarirssi_nonaway") || $server->{usermode_away} == 1) && $data =~ /$server->{nick}/i && index(Irssi::settings_get_str("boxcarirssi_ignore_nettag"), $server->{tag}) == -1){
            send_noti("$nick in $target (" . scalar(split(/\s+/, $data)) . ")" , "Current nick: " . $server->{nick} ." (Away: ". $server->{away_reason} .")" );
        }
    }
}

sub privmsg {
    my ($server, $data, $nick) = @_;
    if( (Irssi::settings_get_bool("boxcarirssi_nonaway") || $server->{usermode_away} == 1) && index(Irssi::settings_get_str("boxcarirssi_ignore_nettag"), $server->{tag}) == -1){
        send_noti("PM from $nick (" . scalar(split(/\s+/, $data)) . " words)", "Current nick: " . $server->{nick} ." (Away: ". $server->{away_reason} .")" );
    }
}

sub genhilight {
    my($dest, $text, $stripped) = @_;
    my $server = $dest->{server};

    if($dest->{level} & MSGLEVEL_HILIGHT) {
        if( (Irssi::settings_get_bool("boxcarirssi_nonaway") || $server->{usermode_away} == 1) && index(Irssi::settings_get_str("boxcarirssi_ignore_nettag"), $server->{tag}) == -1){
            if(Irssi::settings_get_bool("boxcarirssi_general_hilight")){
                send_noti("Genhighlight - $stripped", "General Hilight " . $server->{tag} . "/" . $dest->{target} ." - ");
            }
        }
    }
}

Irssi::signal_add_last('message public', 'pubmsg');
Irssi::signal_add_last('message private', 'privmsg');
Irssi::signal_add_last('print text', 'genhilight');
