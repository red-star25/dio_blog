import 'package:dio_blog/data/models/user/new_user_model.dart';
import 'package:dio_blog/di/service_locator.dart';
import 'package:dio_blog/ui/home/controller.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/add_user_form.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({
    Key? key,
  }) : super(key: key);

  @override
  State<NewUserPage> createState() => _NewUserPageState();
}

class _NewUserPageState extends State<NewUserPage> {
  final homeController = getIt.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Newly added User'),
      ),
      body: ListView.builder(
        itemCount: homeController.newUsers.length,
        itemBuilder: (context, index) {
          final NewUser user = homeController.newUsers[index];
          return ListTile(
              onLongPress: () async {
                await homeController.deleteNewUser(index).then((value) {
                  setState(() {});
                }).then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Deleted Successfully'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                });
              },
              onTap: () {
                homeController.nameController.text = user.name!;
                homeController.jobController.text = user.job!;
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return UserForm(
                      homeController: homeController,
                      isUpdate: true,
                      onSubmit: () async {
                        await homeController
                            .updateUser(
                          index,
                          homeController.nameController.text,
                          homeController.jobController.text,
                        )
                            .then((value) {
                          Navigator.pop(context);
                          setState(() {});
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('User Updated Successfully'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                );
              },
              title: Text(user.name!),
              subtitle: Text(user.job!),
              trailing: user.updatedAt != null
                  ? Text(DateFormat().format(DateTime.parse(user.updatedAt!)))
                  : Text(DateFormat().format(DateTime.parse(user.createdAt!))));
        },
      ),
    );
  }
}
