import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:swapxchange/repository/repo_app_settings.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/loading_progressbar.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/helpers.dart';

class Privacy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          title: 'Privacy Policy',
        ),
      ),
      body: FutureBuilder<String?>(
          future: RepoAppSettings.getAppSettingsByKey(key: "privacy_policy"),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LoadingProgressMultiColor(showBg: false);
            }
            final data = snapshot.data;

            return SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: Html(
                  data: data != null ? Helpers.parseHtmlString(data) : "Network error",
                ),
              ),
            );
          }),
    );
  }
}
