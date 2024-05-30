import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:poll_app/controllers/admin_controller.dart';
import 'package:poll_app/utils/extensions.dart';
import 'package:poll_app/utils/slugify.dart';

import '../models/PollResponseModel.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final key = GlobalKey<PaginatedDataTableState>();

  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  TextEditingController repasswordController = TextEditingController();
  TextEditingController passwordControllerRegister = TextEditingController();
  TextEditingController userNameControllerRegister = TextEditingController();

  TextEditingController forgotpasswordController = TextEditingController();
  TextEditingController recoveryKeyController = TextEditingController();
  TextEditingController forgotuserNameController = TextEditingController();

  String _searchResult = '';

  @override
  void initState() {
    c.checkLogin();
    c.getVisitors();
    super.initState();
  }

  final AdminController c = Get.put(AdminController());
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          appBar: c.isLogined.value
              ? PreferredSize(
              preferredSize: Size.fromHeight(100),
              child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                  color: Colors.white,
                  elevation: 5,
                  child: Container(
                    height: 60,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (){
                            c.disconnect();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.asset(
                              "assets/images/ic_admin_dark.png",
                              height: 75,
                              width: 75,
                            ),
                          ),
                        ),
                        Text(c.authResponseModel.value.admin?.userName ?? "",style: TextStyle(fontWeight: FontWeight.bold),),
                        Expanded(
                            child: Center(
                                child: Text(
                                  "Admin",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold),
                                ))),
                      ],
                    ),
                  )))
              : PreferredSize(
              preferredSize: Size.fromHeight(100), child: SizedBox()),
          backgroundColor: Color(0xffF5F5F9),
          body: Obx(() {
            return c.isLogined.value
                ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  staticsHeader(),
                  FutureBuilder(
                      future: c.getAllPolls(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(
                              child: Lottie.asset(
                                  "assets/lottie/lottie2.json",
                                  frameRate: FrameRate.max));
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 150, vertical: 10),
                            child: Card(
                              elevation: 20,
                              child: Obx(() {
                                return PaginatedDataTable(
                                    key: key,
                                    header: Row(
                                      children: [
                                        Container(

                                            child: Center(child: Text(
                                              "Polls On Active",
                                              style: TextStyle(
                                                  fontWeight: FontWeight
                                                      .bold),))),
                                        Spacer(),
                                        Container(
                                            width: 210,
                                            height: 50,
                                            child: TextField(
                                              onChanged: (String value) {
                                                _searchResult = value;
                                                c.pollsFiltered.value =
                                                    c.pollResponseModel.value
                                                        .polls!
                                                        .where((poll) =>
                                                    poll.sId?.contains(
                                                        _searchResult) ?? false)
                                                        .toList();
                                                key.currentState?.pageTo(0);
                                              },
                                              style: TextStyle(),
                                              decoration: InputDecoration(
                                                  hintText: "Search"),))
                                      ],
                                    ),
                                    columnSpacing: 40,
                                    columns: [
                                      DataColumn(label: Text("Create Date")),
                                      DataColumn(label: Text("id")),
                                      DataColumn(label: Text("Answer Count")),
                                      DataColumn(label: Text("Action")),

                                    ],
                                    source: TableData(c.pollsFiltered.value));
                              }),
                            ),
                          );
                        }
                      }),
                ],
              ),
            )
                : Center(child: getBody());
          }));
    });
  }
  getBody(){
    if(c.isWantRegister.value){
      return getRegisterBody();
    }else if(c.isWantForgot.value){
      return getForgotPassBody();
    }
    else{
      return getLoginBody();
    }
  }

  staticsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Container(
          width: 200,
          height: 100,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Countup(
                      begin: 0,
                      end: c.pollCount.value,
                      duration: Duration(milliseconds: 200),
                      separator: ',',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Active Poll Count",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Countup(
                      begin: 0,
                      end: c.answeredUserCount.value,
                      duration: Duration(milliseconds: 200),
                      separator: ',',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Answer Count",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Countup(
                      begin: 0,
                      end: c.visitorsCount.value,
                      duration: Duration(milliseconds: 200),
                      separator: ',',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Visitor Count",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    width: 1,
                    color: Colors.grey.shade200,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Countup(
                      begin: 0,
                      end: c.activeUsersCount.value,
                      duration: Duration(milliseconds: 200),
                      separator: ',',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      "Active Admin Count",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getLoginBody() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 50,
      color: Colors.black12,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff31313a),
              ),
              child: Center(
                  child: Text(
                    "PLEASE ENTER YOUR LOGIN DETAILS",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: 300,
              height: 420,
              color: Color(0xff363740),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/ic_admin.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.userName.value = value;
                          c.checkForm();
                        },
                        controller: userNameController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.password.value = value;
                          c.checkForm();
                        },
                        controller: passwordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: (){
                          c.isWantForgot.value = true;
                        },
                        child: Text("Forgot Password",
                          style: TextStyle(color: Colors.white,
                              decoration: TextDecoration.underline),),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: c.isFormValid.value
                                ? () async {
                              await c.login();
                              passwordController.clear();
                              userNameController.clear();
                            }
                                : null,
                            child: Container(
                              child: Center(
                                  child: !c.isLoading.value
                                      ? Text(
                                    "Login",
                                    style: TextStyle(
                                        color: c.isFormValid.value
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                      : SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Obx(() => Checkbox(
                              value: c.rememberMe.value,
                              onChanged: (bool? newValue) {
                                c.rememberMe.value = newValue!;
                              })),
                          Text(
                            "Remember Me",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                   GestureDetector(
                          onTap: (){
                            c.isWantRegister.value = true;
                          },
                          child: Center(child: Text("or Sign Up",
                            style: TextStyle(color: Colors.white,
                                decoration: TextDecoration.underline),)),
                        ),

                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getRegisterBody() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 50,
      color: Colors.black12,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff31313a),
              ),
              child: Center(
                  child: Text(
                    "PLEASE ENTER YOUR REGISTER DETAILS",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: 300,
              height: 400,
              color: Color(0xff363740),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/ic_admin.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.userNameRegister.value = value;
                          c.checkFormForRegister();
                        },
                        controller: userNameControllerRegister,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.passwordRegister.value = value;
                          c.checkFormForRegister();
                        },
                        controller: passwordControllerRegister,
                        obscureText: true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.repasswordRegister.value = value;
                          c.checkFormForRegister();
                        },
                        obscureText: true,
                        controller: repasswordController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "rePassword",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: c.isFormValidRegister.value
                                ? () async {
                             var recovery =  await c.register();
                             if(recovery!=""){
                               showSuccessDialog(recovery);
                             }
                             passwordControllerRegister.clear();
                             userNameControllerRegister.clear();
                             repasswordController.clear();
                            }
                                : null,
                            child: Container(
                              child: Center(
                                  child: !c.isLoading.value
                                      ? Text(
                                    "Register",
                                    style: TextStyle(
                                        color: c.isFormValidRegister.value
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                      : SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: (){
                          c.isWantRegister.value = false;
                        },
                        child: Center(child: Text("or Sign In",
                          style: TextStyle(color: Colors.white,
                              decoration: TextDecoration.underline),)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
  getForgotPassBody() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 50,
      color: Colors.black12,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 300,
              height: 50,
              decoration: BoxDecoration(
                color: Color(0xff31313a),
              ),
              child: Center(
                  child: Text(
                    "ENTER YOUR NEW DETAILS",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
            Container(
              width: 300,
              height: 400,
              color: Color(0xff363740),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        "assets/images/ic_admin.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.userNameForgot.value = value;
                          c.checkFormForgot();
                        },
                        controller: forgotuserNameController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "username",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.passwordForgot.value = value;
                          c.checkFormForgot();
                        },
                        controller: forgotpasswordController,
                        obscureText: true,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "password",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextField(
                        onChanged: (String value) {
                          c.recoveryForgot.value = value;
                          c.checkFormForgot();
                        },
                        obscureText: true,
                        controller: recoveryKeyController,
                        style: TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "recoveryKey",
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: c.isFormValidForgot.value
                                ? () async {
                               await c.resetPassword();
                               recoveryKeyController.clear();
                               forgotuserNameController.clear();
                               forgotpasswordController.clear();
                            }
                                : null,
                            child: Container(
                              child: Center(
                                  child: !c.isLoading.value
                                      ? Text(
                                    "Reset",
                                    style: TextStyle(
                                        color: c.isFormValidForgot.value
                                            ? Colors.white
                                            : Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  )
                                      : SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ))),
                              decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: (){
                          c.isWantRegister.value = false;
                          c.isWantForgot.value = false;
                        },
                        child: Center(child: Text("or Sign In",
                          style: TextStyle(color: Colors.white,
                              decoration: TextDecoration.underline),)),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showSuccessDialog(String recoveryId) {
    Get.defaultDialog(
        barrierDismissible: false,
        title: "Admin Kaydınız Yapıldı", content: Column(
      children: [
        Text("Kurtarma numaranız aşağıda verilmiştir !"),

        SizedBox(height: 5,),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(recoveryId.toString(), style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),),
            SizedBox(width: 20,),
            ElevatedButton(onPressed: () async {
              var modified = slug(recoveryId);
              await Clipboard.setData(ClipboardData(text: modified));
              c.isWantRegister.value = false;
              Navigator.pop(context);
            },
              child: Text("Copy"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),)
          ],),

        SizedBox(height: 5,),
        Text("Kopyaladıktan sonra devam edebilirsiniz !"),
        SizedBox(height: 5,),
      ],
    ));
  }
}

class TableData extends DataTableSource {
  final List<Polls>? polls;

  TableData(this.polls);

  final AdminController c = Get.put(AdminController());

  @override
  DataRow? getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(polls?[index].createdAt?.customDateFormat() ?? "")),
      DataCell(Text(polls?[index].sId ?? "")),
      DataCell(Text(polls?[index].userAnswers?.length.toString() ?? "")),
      DataCell(Row(children: [
        IconButton(icon: Icon(Icons.question_answer_outlined), onPressed: () {
          showAnswers(index);
        },),
        IconButton(icon: Icon(Icons.add), onPressed: () async {
          var modified = slug(polls?[index].sId ?? "");
          String url = "/solvePool/$modified";
          await Get.toNamed(url);
          c.getAllPolls();
        },),
        IconButton(icon: Icon(Icons.remove_red_eye), onPressed: () async {
          var modified =slug( polls?[index].sId ?? "");
          String url = "/preview/$modified";
          print(url.toString());
          Get.toNamed(url);
        },),
        IconButton(icon: Icon(Icons.delete), onPressed: () {
          c.deletePoll(polls?[index].sId ?? "");
        },),
      ],)),
    ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => polls?.length ?? 0;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;

  void showAnswers(int index) {
    var selectedPoll = polls?[index].userAnswers;
    Get.defaultDialog(
        barrierDismissible: true,
        title: "Answer List", content: SingleChildScrollView(
      child: Container(
        width: 400,
        height: 200,
        child: ListView.builder(shrinkWrap: true,
            itemCount: polls?[index].userAnswers?.length,
            itemBuilder: (context, index) {
              return ListTile(trailing: IconButton(
                icon: Icon(Icons.remove_red_eye,), onPressed: () {
                List<Answers>? list = selectedPoll?[index].answers;
                Get.toNamed("/getAnswers", arguments: list);
              },),
                title: Text(selectedPoll?[index].sId.toString() ?? ""),
                subtitle: Text(selectedPoll?[index].sId.toString() ?? ""),);
            }),
      ),
    ));
  }
}

