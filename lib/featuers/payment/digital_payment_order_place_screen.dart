import 'dart:async';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:base_project/app/app_functions.dart';
import 'package:base_project/common/resources/color_manager.dart';
import 'package:base_project/common/resources/strings_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

class DigitalPaymentView extends StatefulWidget {
  final String url;
  final int pageIndex;
  const DigitalPaymentView({super.key, required this.url, this.pageIndex = 0});

  @override
  DigitalPaymentViewState createState() => DigitalPaymentViewState();
}

class DigitalPaymentViewState extends State<DigitalPaymentView> {
  String? selectedUrl;
  double value = 0.0;

  late WebViewController controllerGlobal;
  PullToRefreshController? pullToRefreshController;
  late MyInAppBrowser browser;

  @override
  void initState() {
    super.initState();
    selectedUrl = widget.url;
    _initData();
  }

  void _initData() async {
    browser = MyInAppBrowser(context,widget.pageIndex);
    if(Platform.isAndroid){
      await InAppWebViewController.setWebContentsDebuggingEnabled(true);
      bool swAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_BASIC_USAGE);
      bool swInterceptAvailable = await WebViewFeature.isFeatureSupported(WebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);
      if (swAvailable && swInterceptAvailable) {
        ServiceWorkerController serviceWorkerController = ServiceWorkerController.instance();
        await serviceWorkerController.setServiceWorkerClient(ServiceWorkerClient(
          shouldInterceptRequest: (request) async {
            if (kDebugMode) {
              print(request);
            }
            return null;
          },
        ));
      }
    }
    await browser.openUrlRequest(
        urlRequest: URLRequest(url: WebUri(selectedUrl??'')),
        settings: InAppBrowserClassSettings(
            webViewSettings: InAppWebViewSettings(useShouldOverrideUrlLoading: true, useOnLoadResource: true),
            browserSettings: InAppBrowserSettings(hideUrlBar: true, hideToolbarTop: Platform.isAndroid)));
  }



  @override
  Widget build(BuildContext context) {
    return PopScope(canPop: false,
      onPopInvoked: (val) => _exitApp(context),
      child: const Scaffold(),
    );
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await controllerGlobal.canGoBack()) {
      controllerGlobal.goBack();
      return Future.value(false);
    } else {
      context.pop();
      // context.go(AppRouters.btmNav);
      AppFunctions.showsToast(AppStrings.paymentCanceled.tr(), ColorManager.red, context);
      return Future.value(true);
    }
  }
}



class MyInAppBrowser extends InAppBrowser {

  final BuildContext context;
  final int pageIndex;

  MyInAppBrowser(this.context, this.pageIndex, {
    super.windowId,
    super.initialUserScripts,
  });

  bool _canRedirect = true;

  @override
  Future onBrowserCreated() async {
    if (kDebugMode) {
      print("\n\nBrowser Created!\n\n");
    }
  }

  @override
  Future onLoadStart(url) async {
    if (kDebugMode) {
      print("\n\nStarted: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  Future onLoadStop(url) async {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("\n\nStopped: $url\n\n");
    }
    _pageRedirect(url.toString());
  }

  @override
  void onLoadError(url, code, message) {
    pullToRefreshController?.endRefreshing();
    if (kDebugMode) {
      print("Can't load [$url] Error: $message");
    }
  }

  @override
  void onProgressChanged(progress) {
    if (progress == 100) {
      pullToRefreshController?.endRefreshing();
    }
    if (kDebugMode) {
      print("Progress: $progress");
    }
  }

  @override
  void onExit() {
    if(_canRedirect) {
      context.pop();
      // context.go(AppRouters.btmNav);
      AppFunctions.showsToast(AppStrings.paymentFailed.tr(), ColorManager.red, context);
    }

    if (kDebugMode) {
      print("\n\nBrowser closed!\n\n");
    }
  }

  @override
  Future<NavigationActionPolicy> shouldOverrideUrlLoading(navigationAction) async {
    if (kDebugMode) {
      print("\n\nOverride ${navigationAction.request.url}\n\n");
    }
    return NavigationActionPolicy.ALLOW;
  }

  @override
  void onLoadResource(resource) {
  }

  @override
  void onConsoleMessage(consoleMessage) {
    if (kDebugMode) {
      print("""
    console output:
      message: ${consoleMessage.message}
      messageLevel: ${consoleMessage.messageLevel.toValue()}
   """);
    }
  }

  void _pageRedirect(String url) {
    print("url ===========> $url");
    if(_canRedirect) {
      bool isSuccess = url.contains('success=true') && url.contains("https://auctionmycar.online/");
      bool isFailed = url.contains('success=false') && url.contains("https://auctionmycar.online/");
      bool isCancel = url.contains('status=cancel') && url.contains("https://auctionmycar.online/");
      if(isSuccess || isFailed || isCancel) {
        _canRedirect = false;
        Future.delayed(const Duration(milliseconds: 500), () {
          if(isSuccess){
            // context.go(AppRouters.btmNav,
            //   extra: {
            //   "pageIndex": pageIndex,
            //   "refreshKey": UniqueKey(),
            //   },
            // );
            context.pop();
            context.pop();
            AppFunctions.showsToast(AppStrings.paymentSuccess.tr(), ColorManager.successGreen, context);
          }else if(isCancel) {
            context.pop();
            context.pop();
            AppFunctions.showsToast(AppStrings.paymentCanceled.tr(), ColorManager.red, context);
          }else{
            context.pop();
            context.pop();
            AppFunctions.showsToast(AppStrings.paymentFailed.tr(), ColorManager.red, context);
          }
          close();
        });

      }
    }

  }
}