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
   shExpMatch(url, "smtp:*") ||
   shExpMatch(url, "submission:*") ||
   shExpMatch(url, "imap:*") ||
   shExpMatch(url, "imaps:*")
   ||
   // Apple Enterprise Network Domains; https://support.apple.com/en-us/HT210060
   dnsDomainIs(host, ".apple.com") ||
   dnsDomainIs(host, ".cdn-apple.com") ||
   dnsDomainIs(host, ".apple-cloudkit.com") ||
   dnsDomainIs(host, ".apple-livephotoskit.com") ||
   (host == "app-site-association.cdn-apple.com") ||
   dnsDomainIs(host, ".app-site-association.cdn-apple.com") ||
   (host == "app-site-association.networking.apple") ||
   dnsDomainIs(host, ".app-site-association.networking.apple") ||
   dnsDomainIs(host, ".apzones.com") ||
   (host == "appldnld.apple.com.edgesuite.net") ||
   (host == "icloud.com") ||
   dnsDomainIs(host, ".icloud.com") ||
   dnsDomainIs(host, ".icloud-content.com") ||
   (host == "itunes.com") ||
   dnsDomainIs(host, ".itunes.com") ||
   dnsDomainIs(host, ".mzstatic.com") ||
   dnsDomainIs(host, ".vertexsmb.com") ||
   (host == "crl.entrust.net") || dnsDomainIs(host, "crl.entrust.net") ||
   (host == "crl3.digicert.com") || dnsDomainIs(host, "crl3.digicert.com") ||
   (host == "crl4.digicert.com") || dnsDomainIs(host, "crl4.digicert.com") ||
   (host == "ocsp.digicert.com") || dnsDomainIs(host, "ocsp.digicert.com") ||
   (host == "ocsp.entrust.net") || dnsDomainIs(host, "ocsp.entrust.net") ||
   (host == "ocsp.verisign.net") || dnsDomainIs(host, "ocsp.verisign.net")
   ||
   /*
       Proxy bypass hostnames
   */
   // Zoom
   dnsDomainIs(host, ".zoom.us")
)
        return "DIRECT";
else
        return "PROXY @PROXY_SERVER@:8118";
}
