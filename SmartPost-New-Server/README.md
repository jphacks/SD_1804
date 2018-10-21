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

## OCRを触る場合は
api keyをbashで入力する必要があります  
api keyにはgoogle cloud visionのapi keyが入ります
```sh
cd functions
firebase functions:config:set vision.key="api key"
npm run build
npm run deploy
```
