import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';

class LoginResult {
  final String visitorData;
  final String dataSyncId;
  final String innerTubeCookie;

  LoginResult({
    required this.visitorData,
    required this.dataSyncId,
    required this.innerTubeCookie,
  });
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  InAppWebViewController? controller;

  String visitorData = "";
  String dataSyncId = "";
  String innerTubeCookie = "";
  String accountName = "";
  String accountEmail = "";
  String accountChannelHandle = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(
            result: LoginResult(
              visitorData: visitorData,
              dataSyncId: dataSyncId,
              innerTubeCookie: innerTubeCookie,
            ),
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: () async {
          if (controller != null) {
            bool canGoBack = await controller!.canGoBack();
            if (canGoBack) {
              controller!.goBack();
              return false;
            }
          }
          return true;
        },

        child: InAppWebView(
          initialUrlRequest: URLRequest(
            url: WebUri(
              "https://accounts.google.com/ServiceLogin?continue=https%3A%2F%2Fmusic.youtube.com",
            ),
          ),
          initialSettings: InAppWebViewSettings(
            javaScriptEnabled: true,
            supportZoom: true,
            builtInZoomControls: true,
            displayZoomControls: false,
            userAgent:
                "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
          ),
          onWebViewCreated: (ctrl) {
            controller = ctrl;

            controller?.addJavaScriptHandler(
              handlerName: "onRetrieveVisitorData",
              callback: (args) {
                final newVisitorData = args.isNotEmpty ? args.first : "";
                setState(() => visitorData = newVisitorData);
              },
            );

            controller?.addJavaScriptHandler(
              handlerName: "onRetrieveDataSyncId",
              callback: (args) {
                final newDataSyncId = args.isNotEmpty ? args.first : "";
                setState(() => dataSyncId = newDataSyncId.split("||").first);
              },
            );
          },

          onLoadStop: (ctrl, url) async {
            if (url == null) return;

            if (url.toString().startsWith("https://music.youtube.com")) {
              final cookies = await CookieManager.instance().getCookies(
                url: WebUri("https://music.youtube.com"),
                webViewController: ctrl,
              );

              setState(() {
                innerTubeCookie = cookies
                    .map((c) => "${c.name}=${c.value}")
                    .join("; ");
              });

              await ctrl.evaluateJavascript(
                source:
                    "window.flutter_inappwebview.callHandler('onRetrieveVisitorData', window.yt?.config_?.VISITOR_DATA);",
              );
              await ctrl.evaluateJavascript(
                source:
                    "window.flutter_inappwebview.callHandler('onRetrieveDataSyncId', window.yt?.config_?.DATASYNC_ID);",
              );
            }
          },
        ),
      ),
    );
  }
}
