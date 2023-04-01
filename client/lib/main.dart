import 'package:conduitflutter/cubit/auth_cubit.dart';
import 'package:conduitflutter/locator_service.dart';
import 'package:conduitflutter/post.dart';
import 'package:conduitflutter/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_enviroment.dart';
import 'approuter/router.dart';
import 'interceptor.dart';
List<String>filtered=["Да","Нет"];
String filter="false";
int postid=-1;
final Dio dio = Dio();
var result;
bool? box=false;
String token = '';
var jsonList;
int currenUserID = 0;
List<Post> myWidgetList = <Post>[];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Dio().put('127.0.0.1:8888/',data:"");
  await init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  AppRouter router = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: log,
      onGenerateRoute: router.generateRouter,
    );
  }
}

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Form(
              key: _key,
              child: Column(
                children: [
                  Text('Логин'),

                  TextFormField(
                    maxLength: 25,
                    controller: _loginController,
                    // initialValue: "PDAfa!!!!!!!!!!!!!!!!!",

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Логин не должен быть пустым';
                      }
                      if (value.length < 5) {
                        return 'Логин должен быть не менее 5 символов';
                      }
                      
                    },
                    decoration: const InputDecoration(
                      hintText: 'Логин',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  //Пароль
                  TextFormField(
                    maxLength: 30,
                    controller: _passwordController,
                    //   initialValue: "cringes",
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Пароль не должен быть пустым';
                      }
                     
                     
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Пароль',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  //Почта
                  TextFormField(
                    // initialValue: "oofua@mail.ru",
                    controller: _emailController,
                    maxLength: 100,

                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Почта не должна быть пустой';
                      }

                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Почта',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () async{
                        if (_key.currentState!.validate()) {
                          await signIn(_loginController.text,
                              _passwordController.text, _emailController.text);
                        } else {}
                      },
                      child: const Text(
                        'Авторизация',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, reg);
                      },
                      child: const Text(
                        'Регистрация',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }

// Авторизация
  Future<void> signIn(String login, String password, String email) async {
    dio.interceptors.add(AuthInterceptor());

    result = await dio.post('http://192.168.148.237:8888/token',
        data: User(userName: login, password: password, email: email),
        options: Options(headers: dio.options.headers));
    if (result.statusMessage == "OK") {
      var json = result.data["data"];
      token = json["accessToken"].toString();
      currenUserID = json["id"];
      dio.options.headers['Authorization'] = 'Bearer ' + token;
      // var resultNotes = await dio.get("http://127.0.0.1:8888/notes",queryParameters: {
      //               "page": "1",
      //               "amount": "6",
      //               "filter": filter,
      //             },).then((value) => myWidgetList = (value.data["data"]) );
      ;
      // getData("1", "6", filter, dio);
      Navigator.pushReplacementNamed(context, userpage);
    }
  }
}

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  State<Registration> createState() => _Registration();
}

