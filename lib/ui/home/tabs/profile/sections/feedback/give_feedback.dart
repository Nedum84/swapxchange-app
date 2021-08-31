import 'package:flutter/material.dart';
import 'package:swapxchange/models/feedback_model.dart';
import 'package:swapxchange/repository/repo_feedback.dart';
import 'package:swapxchange/ui/widgets/custom_appbar.dart';
import 'package:swapxchange/ui/widgets/custom_button.dart';
import 'package:swapxchange/utils/alert_utils.dart';
import 'package:swapxchange/utils/colors.dart';
import 'package:swapxchange/utils/constants.dart';
import 'package:swapxchange/utils/styles.dart';

class GiveFeedback extends StatelessWidget {
  TextEditingController messageController = TextEditingController();
  FocusNode textFieldFocusName = FocusNode();

  _submitFeedback() async {
    textFieldFocusName.unfocus();
    final msg = messageController.text.toString().trim();
    if (msg.isEmpty) {
      AlertUtils.toast('Enter feedback message');
      return;
    }

    AlertUtils.showProgressDialog(title: null);
    final feedback = FeedbackModel(message: msg);
    final addFeedback = await RepoFeedback.addFeedbackModel(feedback: feedback);
    if (addFeedback != null) {
      AlertUtils.toast('Message received successfully');
      messageController.clear();
    } else {
      AlertUtils.toast('Error occurred, try again');
    }

    AlertUtils.hideProgressDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: KColors.WHITE_GREY,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Constants.APPBAR_HEIGHT),
        child: CustomAppbar(
          title: 'Give Feedback',
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: KColors.TEXT_COLOR_LIGHT.withOpacity(.5), width: 1),
              ),
              child: TextField(
                controller: messageController,
                focusNode: textFieldFocusName,
                keyboardType: TextInputType.multiline,
                maxLines: 8,
                style: TextStyle(
                  color: KColors.TEXT_COLOR_DARK,
                  fontWeight: FontWeight.w600,
                ),
                cursorColor: Colors.blueGrey,
                decoration: InputDecoration(
                  hintText: 'Enter your feedback...',
                  hintStyle: StyleNormal.copyWith(
                    color: KColors.TEXT_COLOR,
                    fontWeight: FontWeight.w500,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  errorBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 8, bottom: 2, top: 2, right: 8),
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            PrimaryButton(onClick: _submitFeedback, btnText: 'Submit')
          ],
        ),
      ),
    );
  }
}
