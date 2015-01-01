Some scripts that I have written or modified for use with the popular IRC
client, [irssi](http://www.irssi.org/)

## boxcarirssi.pl

Forked from [sniker's boxcarirssi.pl](https://git.eth0.info/sniker/boxcarirssi/blob/ab959500632d1272161801282ae9b38c6f8f2ebf/boxcarirssi.pl)

This script sends notifications to your phone (via [Boxcar](https://boxcar.io/)) using [boxcar-growl.py](https://gist.github.com/foolishbrilliance/1b3d394ceb8b776f06d7). By default, this script will only send notifications when you are away. You can enable non-away notifications by running `/set boxcarirssi_nonaway ON`.

## monitorwin.pl

Originally forked from [znxster's hilightwin.pl](https://github.com/znxster/irssi-scripts/blob/master/hilightwin.pl). Allows you to have a window with output coming from all channels (similar to [LimeChat](http://limechat.net/mac/)'s bottom channel pane. It does this by printing all public messages to a window named 'm', unless the message was destined to the active window (to avoid duplicates of the message showing up).
