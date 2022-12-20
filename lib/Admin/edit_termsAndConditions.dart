import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constant/constants.dart';
import '../constant/theme.dart';
import '../notifier/CookieData.dart';
import '../utils/colorUtils.dart';
import '../utils/textUtils.dart';
import '../widget/commonTextFromField.dart';
import '../widget/validation.dart';

class EditTermAndConditions extends StatefulWidget {
  const EditTermAndConditions({Key? key}) : super(key: key);

  @override
  State<EditTermAndConditions> createState() => _EditTermAndConditionsState();
}

class _EditTermAndConditionsState extends State<EditTermAndConditions> {
  @override
  void initState() {
    getData();
    super.initState();
  }

  var formKey = GlobalKey<FormState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  bool isValid = true;

  getData() async {
    var objTermAndConditionProvider =
        Provider.of<CookiesData>(context, listen: false);
    await objTermAndConditionProvider.getConditions(context);

    _title.text = objTermAndConditionProvider.objTermAndConditionModel.title!;
    _description.text =
        objTermAndConditionProvider.objTermAndConditionModel.description!;
  }

  @override
  Widget build(BuildContext context) {
    final objTermAndConditionProvider = context.watch<CookiesData>();
    return Scaffold(
      //--------------------Arrow back Icon------------------------------
      appBar: AppBar(
        backgroundColor: AppTheme.getTheme().scaffoldBackgroundColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: ConstColor.primaryColor,
            size: width * 0.06,
          ),
        ),
        leadingWidth: width * 0.1,
        title:

            ///--------------------Edit Cookie  text  ---------------------
            Text(
          TextUtils.editTermsand,
          style: AppTheme.getTheme().textTheme.bodyText2!.copyWith(
              color: ConstColor.primaryColor,
              height: 1.4,
              fontSize: width * 0.052),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          objTermAndConditionProvider.isLoading ||
                  objTermAndConditionProvider
                          .objTermAndConditionModel.description ==
                      null ||
                  objTermAndConditionProvider
                          .objTermAndConditionModel.description ==
                      "" ||
                  objTermAndConditionProvider.objTermAndConditionModel.title ==
                      null ||
                  objTermAndConditionProvider.objTermAndConditionModel.title ==
                      ""
              ? Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                )
              : Container(),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: width * 0.03,
                    right: width * 0.03,
                    top: height * 0.02,
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CommonTextFromField(
                          textCapitalization: TextCapitalization.sentences,
                          txt: TextUtils.youromw,
                          controller: _title,
                          validator: isvalidinformation,
                          onChanged: (val) {
                            setState(() {
                              isValid = formKey.currentState!.validate();
                            });
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.026),
                          child: TextFormField(
                            maxLines: 25,
                            autovalidateMode: AutovalidateMode.disabled,
                            style: AppTheme.getTheme()
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                  fontSize: width * 0.041,
                                  color: ConstColor.white_Color,
                                ),
                            controller: _description,
                            onChanged: (val) {
                              setState(() {
                                isValid = formKey.currentState!.validate();
                              });
                            },
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              errorStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.036,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.04),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.04),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.04),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              disabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.04),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(height * 0.04),
                                borderSide: BorderSide(
                                  color: ConstColor.textFormFieldColor,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: width * 0.05,
                                  vertical: height * 0.028),
                              hintText: TextUtils.enterDescription,
                              hintStyle: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                    fontSize: width * 0.041,
                                    height: 1.5,
                                    color: ConstColor.white_Color,
                                  ),
                            ),
                            validator: isvalidDescription,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              //-------------------------------Save Button View------------------------
              Container(
                margin: EdgeInsets.only(
                  bottom: height * 0.03,
                  left: width * 0.03,
                  right: width * 0.03,
                ),
                child: GestureDetector(
                  onTap: () async {
                    setState(() {
                      isValid = formKey.currentState!.validate();
                    });

                    if (isValid) {
                      await objTermAndConditionProvider
                          .updateTermsAndConditions(
                        context,
                        objTermAndConditionProvider
                            .objTermAndConditionModel.id!,
                        _description.text,
                        _title.text,
                      );
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.only(
                      top: height * 0.030,
                    ),
                    padding: EdgeInsets.all(height * 0.019),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(height * 0.1),
                      color:
                          isValid ? ConstColor.primaryColor : Color(0xff2F2F2F),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ------------ Text View-----------
                        Expanded(
                          child: Center(
                            child: Text(
                              TextUtils.Save,
                              style: AppTheme.getTheme()
                                  .textTheme
                                  .bodyText2!
                                  .copyWith(
                                    fontSize: width * 0.055,
                                    color: ConstColor.black_Color,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
