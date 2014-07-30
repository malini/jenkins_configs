virtualenv venv
. venv/bin/activate
pip install gaiatest
adb forward tcp:2828 tcp:2828
python set_wifi.py "${WIFI_NAME}" ${WIFI_PWD}
