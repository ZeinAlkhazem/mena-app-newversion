import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ThreeDViewerWidget extends StatefulWidget {
  const ThreeDViewerWidget({super.key});

  @override
  State<ThreeDViewerWidget> createState() => _ThreeDViewerWidgetState();
}

class _ThreeDViewerWidgetState extends State<ThreeDViewerWidget> {
  late WebViewController webViewController;
  @override
  void initState() {
    super.initState();
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://skfb.ly/6VtZu')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://skfb.ly/6VtZu'));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(),
          child: WebViewWidget(
            controller: webViewController,
          ),
        ),
        Positioned(
          right: 10,
          top: 20,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(15),
                child: CircleAvatar(
                  backgroundColor: Color(0x4C252836),
                  child: Icon(
                    Icons.more_vert_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/menamarket/heart_circle_outline_28 2.svg',
              ),
              const SizedBox(
                height: 10,
              ),
              SvgPicture.asset(
                'assets/menamarket/share_external_outline_28 3.svg',
              ),
            ],
          ),
        ),
        const Positioned(
          left: 10,
          top: 20,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: CircleAvatar(
              backgroundColor: Color(0x4C252836),
              child: Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
