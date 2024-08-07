## 问题起因

通过Android studio新建了一个Android项目，同步gradle居然花费了30多分钟。忍不了，真的忍不了。

## 原因分析

### 通过观察日志耗时情况

发现耗时主要集中在两方面：gradle下载和gradle依赖下载，如下图所示，gradle下载耗时24分钟，gradle依赖下载耗时7分钟

![stickPicture.png](../img/image001.png)

PS：源耗时日志没了，上图是小编为了写博客后补的，可真是煎熬的30分钟啊，如此敬业，这你不得点个赞？

### 查看gradle-wrapper.properties

文件路径gradle/wrapper/gradle-wrapper.properties

gradle-wrapper.properties是Gradle Wrapper的配置文件，用于指定Gradle版本。通过配置这个文件，可以确保项目在不同的环境中使用相同版本的Gradle进行构建。

Gradle Wrapper的目的是解决不同机器上Gradle版本不一致的问题，通过配置gradle-wrapper.properties文件，项目可以在任何环境下自动下载并使用正确的Gradle版本进行构建。

查看后发现，默认使用的地址为<https://services.gradle.org/distributions/gradle-8.2-bin.zip>。

```properties
distributionBase=GRADLE_USER_HOME

distributionPath=wrapper/dists

distributionUrl=https\\//services.gradle.org/distributions/gradle-8.2-bin.zip

zipStoreBase=GRADLE_USER_HOME

zipStorePath=wrapper/dists
```



提示：可能你的gradle版本与小编不同，但并无影响

通过ip查询工具，可发现services.gradle.org域名所在地理位置为美国。呵呵！国外源，慢得理所应当。

### 查看settings.gradle.kts

文件路径根目录

settings.gradle.kts文件是Kotlin DSL格式的settings文件，它用于配置项目的模块结构。在这个文件中，你可以声明项目中包含哪些模块、这些模块之间的依赖关系，以及全局的构建逻辑。

在新版本gradle中，settings.gradle.kts文件还承担了仓库配置的工作，而这也是我们关注的重点

通过Android studio新建的项目，gradle仓库配置默认如下

```gradle
pluginManagement {

    repositories {

        google()

        mavenCentral()

        gradlePluginPortal()

    }

}

dependencyResolutionManagement {

    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {

        google()

        mavenCentral()

    }

}

rootProject.name = "Demo"

include(":app")
```



通过ip查询工具，分别查询地理位置，默认源同样均在国外

|                      |                                   |          |
|----------------------|-----------------------------------|----------|
| 配置                 | 地址                              | 地址位置 |
| google()             | <https://maven.google.com/>       | 美国     |
| mavenCentral()       | <https://repo1.maven.org/maven2/> | 瑞典     |
| gradlePluginPortal() | <https://plugins.gradle.org/m2/>  | 美国     |

行吧，国外源，网络情况不理想，下载速度相对较慢，慢得有理有据。

## 解决方式

对于上述问题，常见的解决方式无非走**VPN代理**或通过**国内镜像源**加速，由于合规的VPN代理需要申请，本文主要讲解通过国内镜像源加速的方式。有合规VPN代理的观众老爷们可以撤了。

### gradle下载慢解决方案

常见的解决方案包括：使用gradle离线下载 或 通过gradle国内镜像源加速

个人觉得，gradle离线下载相对麻烦，不展开讲解。感兴趣的同学可自行百度[gradle离线下载](true)

对比gradle离线下载，通过gradle国内镜像源相对方便些，国内知名的gradle镜像源，包含阿里云和腾讯云

阿里云gradle镜像源：<https://mirrors.aliyun.com/gradle>

腾讯云gradle镜像源：<https://mirrors.cloud.tencent.com/gradle/>