class _Registration extends State<Registration> {
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text(
                      'Регистрация',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26),
                    ),
                    const Spacer(),

                    TextFormField(
                      maxLength: 25,
                      controller: _loginController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Логин не должен быть пустым';
                        }
                        if (value.length < 5) {
                          return 'Логин должен быть не менее 5 символов';
                        }
                        if (value.contains(RegExp(r"[а-яА-Я]"), 0)) {
                          return 'Только английские символы ';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Логин',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    //Пароль
                    TextFormField(
                      maxLength: 30,
                      controller: _passwordController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Пароль не должен быть пустым';
                        }
                        if (value.length < 5) {
                          return 'Пароль должен быть не менее 5 символов';
                        }
                        if (value.contains(RegExp(r"[а-яА-Я0]"), 0)) {
                          return 'Только английские символы ';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Пароль',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //Почта
                    TextFormField(
                      maxLength: 100,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Почта не должна быть пустой';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Почта',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            context.read<AuthCubit>().signUp(User(
                                userName: _loginController.text,
                                password: _passwordController.text,
                                email: _emailController.text));
                          } else {}
                        },
                        child: const Text(
                          'Зарегистрироваться',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () =>
                            Navigator.pushReplacementNamed(context, log),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // Future<void> signUp(String login, String password, String email) async {
  //   if (await Dio().put('http://127.0.0.1:8888/token',
  //           data: User(userName: login, password: password, email: email)) ==
  //       true) ;
  //   Navigator.pushReplacementNamed(context, log);
  // }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPage();
}

class _MainPage extends State<MainPage> {
  GlobalKey<FormState> _key = GlobalKey();

  TextEditingController _loginController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController numController=TextEditingController();
   TextEditingController searchController=TextEditingController();
  late Future<List<Post>> postList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          getData("1", "6", filter, dio);
          return SingleChildScrollView (
           
            child: 
            Form(
              key: _key,
              child: Column(
                children: [
                  // if (myWidgetList.isNotEmpty)
                  // ListView.builder(
                  //     itemCount: myWidgetList.length,
                  //     itemBuilder: (context, index) {
                  //       return Container(
                  //           padding: EdgeInsets.symmetric(vertical: 10),
                  //           child: Column(
                  //             crossAxisAlignment: CrossAxisAlignment.start,
                  //             children: [
          
                  //               Text("id: ${myWidgetList[index].id}",
                  //                   style: TextStyle(fontSize: 18)),
                  //               Text(
                  //                   "Категория: ${myWidgetList[index].notecategory}",
                  //                   style: TextStyle(fontSize: 18)),
                  //               Text(
                  //                   "Дата создания: ${myWidgetList[index].noteDateCreated}",
                  //                   style: TextStyle(fontSize: 18)),
                  //               Text(
                  //                   "Дата изменения: ${myWidgetList[index].noteDateChanged}",
                  //                   style: TextStyle(fontSize: 18)),
                  //             ],
                  //           ));
                  //     }),
          
                  FutureBuilder(
                      future: context
                          .read<AuthCubit>()
                          .getPost("1", "6", filter, token,postid),
                      builder: (context, snapshot) {
                        List<Widget> childrenVal = <Widget>[];
                        if (snapshot.hasData) {
                          childrenVal = <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                for (int i = 0; i < snapshot.data!.length; i++)
                                  Column(
                                    children: [
                                      Text(
                                          "Тема: ${snapshot.data?.elementAt(i).theme}",
                                          style: TextStyle(fontSize: 18)),
                                      Text(
                                          "id: ${snapshot.data?.elementAt(i).id}",
                                          style: TextStyle(fontSize: 18)),
                                      Text(
                                          "Содержание: ${snapshot.data?.elementAt(i).content}",
                                          style: TextStyle(fontSize: 18)),
                                    ],
                                  )
                              ],
                            ),
                          ];
                        }
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: childrenVal,
                        ));
                      })
          
                  // Text(context.read<AuthCubit>().getNotes("1","6",filter,token).toString()),
                  // ListView.builder(
                  //     // physics: NeverScrollableScrollPhysics(),
                  //     shrinkWrap: true,
                  //     //  itemCount: myWidgetList.length,
                  //   //  itemCount: 15,
                  //     itemBuilder: (context, index) {
                  //       return BlocBuilder<AuthCubit, AuthState>(
                  //         builder: (context, state) {
                  //           {
                  //           //
                  //             // if (jsonList.isNotEmpty)
                  //             {
                  //               if (myWidgetList.isNotEmpty) {
                  //                 return Container(
                  //                     padding: EdgeInsets.symmetric(vertical: 10),
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: [
                  //                         Text(
                  //                             myWidgetList
                  //                                 .elementAt(index)
                  //                                 .notename
                  //                                 .toString(),
                  //                             style: TextStyle(fontSize: 22)),
                  //                         Text("id: ${myWidgetList[index].id}",
                  //                             style: TextStyle(fontSize: 18)),
                  //                         Text(
                  //                             "Категория: ${myWidgetList[index].notecategory}",
                  //                             style: TextStyle(fontSize: 18)),
                  //                         Text(
                  //                             "Дата создания: ${myWidgetList[index].noteDateCreated}",
                  //                             style: TextStyle(fontSize: 18)),
                  //                         Text(
                  //                             "Дата изменения: ${myWidgetList[index].noteDateChanged}",
                  //                             style: TextStyle(fontSize: 18)),
                  //                       ],
                  //                     ));
                  //               }
                  //               return Text("Лист пуст");
                  //             }
                  //           }
                  //         },
                  //       );
                  //     }),
                  ,
                   TextField(
                    decoration:
                        new InputDecoration(labelText: "Введите id, для удаления записи"),
                    keyboardType: TextInputType.number,
                    controller: numController,
                      inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
          ], // On
                  ),
                   SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<AuthCubit>().delete(0,int.parse( numController.text ));
                       context.read<AuthCubit>().getPost("1", "6", filter, token,postid);
                        Navigator.pushReplacementNamed(context, userpage);
              
                      },
                      child: const Text(
                        'Удалить',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                     TextField(
                    decoration:
                        new InputDecoration(labelText: "Введите id, для поиска"),
                    keyboardType: TextInputType.number,
                    controller: searchController,
                      inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
          ], // On
                  ),
                   SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                                   // context.read<AuthCubit>().getNote("1", "6", filter, token,int.parse(searchController.text));
                                   postid=int.parse(searchController.text);
                        Navigator.pushReplacementNamed(context, userpage);
              
                      },
                      child: const Text(
                        'Поиск',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                 CheckboxListTile(
  title: Text("Фильтрация"),
  value: box,
  onChanged: (newValue) {
    setState(() {
      box = newValue;
      changeFilter(newValue);
    });
  },
 
),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, log);
                      },
                      child: const Text(
                        'Логин',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, updateprofile);
                      },
                      child: const Text(
                        'Изменить данные профиля',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                   SizedBox(
                    height: 35,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, manpost);
                      },
                      child: const Text(
                        'Манипуляция заметками',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
                  ),
          );
        
      },
    )),
    );
  }
  
  changeFilter(value) {
    if(value==true){
      filter="true";
    }
    else if(value==false)
    {
        filter="false";
    }
     Navigator.pushReplacementNamed(context, userpage);
  }
}

