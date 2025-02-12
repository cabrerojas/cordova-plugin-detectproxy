package cl.oneapp.detectproxy;

import org.apache.cordova.*;
import org.json.JSONArray;
import org.json.JSONException;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.net.ProxySelector;
import java.util.List;

public class DetectProxy extends CordovaPlugin {

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("isProxyEnabled")) {
            return this.isProxyEnabled(callbackContext);
        }
        return false;
    }

    private boolean isProxyEnabled(CallbackContext callbackContext) {
        boolean isProxy = detectProxy();
        callbackContext.success(isProxy ? 1 : 0);
        return true;
    }

    private boolean detectProxy() {
        try {
            List<Proxy> proxies = ProxySelector.getDefault().select(new java.net.URI("http://www.google.com"));
            for (Proxy proxy : proxies) {
                if (proxy.address() instanceof InetSocketAddress) {
                    return true; // Proxy detectado
                }
            }
        } catch (Exception e) {
            return false;
        }
        return false;
    }
}