可惜的是，[阿里云gradle镜像源](https://mirrors.aliyun.com/gradle)截至2019年就不再更新，gradle版本也停留在了gradle-5.6.2，若你使用的是gradle-5.6.2以上版本，更推荐你使用[腾讯云gradle镜像源](https://mirrors.cloud.tencent.com/gradle/)，使用方式如下：

替换`https\\//services.gradle.org/distributions`为`https\\//mirrors.cloud.tencent.com/gradle`

gradle-wrapper.properties文件如下

```properties
distributionBase=GRADLE_USER_HOME

distributionPath=wrapper/dists

distributionUrl=https\\//mirrors.cloud.tencent.com/gradle/gradle-8.2-bin.zip

zipStoreBase=GRADLE_USER_HOME

zipStorePath=wrapper/dists
```



### gradle依赖下载慢解决方案

为加速gradle依赖下载，我们可以通过国内镜像源加速，这里强烈安利 [阿里云镜像源](https://developer.aliyun.com/mvn/guide)

|                      |                                                     |
|----------------------|-----------------------------------------------------|
| 源库                 | 阿里云的镜像地址                                    |
| google()             | <https://maven.aliyun.com/repository/google>        |
| mavenCentral()       | <https://maven.aliyun.com/repository/central>       |
| gradlePluginPortal() | <https://maven.aliyun.com/repository/gradle-plugin> |

提示：上面仅列出我们使用到的镜像源，全量镜像源请见附录1：阿里云全量镜像源。

使用方式如下：

修改settings.gradle.kts，将对应阿里云镜像仓库添加到google()和mavenCentral()上方，优先从国内源下载，如果没有再去原网站下。

```gradle
pluginManagement {

    repositories {

        // 使用阿里镜像源

        maven(url = "https://maven.aliyun.com/repository/google")

        maven(url = "https://maven.aliyun.com/repository/central")

        maven(url = "https://maven.aliyun.com/repository/gradle-plugin")

        google()

        mavenCentral()

        gradlePluginPortal()

    }

}

dependencyResolutionManagement {

    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {

        // 使用阿里镜像源

        maven(url = "https://maven.aliyun.com/repository/google")

        maven(url = "https://maven.aliyun.com/repository/central")

        google()

        mavenCentral()

    }

}

rootProject.name = "Demo"

include(":app")
```



建议：请不要随意改变仓库位置。各个仓库的列出顺序决定了 Gradle 在这些仓库中搜索各个项目依赖项的顺序。例如，如果从仓库 A 和 B 均可获得某个依赖项，而您先列出了仓库 A，则 Gradle 会从仓库 A 下载该依赖项。 提示：若你使用的groovy，非kotlin，请转附录2：gradle依赖下载加速-groovy版

## 总结（省流版）

### gradle下载慢解决方案

替换`https\\//services.gradle.org/distributions`为`https\\//mirrors.cloud.tencent.com/gradle`

```gradle
distributionBase=GRADLE_USER_HOME

distributionPath=wrapper/dists

distributionUrl=https\\//mirrors.cloud.tencent.com/gradle/gradle-8.2-bin.zip

zipStoreBase=GRADLE_USER_HOME

zipStorePath=wrapper/dists
```



### gradle依赖下载慢解决方案

修改settings.gradle.kts，将对应阿里云镜像仓库添加到google()和mavenCentral()上方，优先从国内源下载，如果没有再去原网站下。

pluginManagement {

repositories {

// 使用阿里镜像源

maven(url = "https://maven.aliyun.com/repository/google")

maven(url = "https://maven.aliyun.com/repository/central")

maven(url = "https://maven.aliyun.com/repository/gradle-plugin")

google()

mavenCentral()

gradlePluginPortal()

}

}

dependencyResolutionManagement {

repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

repositories {

// 使用阿里镜像源

maven(url = "https://maven.aliyun.com/repository/google")

maven(url = "https://maven.aliyun.com/repository/central")

google()

mavenCentral()

}

}

rootProject.name = "Demo"

include(":app")

123456789101112131415161718192021222324

建议：请不要随意改变仓库位置。各个仓库的列出顺序决定了 Gradle 在这些仓库中搜索各个项目依赖项的顺序。例如，如果从仓库 A 和 B 均可获得某个依赖项，而您先列出了仓库 A，则 Gradle 会从仓库 A 下载该依赖项。 提示：若你使用的groovy，非kotlin，请转附录2：gradle依赖下载加速-groovy版



## 附录



### 附录1：阿里云全量镜像源

阿里云常见镜像库：<https://developer.aliyun.com/mvn/guide>

|  |  |  |  |
|----|----|----|----|
| **仓库名称** | **阿里云仓库地址** | **阿里云仓库地址(老版)** | **源地址** |
| central | <https://maven.aliyun.com/repository/central> | <https://maven.aliyun.com/nexus/content/repositories/central> | <https://repo1.maven.org/maven2/> |
| jcenter | <https://maven.aliyun.com/repository/public> | <https://maven.aliyun.com/nexus/content/repositories/jcenter> | <http://jcenter.bintray.com/> |
| public | <https://maven.aliyun.com/repository/public> | <https://maven.aliyun.com/nexus/content/groups/public> | central仓和jcenter仓的聚合仓 |
| google | <https://maven.aliyun.com/repository/google> | <https://maven.aliyun.com/nexus/content/repositories/google> | <https://maven.google.com/> |
| gradle-plugin | <https://maven.aliyun.com/repository/gradle-plugin> | <https://maven.aliyun.com/nexus/content/repositories/gradle-plugin> | <https://plugins.gradle.org/m2/> |
| spring | <https://maven.aliyun.com/repository/spring> | <https://maven.aliyun.com/nexus/content/repositories/spring> | <http://repo.spring.io/libs-milestone/> |
| spring-plugin | <https://maven.aliyun.com/repository/spring-plugin> | <https://maven.aliyun.com/nexus/content/repositories/spring-plugin> | <http://repo.spring.io/plugins-release/> |
| grails-core | <https://maven.aliyun.com/repository/grails-core> | <https://maven.aliyun.com/nexus/content/repositories/grails-core> | <https://repo.grails.org/grails/core> |
| apache snapshots | <https://maven.aliyun.com/repository/apache-snapshots> | <https://maven.aliyun.com/nexus/content/repositories/apache-snapshots> | <https://repository.apache.org/snapshots/> |

提示：由于阿里云官网更新，大家查到的数据可能比上面少。大部分库未在常见镜像库中展示，如google()库，全量仓库请通过<https://developer.aliyun.com/mvn/view>查看



### 附录2：gradle依赖下载加速-groovy版

修改settings.gradle，将对应阿里云镜像仓库添加到google()和mavenCentral()上方，优先从国内源下载，如果没有再去原网站下。

```gradle
pluginManagement {

    repositories {

        // 使用阿里镜像源

        maven { url 'https://maven.aliyun.com/repository/google' }

        maven { url 'https://maven.aliyun.com/repository/central' }

        maven { url 'https://maven.aliyun.com/repository/gradle-plugin' }

        google()

        mavenCentral()

        gradlePluginPortal()

    }

}

dependencyResolutionManagement {

    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)

    repositories {

        // 使用阿里镜像源

        maven { url 'https://maven.aliyun.com/repository/google' }

        maven { url 'https://maven.aliyun.com/repository/central' }

        google()

        mavenCentral()

    }

}

rootProject.name = "Demo"

include ':app'
```



建议：请不要随意改变仓库位置。各个仓库的列出顺序决定了 Gradle 在这些仓库中搜索各个项目依赖项的顺序。例如，如果从仓库 A 和 B 均可获得某个依赖项，而您先列出了仓库 A，则 Gradle 会从仓库 A 下载该依赖项。



## 参考文档

[添加 build 依赖项 \| Android Studio \| Android Developers (google.cn)](https://developer.android.google.cn/build/dependencies?hl=zh-cn#remote-repositories)

[阿里云仓库服务 (aliyun.com)](https://developer.aliyun.com/mvn/guide)

[阿里巴巴开源镜像站](https://developer.aliyun.com/mirror/)

[Android Studio 配置国内镜像源、HTTP代理](https://juejin.cn/post/7321912587731075111)
