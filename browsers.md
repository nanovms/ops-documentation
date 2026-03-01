Browser Issues
========================

__Chrome__

You might find in recent chrome && mac releases the inability to
connect to a local private ip such as 192.168.x.x. There is a known
issue where MacOS is not recoginizing newer builds of chrome as the same
application.

To get around this you can go to Applications. Right-click on chrome,
show package contents. Then simply rename the binary in
Contents/MacOS/Google Chrome to something like 'chrome 2'. Try to open
it, let it fail, then rename it back. The next time you try to open a
local ip you'll be prompted to allow access to the local network.
