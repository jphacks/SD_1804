# SmartPost Server

## 使い方
```sh
npm i -g firebase-tools
firebase login
firebase use --add # firebaseのサイトを選択
cd functions
npm install # または yarn
npm run deploy # または yarn deploy
```
```
curl https://us-central1-$(firebase use).cloudfunctions.net/helloWorld
```

## ファイルを編集したら
```sh
cd functions
npm run build
npm run deploy
```
