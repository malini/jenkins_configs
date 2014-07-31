TRIES=0
cd fxos-certsuite

echo "Setting up virtualenv"

if [ ! -d "certsuite_venv" ]; then
  virtualenv --no-site-packages certsuite_venv || { echo 'error creating virtualenv' ; exit 1; }
fi

. certsuite_venv/bin/activate
python setup.py install
echo "Done, running the suite"
runcertsuite > testoutput  2>&1 &

on_die() {
  echo "in on_die"
  kill `ps ux | grep runcertsuite | grep -v grep | awk '{ print $2 }'`
  kill `ps ux | grep run.sh | grep -v grep | awk '{ print $2 }'`
  kill `ps ux | grep webapirunner | grep -v grep | awk '{ print $2 }'`
}

trap 'on_die' TERM
trap 'on_die' KILL

RUNNING=1
while [ $TRIES -lt 20 ]; do
  echo $TRIES
  # NOTE: this is a rough draft. This makes sure we get to the point where we can
  # run the semiauto tests, but if there are issues *during* the test, we
  # don't catch them. For example, if we can't connect to marionette,
  # then we still get TEST_START
  cat testoutput | grep TEST_START
  if [ $? -eq 0 ]; then
    EXIT_CODE=0
    nc -z localhost 2828
    if [ $? != 0 ]; then
      echo "Marionette is not running on the device"
      EXIT_CODE=1
    fi
    on_die
    exit $EXIT_CODE
  fi
  TRIES=$((TRIES+1))
  sleep 5
done
echo "didn't get TEST_END in time"
on_die
exit 1
