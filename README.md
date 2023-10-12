<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

O Stage é um gerenciador de estado dinâmico fundamentado em Singleton que permite o gerenciamento de 
variáveis de forma global e uma grande integração com o flutter_secure_storage o que posibilita uma
extrema facilidade e praticidade na persistência de dados do seu app, como cache, tokens, informações
que são utilizadas a todo momento e que agora serão facilmete acessivéis. A curva de aprendizado é muito
curta assim como a implementação, mas ainda assim é possível realizar implementações mais robutas que 
resultam em um maior controle e emuma maior performance.
## Features

-notify(dynamic dependency):
Notifica um ouvinte específico para atualizar seu estado.

notifyAll():
Notifica todos os ouvintes para atualizar seus estados.

statusOf(String key):
Retorna o status de um Worker.

setStatus(String key, dynamic status):
Define o status de um Worker.

set(String key, dynamic value):
Define um valor associado a uma key no Stage e retorna uma referência para essa key.

make(String key, Function(dynamic) maker):
Cria um valor usando uma função maker para uma key no Stage e retorna uma referência para essa key.

get(String key):
Obtém o valor associado a uma key no Stage.

getAs<T extends Object>(String key):
Obtém e converte o valor associado a uma key no Stage para o tipo especificado T.

store(String key, dynamic value):
Armazena um valor no dispositivo usando flutter_secure_storage.

fromStore<T extends Object>(String key):
Recupera um valor armazenado no dispositivo e atualiza o Stage com esse valor.

free(String key):
Remove uma key e seu valor do Stage.

ref(String key):
Retorna uma referência para uma key no Stage.

clear():
Remove todos os valores do Stage.

clearWithout(List<String> keys):
Remove todos os valores do Stage, exceto os especificados na lista keys`.

lock(String key):
Bloqueia uma key específica para evitar alterações.

unlock(String key):
Desbloqueia uma key anteriormente bloqueada.

on(String key, Function(dynamic params, Function(dynamic) setStatus) work):
Define um trabalho a ser executado para uma key no Stage.

off(String key):
Remove um trabalho associado a uma key no Stage.

call(String key, {dynamic params}):
Executa o trabalho associado a uma key no Stage e atualiza o status.

caller(String key, {dynamic params}):
Retorna uma função que pode ser usada para executar o trabalho associado a uma key no Stage.

bind(dynamic obj):
Retorna a instância Singleton de um objeto.

dispose(dynamic obj):
Remove a instância Singleton de um objeto.

watcher(Widget Function() build, {List<dynamic> dependencies}):
Cria um widget de observação que será reconstruído quando as dependencies especificadas mudarem.

builder({Widget Function(BuildContext context) builder, List<dynamic> dependencies}):
Cria um widget de construção personalizada com base em dependencies.

switcher({dynamic status, Map<dynamic, Widget> cases, List<dynamic> dependencies}):
Cria um widget de alternância com base em um status e casos associados a dependencies.

## Getting started

O Stage não necessita de setup, apenas use onde precisar! :)

## Usage

```dart
void main() {
  Stage.set('contador', 3);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Stage.set('contador', 57);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contador Flutter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Contagem:',
              style: TextStyle(fontSize: 20),
            ),
            Stage.watcher(
              () => Text(
                "Meu contador vale ${Stage.get('contador')}!",
                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Stage.make('contador', (c) => c + 1),
        tooltip: 'Incrementar',
        child: const Icon(Icons.add),
      ),
    );
  }
}
```

## Additional information

Me chamo Felipe Kaian, sou o autor deste pacote, vocês podem me econtrar no LinkedIn ou 
através do email felipekaianmutti@gmail.com, podem trazer melhorias, sugestões e feedbacks,
quanto mais melhor, espero que esse pacote ajude nossa comunidade Flutter a crescer cada vez mais!
