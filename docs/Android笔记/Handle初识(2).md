---
title: Handler初识(2)
date: 2017-09-28
time: 22:41:05
categories: android
toc: true
tag: handler
---
</p>

## handler 异步通信

```java
private Button timeButton = null;
private ProgressBar progressBar = null;

@Override
protected void onCreate(Bundle savedInstanceState) {
    ...
    timeButton = (Button)findViewById(R.id.proButton);
    progressBar = (ProgressBar)findViewById(R.id.progressBar);
    timeButton.setOnClickListener(new Button.OnClickListener(){
            @Override
            public void onClick(View view) {
                progressBar.setVisibility(View.VISIBLE);
                timeHandle.post(timeThread);
            }
        });
    }
    Handler timeHandle = new Handler(){
        @Override
        public void handleMessage(Message msg) {
            //super.handleMessage(msg);
            progressBar.setProgress(msg.arg1);//progressBar赋值
            timeHandle.post(timeThread);//把线程压入到线程队列中
        }
    };
    Runnable timeThread = new Runnable() {
        int i = 0;
        @Override
        public void run() {
            System.out.println("Begin timeThread");
            i = i + 10;
            //得到一个消息对象,Message类是由Android操作系统提供
            Message msg = timeHandle.obtainMessage();
            //将Message对象的arg1成员变量赋值为i,
            //用arg1和arg2这两个成员变量的好处是占用资源低
            msg.arg1 = i;
            try {
                //设置此线程休眠1000ms
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            //将Message对象加入到Message消息队列中
            timeHandle.sendMessage(msg);//把消息压入到Message队列中
            if(i == 100){
                //如果当i的值为100时,就将线程从handle中移除
                timeHandle.removeCallbacks(timeThread);
            }
        }
    };
}
```