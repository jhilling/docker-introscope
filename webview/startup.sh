#!/bin/sh

# we need a special startup script, as we need to set the enterprise manager the webview is linked to
# we store the original file to be able to apply the transformation again.
if [ ! -f IntroscopeWebView-orig.properties ]
	then
		cp ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties IntroscopeWebView-orig.properties
fi
cp IntroscopeWebView-orig.properties ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/EM_HOST_MARKER/${EM_HOST}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/EM_PORT_MARKER/${EM_PORT}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties
sed -i s/{EM_HOST}:8081/${EM_HOST}:${EM_WEB_PORT}/g ${INTROSCOPE_HOME}/config/IntroscopeWebView.properties

# activate Java agent
sed -i "s#lax.nl.java.option.additional=#lax.nl.java.option.additional=-javaagent:./product/webview/agent/wily/Agent.jar -Dcom.wily.introscope.agentProfile=./product/webview/agent/wily/core/config/IntroscopeAgent.profile -Dcom.wily.introscope.wilyForWilyPrefix=com.wily -Djetty.home=./ #" ${INTROSCOPE_HOME}/Introscope_WebView.lax
sed -i s/EM_HOST_MARKER/${EM_HOST}/g ${INTROSCOPE_HOME}/product/webview/agent/wily/core/config/IntroscopeAgent.profile
sed -i s/EM_PORT_MARKER/${EM_PORT}/g ${INTROSCOPE_HOME}/product/webview/agent/wily/core/config/IntroscopeAgent.profile


# configure the heap
if [ "${HEAP_XMX}" == "**DEFAULT**" ] ; then
	unset HEAP_XMX
fi
if [ -n "${HEAP_XMX}" ] ; then
	sed -i s/Xmx512m/Xmx${HEAP_XMX}/g ${INTROSCOPE_HOME}/Introscope_Webview.lax
fi

# give EM time to start up
sleep 15

# now we correctly set everything and startup the enterprise manager.
${INTROSCOPE_HOME}/Introscope_WebView
