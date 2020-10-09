# How to Load Test Connectomics

Usng jmeter load test tool.  Setup recording proxy in jmeter.  Configured browser to use proxy. Logged onto connectomics web app, and went through the application.  Edited the captured jmeter test.  Extracted the radnomized token with a json extractor naming the variable ${token}.  Replaced the captured tokens in the http requests in test plan with variable ${token}

Run the load new load test script on a host with docker

```export timestamp=$(date +%Y%m%d_%H%M%S) && \
export volume_path=<where files are on host> && \
export jmeter_path=/mnt/jmeter && \
docker run \
  --volume "${volume_path}":${jmeter_path} \
  jmeter \
  -n \
  -t ${jmeter_path}/<jmx_script> \
  -l ${jmeter_path}/tmp/result_${timestamp}.jtl \
  -j ${jmeter_path}/tmp/jmeter_${timestamp}.log```

