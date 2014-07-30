import sys

from gaiatest import GaiaData
from marionette import Marionette

assert(len(sys.argv) == 3)
m = Marionette()
m.start_session()
testvars = {"wifi":{"ssid": sys.argv[1], "keyManagement": "WPA-PSK", "psk": sys.argv[2]}}
gd = GaiaData(m, testvars=testvars)
gd.enable_wifi()
gd.connect_to_wifi()
