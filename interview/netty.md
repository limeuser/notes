os zero copy
===

io操作的基础流程，以发送文件到socket为例，磁盘 -> 页缓存 -> 用户buffer -> 内核socket buffer -> 网卡buffer
zero copy的体现：
1. 硬件和内核之间的数据拷贝，不是由CPU完成，而是由专门的硬件DMA完成，解放了cpu，但还是执行了内存拷贝，例如磁盘 -> 页缓存，内核socket buffer -> 网卡buffer。
2. mmap，把用户态buffer映射到文件，避免用户态和内核态之间的拷贝：
   ！注意，mmap只能映射文件或其他支持随机读写的设备，所以mmap不能映射socket，因为socket是一个stream，不支持随机读写。
   buf = mmap(diskfd, len);write(sockfd, buf, len);
   磁盘 -> mmap buffer -> 内核socket buffer -> 网卡buffer：减少了两次内存拷贝
   但是mmap有共享的问题，例如多个进程操作同一个文件
3. sendfile：直接在fd之间做数据拷贝，从一个fd的output拷贝到另一个fd的input，目前只能用于磁盘文件 -> socket。
   2.4之后sendfile的实现基本完全解放了cpu，磁盘 ---DMA--> 页缓存 ---fd/length--> socket buffer --DMA--> 网卡buffer。
   cpu参与的只是把页缓存的元数据信息传递给socket buffer。
4. cow，以上三种技术都是为了减少用户态和内核态之间的内存拷贝，当拷贝不可避免时，linux使用copy on write技术提高性能。
   当多个程序访问同一分数据时，只读的进程之间可以共享同一份内存数据，只有写的进程做cow，保存修改过的数据，避免大量重复数据加载到物理内存，以及数据拷贝。

netty zero copy
=== 

1. netty使用了操作系统的zero copy能力
- 1.1 mmap：FileChanel.map
- 1.2 sendfile：FileChannel.transferTo
2. CompositeByteBuf，避免用户态内存拷贝，把多个buffer封装成一个完成的buf，避免把多个buffer拷贝到一个大buffer中。
3. netty的direct memory buffer和零拷贝没关系，只是使用了堆外内存，手动管理内存，性能更高。
4. direct memory：io操作时如果使用堆内存，JVM会先把堆内存拷贝到direct内存，使用direct内存避免了这次拷贝。

zero copy技术大概能提升50%性能。

netty 内存
===

1. direct buffer vs heap buffer
-   direct buffer: large, long-lived buffers that are subject to the underlying system’s native I/O operations
-   heap buffer: small, short-lived buffer
-   heap memory的分配比direct memory快上一个数量级，回收也更快（年轻代），direct buffer的回收依赖weak reference，可能造成gc pause。

io同步/异步，阻塞/非阻塞
===

io

```       
          阻塞            非阻塞
同步     read/write      NO_BLOCK
异步     epoll           AIO
```

同步非阻塞没有意义


