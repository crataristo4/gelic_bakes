import 'package:flutter/material.dart';
import 'package:gelic_bakes/constants/constants.dart';
import 'package:gelic_bakes/provider/review_provider.dart';
import 'package:gelic_bakes/ui/widgets/progress_dialog.dart';

import '../../main.dart';

class AddReviewPage extends StatefulWidget {
  static const routeName = '/addReview';

  const AddReviewPage({Key? key}) : super(key: key);

  @override
  _AddReviewPageState createState() => _AddReviewPageState();
}

class _AddReviewPageState extends State<AddReviewPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  ReviewProvider reviewProvider = ReviewProvider();

  @override
  void dispose() {
    controller.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    buildReview() {
      return TextFormField(
          maxLines: 30,
          controller: controller,
          autofocus: true,
          validator: (value) {
            return value!.length > 10 && value.isNotEmpty
                ? null
                : reviewRequired;
          },
          keyboardType: TextInputType.multiline,
          onChanged: (value) {
            reviewProvider.setMessage(value);
          },
          decoration: InputDecoration(
              hintStyle: TextStyle(fontSize: sixteenDp),
              suffix: GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    Dialogs.showLoadingDialog(
                        context, loadingKey, "adding review", Colors.white);
                    reviewProvider.createReview(context);
                    controller.clear();
                  }
                },
                child: Container(
                  child: Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                  width: thirtySixDp,
                  height: thirtySixDp,
                  decoration: BoxDecoration(
                    color: Colors.pink,
                    borderRadius: BorderRadius.circular(eightDp),
                    border: Border.all(width: 0.5, color: Colors.white54),
                  ),
                ),
              ),
              hintText: writeAReview,
              helperMaxLines: 2,
              fillColor: Colors.white70,
              filled: true,
              contentPadding:
                  EdgeInsets.symmetric(vertical: twentyDp, horizontal: tenDp),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFF5F5F5)),
              ),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFF5F5F5)))));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: EdgeInsets.all(tenDp),
            decoration: BoxDecoration(
                border: Border.all(width: 0.3, color: Colors.grey),
                color: Colors.pink,
                borderRadius: BorderRadius.circular(thirtyDp)),
            child: Padding(
              padding: EdgeInsets.all(eightDp),
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
                size: sixteenDp,
              ),
            ),
          ),
        ),
        title: Text(
          writeAReview,
          style: TextStyle(color: Colors.pink),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: Form(
              key: _formKey,
              child: Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(sixteenDp),
                  child: buildReview(),
                ),
              ),
            ),
          ),

          /*SizedBox(
            height: fortyEightDp,
            child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(eightDp))),
                onPressed: () {

                },
                child: Text(
                  send,
                  style: TextStyle(fontSize: fourteenDp),
                )),
          ),*/
        ],
      ),
    );
  }
}
