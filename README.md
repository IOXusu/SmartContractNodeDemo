# SmartContractNodeDemo
一个简单的Demo带你了解智能合约开发流程，从合约编译部署，通过web3调用合约来讲解整个流程。

### 1. 环境搭建

- 本地开发工具 [Remix-Ide](https://github.com/ethereum/remix-ide)

  ```
  npm install remix-ide -g
  remix-ide
  ```

- solidity语言编译器 [solcjs](https://www.npmjs.com/package/solc)

  ```
  npm install –g solc
  ```

- 以太坊测试环境 [testrpc](https://www.npmjs.com/package/ethereumjs-testrpc-sc)（它会自动挖矿）

  ```
  npm install -g ethereumjs-testrpc
  ```

### 2.  编写编译智能合约

#### 1.给WebStorm安装[Intellij Solidity](https://plugins.jetbrains.com/plugin/9475-intellij-solidity)插件（上传到plugins目录下） 

#### 2.配置WebStrom用来编译sol文件 

File | Settings | Tools | External Tools |   添加一个配置

![编译工具配置信息](https://github.com/IOXusu/SmartContractNodeDemo/blob/master/images/ex_tools.png)

#### 3.配置WebStrom用来编译sol文件

```Solidity
pragma solidity ^0.4.0;

contract Factorial
{
    address public owner; // 合约创建者
    uint public jc = 0;
    function factorial(uint n) returns(uint)
    {
        if(n == 0 || n == 1)
        {
            return 1;
        }
        else
        {
            jc = n *factorial(n - 1);
            return jc;
        }
    }
}
```

####  4.测试合约

1. 启动testrpc,在终端中执行

   ```
   $ testrpc
   ```

2. 在重新开一个终端，启动remix-ide

   ```
   $ remix-ide
   ```

3. 在浏览器里打开remix测试合约

   ![remix_test](https://github.com/IOXusu/SmartContractNodeDemo/blob/master/images/remix_test.png)

   > 注意开发环境选择本地的Web3 Provider，点击Creat创建可约，然后输入数值进行测试，本合约为阶乘代码

4. 在WebStrom中编译合约

   我们前面配置了编译的工具，在webstrom中点击合约文件右击External Tools | BuildSolidity 之后就在bin目录下生成Factorial_sol_Factorial.abi和Factorial_sol_Factorial.bin文件

> 至此，我们已经完成了合约的编译，接下来我们来部署和调用合约

### 3.部署和调用智能合约

> 使用AJAX和Node.js异步访问智能合约

1. 在webstrome中新建一个node.js Express App项目

   项目的node_modules是没有web3（与合约交互的包）包的，切换到node_modules目录下执行

   ```
   $ npm install web3@0.20.1
   ```

2. 编写routes/index.js文件

   ```javascript
   var express = require('express');
   var router = express.Router();
   var Web3 = require('web3');
   var fs = require('fs');

   /* GET home page. */
   router.get('/contract', function (req, res, next) {
       // res.render('index', { title: 'Express' });
       var n = parseInt(req.param('n'));
       var web3 = new Web3(new Web3.providers.HttpProvider('http://localhost:8545'));
       eth = web3.eth;
       abi = JSON.parse(fs.readFileSync('[这里改成你生成的Factorial_sol_Factorial.abi文件路径]').toString());
       contract = eth.contract(abi);
       instance= contract.at('[这里输入刚create的合约地址]');
       result = instance.factorial.call(n);
       res.send(result);
   });
   module.exports = router;
   ```

   > 至此，在浏览器中输入http://localhost:3000/contract?n=3 就能看到返回值“6”，接下来我们提供一个用户界面，可以通过界面的控件和合约交互

3. 在public目录下新建一个contract.html文件

   ```html
   <!DOCTYPE html>
   <html lang="en">
   <head>
       <meta charset="UTF-8">
       <title>AJAX异步调用智能合约</title>
   </head>

   <script src="./javascripts/jquery-1.7.2.min.js"></script>
   <script>
       function jc() {
           var n = $('#n').val();
           $.ajax({
               url : 'contract?n=' + n,
               type : 'GET',
               success : function (result) {
                   $('#result').text('阶乘：' + result)
               }
           });
       }
   </script>
   <input id="n" placeholder="请输入一个正整数"/>
   <p/>
   <label id="result" />
   <p/>
   <button onclick=" jc(this) ">计算阶乘</button>
   </body>
   </html>
   ```

在浏览器中输入http://localhost:3000/contract.html即可查看交互界面





