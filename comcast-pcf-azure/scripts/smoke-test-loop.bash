STOP_AFTER=1456156800

while : ; do
 now=$(date +%s)
 if [[ "$STOP_AFTER" -lt "$now" ]] ; then
   break
 fi
 echo "===== $(date) ====="
 bosh -d /home/pivotal/workspace/azure-trail-blazer/merrill/ert_1.6/pcf_1_6_azure.yaml run errand smoke-tests --keep-alive
done > ~/tmp/smoke-test-err 2>&1 >~/tmp/smoke-test-out

echo "+++++++ stopped at $(date)" >> ~/tmp/smoke-test-out

