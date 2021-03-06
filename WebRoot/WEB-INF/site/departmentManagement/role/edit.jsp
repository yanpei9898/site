<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/layouts/common/public.jsp" %>
<html>
<head>
<title>更新职位</title>
</head>
<body>
<article class="page-container">
	<form action="" method="post" class="form form-horizontal" id="form-member-add">
		<input type="hidden" name="number" value="${role.number }" />
		<input type="hidden" name="id" value="${role.id }" />
		<input type="hidden" class="input-text" value="SXTX-${role.number }">
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>职位名称：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<input type="text" class="input-text" name="name" value="${role.name }">
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>所属部门：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<span class="select-box">
					<select class="select" size="1" id="deptId" name="deptId" onchange="getRoleListByOrgId();">
						<c:forEach items="${deptList }" var="department">
							<c:if test="${department.pid != 0 }">
								<option <c:if test="${department.deptNum == role.deptId }">selected</c:if>
									value="${department.deptNum }">${department.name }</option>
							</c:if>
						</c:forEach>
					</select>
				</span>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>职位分类：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<span class="select-box">
					<select class="select" size="1" id="type" name="type" onchange="getRoleListByOrgId();">
						<option <c:if test="${role.type == 1 }">selected</c:if> value="1">管理</option>
						<option <c:if test="${role.type == 2 }">selected</c:if> value="2">技术</option>
						<option <c:if test="${role.type == 3 }">selected</c:if> value="3">实施</option>
					</select>
				</span>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3"><span class="c-red">*</span>直属领导：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<span class="select-box">
					<select class="select" size="1" id="leadership" name="leadership">
						<option value="${role.leadership }">${deptName }</option>
					</select>
				</span>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">职位描述：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<textarea  class="input-text textarea" rows="4" name="description">${role.description }</textarea>
			</div>
		</div>
		<div class="row cl">
			<label class="form-label col-xs-4 col-sm-3">备 注：</label>
			<div class="formControls col-xs-8 col-sm-9">
				<input type="text" class="input-text" name="remark" value="${role.remark }">
			</div>
		</div>
		<div class="row cl">
			<div class="col-xs-8 col-sm-9 col-xs-offset-4 col-sm-offset-3">
				<input class="btn btn-primary radius" type="submit" value="&nbsp;&nbsp;提交&nbsp;&nbsp;">
				<button onClick="layerClose();" class="btn btn-default radius" type="button">&nbsp;&nbsp;取消&nbsp;&nbsp;</button>
			</div>
		</div>
	</form>
</article>
<script type="text/javascript" src="${ctxsty}/static/h-ui.admin/js/H-ui.admin.js"></script>
<script type="text/javascript">
$(function(){
	$("#form-member-add").validate({
		rules:{
			name:{
				required:true,
			},
			deptId:{
				required:true,
			},
		},
		onkeyup:false,
		focusCleanup:true,
		success:"valid",
		submitHandler:function(form){
			 $(form).ajaxSubmit({
				type: 'post',
				url: "updRole.action",
				data: $(form).serialize(),
				dataType: "json",
				success: function(data) {
					if(data.status == 200) {
						var message = '更新成功!';
						var index = parent.layer.getFrameIndex(window.name); //先得到当前iframe层的索引,隐藏layer层和shade
						parent.$('#layui-layer'+index).css({'display':'none'});
	                    parent.$('#layui-layer-shade'+index).css({'display':'none'});
	                    parent.reloadTable(); //再刷新DT
						parent.showSuccessMessage(message, null, function() {
							parent.layer.close(index); //然后执行关闭     
						});
					} else {
						var message = '更新失败!';
						parent.showFailMessage(message);
					}
				},
				error: function(XMLHttpRequest, textStatus, errorThrown) {
					layer.alert(errorThrown, {
					     closeBtn: 1,    // 是否显示关闭按钮
					     anim: 1, //动画类型
					     btn: ['确定'], //按钮
					     icon: 5,    // icon
					     });
					return false;
				}
			});
		}
	});
});

//ajax二级联动,添加上级领导
function getRoleListByOrgId(){
    var type = $("#type").val();
    var deptId = $("#deptId").val();
	$.ajax({
	   type: "post",
	   url: "ajaxLeadership.action",
	   data: "type=" + type + "&deptId=" + deptId,
	   success: function(msg){
	   	 //存到文本域方便职位的级联操作
	  	 $("#list").val(msg);
	   	 var list = eval("("+msg+")");
	   	 var html = "";
	     for(var i = 0;i < list.length;i++){
	     	html += "<option value='"+list[i].number+"'>"+list[i].name+"</option>";
	     }
	     $("#leadership").html(html);
	   }
	});
}
</script>
</body>
</html>