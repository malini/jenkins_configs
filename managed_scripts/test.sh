TRIES=0
cd fxos-certsuite
./run.sh &> testoutput&

#while [ $TRIES -lt 15 ]; do
while [ $TRIES -lt 60 ]; do
  echo $TRIES
  #NOTE: this is a rough draft. This makes sure we get to the point where we can
  # run the semiauto tests, but if there are issues *during* the test, we 
  # don't catch them. For example, if we can't connect to marionette,
  # then we still get TEST_END
  cat testoutput | grep TEST_END
  if [ $? -eq 0 ]; then
    EXIT_CODE=0
    nc -z localhost 2828
    if [ $? != 0 ]; then
      echo "Marionette is not running on the device"
      EXIT_CODE=1
    fi
    kill `ps ux | grep runcertsuite | grep -v grep | awk '{ print $2 }'`
    exit $EXIT_CODE
  fi
  TRIES=$((TRIES+1))
  sleep 5
done
exit 1
