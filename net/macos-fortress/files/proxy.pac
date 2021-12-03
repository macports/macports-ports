function FindProxyForURL(url, host)
{
if (
   // Bypass proxy on the LAN for local DNS domainname
   // (host == "mydomainname.com") ||
   // dnsDomainIs(host, ".mydomainname.com") ||
   // (host == "mydomainname.private") ||
   // dnsDomainIs(host, ".mydomainname.private") ||
   isPlainHostName(host) ||
   shExpMatch(host, "10.*") ||
   shExpMatch(host, "172.16.*") ||
   shExpMatch(host, "192.168.*") ||
   shExpMatch(host, "127.*") ||
   dnsDomainIs(host, ".LOCAL") || dnsDomainIs(host, ".local")
   /*
       Fix iOS 13 PAC file issue with Mail.app
       See: https://forums.developer.apple.com/thread/121928
       See: https://discussions.apple.com/thread/250687994
   */
   ||
   // Comcast
   (host == "imap.comcast.net") || (host == "smtp.comcast.net") ||
   dnsDomainIs(host, "imap.comcast.net") || dnsDomainIs(host, "smtp.comcast.net") ||
   // Apple
   (host == "imap.mail.me.com") || (host == "smtp.mail.me.com") ||
   dnsDomainIs(host, "imap.mail.me.com") || dnsDomainIs(host, "smtp.mail.me.com") ||
   (host == "p03-imap.mail.me.com") || (host == "p03-smtp.mail.me.com") ||
   dnsDomainIs(host, "p03-imap.mail.me.com") || dnsDomainIs(host, "p03-smtp.mail.me.com") ||
   (host == "p66-imap.mail.me.com") || (host == "p66-smtp.mail.me.com") ||
   dnsDomainIs(host, "p66-imap.mail.me.com") || dnsDomainIs(host, "p66-smtp.mail.me.com") ||
   // Google
   (host == "imap.gmail.com") || (host == "smtp.gmail.com") ||
   dnsDomainIs(host, "imap.gmail.com") || dnsDomainIs(host, "smtp.gmail.com") ||
   // Yahoo
   (host == "imap.mail.yahoo.com") || (host == "smtp.mail.yahoo.com") ||
   dnsDomainIs(host, "imap.mail.yahoo.com") || dnsDomainIs(host, "smtp.mail.yahoo.com") ||
   // Apple Enterprise Network Domains; https://support.apple.com/en-us/HT210060
   (host == "albert.apple.com") || dnsDomainIs(host, "albert.apple.com") ||
   (host == "captive.apple.com") || dnsDomainIs(host, "captive.apple.com") ||
   (host == "gs.apple.com") || dnsDomainIs(host, "gs.apple.com") ||
   (host == "humb.apple.com") || dnsDomainIs(host, "humb.apple.com") ||
   (host == "static.ips.apple.com") || dnsDomainIs(host, "static.ips.apple.com") ||
   (host == "tbsc.apple.com") || dnsDomainIs(host, "tbsc.apple.com") ||
   (host == "time-ios.apple.com") || dnsDomainIs(host, "time-ios.apple.com") ||
   (host == "time.apple.com") || dnsDomainIs(host, "time.apple.com") ||
   (host == "time-macos.apple.com") || dnsDomainIs(host, "time-macos.apple.com") ||
   dnsDomainIs(host, ".push.apple.com") ||
   (host == "gdmf.apple.com") || dnsDomainIs(host, "gdmf.apple.com") ||
   (host == "deviceenrollment.apple.com") || dnsDomainIs(host, "deviceenrollment.apple.com") ||
   (host == "deviceservices-external.apple.com") || dnsDomainIs(host, "deviceservices-external.apple.com") ||
   (host == "identity.apple.com") || dnsDomainIs(host, "identity.apple.com") ||
   (host == "iprofiles.apple.com") || dnsDomainIs(host, "iprofiles.apple.com") ||
   (host == "mdmenrollment.apple.com") || dnsDomainIs(host, "mdmenrollment.apple.com") ||
   (host == "setup.icloud.com") || dnsDomainIs(host, "setup.icloud.com") ||
   (host == "appldnld.apple.com") || dnsDomainIs(host, "appldnld.apple.com") ||
   (host == "gg.apple.com") || dnsDomainIs(host, "gg.apple.com") ||
   (host == "gnf-mdn.apple.com") || dnsDomainIs(host, "gnf-mdn.apple.com") ||
   (host == "gnf-mr.apple.com") || dnsDomainIs(host, "gnf-mr.apple.com") ||
   (host == "gs.apple.com") || dnsDomainIs(host, "gs.apple.com") ||
   (host == "ig.apple.com") || dnsDomainIs(host, "ig.apple.com") ||
   (host == "mesu.apple.com") || dnsDomainIs(host, "mesu.apple.com") ||
   (host == "oscdn.apple.com") || dnsDomainIs(host, "oscdn.apple.com") ||
   (host == "osrecovery.apple.com") || dnsDomainIs(host, "osrecovery.apple.com") ||
   (host == "skl.apple.com") || dnsDomainIs(host, "skl.apple.com") ||
   (host == "swcdn.apple.com") || dnsDomainIs(host, "swcdn.apple.com") ||
   (host == "swdist.apple.com") || dnsDomainIs(host, "swdist.apple.com") ||
   (host == "swdownload.apple.com") || dnsDomainIs(host, "swdownload.apple.com") ||
   (host == "swpost.apple.com") || dnsDomainIs(host, "swpost.apple.com") ||
   (host == "swscan.apple.com") || dnsDomainIs(host, "swscan.apple.com") ||
   (host == "updates-http.cdn-apple.com") || dnsDomainIs(host, "updates-http.cdn-apple.com") ||
   (host == "updates.cdn-apple.com") || dnsDomainIs(host, "updates.cdn-apple.com") ||
   (host == "xp.apple.com") || dnsDomainIs(host, "xp.apple.com") ||
   dnsDomainIs(host, ".itunes.apple.com") ||
   dnsDomainIs(host, ".apps.apple.com") ||
   dnsDomainIs(host, ".mzstatic.com") ||
   (host == "ppq.apple.com") || dnsDomainIs(host, "ppq.apple.com") ||
   (host == "lcdn-registration.apple.com") || dnsDomainIs(host, "lcdn-registration.apple.com") ||
   (host == "crl.apple.com") || dnsDomainIs(host, "crl.apple.com") ||
   (host == "crl.entrust.net") || dnsDomainIs(host, "crl.entrust.net") ||
   (host == "crl3.digicert.com") || dnsDomainIs(host, "crl3.digicert.com") ||
   (host == "crl4.digicert.com") || dnsDomainIs(host, "crl4.digicert.com") ||
   (host == "ocsp.apple.com") || dnsDomainIs(host, "ocsp.apple.com") ||
   (host == "ocsp.digicert.com") || dnsDomainIs(host, "ocsp.digicert.com") ||
   (host == "ocsp.entrust.net") || dnsDomainIs(host, "ocsp.entrust.net") ||
   (host == "ocsp.verisign.net") || dnsDomainIs(host, "ocsp.verisign.net") ||
   // Zoom
   /*
       Proxy bypass hostnames
   */
   ||
   dnsDomainIs(host, ".zoom.us")
)
        return "DIRECT";
else
        return "PROXY @PROXY_SERVER@:8118";
}
