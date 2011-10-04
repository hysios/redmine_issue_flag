function bind_award_button(name, url, token, issue, flag, member){
	Event.observe(name , 'click' , function(event){
		Event.stop(event);
		
		var form = new Element("form", {method:'POST', action:url});
		var issue_e = new Element("input", { type: 'hidden', name: "issue_id", value:issue});
		var member_e = new Element("input", { type: 'hidden', name: "member_id", value:member});
		var flag_e = new Element("input", { type: 'hidden', name: "flag", value:flag});
		var method = new Element("input", { name:"_method", type:"hidden", value:"put"});
		var auth_token = new Element("input", {name:"authenticity_token", type: "hidden" ,value:token});
		form.appendChild(method);
		form.appendChild(auth_token);
		form.appendChild(flag_e);
		form.appendChild(issue_e);
		form.appendChild(member_e);
		form.submit();
		
		return false;
	}, false)            
	
}

function bind_punish_button(name){
	Event.observe(name, 'click' , function(event){
		alert('click');
		Event.stop(event);
		return false;
	}, false)            
	
}
