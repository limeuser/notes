对象模型提供了一些内置服务，用于完成常见的基础功能。  
从语法上分为模板服务和实例服务两类，如果把模板看作是java/js的class，模板服务就是class上的静态方法，而实例服务就是class的普通方法。  
模板服务只能在模板上执行，me绑定到模板，服务别名首字母大写。实例服务只能在实例上执行，me绑定到实例，服务别名首字母小写。  
内置的模板服务主要用于数据的CRUD。 内置的实例服务主要用于获取属性的实时值，历史值，设置属性实时值等。

-   服务端脚本开发指南请参考：http://confluence.bluetron.cn/pages/viewpage.action?pageId=46581430

-   模板/实例/属性的访问语法及命名空间的使用请参考：http://confluence.bluetron.cn/pages/viewpage.action?pageId=46575130

**目录**

1 [模板服务](#模板服务)  
1.1 [AddDataTableEntry](#AddDataTableEntry)  
1.2 [AddDataTableEntries](#AddDataTableEntries)  
1.3 [UpdateDataTableEntry](#UpdateDataTableEntry)  
1.4 [DeleteDataTableEntries](#DeleteDataTableEntries)  
1.5 [GetDataTableEntries](#GetDataTableEntries)  
2 [实例服务](#实例服务)  
2.1 [getPropertyValue](#getPropertyValue)  
2.2 [getPropertyValues](#getPropertyValues)  
2.3 [getPropertyVQTValue](#getPropertyVQTValue)  
2.4 [getPropertyVQTValues](#getPropertyVQTValues)  
2.5 [getPropertyLastValue](#getPropertyLastValue)  
2.6 [getPropertyLastVQTValue](#getPropertyLastVQTValue)  
2.7 [getPropertiesHistory](#getPropertiesHistory)  
2.8 [getCertainHistory](#getCertainHistory)  
2.9 [setPropertyValue](#setPropertyValue)  
2.10 [setPropertyValues](#setPropertyValues)  
2.11 [setPropertyVQTValues](#setPropertyVQTValues)  
2.12 [setPropertyDefaultValue](#setPropertyDefaultValue)  

模板服务
========

**目前所有的内置模板服务只能用于表单模板，后续会在所有模板上提供**  

示例中使用以下表单模板

-   user: 员工表单模板，命名空间为work，包含以下属性

    -   uid: 字符串类型，员工编号

    -   name: 字符串类型，员工姓名

    -   dep: 字符串类型，员工部门

    -   age: 整数类型，员工年龄

    -   employ\_time：日期类型，入职时间

AddDataTableEntry
-----------------

-   用途：向模板中插入一条数据。

-   openapi入参格式

<!-- -->

    {
       "uid": "01",
       "name": "张三",
       "age": 30
    }

-   入参说明：key是属性别名，value是属性值

-   出参：整数，插入的数量。

-   在自定义服务中调用

<!-- -->

    // 入参是一个对象，key是属性别名，value是属性值
    var inputs = {
       uid: "01",
       name: "张三",
       age: 30
    };

    templates["work.user"].AddDataTableEntry(inputs);

-   通过openapi调用 {domain}/runtime/work/template/user/service/system/AddDataTableEntry post body:

<!-- -->

    {
       "uid": "01",
       "name": "张三",
       "age": 30
    }

AddDataTableEntries
-------------------

-   用途：向模板中插入多条数据。

-   openapi入参

<!-- -->

    {
       "list":[
          {
             "name": "张三",
             "age": 30
          },
          {
             "system.name": "李四",
             "system.age": 40
          }
       ]
    }

-   入参说明: list中包含所有待插入的数据，格式同AddDateTableEntry

-   出参：整数，插入的数量。

-   在自定义服务中调用

<!-- -->

    var inputs = {
       list: [
          {
             name: "张三",
             age: 30
          },
          {
             name: "李四",
             age: 40
          }
       ]
    };
    // 访问模板是省略命名空间
    templates.user.AddDataTableEntries(inputs);

-   通过openapi调用 {domain}/runtime/work/template/user/service/system/AddDataTableEntries  
    post body:

<!-- -->

    {
       "list":[
          {
             "name": "张三",
             "age": 30
          },
          {
             "system.name": "李四",
             "system.age": 40
          }
       ]
    }

UpdateDataTableEntry
--------------------

-   用途：更新模板的一条数据。

-   openapi入参

<!-- -->

    {
        "update": {
            "age": 40,
            "grade": 3
        },
        "where": {
            "name": "张三",
            "dep": "研发"
        }
    }

-   入参说明

    -   update中包含需要更新的属性值。

    -   where中的kv使用等于符号拼接条件，多个kv使用and拼接条件。

-   出参：整数，更新的数量。

-   在自定义服务中调用

<!-- -->

    {
        update: {
            age: 40,
            grade: 3
        },
        where: {
            name: "张三",
            dep: "研发"
        }
    }
    templates["work.user"].UpdateDataTableEntry(inputs);

-   通过openapi调用 {domain}/runtime/work/template/user/service/system/UpdateDataTableEntry  
    post body:

<!-- -->

    {
        "update": {
            "age": 40,
            "grade": 3
        },
        "where": {
            "name": "张三",
            "dep": "研发"
        }
    }

DeleteDataTableEntries
----------------------

-   用途：删除模板的多条数据。

-   openapi入参

<!-- -->

    {
        "name": "张三",
        "dep": "研发"
    }

-   入参说明: 参数中指定的是删除的where条件，kv使用等于符号拼接条件，多个kv使用and拼接条件。

-   出参：整数，删除的数量。

-   在自定义服务中调用

<!-- -->

    var inputs = {
        name: "张三",
        dep: "研发"
    };

    templates.user.DeleteDataTableEntries(inputs);

-   通过openapi调用 {domain}/runtime/work/template/user/service/system/DeleteDataTableEntries post body:

<!-- -->

    {
        "name": "张三",
        "dep": "研发"
    }

GetDataTableEntries
-------------------

-   用途：查询表单模板的多条数据。

-   openapi入参

<!-- -->

    {
    };

-   入参说明: todo

-   出参: 查询到的数据

-   在自定义服务中调用

<!-- -->

    // todo
    var inputs = {};

    templates["work.user"].GetDataTableEntries(inputs);

-   通过openapi调用 {domain}/runtime/work/template/user/service/system/GetDataTableEntries  
    post body:

<!-- -->

    todo

实例服务
========

**实例服务只能在实体模板的实例上执行**

示例中使用以下实体模板

-   device: 设备实体模板，命名空间为factory，包含以下属性

    -   code: 字符串类型，设备编码

    -   name: 字符串类型，设备名称

    -   workshop: 字符串类型，所属车间

    -   first\_use\_time：日期类型，首次投入使用时间

    -   temperature: float类型，温度

device模板中有一个锅炉实例，别名为boiler1

getPropertyValue
----------------

-   用途: 获取属性实时值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertyValue  
    post body:

<!-- -->

    // todo
    var boiler1 = templates.device.boiler1;
    var temperature = boiler1.getPropertyValue("temperature");

getPropertyValues
-----------------

-   用途: 批量获取属性实时值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertyValues  
    post body:

<!-- -->

    // todo

getPropertyVQTValue
-------------------

-   用途: 获取属性实时值，以VQT格式返回数据

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instace/boiler1/service/system/getPropertyVQTValue  
    post body:

<!-- -->

    // todo

getPropertyVQTValues
--------------------

-   用途: 批量获取属性实时值，以VQT格式返回数据

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertyVQTValues  
    post body:

<!-- -->

    // todo

getPropertyLastValue
--------------------

-   用途: 获取属性最后一次通过setPropertyValue设置的值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertyLastValue  
    post body:

<!-- -->

    // todo

getPropertyLastVQTValue
-----------------------

-   用途: 获取属性最后一次通过setPropertyVQTValue设置的值，以VQT格式返回数据

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertyLastVQTValue  
    post body:

<!-- -->

    // todo

getPropertiesHistory
--------------------

-   用途: 获取属性历史值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getPropertiesHistory  
    post body:

<!-- -->

    // todo

getCertainHistory
-----------------

-   用途: 根据给定时刻和处理策略获取最近一条历史值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/getCertainHistory  
    post body:

<!-- -->

    // todo

setPropertyValue
----------------

-   用途: 设置属性实时值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/setPropertyValue  
    post body:

<!-- -->

    // todo
    var boiler1 = templates.device.boiler1;
    var temperature = boiler1.setPropertyValue("temperature", 30.9);

setPropertyValues
-----------------

-   用途: 批量设置属性实时值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instance/boiler1/service/system/setPropertyValues  
    post body:

<!-- -->

    // todo

setPropertyVQTValues
--------------------

-   用途: 批量设置属性VQT实时值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/instace/boiler1/service/system/setPropertyVQTValues  
    post body:

<!-- -->

    // todo

setPropertyDefaultValue
-----------------------

-   用途: 设置属性默认值

-   入参

<!-- -->

    // todo

-   入参说明: todo

-   在自定义服务中调用

<!-- -->

    // todo

-   通过openapi调用 {domain}/runtime/factory/template/device/service/system/setPropertyDefaultValue  
    post body:

<!-- -->

    // todo
