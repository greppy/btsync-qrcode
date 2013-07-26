btsync-qrcode
=============

BitTorrent Sync QR Code generator

I like the idea of being able to sync directories on my android phone and tablet with my other systems.
However, there is no way to generate the QR Code on linux if using a config file instead of the webui interface.

This script provides QR Codes as individual PNG files for each share in a BTSync configuration file.

    $ btsync_qrcode.rb --help
    Usage: btsync_qrcode.rb [options]
        --[no-]png                   Output as individual PNG files, default TRUE
        --html FILE                  Print HTML QR Codes to FILE
    -f, --file FILE                  BTSync config file ( default ~/.btsync )
    -s, --size SIZE                  PNG image size (default 300)