// dio.options.headers['Authorization'] = 'Bearer ' + token;

//   result = await dio.post('http://127.0.0.1:8888/token',
// data: User(userName: "12345678", password: "12345678", email: "12345678@mail.ru"),
// options: Options(headers: dio.options.headers));// AAAAAAAAAAAAAAAAAAAAAA
void getData(String page, String amount, String filtered, Dio dio) async {
  myWidgetList.clear();
  final resultQuery = await dio.get(
      'http://192.168.148.237:8888/post',
      options: Options(headers: dio.options.headers));
  if (resultQuery.statusCode == 200) {
    // myWidgetList =
    //     (resultQuery.data as List).map((e) => Notes.fromJson(e)).toList();
    var json = resultQuery.data["data"];
    for (var x in json) {
      if (x != null) {
        myWidgetList.add(Post(
            id: x["id"],
            theme: x["theme"],
            content: x["content"],
            ));
      }
    }
  } else {
    return;
  }
}

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfile();
}

class _UpdateProfile extends State<UpdateProfile> {
  GlobalKey<FormState> _key = GlobalKey();
  GlobalKey<FormState> _keyPas = GlobalKey();
  TextEditingController _loginController = TextEditingController();
  TextEditingController _oldpasswordController = TextEditingController();
  TextEditingController _newpasswordController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text(
                      'Изменение данных',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26),
                    ),
                    const Spacer(),

                    TextFormField(
                      maxLength: 25,
                      controller: _loginController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Логин не должен быть пустым';
                        }
                        if (value.length < 5) {
                          return 'Логин должен быть не менее 5 символов';
                        }
                        if (value.contains(RegExp(r"[а-яА-Я]"), 0)) {
                          return 'Только английские символы ';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Логин',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    //Почта
                    TextFormField(
                      maxLength: 100,
                      controller: _emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Почта не должна быть пустой';
                        }

                        return null;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Почта',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_key.currentState!.validate()) {
                            context.read<AuthCubit>().changeData(User(
                                userName: _loginController.text,
                                password: _oldpasswordController.text,
                                email: _emailController.text));
                            Navigator.pushNamed(context, userpage);
                          } else {}
                        },
                        child: const Text(
                          'Изменить данные',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    //Пароль
                    TextFormField(
                      maxLength: 30,
                      controller: _oldpasswordController,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Пароль не должен быть пустым';
                      //   }
                      //   if (value.length < 5) {
                      //     return 'Пароль должен быть не менее 5 символов';
                      //   }
                      //   if (value.contains(RegExp(r"[а-яА-Я0]"), 0)) {
                      //     return 'Только английские символы ';
                      //   }
                      //   return null;
                      // },
                      decoration: const InputDecoration(
                        hintText: 'Старый Пароль',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    //Пароль
                    TextFormField(
                      maxLength: 30,
                      controller: _newpasswordController,
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Пароль не должен быть пустым';
                      //   }
                      //   if (value.length < 5) {
                      //     return 'Пароль должен быть не менее 5 символов';
                      //   }
                      //   if (value.contains(RegExp(r"[а-яА-Я0]"), 0)) {
                      //     return 'Только английские символы ';
                      //   }
                      //   return null;
                      // },
                      decoration: const InputDecoration(
                        hintText: 'Новый Пароль',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                          //if (_key.currentState!.validate()) {
                          context.read<AuthCubit>().changePassword(
                              _oldpasswordController.text,
                              _newpasswordController.text);
                          Navigator.pushNamed(context, userpage);
                          // } else {}
                        },
                        child: const Text(
                          'Изменить пароль',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const Spacer(flex: 3),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, userpage),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
class PostRedaction extends StatefulWidget {
  const PostRedaction({Key? key}) : super(key: key);

  @override
  State<PostRedaction> createState() => _PostRedaction();
}

class _PostRedaction extends State<PostRedaction> {
  GlobalKey<FormState> _key = GlobalKey();
 
  TextEditingController _theme = TextEditingController();
  TextEditingController _content = TextEditingController();
TextEditingController _idpost = TextEditingController();
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _key,
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state is ErrorState) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Spacer(),
                    const Text(
                      'Манипуляция постами',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26),
                    ),
                    const Spacer(),
    // ignore: unnecessary_new
    new TextField(
                  decoration:
                      new InputDecoration(labelText: "Введите id, для поиска"),
                  keyboardType: TextInputType.number,
                  controller: _idpost,
                    inputFormatters: <TextInputFormatter>[
    FilteringTextInputFormatter.digitsOnly
], // On
                ),
                 SizedBox(
                  height: 35,
                  child: ElevatedButton(
                    onPressed: () {
                    //  context.read<AuthCubit>().delete(0,int.parse( numController.text ));
                    
                      Navigator.pushReplacementNamed(context, manpost);
            
                    },
                    child: const Text(
                      'Поиск',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                    TextFormField(
                      maxLength: 25,
                      controller: _theme,
                    
                       
                      decoration: const InputDecoration(
                        hintText: 'Тема',
                        border: OutlineInputBorder(),
                      ),
                    ),

                     
                    TextFormField(
                      maxLength: 100,
                      controller: _content,
                     
                      decoration: const InputDecoration(
                        hintText: 'Содержимое',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    

                    SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: () {
                        
                            context.read<AuthCubit>().changePost(Post(
                              id:int.parse(_idpost.text),
                                theme: _theme.text,
                                content: _content.text,
                              ));
                            Navigator.pushNamed(context, userpage);
                       
                        },
                        child: const Text(
                          'Изменить данные',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                       SizedBox(
                      height: 35,
                      child: ElevatedButton(
                        onPressed: ()async {
                          if (_key.currentState!.validate()) {
                           await context.read<AuthCubit>().addPost(Post(
                                id:0,
                                theme: _theme.text,
                                content: _content.text,
                                ));
                            Navigator.pushNamed(context, userpage);
                          } else {}
                        },
                        child: const Text(
                          'Добавить данные',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                  
                    const Spacer(flex: 3),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pushNamed(context, userpage),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(15),
                        ),
                        child:
                            const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
