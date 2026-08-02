The files in this directory are samples of the files referenced on the
www.lifewithqmail.org web site. They should be moved and renamed accordingly.
They require the use of several ports - daemontools and ucspi-tcp.
If you are following the Life with Qmail directions, then you would rename and
move the files like this:

qmailctl -> QMAIL HOME/bin/qmailctl
run -> QMAIL HOME/run
qmail-send-run -> QMAIL HOME/supervise/qmail-send/run
qmail-send-log-run -> QMAIL HOME/supervise/qmail-send/log/run
qmail-smtpd-run -> QMAIL HOME/supervise/qmail-smtpd/run
qmail-smtpd-log-run -> QMAIL HOME/supervise/qmail-smtpd/log/run

You will definitely want to at least review the Life with Qmail site carefully
if this is your first experience with Qmail. Also, this is the enhanced version
of Qmail with the SPAMCONTROL patches from www.fehcom.de, you will want to read
that site careifully to see what features you may want to take advantage of.

The files here are samples only, modify and use them as you see fit!
The qmail-smtpd-run file has an example of using some Spamcontrol add-ons as
well a using some rbl spam lists. It also uses fixcrio which is part of
ucspi-tcp to fix up buggy email software.
