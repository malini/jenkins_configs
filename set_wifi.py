from gaiatest import GaiaData
from marionette import Marionette
m = Marionette()
m.start_session()
testvars = {"wifi":{"ssid": "${WIFI_NAME}", "keyManagement": "WPA-PSK", "psk": "${WIFI_PWD}"}}
gd = GaiaData(m, testvars=testvars)
gd.enable_wifi()
gd.connect_to_wifi()
