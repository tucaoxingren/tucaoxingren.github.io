---
title: Android 蓝牙通信
date: 2017-08-01
time: 21:41:05
categories: Android
toc: true
tag: 蓝牙
---
</p>

# Android 蓝牙通信

## Android 常用蓝牙API

** Bluetooth Adapter **
    
代表本地蓝牙适配器（蓝牙无线电）。BluetoothAdapter是所有蓝牙交互的入口。使用这个你可以发现其他蓝牙设备，查询已配对的设备列表，使用一个已知的MAC地址来实例化一个BluetoothDevice，以及创建一个BluetoothServerSocket来为监听与其他设备的通信。

** BluetoothDevice **

代表一个远程蓝牙设备，使用这个来请求一个与远程设备的BluetoothSocket连接，或者查询关于设备名称、地址、类和连接状态等设备信息。

** BluetoothSocket **

代表一个蓝牙socket的接口（和TCP Socket类似）。这是一个连接点，它允许一个应用与其他蓝牙设备通过InputStream和OutputStream交换数据。

** BluetoothServerSocket **

代表一个开放的服务器socket，它监听接受的请求（与TCP ServerSocket类似）。为了连接两台Android设备，一个设备必须使用这个类开启一个服务器socket。当一个远程蓝牙设备开始一个和该设备的连接请求，BluetoothServerSocket将会返回一个已连接的BluetoothSocket，接受该连接。