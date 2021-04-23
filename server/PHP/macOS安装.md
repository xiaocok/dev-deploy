# macOS安装

## 路径
  执行程序路径
      
      /usr/sbin/php-fpm
  
  配置文件路径
  
      /private/etc/php-fpm.conf

## 配置文件整理
  1. 复制配置文件
  
      cp /private/etc/php-fpm.conf.default /private/etc/php-fpm.conf
  2. 设置日志路径
      
      vim /private/etc/php-fpm.conf
      将 error_log 配置为 /usr/local/var/log/php-fpm.log
  3. 启动php-fpm
    
      sudo php-fpm -D

## 开机启动
  1. 配置调整
  
      vim /private/etc/php-fpm.conf
      修改为后台启动
      daemonize = yes
  2. 加入启动项

      在~/Library/LaunchAgents目录，新建 org.php.php-fpm.plist 文件：
      ```
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
          <key>Label</key>
          <string>php-fpm</string>
          <key>Program</key>
          <string>/usr/sbin/php-fpm</string>
          <key>KeepAlive</key><true/>
      </dict>
      </plist>
      ```
      注意：xml文件中的php-fpm的路径，是通过上面的命令得到的。
      
  3. 设置开机启动
      ```
      sudo chown root:owner ~/Library/LaunchAgents/org.php.php-fpm.plist
      sudo chmod +x ~/Library/LaunchAgents/org.php.php-fpm.plist
      sudo launchctl load -w ~/Library/LaunchAgents/org.php.php-fpm.plist
      ```
      执行完以上命令，可以用这个调试命令，来看看是否加载了启动项：
      
        launchctl list | grep php
      
      输出：
      
        -	0	php-fpm

      中间的数字是状态码，如果是0说明已经成功了，这时服务已经启动了；
      
      如果不是0，就可能有问题了。


#### 参考
* [mac系统，php-fpm加入开机启动项](https://blog.csdn.net/testcs_dn/article/details/80060551)
* [Mac自带PHP启动php-fpm问题解决](https://blog.csdn.net/zrainload/article/details/78962062)
* [Mac下启动php-fpm问题解决](https://zhuanlan.zhihu.com/p/91105007)
