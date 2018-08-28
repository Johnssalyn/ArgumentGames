
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
    $(".save").click(function(){
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
                data0 = obj0.allPathsJson;
                var len = objs.length;
                //alert(len);
                for(var i=1;i<len;i++){
                    //alert(objs[i].nodelist);
                }
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
                alert("success!");
                /*var right = document.getElementById('right');
                var myChart = echarts.init(right);
                myChart.showLoading();
                //var data0 = {"name":"A","children":[{"name":"B","children":[{"name":"C","children":[{"name":"D","children":[{"name":"C"},{"name":"E"}]}]},{"name":"D","children":[{"name":"C","children":[{"name":"D","children":[{"name":"E"}]}]},{"name":"E"}]}]}]}
                myChart.hideLoading();
                var option = {
                    tooltip: {
                        trigger: 'item',
                        triggerOn: 'mousemove'
                    },
                    series:[
                        {
                            type: 'tree',

                            data: [data0],

                            left: '2%',
                            right: '2%',
                            top: '8%',
                            bottom: '20%',

                            symbol: 'emptyCircle',

                            orient: 'vertical',

                            expandAndCollapse: true,

                            symbolSize:10,

                            label: {
                                normal: {
                                    position: 'top',
                                    rotate: 0,
                                    verticalAlign: 'middle',
                                    align: 'middle',
                                    fontSize: 13
                                }
                            },

                            lineStyle: {
                                color: '#000',
                            },


                            leaves: {
                                label: {
                                    normal: {
                                        position: 'bottom',
                                        rotate: 0,
                                        verticalAlign: 'middle',
                                        align: 'middle'
                                    }
                                }
                            },

                            animationDurationUpdate: 750
                        }
                    ]
                };
                myChart.clear();
                myChart.setOption(option,true);*/

                //document.write("<script src=\"js/d3func.js\" charset=\"utf-8\"></script>");
                //drawtree(data0);
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
            allowLoopback: true
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