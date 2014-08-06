#/bin/bash -e

TRIES=0

./run.sh > testoutput  2>&1 &

on_die() {
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
      echo "JENKINS-FAILURE: Marionette is not running on the device"
      EXIT_CODE=1
    fi
    on_die
    if [ $EXIT_CODE -eq 0 ]; then
      echo "Found TEST_START"
    fi
    exit $EXIT_CODE
  fi
  TRIES=$((TRIES+1))
  sleep 5
done
echo "JENKINS-FAILURE: didn't get TEST_START in time"
on_die
exit 1
