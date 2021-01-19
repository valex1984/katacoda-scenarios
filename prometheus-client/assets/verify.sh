TOKEN=`awk 'NR==1' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`
RPS=`awk 'NR==2' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`
LATENCY=`awk 'NR==3' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`
ERRORS=`awk 'NR==4' /root/results.txt  | awk -F: '{print $2}' | sed -e 's/ //g'`

if (( $RPS > 2  &&  $RPS < 4)) ; then RPS_OK=1; else RPS_OK=0; fi
if (( $ERRORS > 1  &&  $ERRORS < 40)) ; then ERRORS_OK=1; else ERRORS_OK=0; fi
if (( $LATENCY > 200  &&  $LATENCY < 600)) ; then LATENCY_OK=1; else LATENCY_OK=0; fi

[[ $RPS_OK == 1 && $ERRORS_OK == 1 && $LATENCY_OK == 1 ]] && echo "done"
