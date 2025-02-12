import Foundation
import UIKit

@objc(DetectProxy) class DetectProxy: CDVPlugin {

    @objc(isProxyEnabled:)
    func isProxyEnabled(command: CDVInvokedUrlCommand) {
        let proxyEnabled = self.detectProxy()
        let pluginResult = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: proxyEnabled ? 1 : 0)
        self.commandDelegate.send(pluginResult, callbackId: command.callbackId)

        if proxyEnabled {
            self.showAlertAndExit()
        }
    }

    private func detectProxy() -> Bool {
        guard let proxySettings = CFNetworkCopySystemProxySettings()?.takeUnretainedValue() as? NSDictionary else {
            return false
        }

        if let proxies = proxySettings["HTTPEnable"] as? Int, proxies == 1 {
            return true
        }
        if let httpsProxies = proxySettings["HTTPSEnable"] as? Int, httpsProxies == 1 {
            return true
        }
        if let proxyHost = proxySettings["HTTPProxy"] as? String, !proxyHost.isEmpty {
            return true
        }
        if let proxyHost = proxySettings["HTTPSProxy"] as? String, !proxyHost.isEmpty {
            return true
        }

        return false
    }

    private func showAlertAndExit() {
        DispatchQueue.main.async {
            if let viewController = UIApplication.shared.keyWindow?.rootViewController {
                let alert = UIAlertController(
                    title: "❌ Conexión Insegura",
                    message: "Se ha detectado un proxy o VPN. La aplicación se cerrará.",
                    preferredStyle: .alert
                )

                alert.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { _ in
                    exit(0) // Cierra la app si el usuario presiona "Aceptar"
                }))

                viewController.present(alert, animated: true, completion: nil)

                // 🔥 Cerrar automáticamente la app después de 5 segundos si el usuario no presiona "Aceptar"
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                    exit(0)
                }
            }
        }
    }
}
