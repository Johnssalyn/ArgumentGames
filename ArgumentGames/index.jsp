<%--
  Created by IntelliJ IDEA.
  User: Johns
  Date: 2018/6/14
  Time: 17:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
  response.setHeader("Cache-Control","no-store");
  response.setHeader("Pragrma","no-cache");
  response.setDateHeader("Expires",0);
%>
<%
  String path = request.getContextPath();
  String basePath = request.getScheme() + "://"
          + request.getServerName() + ":" + request.getServerPort()
          + path + "/";
%>
<!doctype html>
<html>
<head>
  <base href="<%=basePath%>">

  <title>jsPlumb </title>

  <meta http-equiv="content-type" content="text/html;charset=utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no"/>
  <meta http-equiv="Pragma" content="no-cache" />
  <meta http-equiv="Cache-Control" content="no-cache" />
  <meta http-equiv="Expires" content="0" />
    <link rel="shortcut icon" href="../favicon.ico">
    <link rel="stylesheet" type="text/css" href="css/demobutton.css" />
    <link rel="stylesheet" type="text/css" href="css/style4.css" />
  <link rel="stylesheet" type="text/css" href="css/style2.css" />
    <link href='http://fonts.googleapis.com/css?family=Open+Sans' rel='stylesheet' type='text/css'>
  <link rel="stylesheet" href="https://cdn.bootcss.com/bootstrap/3.3.7/css/bootstrap.min.css">
  <link rel="stylesheet" href="css/demo.css">
  <link rel="stylesheet" href="css/jquery-ui.min.css">
  <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
  <script src="js/jquery-3.3.1.min.js"></script>

  <script src="https://cdn.bootcss.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
  <script src="js/jsplumb.min.js"></script>
  <script src="js/jquery-ui.min.js"></script>
  <style type="text/css">
    #bar { position: absolute; top: 0px; width: 100%; height: 40px; border-bottom: 1px solid #33cc99; }
    #bar span { display: inline-block; line-height: 35px; margin-left: 20px; }
    #bar cite { color: #ff3300; }
    #prop{position:absolute;left: 0px;}
    #oppo{position:absolute;right: 20px;}
    #add { position: absolute; bottom: 40px; width: 98.5%; height: 35px; margin: 0 auto;text-align: center;  }
    #pop { position: absolute; width: 100%; height: 100%; background-color: rgba(255, 255, 255, 0); z-index: 9999; display: none; }
    .win { width: 400px; height: 160px; margin: 150px auto; border: 3px solid
    #2591B4; border-radius: 10px; background: -moz-linear-gradient(top, rgba(255, 204, 0, 0.5), rgba(255, 255, 255, 0.5)); background: -webkit-gradient(linear, 0 0, 0 100%, from(rgba(37, 145, 180, 0.5)), to(rgba(58, 178, 222, 0.5))); box-shadow: 0px 0px 50px rgba(0, 0, 0, 0.75); text-align: center; }
    .win p { font-size: 36px; font-family: "微软雅黑"; color: #FD1E1F; text-align: center; margin-bottom: 16px; }
    .win input { width: 100px; height: 35px; color: #FD1E1F; }
    #showlist{ position: absolute;top:80px; text-align: center;  }
    .prostyle {
      display:inline-block;
      padding: 20px;
      border: 1px solid #2e6f9a;
      box-shadow: 2px 2px 19px #e0e0e0;
      -o-box-shadow: 2px 2px 19px #e0e0e0;
      -webkit-box-shadow: 2px 2px 19px #e0e0e0;
      -moz-box-shadow: 2px 2px 19px #e0e0e0;
      -moz-border-radius: 8px;
      border-radius: 8px;
      opacity: 0.8;
      background-color: white;
      font-size: 11px;
      -webkit-transition: background-color 0.25s ease-in;
      -moz-transition: background-color 0.25s ease-in;
      transition: background-color 0.25s ease-in;
    }
  </style>
  <script type="text/javascript">
      jsPlumb.ready(function () {

          // setup some defaults for jsPlumb.
          var instance = jsPlumb.getInstance({
              Endpoint: ["Dot", {radius: 2}],
              Connector:"StateMachine",
              HoverPaintStyle: {stroke: "#1e8151", strokeWidth: 2 },
              ConnectionOverlays: [
                  [ "Arrow", {
                      location: 1,
                      id: "arrow",
                      length: 14,
                      foldback: 0.8
                  } ]
              ],
              Container: "canvas"
          });

          i = 3;
          instance.registerConnectionType("basic", { anchor:"Continuous", connector:"StateMachine" });

          window.jsp = instance;
          var canvas = document.getElementById("canvas");
          var windows = jsPlumb.getSelector(".w");

          $(function() {
              $( "#dragsource" ).draggable({
                  helper:"clone",
                  revert: "invalid",cursor: "move", cursorAt: { top: 0, left: 0 }
              });
              $( "#canvas" ).droppable({
                  activeClass: "ui-state-hover",
                  hoverClass: "ui-state-active",
                  drop:function(event,ui){
                      newNode(parseInt(ui.offset.left - $(this).offset().left), parseInt(ui.offset.top - $(this).offset().top));
                  }
              });
          })

          $("input").blur(function(){
              $thisinput = $(this);
              var NODES = [];
              $('.w').find('input').not($thisinput).each(function(){
                  NODES.push($(this).val());
              });
              var index = $.inArray($thisinput.val(), NODES);
              if (index >= 0){
                  alert("already existed");
                  $($thisinput).val('');
                  $($thisinput).attr('placeholder',"Please input");
              }
              if( $(this).val() == '' ) {
                  //focus和alert不能同时用，否则会出现死循环
                  $(this).css("border","1px solid orange");
                  $(this).focus();    // 如果内容为空，继续聚集焦点
              }else{
                  $(this).css("border",0).css("background","transparent");
              }
          });

          $(".w").mouseenter(function () {
              $(this).find(".delete").show();
          });

          $(".delete").click(function () {
              instance.remove($(this).parent());
          });

          $(".w").mouseleave(function () {
              $(this).find(".delete").hide();
          });

          // bind a click listener to each connection; the connection is deleted. you could of course

          // just do this: instance.bind("click", instance.deleteConnection), but I wanted to make it clear what was

          // happening.

          instance.bind("click", function (c) {

              instance.deleteConnection(c);

          });



          list=instance.getAllConnections();
          $("#save").click(function(){
              //window.location.reload();
              var AF = [];
              for (i=0;i<list.length;i++){
                  var conn = {}
                  //var AF[i] = [];
                  var source = list[i].sourceId;
                  var target = list[i].targetId;
                  var sour = $('#'+ source).find('input').val();
                  var targ = $('#'+ target).find('input').val();
                  //attr()用来设置，val()用来读取
                  //js没有二维数组，只有一维数组，但是其数组的元素可以是数组，所以可以实现二维数组的效果
                  conn.source=sour;
                  conn.target=targ;
                  //alert(conn);
                  AF.push(conn);

              }
              //alert(AF);
              var nodes = [];
              $('.w').find('input').each(function(){
                  nodes.push($(this).val());
              });
              var root = $("#sel option:checked ").val();
              //alert(root);
              var AFType =  $("#selSemantics option:selected").val();
              //alert(AFType);
              var data0;
              $.ajax({
                  url:'html',
                  data:{AFConns:encodeURIComponent(JSON.stringify(AF)),AFNodes:encodeURIComponent(JSON.stringify(nodes)),AFRoot:root,AFType:AFType},
                  dataType:'json',
                  async : false ,
                  error: function(){
                      alert("error occured!!!");
                  },
                  success: function(data){
                      var objs=eval(data); //解析json对象
                      var obj0 = objs[0];
                      var obj1 = objs[1];
                      data0 = obj0.allPathsJson;
                      var winReason = obj1.IsWin;
                      //alert(winReason);
                      //var obj1 = objs[1];
                      //data1 = obj1.nodelist;
                      //var len = objs.length;
                      /*var obj1 = objs[1];
                      var win = obj1.winningStrategy;
                      for(var i=0;i<win.length;i++){
                          for(var j=0;j<win[i].length;j++){
                              alert(win[i][j]);
                          }
                      }*/
                      /*var obj2 = objs[2];
                      var allPaths = obj2.allPaths;
                      for(var i=0;i<allPaths.length;i++){
                          var perPath = allPaths[i];
                          var len = perPath.length;
                          for(var j=1;j<len;j++){
                              alert(perPath[j].name);
                          }
                      }*/


                      //alert(win);
                      //alert("success!");
                      buildtree(data0,winReason);
  }

  });

  });

  //list=instance.getAllConnections();
  instance.bind("connection", function(ci) { // ci is connection info.
  for (var i=0;i<list.length-1;i++){
  if (ci.sourceId == list[i].sourceId && ci.targetId == list[i].targetId){
  alert("Connection can not repeat");
  instance.deleteConnection(ci.connection);
  }
  }
  //var s=ci.sourceId,t=ci.targetId;
  //alert(s+" -> "+t);
  });

  // initialise element as connection targets and source.
  //

  var initNode = function(el) {
  // initialise draggable elements.
  instance.draggable(el,{
  containment:true
  });
  instance.makeSource(el, {
  filter: ".ep",
  anchor: "Continuous",
  connectorStyle: { stroke: "#5c96bc", strokeWidth: 2, outlineStroke: "transparent", outlineWidth: 4 },
  connectionType:"basic",
  extract:{
  "action":"the-action"
  },
  maxConnections: 20,
  onMaxConnections: function (info, e) {
  alert("Maximum connections (" + info.maxConnections + ") reached");
  }
  });
  instance.makeTarget(el, {
  dropOptions: { hoverClass: "dragHover" },
  anchor: "Continuous",
  allowLoopback: false
  });
  // this is not part of the core demo functionality; it is a means for the Toolkit edition's wrapped
  // version of this demo to find out about new nodes being added.
  instance.fire("jsPlumbDemoNodeAdded", el);
  };

  var newNode = function(x, y) {
  var d = document.createElement("div");
  i++;
  var id = i;
  d.className = "w";
  d.id = id;
  d.innerHTML ="<input type='text' style='width: 50px' value='"+ i +"'/>" + "<div class=\"ep\"></div>"+"<img src='/pic/close.png' class='delete' />";
  d.style.left = x + "px";
  d.style.top = y + "px";
  instance.getContainer().appendChild(d);

  $("input").blur(function(){
  $thisinput = $(this);
  var NODES = [];
  $('.w').find('input').not($thisinput).each(function(){
  NODES.push($(this).val());
  });
  var index = $.inArray($thisinput.val(), NODES);
  if (index >= 0){
  alert("already existed");
  $($thisinput).val('');
  $($thisinput).attr('placeholder',"Please input");
  }
  if( $(this).val() == '' ) {
  //focus和alert不能同时用，否则会出现死循环
  $(this).css("border","1px solid orange");
  $(this).focus();    // 如果内容为空，继续聚集焦点
  }else{
  //alert(NODES.not($thisinput.val()));
  $(this).css("border",0).css("background","transparent");
  }
  });

  $(".w").mouseenter(function () {
  $(this).find(".delete").show();
  });

  $(".delete").click(function () {instance.remove($(this).parent());});

  $(".w").mouseleave(function () {
  $(this).find(".delete").hide();
  });


  initNode(d);

  return d;

  };



  // suspend drawing and initialise.

  instance.batch(function () {

  for (var i = 0; i < windows.length; i++) {

  initNode(windows[i], true);

  }


  // and finally, make a few connections

  instance.connect({ source: "opened", target: "phone1", type:"basic" });

  //instance.connect({ source: "phone1", target: "phone1", type:"basic" });

  //instance.connect({ source: "phone2", target: "opened", type:"basic" });

  });

  jsPlumb.fire("jsPlumbDemoLoaded", instance);

  });
  </script>
  <script type="text/javascript">
      $(function() {
          var Nodes = [];
          $('.w').find('input').each(function(){
              Nodes.push($(this).val());
          });
          $("#sel").find("option").remove();
          var l = Nodes.length;
          $("#sel option:first").prop("selected", 'selected');
          for(var i=0;i<l;i++){
              $("#sel").append("<option value="+Nodes[i]+">"+Nodes[i]+"</option>");
          }
          $("#sel").focus(function(){

              var Nodes = [];
              $('.w').find('input').each(function(){
                  Nodes.push($(this).val());
              });
              $("#sel").find("option").remove();
              var l = Nodes.length;
              $("#sel option:first").prop("selected", 'selected');
              for(var i=0;i<l;i++){
                  $("#sel").append("<option value="+Nodes[i]+">"+Nodes[i]+"</option>");
              }
          });
      });
  </script>
  <script type="text/javascript">
      $(function() {
          $("#toggle").click(function() {
              $(this).text($("#canvas").is(":hidden") ? "收起" : "展开");
              $("#canvas").slideToggle();
          });
      });
  </script>
</head>

<body>

<div>
  <!-- left -->
  <!--div id="left">



    <a href="#" id="toggle" style="position:absolute;top:200px;">展开</a>
    <div id="content" style="display: none;"><p>隐藏内容<p><p>隐藏内容<p></div>


  </div-->

  <!--canvas-->
  <div id="canvas" class="container_buttons">

    <div class="w" id="opened"><input type="text" style="width: 50px" value="A"/>
      <div class="ep" action="begin"></div>
      <img src="pic/close.png" class="delete" />
    </div>

    <div class="w" id="phone1"><input type="text" style="width: 50px" value="B"/>
      <div class="ep" action="phone1"></div>
      <img src="pic/close.png" class="delete" />
    </div>

    <div class="w" id="phone2"><input type="text" style="width: 50px" value="C"/>
      <div class="ep" action="phone2"></div>
      <img src="pic/close.png" class="delete"/>
    </div>


  </div>

  <div id="middle" >


    <div class="c" id="dragsource" style="left:15px;box-shadow: 0 5px 15px #888888;">Drag me!
      <div class="ep" action="begin"></div>
    </div>
    <br><br><br><br><br><br><br><br><br><br>

    <select name="sel" id="sel" class="form-control" style="width:110px;top:200px;box-shadow: 0 5px 15px #888888;"></select>
    <br>

    <select name="selSemantics" id="selSemantics" class="form-control" style="width:110px;box-shadow: 0 5px 15px #888888;">
      <option value ="grounded">Grounded</option><!--删除selected就没问题了？-->
      <option value ="preferred">Preferred</option>
    </select>

    <br><br><br><br><br><br>
    <form id="form1" method="post">
      <div style="text-align:center;clear:both">
        <script src="/gg_bd_ad_720x90.js" type="text/javascript"></script>
        <script src="/follow.js" type="text/javascript"></script>
      </div>
      <a id="save" class="a_demo_four">build_tree</a>
      <br><br><br>
      <a id="playgame" class="a_demo_four">play_game</a>
    </form>
  </div>

  <!-- right -->
  <div id="right" class="container_buttons">
  </div>

</div>
<script src="http://d3js.org/d3.v3.min.js"></script>
<script>
    $("#playgame").click(function(){
        //window.location.reload();
        var AF = [];
        for (i=0;i<list.length;i++){
            var conn = {}
            //var AF[i] = [];
            var source = list[i].sourceId;
            var target = list[i].targetId;
            var sour = $('#'+ source).find('input').val();
            var targ = $('#'+ target).find('input').val();
            //attr()用来设置，val()用来读取
            //js没有二维数组，只有一维数组，但是其数组的元素可以是数组，所以可以实现二维数组的效果
            conn.source=sour;
            conn.target=targ;
            //alert(conn);
            AF.push(conn);

        }
        //alert(AF);
        var nodes = [];
        $('.w').find('input').each(function(){
            nodes.push($(this).val());
        });
        var AFType =  $("#selSemantics option:selected").val();
        var data0;
        $.ajax({
            url:'game',
            data:{AFConns:encodeURIComponent(JSON.stringify(AF)),AFNodes:encodeURIComponent(JSON.stringify(nodes)),AFType:AFType},
            dataType:'json',
            async : false ,
            error: function(){
                alert("error occured!!!");
            },
            success: function(data){
                var objs=eval(data); //解析json对象
                var len = objs.length;
                var NodeLists = [];

                for(var i=0;i<len;i++){
                    var obj=objs[i];
                    var data = obj.nodelist;
                    var lis = [];
                    for(var j=0;j<data.length;j++){
                        lis.push(data[j]);
                    }
                    NodeLists.push(lis);
                }
                //alert("success!");
                startgame(NodeLists,AFType);
            }
        });
    });
</script>
<script>
    function startgame(data,AFType) {
        document.getElementById("right").innerHTML="";
        var html = '';
        html += '<div id="bar">';
        html += '<span id="prop">Proponent：<cite id="proponent">You</cite></span>';
        html += '<div style="position: absolute;display: inline-block; line-height: 35px;left: 245px;">';
        html += '<a href="#" id="startBtn" class="a_demo_two">' + 'start!' + '</a>';
        html += '<a id="replay" class="a_demo_two" style="display: none;">'+ 'replay!' + '</a>';
        html += '<a id="undo" class="a_demo_two">'+ 'undo!' + '</a>';
        html += '</div>';
        html += '<span id="oppo">Opponent：<cite id="opponent">Computer</cite></span>';
        html += '</div>';
        html += '<div id="showlist" >'+'</div>'+'<br><br>';
        html += '<div id="add">'+'</div>';
        html += '<div id="pop">';
        html += '<div class="win">';
        html += '<p id="p1">You Win！</p>';
        html += '<input id="playAgain" type="button" value="REPLAY" />';
        html += '</div>';
        html += '</div>';
        $('#right').html(html);

        //var nodelist = [["A","B","C"],["B","A"],["C","A"]];
        //var nodelist = [["A","B"],["B","C","D"],["C","D"],["D","C","E"],["E"]];
        var nodelist = data;
        //var gameType = "grounded";
        //alert(AFType);
        var gameType = AFType;
        //var gameType = "preferred";
        var gamelist = [];

        $(function(){
            $("#replay").bind("click",function(){
                gamelist = [];
                document.getElementById("add").innerHTML="";
                document.getElementById("showlist").innerHTML="";
                $("#pop").hide();
                play();
            });
            $("#playAgain").bind("click",function(){
                gamelist = [];
                document.getElementById("add").innerHTML="";
                document.getElementById("showlist").innerHTML="";
                $("#pop").hide();
                play();
            });
            $("#startBtn").bind("click",function(){
                $("#startBtn").hide();
                $("#replay").show();
                play();
            });
            $("#undo").bind("click",function(){
                undo();
            });
            var play = function(){
                human();
            };
            var human = function(){
                var children = [];
                if(gamelist.length==0){
                    for(var j=0;j<nodelist.length;j++){
                        children.push(nodelist[j][0]);
                    }
                }else{

                    var lastnode = gamelist[gamelist.length-1];
                    for(var i=0;i<nodelist.length;i++){
                        if(nodelist[i][0]==lastnode){
                            children = nodelist[i].slice(1,nodelist[i].length);
                        }
                    }
                }
                //alert("获得当前要加在add区的节点"+children);
                for(var i=0;i<children.length;i++){
                    var obj = document.getElementById("add");
                    var inputFile = document.createElement("input");
                    inputFile.setAttribute("type","button");
                    inputFile.setAttribute("id","rootn");
                    inputFile.setAttribute("class","a_demo_two");
                    inputFile.setAttribute("value",children[i]);
                    inputFile.onclick = function(){
                        var clickedValue = $(this).val();
                        if(gameType=="grounded"){
                            if(CanPropose(clickedValue)){
                                gamelist.push(clickedValue);
                                var showList = document.getElementById("showlist");
                                var clickedNode = document.createElement("span");
                                clickedNode.appendChild(document.createTextNode(clickedValue));
                                clickedNode.setAttribute("class","prostyle");
                                clickedNode.setAttribute("style","text-align:center;");
                                showList.appendChild(clickedNode);
                                document.getElementById("add").innerHTML="";
                                //查看computer有没有可行的方案
                                //1.如果上一个子节点没有children，则结束，human赢
                                //2.children不为空，如果是grounded,opp可以repeat，则可以进行下一步
                                //3.children不为空，如果是preferred,opp不可以repeat，则检查是否有进行下一步的args,如果有则可以进行下一步
                                //4.children不为空，如果是preferred,opp不可以repeat，则检查是否有进行下一步的args,如果没有则human赢
                                if(IsOver(clickedValue)){
                                    $("#p1").html("YOU WIN!");
                                    win();
                                }else{
                                    if(canComputerContinue()){
                                        setTimeout(computer,400);
                                    }else{
                                        $("#p1").html("YOU WIN!");
                                        win();
                                    }
                                }
                            }else{
                                //alert("请选择其他argument！嘻嘻！");
                                alert("you can not use this argument! please choose other arguments!");
                            }
                        }else{
                            gamelist.push(clickedValue);
                            var showList = document.getElementById("showlist");
                            var clickedNode = document.createElement("span");
                            clickedNode.appendChild(document.createTextNode(clickedValue));
                            clickedNode.setAttribute("class","prostyle");
                            clickedNode.setAttribute("style","text-align:center;");
                            showList.appendChild(clickedNode);
                            document.getElementById("add").innerHTML="";
                            //查看computer有没有可行的方案
                            //1.如果上一个子节点没有children，则结束，human赢
                            //2.children不为空，如果是grounded,opp可以repeat，则可以进行下一步
                            //3.children不为空，如果是preferred,opp不可以repeat，则检查是否有进行下一步的args,如果有则可以进行下一步
                            //4.children不为空，如果是preferred,opp不可以repeat，则检查是否有进行下一步的args,如果没有则human赢
                            if(IsOver(clickedValue)){
                                $("#p1").html("YOU WIN!");
                                win();
                            }else{
                                if(canComputerContinue()){
                                    setTimeout(computer,400);
                                }else{
                                    $("#p1").html("YOU WIN!");
                                    win();
                                }
                            }
                        }
                    };
                    obj.appendChild(inputFile);
                }
            };
            var computer = function(){
                var ret = findArgForAI();
                gamelist.push(ret);;
                var showList = document.getElementById("showlist");
                var nodechaAI = document.createElement("span");
                //nodechaAI.setAttribute("id","container_buttons");
                nodechaAI.setAttribute("class","prostyle");
                nodechaAI.setAttribute("style","color:red;text-align:center;");
                nodechaAI.appendChild(document.createTextNode(ret));
                showList.appendChild(nodechaAI);
                //1.如果opp出的这个arg无子节点，则computer快要赢了
                //2.如果opp出的这个arg有子节点，但Pro不能出，则computer快要赢了
                if(IsOver(ret)){
                    var result = confirm('The computer is going to win. Do you choose undo?');
                    if(result){
                        undo();
                    }else{
                        //alert("computer win!");
                        $("#p1").html("computer win!");
                        win();
                    }
                }else{
                    if(canHumanContinue()){
                        human();
                    }else{
                        var result = confirm('The computer is going to win. Do you choose undo?');
                        if(result){
                            undo();
                        }else{
                            //alert("computer win!");
                            $("#p1").html("computer win!");
                            win();
                        }
                    }
                }
            };
            var undo = function() {
                var jjj = document.getElementById("showlist");
                jjj.removeChild(jjj.lastChild);
                jjj.removeChild(jjj.lastChild);
                gamelist.pop();
                gamelist.pop();
                document.getElementById("add").innerHTML="";
                human();
            }
            var win = function() {
                $("#pop").delay(200).fadeIn();
            }
            var lose = function() {

                $("#pop").delay(200).fadeIn();
            }
            var IsOver = function(arg){
                var childrenList = [];
                for(var i=0;i<nodelist.length;i++){
                    if(nodelist[i][0]==arg){
                        childrenList = nodelist[i].slice(1,nodelist[i].length);
                    }
                }
                if(childrenList.length==0){
                    return true;
                }else{
                    return false;
                }
            };
            var CanPropose=function(arg){
                if(gameType=="grounded"){ //pro cannot repeat
                    var prolist = [];
                    for(var i=0;i<gamelist.length;i=i+2){
                        prolist.push(gamelist[i]);
                    }
                    if(prolist.indexOf(arg)==-1){
                        return true;
                    }else{
                        return false;
                    }
                }else if(gameType=="preferred"){
                    var opplist = [];
                    for(var i=1;i<gamelist.length;i=i+2){
                        opplist.push(gamelist[i]);
                    }
                    if(opplist.indexOf(arg)==-1){
                        return true;
                    }else{
                        return false;
                    }
                }
            };
            var canComputerContinue = function(){
                var lastnode = gamelist[gamelist.length-1];
                var childrenList = [];
                for(var i=0;i<nodelist.length;i++){
                    if(nodelist[i][0]==lastnode){
                        childrenList = nodelist[i].slice(1,nodelist[i].length);
                    }
                }
                if(gameType=="grounded"){ //pro cannot repeat, opp can repeat
                    return true;
                }else if(gameType=="preferred"){
                    var opplist = [];
                    for(var i=1;i<gamelist.length;i=i+2){
                        opplist.push(gamelist[i]);
                    }
                    for(var j=0;j<childrenList.length;j++){
                        if(opplist.indexOf(childrenList[j])==-1){
                            return true;
                        }
                    }
                    return false;
                }
            };
            var canHumanContinue = function(){
                var lastnode = gamelist[gamelist.length-1];
                var childrenList = [];
                for(var i=0;i<nodelist.length;i++){
                    if(nodelist[i][0]==lastnode){
                        childrenList = nodelist[i].slice(1,nodelist[i].length);
                    }
                }
                if(gameType=="preferred"){ //pro can repeat, opp cannot repeat
                    return true;
                }else if(gameType=="grounded"){
                    var prolist = [];
                    for(var i=0;i<gamelist.length;i=i+2){
                        prolist.push(gamelist[i]);
                    }
                    for(var j=0;j<childrenList.length;j++){
                        if(prolist.indexOf(childrenList[j])==-1){
                            return true;
                        }
                    }
                    return false;
                }
            };
            var findArgForAI=function(){
                var lastnode = gamelist[gamelist.length-1];
                var children = [];
                for(var i=0;i<nodelist.length;i++){
                    if(nodelist[i][0]==lastnode){
                        var children = nodelist[i].slice(1,nodelist[i].length);
                    }
                }
                var opplist = [];
                for(var i=1;i<gamelist.length;i=i+2){
                    opplist.push(gamelist[i]);
                }
                if(gameType=="grounded"){ //pro cannot repeat
                    var ret = children[Math.floor(Math.random()*children.length)];
                    return ret;
                }else if(gameType=="preferred"){
                    for(var j=0;j<children.length;j++){
                        var li = [];
                        if(opplist.indexOf(children[j])==(-1)){
                            return children[j];
                            break;
                        }
                    }
                }
            };
        });
    };
</script>
<script>
  function buildtree(data0,reason) {
      document.getElementById("right").innerHTML="";

      var html = '';
      html += '<span id="reason" style="position:absolute;display:inline-block;text-align:center;left:5px;bottom: 5px;z-index: 9999;">'+ reason +'</span>';
      $('#right').html(html);
      //alert(data0);
      var treedata = [data0];
      // ************** Generate the tree diagram  *****************
      //定义树图的全局属性（宽高）

      var margin = {top: 20, right: 20, bottom: 20, left: 20},
          width = 560,
          height = 570;

      var i = 0, duration = 750, root;

      //创建一个树布局
      var tree = d3.layout.tree().size([height, width]);

      //定义连线生成器
      var diagonal = d3.svg.diagonal().projection(function (d) {
          return [d.x, d.y];
      });//创建新的斜线生成器

      function redraw() {
          svg.attr("transform",
              "translate(" + d3.event.translate + ")scale(" + d3.event.scale + ")");
      }

      //绘制svg图形
      var svg = d3.select("#right").append("svg")
          .attr("width", 560)
          .attr("height", 560)
          .call(zm = d3.behavior.zoom().scaleExtent([0.1, 3]).on("zoom", redraw))
          .append("g")
          .attr("transform", "translate(" + margin.left + "," + margin.top + ")");
      //定义偏移量

      zm.translate([margin.left, margin.top]);

      root = treedata[0];//treeData为上边定义的节点属性


      update(root);

      d3.select(self.frameElement).style("height", "570px");

      function update(source) {
          root.x0 = 50;
          root.y0 = 50;

          // Compute the new tree layout.计算新树图的布局
          var nodes = tree.nodes(root).reverse(),
              links = tree.links(nodes);

          // Normalize for fixed-depth.设置y坐标点，每层占180px
          nodes.forEach(function (d) {
              d.y = d.depth * 90;
          });

          // Update the nodes…每个node对应一个group
          var node = svg.selectAll("g.node")
              .data(nodes, function (d) {
                  return d.id || (d.id = ++i);
              });//data()：绑定一个数组到选择集上，数组的各项值分别与选择集的各元素绑定

          // Enter any new nodes at the parent's previous position.新增节点数据集，设置位置
          var nodeEnter = node.enter().append("g")  //在 svg 中添加一个g，g是 svg 中的一个属性，是 group 的意思，它表示一组什么东西，如一组 lines ， rects ，circles 其实坐标轴就是由这些东西构成的。
              .attr("class", "node") //attr设置html属性，style设置css属性
              .attr("transform", function (d) {
                  return "translate(" + source.x0 + "," + source.y0 + ")";
              })
              .on("click", click);

          //添加连接点---此处设置的是圆圈过渡时候的效果（颜色）
          // nodeEnter.append("circle")
          //   .attr("r", 1e-6);//d 代表数据，也就是与某元素绑定的数据。

          nodeEnter.append("path").style("stroke-width", "2px")
              .style("stroke", "#4682b4")
              .style("fill", "white")
              .attr("d", d3.svg.symbol()
                  .size(function (d) {
                      if
                      (d.value <= 9) {
                          return "400";
                      } else if
                      (d.value >= 9) {
                          return "400";
                      }
                  })
                  .type(function (d) {
                      if
                      (d.value <= 9) {
                          return "triangle-up";
                      } else if
                      (d.value >= 9) {
                          return "circle";
                      }
                  }))
              .attr('class', function (d) {
                  if (d.value <= 9) {
                      return 'bling';
                  } else {
                      return 'fill_normal';
                  }
              });

          //添加标签
          nodeEnter.append("text")
              .attr("x", function (d) {
                  return d.children || d._children ? -13 : -20;
              })
              .attr("dy", ".35em")
              .attr("text-anchor", function (d) {
                  return d.children || d._children ? "end" : "start";
              })
              .text(function (d) {
                  return d.name;
              })
              .style("fill-opacity", 1e-6);

          // Transition nodes to their new position.将节点过渡到一个新的位置-----主要是针对节点过渡过程中的过渡效果
          //node就是保留的数据集，为原来数据的图形添加过渡动画。首先是整个组的位置
          var nodeUpdate = node.transition()  //开始一个动画过渡
              .duration(duration)  //过渡延迟时间,此处主要设置的是圆圈节点随斜线的过渡延迟
              .attr("r", 10)
              .attr("transform", function (d) {
                  return "translate(" + d.x + "," + d.y + ")";
              });

          nodeUpdate.select("path")
              .style("stroke-width", "2px")
              .style("stroke", "#4682b4")
              .style("fill", "white")
              .attr("d", d3.svg.symbol().size(function (d) {
                  if
                  (d.value <= 9) {
                      return "400";
                  } else if
                  (d.value >= 9) {
                      return "400";
                  }
              })
                  .type(function (d) {
                      if
                      (d.value <= 9) {
                          return "triangle-up";
                      } else if
                      (d.value >= 9) {
                          return "circle";
                      }
                  }))
              .attr('class', function (d) {
                  if (d.value <= 9) {
                      return 'bling';
                  } else {
                      return 'fill_normal';
                  }
              });

          nodeUpdate.select("text")
              .style("fill-opacity", 1);

          // Transition exiting nodes to the parent's new position.过渡现有的节点到父母的新位置。
          //最后处理消失的数据，添加消失动画
          var nodeExit = node.exit().transition()
              .duration(duration)
              .attr("transform", function (d) {
                  return "translate(" + source.x + "," + source.y + ")";
              })
              .remove();

          nodeExit.select("circle")
              .attr("r", 1e-6);

          nodeExit.select("text")
              .style("fill-opacity", 1e-6);

          // Update the links…线操作相关
          //再处理连线集合
          var link = svg.selectAll("path.link")
              .data(links, function (d) {
                  return d.target.id;
              });

          // Enter any new links at the parent's previous position.
          //添加新的连线
          link.enter().insert("path", "g")
              .attr("class", "link")
              .attr("d", function (d) {
                  var o = {x: source.x0, y: source.y0};
                  return diagonal({source: o, target: o});  //diagonal - 生成一个二维贝塞尔连接器, 用于节点连接图.
              })
              .style("stroke", function (d) {
                  //d包含当前的属性console.log(d)
                  return '#ccc';
              });

          // Transition links to their new position.将斜线过渡到新的位置
          //保留的连线添加过渡动画
          link.transition()
              .duration(duration)
              .attr("d", diagonal);

          // Transition exiting nodes to the parent's new position.过渡现有的斜线到父母的新位置。
          //消失的连线添加过渡动画
          link.exit().transition()
              .duration(duration)
              .attr("d", function (d) {
                  var o = {x: source.x, y: source.y};
                  return diagonal({source: o, target: o});
              })
              .remove();

          // Stash the old positions for transition.将旧的斜线过渡效果隐藏
          nodes.forEach(function (d) {
              d.x0 = d.x;
              d.y0 = d.y;
          });
      }

      //定义一个将某节点折叠的函数
      // Toggle children on click.切换子节点事件
      function click(d) {
          if (d.children) {
              //console.log(d.children);
              d._children = d.children;
              d.children = null;
          } else {
              d.children = d._children;
              d._children = null;
          }
          update(d);
      }
  }

</script>

</body>
</html>
