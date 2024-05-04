import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:poll_app/controllers/admin_controller.dart';
import 'package:poll_app/utils/extensions.dart';
class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final DataTableSource _data = TableData();
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    c.checkLogin();
    super.initState();
  }

  final AdminController c = Get.put(AdminController());

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
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/images/ic_admin_dark.png",
                                height: 75,
                                width: 75,
                              ),
                            ),
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
                                  padding: const EdgeInsets.symmetric(horizontal: 150,vertical: 10),
                                  child: Card(
                                     elevation: 20,
                                    child: PaginatedDataTable(
                                      header: Center(child: Text("Polls On Active"),),
                                        columnSpacing: 40,
                                        columns: [
                                          DataColumn(label: Text("Create Date")),
                                          DataColumn(label: Text("id")),
                                          DataColumn(label: Text("Answer Count")),
                                          DataColumn(label: Text("Action")),

                                    ], source: _data),
                                  ),
                                );
                              }
                            }),
                      ],
                    ),
                )
                : Center(child: getLoginBody(),);
          }));
    });
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
                      duration: Duration(seconds: 3),
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
                      end: 750,
                      duration: Duration(seconds: 3),
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
                      end: 750,
                      duration: Duration(seconds: 3),
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
              height: 330,
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
                      Expanded(
                          child: GestureDetector(
                        onTap: c.isFormValid.value
                            ? () async {
                                await c.login();
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
  
 
}
class TableData extends DataTableSource{
  final AdminController c = Get.put(AdminController());
  @override
  DataRow? getRow(int index) {
     return DataRow(cells: [
       DataCell(Text(c.pollResponseModel.value.polls?[index].createdAt?.customDateFormat() ?? "")),
       DataCell(Text(c.pollResponseModel.value.polls?[index].sId ?? "")),
       DataCell(Text(c.pollResponseModel.value.polls?[index].userAnswers?.length.toString() ?? "")),
       DataCell(Row(children: [
         IconButton(icon :Icon(Icons.remove_red_eye),onPressed: () {
           var modified = c.pollResponseModel.value.polls?[index].sId?.replaceAll('"', '');
           String url = "/solvePool/$modified";
           print(url.toString());
           Get.toNamed(url);
         },),
         IconButton(icon :Icon(Icons.delete), onPressed: () {  },),
       ],)),
     ]);
  }

  @override
  // TODO: implement isRowCountApproximate
  bool get isRowCountApproximate => false;

  @override
  // TODO: implement rowCount
  int get rowCount => c.pollResponseModel.value.polls?.length ?? 0;

  @override
  // TODO: implement selectedRowCount
  int get selectedRowCount => 0;


}

