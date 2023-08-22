# 记一次WebLogic与tomcat处理response.getWriter()的不同处理

## bug描述
测试环境以tomcat为应用容器，在一个报表预览的功能中，tomcat环境下能正常预览，而生产环境WebLogic下部分能正常预览，大部分不能正常预览。

## 错误代码描述
前台使用jQuery的post方法异步请求后台

后台根据前台传过来的数据读取报表模板计算合适的数据为报表赋值，最后生成一段报表预览的html代码，写入response中如下代码，此段代码在tomcat下所有报表都能正常预览，但在WebLogic下却有部分报表不能正常预览，前台报错403 后台没有返回。
```java
@RequestMapping({"lodopPrint!print.do"})
public void print(HttpServletRequest request,HttpServletResponse response) throws Exception {
    ...//生成html代码段
    response.setContentType("text/html;charset=UTF-8");
    response.setContentLength(htmlText.length());
    response.getWriter().print(htmlText);
}
```
## 错误修正
上段代码交给我改正，我发现`response.getWriter()`是在操作流，操作流一般会加上下面两行代码
> response.getWriter().flush();\
> response.getWriter().close();

## 思考
#### 修改后在Weblogic下测试所有报表均能正常预览，但是我产生了一个疑问，为什么操作流一般要在操作流结束后加上`flush()`与`close()`呢？

经过网上一番搜索，知悉在向流中写入数据时，一般都会先写入`buffer`中，在所有数据都写入`buffer`后，才向流中写数据，在此过程中如果写入的数据正好等于`buffer`的`size`的整数倍，会自动执行`flush()`方法，但实际情况中，很难做到正好整数倍，所以一般待写入数据最后的一些字符将不会被写入流中，因为最后一个`buffer`还没有满，所以为了数据的完整性，通常要在对流写入完数据后要手动执行`flush()`方法。

#### 那么为什么在tomcat环境下正常，而WebLogic下却不正常呢？
我们知道tomcat和WebLogic实际上是一个`servlet`容器，他们都有对应的类实现了`HttpServletRequest`或`HttpServletResponse`接口，那么会不会是他们实现具体方法的方式不一样，怀着疑问，我们看一下源码。

### WebLogic servlet实现源码分析
在 WebLogic初始化servlet时初始化了一个bufSize的变量，但这个变量并不是`servlet`中`buffer`的最终大小，`buffer`的最终大小是12216，详细看下面的源码分析
```java
// ServletOutputStreamImpl.java
public ServletOutputStreamImpl(OutputStream o, ServletResponseImpl res) {
        this.setHttpServer(WebServerRegistry.getInstance().getHttpServerManager().defaultHttpServer());
        this.response = res;
        this.out = o;
        int bufSize = 8192;// 此处初始化了一个名为bufSize的变量 8192即8k
        if (o instanceof NIOConnection) {
            NIOConnection conn = (NIOConnection)o;
            if (conn.supportsGatheredWrites()) {
                bufSize = conn.getOptimalNumberOfBuffers() * Chunk.CHUNK_SIZE;
            }
        }

        this.co = new ChunkOutputWrapper(ChunkOutput.create(bufSize, true, this.out, this));
        this.setBufferSize(bufSize);// 此行才是真正设置buffer的size
        this.co.setChunking(false);
        this.clen = -1L;
    }

// ChunkOutput.java
static {
    // Chunk.CHUNK_SIZE = 4080
    // this.CHUNK_SIZE = 4072
    CHUNK_SIZE = Chunk.CHUNK_SIZE - 6 - 2;
    END_OFFSET = Chunk.CHUNK_SIZE - 2;
    USE_JDK_ENCODER_FOR_ASCII = isUseJdkEncoderForAscii();
    DIGITS = new byte[]{48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 97, 98, 99, 100, 101, 102};
    trigger = null;
    trigger = new CompleteMessageTimeoutTrigger();
}

public void setBufferSize(int bs) {
    if (!this.stickyBufferSize) {
        if (bs == -1) {
            this.buflimit = -1;
            this.setBufferFlushStrategy();
        } else if (bs == 0) {
            this.buflimit = 0;
            this.setBufferFlushStrategy();
        } else {
            int numBufs = bs / CHUNK_SIZE;
            if (bs % CHUNK_SIZE != 0) {
                ++numBufs;
            }
            // 此处对ChunkOutput的成员变量buflimit赋值
            // buflimit = (8192÷4072)(向上取整) * 4072 = 12216
            this.buflimit = numBufs * CHUNK_SIZE;
            this.setBufferFlushStrategy();
        }
    }
}
```
至此我们知道了WebLogic容器中`PrintWriter`的一个buffer的大小是12216，继续看下面的源码

```java
this.flushStrategy = new ChunkOutput.BufferFlushStrategy(this) {
    public final void checkOverflow(long len) throws IOException {
    }
    public final void checkForFlush() throws IOException {
        // ChunkOutput.this.getCountForCheckOverflow() 即 写入数据的长度
        // ChunkOutput.this.buflimit 上面已经分析过是12216
        // 即写入数据的长度大于12216时会执行flush方法
        // 这也解释了为什么WebLogic容器下有的报表正常，有的不正常 原来正常的报表的html代码段超过了12216
        // 所以自动flush了，html代码段小于12216时，
        // 即没有flush 则数据只写入了buffer并没有真正写入response.getWriter()的流中，所以前台response中没有返回值
        if (ChunkOutput.this.getCountForCheckOverflow() >= ChunkOutput.this.buflimit) {
            this.out.flush();
        }

    }
};
```

### tomcat源码分析
经过上述WebLogic的源码分析，我们直接`response.getBufferSize()`获取到`bufferSize=8192`，根据上面分析WebLogic的源码猜想tomcat也是数据大小大于bufferSize时执行`flush`方法，但是源码跟踪后发现tomcat在像buffer写完数据后不管数据多大都没有执行`flush`方法，猜想不成立，进而想到会不会是在servlet调用结束时，tomcat强制执行了`flush`方法，
```java
// OutputBuffer.java
// 源码跟踪后 cb是ChunkBuffer对象 将数据写入buffer后就完成了 response.getWriter().print(htmlText);
// 并没有判断数据大小去执行flush方法
public void write(String s, int off, int len) throws IOException {
    if (!this.suspended) {
        if (s == null) {
            throw new NullPointerException(sm.getString("outputBuffer.writeNull"));
        } else {
            this.cb.append(s, off, len);
            this.charsWritten += (long)len;
        }
    }
}
// OutputBuffer.java
// 在这个方法的开头打了断点 发现确实每次http请求最后都进入了这个方法
// this.cb.flushBuffer(); this.bb.flushBuffer(); 这两个方法都被执行了
protected void doFlush(boolean realFlush) throws IOException {
    if (!this.suspended) {
        try {
            this.doFlush = true;
            if (this.initial) {
                this.coyoteResponse.sendHeaders();
                this.initial = false;
            }

            if (this.cb.getLength() > 0) {
                this.cb.flushBuffer();
            }

            if (this.bb.getLength() > 0) {
                this.bb.flushBuffer();
            }
        } finally {
            this.doFlush = false;
        }

        if (realFlush) {
            this.coyoteResponse.action(ActionCode.CLIENT_FLUSH, (Object)null);
            if (this.coyoteResponse.isExceptionPresent()) {
                throw new ClientAbortException(this.coyoteResponse.getErrorException());
            }
        }

    }
}
```
## 总结
前人栽树，后人乘凉 前人的经验确实能让我们少走很多弯路，以后一定要在操作流结束后，手动执行`flush()`方法。